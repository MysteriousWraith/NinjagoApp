package ua.ninjago.archive.data

import android.content.Context
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import ua.ninjago.archive.config.AppConfig
import java.io.File
import java.io.FileOutputStream
import java.net.HttpURLConnection
import java.net.URL

/**
 * Офлайн-режим «Рюкзак»: сохраняет видеофайлы в закрытую память приложения (filesDir/backpack/),
 * поэтому их не видно в Галерее и нельзя просто переслать файлом.
 */
class BackpackRepository(private val context: Context) {

    private val backpackDir: File
        get() = File(context.filesDir, "backpack").apply { if (!exists()) mkdirs() }

    fun getLocalFile(episodeId: String): File = File(backpackDir, "$episodeId.mp4")

    fun isDownloaded(episodeId: String): Boolean {
        val f = getLocalFile(episodeId)
        return f.exists() && f.length() > 1024L
    }

    fun listDownloadedIds(): Set<String> =
        backpackDir.listFiles()
            ?.filter { it.isFile && it.name.endsWith(".mp4") && it.length() > 1024L }
            ?.map { it.name.removeSuffix(".mp4") }
            ?.toSet()
            ?: emptySet()

    fun getFileSizeMb(episodeId: String): Double {
        val f = getLocalFile(episodeId)
        return if (f.exists()) f.length() / (1024.0 * 1024.0) else 0.0
    }

    fun deleteEpisode(episodeId: String): Boolean {
        val f = getLocalFile(episodeId)
        return if (f.exists()) f.delete() else false
    }

    suspend fun downloadEpisode(
        episodeId: String,
        url: String,
        onProgress: (Int) -> Unit
    ): Result<File> = withContext(Dispatchers.IO) {
        val tempFile = File(backpackDir, "$episodeId.tmp")
        val finalFile = getLocalFile(episodeId)
        try {
            val conn = (URL(url).openConnection() as HttpURLConnection).apply {
                connectTimeout = 15000
                readTimeout = 30000
                requestMethod = "GET"
                if (AppConfig.BACKEND_API_KEY.isNotBlank() && AppConfig.isBackendConfigured()) {
                    setRequestProperty("X-App-Key", AppConfig.BACKEND_API_KEY)
                }
            }
            if (conn.responseCode !in 200..299) {
                return@withContext Result.failure(IllegalStateException("HTTP ${conn.responseCode}"))
            }
            val totalBytes = conn.contentLengthLong.coerceAtLeast(1L)
            var downloaded = 0L
            conn.inputStream.use { input ->
                FileOutputStream(tempFile).use { output ->
                    val buffer = ByteArray(64 * 1024)
                    var read = input.read(buffer)
                    var lastPercent = -1
                    while (read != -1) {
                        output.write(buffer, 0, read)
                        downloaded += read
                        val pct = ((downloaded * 100) / totalBytes).toInt().coerceIn(0, 100)
                        if (pct != lastPercent) {
                            lastPercent = pct
                            onProgress(pct)
                        }
                        read = input.read(buffer)
                    }
                }
            }
            if (finalFile.exists()) finalFile.delete()
            tempFile.renameTo(finalFile)
            onProgress(100)
            Result.success(finalFile)
        } catch (e: Exception) {
            tempFile.delete()
            Result.failure(e)
        }
    }
}
