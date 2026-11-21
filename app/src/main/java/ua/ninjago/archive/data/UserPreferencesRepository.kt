package ua.ninjago.archive.data

import android.content.Context
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.longPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.core.stringSetPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import ua.ninjago.archive.data.model.AppThemeMode
import ua.ninjago.archive.data.model.ContinueWatching
import ua.ninjago.archive.data.model.ElementStyle
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

private val Context.dataStore by preferencesDataStore(name = "ninjago_ua_prefs")

data class UserPrefsState(
    val element: ElementStyle = ElementStyle.FIRE,
    val themeMode: AppThemeMode = AppThemeMode.GARMADON_SHADOW,
    val isPremium: Boolean = false,
    val dailyWatchDate: String = "",
    val dailyWatchCount: Int = 0,
    val watchedEpisodeIds: Set<String> = emptySet(),
    val bookmarkedEpisodeIds: Set<String> = emptySet(),
    val continueWatching: ContinueWatching? = null,
    val episodePositions: Map<String, Long> = emptyMap()
)

class UserPreferencesRepository(private val context: Context) {

    private object Keys {
        val ELEMENT = stringPreferencesKey("element")
        val THEME_MODE = stringPreferencesKey("theme_mode")
        val IS_PREMIUM = booleanPreferencesKey("is_premium")
        val DAILY_DATE = stringPreferencesKey("daily_date")
        val DAILY_COUNT = intPreferencesKey("daily_count")
        val WATCHED_IDS = stringSetPreferencesKey("watched_ids")
        val BOOKMARKED_IDS = stringSetPreferencesKey("bookmarked_ids")
        val LAST_SEASON_ID = stringPreferencesKey("last_season_id")
        val LAST_SEASON_TITLE = stringPreferencesKey("last_season_title")
        val LAST_EPISODE_ID = stringPreferencesKey("last_episode_id")
        val LAST_EPISODE_TITLE = stringPreferencesKey("last_episode_title")
        val LAST_EPISODE_NUMBER = intPreferencesKey("last_episode_number")
        val LAST_POSITION_MS = longPreferencesKey("last_position_ms")
        val LAST_DURATION_MS = longPreferencesKey("last_duration_ms")
    }

    private fun positionKey(episodeId: String) = longPreferencesKey("pos_$episodeId")

    val prefsFlow: Flow<UserPrefsState> = context.dataStore.data.map { p ->
        val today = currentDayKey()
        val storedDate = p[Keys.DAILY_DATE] ?: ""
        val effectiveCount = if (storedDate == today) (p[Keys.DAILY_COUNT] ?: 0) else 0

        val lastEpId = p[Keys.LAST_EPISODE_ID]
        val continueItem = if (!lastEpId.isNullOrBlank()) {
            ContinueWatching(
                seasonId = p[Keys.LAST_SEASON_ID] ?: "",
                seasonTitle = p[Keys.LAST_SEASON_TITLE] ?: "",
                episodeId = lastEpId,
                episodeTitle = p[Keys.LAST_EPISODE_TITLE] ?: "",
                episodeNumber = p[Keys.LAST_EPISODE_NUMBER] ?: 1,
                positionMs = p[Keys.LAST_POSITION_MS] ?: 0L,
                durationMs = p[Keys.LAST_DURATION_MS] ?: 0L
            )
        } else null

        val positions = p.asMap()
            .filterKeys { it.name.startsWith("pos_") }
            .mapNotNull { (k, v) -> (v as? Long)?.let { k.name.removePrefix("pos_") to it } }
            .toMap()

        UserPrefsState(
            element = runCatching {
                ElementStyle.valueOf(p[Keys.ELEMENT] ?: ElementStyle.FIRE.name)
            }.getOrDefault(ElementStyle.FIRE),
            themeMode = runCatching {
                AppThemeMode.valueOf(p[Keys.THEME_MODE] ?: AppThemeMode.GARMADON_SHADOW.name)
            }.getOrDefault(AppThemeMode.GARMADON_SHADOW),
            isPremium = p[Keys.IS_PREMIUM] ?: false,
            dailyWatchDate = today,
            dailyWatchCount = effectiveCount,
            watchedEpisodeIds = p[Keys.WATCHED_IDS] ?: emptySet(),
            bookmarkedEpisodeIds = p[Keys.BOOKMARKED_IDS] ?: emptySet(),
            continueWatching = continueItem,
            episodePositions = positions
        )
    }

    suspend fun setElement(element: ElementStyle) {
        context.dataStore.edit { it[Keys.ELEMENT] = element.name }
    }

    suspend fun setThemeMode(mode: AppThemeMode) {
        context.dataStore.edit { it[Keys.THEME_MODE] = mode.name }
    }

    suspend fun setPremium(unlocked: Boolean) {
        context.dataStore.edit { it[Keys.IS_PREMIUM] = unlocked }
    }

    suspend fun toggleBookmark(episodeId: String) {
        context.dataStore.edit { p ->
            val current = p[Keys.BOOKMARKED_IDS] ?: emptySet()
            p[Keys.BOOKMARKED_IDS] = if (episodeId in current) current - episodeId else current + episodeId
        }
    }

    suspend fun recordEpisodeStart(
        seasonId: String,
        seasonTitle: String,
        episodeId: String,
        episodeTitle: String,
        episodeNumber: Int,
        incrementDailyCounter: Boolean
    ) {
        val today = currentDayKey()
        context.dataStore.edit { p ->
            if (incrementDailyCounter) {
                val storedDate = p[Keys.DAILY_DATE] ?: ""
                val count = if (storedDate == today) (p[Keys.DAILY_COUNT] ?: 0) else 0
                p[Keys.DAILY_DATE] = today
                p[Keys.DAILY_COUNT] = count + 1
            }
            p[Keys.WATCHED_IDS] = (p[Keys.WATCHED_IDS] ?: emptySet()) + episodeId
            p[Keys.LAST_SEASON_ID] = seasonId
            p[Keys.LAST_SEASON_TITLE] = seasonTitle
            p[Keys.LAST_EPISODE_ID] = episodeId
            p[Keys.LAST_EPISODE_TITLE] = episodeTitle
            p[Keys.LAST_EPISODE_NUMBER] = episodeNumber
            p[Keys.LAST_POSITION_MS] = p[positionKey(episodeId)] ?: 0L
        }
    }

    suspend fun savePlaybackPosition(
        seasonId: String,
        seasonTitle: String,
        episodeId: String,
        episodeTitle: String,
        episodeNumber: Int,
        positionMs: Long,
        durationMs: Long
    ) {
        context.dataStore.edit { p ->
            p[positionKey(episodeId)] = positionMs
            p[Keys.LAST_SEASON_ID] = seasonId
            p[Keys.LAST_SEASON_TITLE] = seasonTitle
            p[Keys.LAST_EPISODE_ID] = episodeId
            p[Keys.LAST_EPISODE_TITLE] = episodeTitle
            p[Keys.LAST_EPISODE_NUMBER] = episodeNumber
            p[Keys.LAST_POSITION_MS] = positionMs
            if (durationMs > 0L) p[Keys.LAST_DURATION_MS] = durationMs
        }
    }

    private fun currentDayKey(): String =
        SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
}
