package ua.ninjago.archive.data.model

import kotlinx.serialization.Serializable

@Serializable
data class CatalogPayload(
    val version: Int = 2,
    val updatedAt: String = "",
    val seasons: List<Season> = emptyList()
)

@Serializable
data class Season(
    val id: String,
    val number: Int,
    val title: String,
    val subtitle: String = "",
    val era: String = "classic",
    val timelineOrder: Int = 0,
    val year: Int = 2011,
    val description: String = "",
    val episodes: List<Episode> = emptyList()
)

@Serializable
data class Episode(
    val id: String,
    val number: Int,
    val title: String,
    val durationMinutes: Int = 22,
    val quality: String = "1080p UA",
    val telegramMessageId: Int = 0,
    val streamUrl: String = ""
)

@Serializable
data class HallOfFamePayload(
    val updatedAt: String = "",
    val ranks: List<HallRank> = emptyList()
)

@Serializable
data class HallRank(
    val id: String,
    val title: String,
    val subtitle: String,
    val badge: String,
    val members: List<HallMember> = emptyList()
)

@Serializable
data class HallMember(
    val name: String,
    val note: String = ""
)

@Serializable
data class KeysPayload(
    val note: String = "",
    val hashes: List<String> = emptyList()
)

@Serializable
data class OpeningsPayload(
    val tracks: List<OpeningTrack> = emptyList(),
    val monasteryRadio: MonasteryRadio = MonasteryRadio()
)

@Serializable
data class OpeningTrack(
    val id: String,
    val title: String,
    val season: String,
    val artist: String = "The Fold",
    val audioUrl: String = "",
    val telegramMessageId: Int = 0
)

@Serializable
data class MonasteryRadio(
    val title: String = "Радіо Монастиря • Lofi",
    val subtitle: String = "Спокійна музика для відпочинку",
    val streamUrl: String = "",
    val telegramMessageId: Int = 0
)

enum class ElementStyle(val labelUa: String, val emoji: String) {
    FIRE("Вогонь", "🔥"),
    ICE("Лід", "❄️"),
    EARTH("Земля", "🪨"),
    LIGHTNING("Блискавка", "⚡"),
    WATER("Вода", "💧"),
    ENERGY("Енергія", "🐉")
}

enum class AppThemeMode(val labelUa: String, val descriptionUa: String) {
    GARMADON_SHADOW("Тінь Гармадона", "Фіолетово-вугільна гама з неоновим сяйвом"),
    DARK("Темна", "Класична нічна палітра"),
    LIGHT("Світла", "Світлий сувій Монастиря")
}

data class ContinueWatching(
    val seasonId: String,
    val seasonTitle: String,
    val episodeId: String,
    val episodeTitle: String,
    val episodeNumber: Int,
    val positionMs: Long = 0L,
    val durationMs: Long = 0L
)
