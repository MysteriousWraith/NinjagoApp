package ua.ninjago.archive.data

import android.content.Context
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.Json
import ua.ninjago.archive.config.AppConfig
import ua.ninjago.archive.data.model.CatalogPayload
import ua.ninjago.archive.data.model.HallOfFamePayload
import ua.ninjago.archive.data.model.KeysPayload
import ua.ninjago.archive.data.model.OpeningsPayload
import java.net.HttpURLConnection
import java.net.URL
import java.security.MessageDigest

class ArchiveRepository(private val context: Context) {

    private val json = Json {
        ignoreUnknownKeys = true
        isLenient = true
    }

    suspend fun loadCatalog(): CatalogPayload = loadJson("catalog.json", CatalogPayload())
    suspend fun loadHallOfFame(): HallOfFamePayload = loadJson("hall_of_fame.json", HallOfFamePayload())
    suspend fun loadOpenings(): OpeningsPayload = loadJson("openings.json", OpeningsPayload())

    suspend fun verifyPremiumKey(inputKey: String): Boolean = withContext(Dispatchers.IO) {
        val normalized = inputKey.trim().uppercase()
        if (normalized.isEmpty()) return@withContext false
        val digest = sha256(normalized)
        val keys = loadJson("keys.json", KeysPayload())
        keys.hashes.any { it.equals(digest, ignoreCase = true) }
    }

    private suspend inline fun <reified T> loadJson(filename: String, fallback: T): T =
        withContext(Dispatchers.IO) {
            val remoteText = fetchRemoteText(filename)
            val text = remoteText ?: readAssetText(filename)
            if (text.isNullOrBlank()) fallback
            else runCatching { json.decodeFromString<T>(text) }.getOrDefault(fallback)
        }

    private fun fetchRemoteText(filename: String): String? {
        val base = AppConfig.GITHUB_RAW_BASE_URL
        if (base.isBlank() || base.contains("YOUR_USERNAME")) return null
        return runCatching {
            val url = URL(base.trimEnd('/') + "/" + filename)
            val conn = (url.openConnection() as HttpURLConnection).apply {
                connectTimeout = 4000
                readTimeout = 4000
                requestMethod = "GET"
            }
            if (conn.responseCode == HttpURLConnection.HTTP_OK) {
                conn.inputStream.bufferedReader().use { it.readText() }
            } else null
        }.getOrNull()
    }

    private fun readAssetText(filename: String): String? = runCatching {
        context.assets.open(filename).bufferedReader().use { it.readText() }
    }.getOrNull()

    private fun sha256(value: String): String {
        val bytes = MessageDigest.getInstance("SHA-256").digest(value.toByteArray(Charsets.UTF_8))
        return bytes.joinToString("") { "%02x".format(it) }
    }
}
