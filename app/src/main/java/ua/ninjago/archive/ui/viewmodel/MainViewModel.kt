package ua.ninjago.archive.ui.viewmodel

import android.app.Application
import android.media.AudioAttributes
import android.media.MediaPlayer
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import ua.ninjago.archive.config.AppConfig
import ua.ninjago.archive.data.ArchiveRepository
import ua.ninjago.archive.data.BackpackRepository
import ua.ninjago.archive.data.UserPreferencesRepository
import ua.ninjago.archive.data.UserPrefsState
import ua.ninjago.archive.data.WuQuotes
import ua.ninjago.archive.data.model.AppThemeMode
import ua.ninjago.archive.data.model.CatalogPayload
import ua.ninjago.archive.data.model.ElementStyle
import ua.ninjago.archive.data.model.Episode
import ua.ninjago.archive.data.model.HallOfFamePayload
import ua.ninjago.archive.data.model.OpeningsPayload
import ua.ninjago.archive.data.model.Season

data class ActivePlayback(
    val season: Season,
    val episode: Episode,
    val mediaUri: String,
    val isOffline: Boolean,
    val isDemoStream: Boolean,
    val startPositionMs: Long
)

data class MainUiState(
    val isLoading: Boolean = true,
    val loadingQuote: String = WuQuotes.randomQuote(),
    val catalog: CatalogPayload = CatalogPayload(),
    val hallOfFame: HallOfFamePayload = HallOfFamePayload(),
    val openings: OpeningsPayload = OpeningsPayload(),
    val prefs: UserPrefsState = UserPrefsState(),
    val selectedEraFilter: String = "all",
    val searchQuery: String = "",
    val limitDialogQuote: String? = null,
    val statusMessage: String? = null,
    val downloadedEpisodeIds: Set<String> = emptySet(),
    val downloadProgress: Map<String, Int> = emptyMap(),
    val activePlayback: ActivePlayback? = null,
    val activeAudioId: String? = null,
    val isAudioPlaying: Boolean = false
) {
    val remainingDailyViews: Int
        get() = if (prefs.isPremium) Int.MAX_VALUE
        else (AppConfig.FREE_DAILY_LIMIT - prefs.dailyWatchCount).coerceAtLeast(0)
}

class MainViewModel(application: Application) : AndroidViewModel(application) {

    private val archiveRepo = ArchiveRepository(application)
    private val prefsRepo = UserPreferencesRepository(application)
    val backpackRepo = BackpackRepository(application)

    private val _uiState = MutableStateFlow(MainUiState())
    val uiState: StateFlow<MainUiState> = _uiState.asStateFlow()

    private var mediaPlayer: MediaPlayer? = null

    init {
        viewModelScope.launch {
            prefsRepo.prefsFlow.collect { prefs ->
                _uiState.update { it.copy(prefs = prefs) }
            }
        }
        refreshData()
    }

    fun refreshData() {
        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true, loadingQuote = WuQuotes.randomQuote()) }
            val catalog = archiveRepo.loadCatalog()
            val hall = archiveRepo.loadHallOfFame()
            val openings = archiveRepo.loadOpenings()
            val downloaded = backpackRepo.listDownloadedIds()
            _uiState.update {
                it.copy(
                    isLoading = false,
                    catalog = catalog,
                    hallOfFame = hall,
                    openings = openings,
                    downloadedEpisodeIds = downloaded
                )
            }
        }
    }

    fun setEraFilter(era: String) = _uiState.update { it.copy(selectedEraFilter = era) }
    fun setSearchQuery(query: String) = _uiState.update { it.copy(searchQuery = query) }
    fun setElement(element: ElementStyle) { viewModelScope.launch { prefsRepo.setElement(element) } }
    fun setThemeMode(mode: AppThemeMode) { viewModelScope.launch { prefsRepo.setThemeMode(mode) } }
    fun toggleBookmark(episodeId: String) { viewModelScope.launch { prefsRepo.toggleBookmark(episodeId) } }
    fun dismissLimitDialog() = _uiState.update { it.copy(limitDialogQuote = null) }
    fun clearStatusMessage() = _uiState.update { it.copy(statusMessage = null) }

    fun findEpisodePair(seasonId: String, episodeId: String): Pair<Season, Episode>? {
        val season = _uiState.value.catalog.seasons.find { it.id == seasonId } ?: return null
        val ep = season.episodes.find { it.id == episodeId } ?: return null
        return season to ep
    }

    fun allBookmarkedPairs(): List<Pair<Season, Episode>> {
        val bookmarked = _uiState.value.prefs.bookmarkedEpisodeIds
        return _uiState.value.catalog.seasons.flatMap { s ->
            s.episodes.filter { it.id in bookmarked }.map { s to it }
        }
    }

    fun allDownloadedPairs(): List<Pair<Season, Episode>> {
        val downloaded = _uiState.value.downloadedEpisodeIds
        return _uiState.value.catalog.seasons.flatMap { s ->
            s.episodes.filter { it.id in downloaded }.map { s to it }
        }
    }

    /**
     * Запускает серию прямо во ВСТРОЕННОМ плеере (офлайн из «Рюкзака» или онлайн с backend).
     */
    fun openEpisodeInPlayer(season: Season, episode: Episode, onNavigateToPlayer: () -> Unit) {
        val state = _uiState.value
        val alreadyWatched = episode.id in state.prefs.watchedEpisodeIds
        if (!state.prefs.isPremium && !alreadyWatched && state.remainingDailyViews <= 0) {
            _uiState.update { it.copy(limitDialogQuote = WuQuotes.randomQuote()) }
            return
        }

        stopAudio()

        val isOffline = backpackRepo.isDownloaded(episode.id)
        val uri = if (isOffline) {
            backpackRepo.getLocalFile(episode.id).toURI().toString()
        } else {
            AppConfig.buildStreamUrl(episode.telegramMessageId, episode.streamUrl)
        }
        val isDemo = !isOffline && uri == AppConfig.DEMO_TEST_VIDEO_URL
        val startPos = state.prefs.episodePositions[episode.id] ?: 0L

        viewModelScope.launch {
            prefsRepo.recordEpisodeStart(
                seasonId = season.id,
                seasonTitle = season.title,
                episodeId = episode.id,
                episodeTitle = episode.title,
                episodeNumber = episode.number,
                incrementDailyCounter = !state.prefs.isPremium && !alreadyWatched
            )
        }

        _uiState.update {
            it.copy(
                activePlayback = ActivePlayback(
                    season = season,
                    episode = episode,
                    mediaUri = uri,
                    isOffline = isOffline,
                    isDemoStream = isDemo,
                    startPositionMs = startPos
                )
            )
        }
        onNavigateToPlayer()
    }

    fun savePlayerProgress(positionMs: Long, durationMs: Long) {
        val active = _uiState.value.activePlayback ?: return
        viewModelScope.launch {
            prefsRepo.savePlaybackPosition(
                seasonId = active.season.id,
                seasonTitle = active.season.title,
                episodeId = active.episode.id,
                episodeTitle = active.episode.title,
                episodeNumber = active.episode.number,
                positionMs = positionMs,
                durationMs = durationMs
            )
        }
    }

    fun closePlayer() {
        _uiState.update { it.copy(activePlayback = null) }
    }

    /** Кнопка «Відкат часу» — случайная серия прямо во встроенном плеере */
    fun launchRandomEpisode(onNavigateToPlayer: () -> Unit) {
        val pairs = _uiState.value.catalog.seasons.flatMap { s -> s.episodes.map { s to it } }
        if (pairs.isEmpty()) return
        val (season, episode) = pairs.random()
        _uiState.update {
            it.copy(statusMessage = "Відкат часу: ${season.title} — Серія ${episode.number}")
        }
        openEpisodeInPlayer(season, episode, onNavigateToPlayer)
    }

    /** Офлайн-режим «Рюкзак»: скачивание серии в защищённую память приложения */
    fun downloadToBackpack(episode: Episode) {
        if (episode.id in _uiState.value.downloadProgress) return
        val url = AppConfig.buildStreamUrl(episode.telegramMessageId, episode.streamUrl)
        viewModelScope.launch {
            _uiState.update { it.copy(downloadProgress = it.downloadProgress + (episode.id to 0)) }
            val result = backpackRepo.downloadEpisode(episode.id, url) { pct ->
                _uiState.update { it.copy(downloadProgress = it.downloadProgress + (episode.id to pct)) }
            }
            _uiState.update {
                it.copy(
                    downloadProgress = it.downloadProgress - episode.id,
                    downloadedEpisodeIds = backpackRepo.listDownloadedIds(),
                    statusMessage = if (result.isSuccess) {
                        "🎒 Збережено в Рюкзак: ${episode.title}"
                    } else {
                        "Не вдалося завантажити серію в Рюкзак."
                    }
                )
            }
        }
    }

    fun removeFromBackpack(episodeId: String) {
        backpackRepo.deleteEpisode(episodeId)
        _uiState.update {
            it.copy(
                downloadedEpisodeIds = backpackRepo.listDownloadedIds(),
                statusMessage = "Серію видалено з Рюкзака."
            )
        }
    }

    fun activatePremiumKey(rawKey: String) {
        viewModelScope.launch {
            val valid = archiveRepo.verifyPremiumKey(rawKey)
            if (valid) {
                prefsRepo.setPremium(true)
                _uiState.update { it.copy(statusMessage = "Преміум-ключ активовано! Повний безліміт відкрито.") }
            } else {
                _uiState.update { it.copy(statusMessage = "Ключ не знайдено. Перевір написання або напиши в Telegram.") }
            }
        }
    }

    fun toggleAudioStream(id: String, streamUrl: String, telegramMessageId: Int) {
        val state = _uiState.value
        if (state.activeAudioId == id && state.isAudioPlaying) {
            stopAudio()
            return
        }
        val resolvedUrl = when {
            streamUrl.isNotBlank() -> streamUrl
            telegramMessageId > 0 && AppConfig.isBackendConfigured() ->
                "${AppConfig.BACKEND_BASE_URL.trimEnd('/')}/stream/$telegramMessageId"
            else -> ""
        }
        if (resolvedUrl.isBlank()) {
            _uiState.update {
                it.copy(statusMessage = "Додай посилання або ID аудіо в data/openings.json, щоб слухати тут.")
            }
            return
        }
        stopAudio()
        runCatching {
            val mp = MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .setUsage(AudioAttributes.USAGE_MEDIA)
                        .build()
                )
                setDataSource(resolvedUrl)
                setOnPreparedListener {
                    it.start()
                    _uiState.update { st -> st.copy(activeAudioId = id, isAudioPlaying = true) }
                }
                setOnCompletionListener {
                    _uiState.update { st -> st.copy(activeAudioId = null, isAudioPlaying = false) }
                }
                prepareAsync()
            }
            mediaPlayer = mp
        }.onFailure {
            _uiState.update { it.copy(statusMessage = "Не вдалося запустити аудіо.") }
        }
    }

    fun stopAudio() {
        runCatching {
            mediaPlayer?.stop()
            mediaPlayer?.release()
        }
        mediaPlayer = null
        _uiState.update { it.copy(activeAudioId = null, isAudioPlaying = false) }
    }

    override fun onCleared() {
        stopAudio()
        super.onCleared()
    }
}
