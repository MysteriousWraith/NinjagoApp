package ua.ninjago.archive.config

object AppConfig {
    /**
     * URL твоего бесплатного прокси-сервера из папки backend/ (например, Hugging Face Spaces).
     * Пример: "https://mysteriouswraith-ninjago-stream.hf.space"
     * Пока здесь стоит YOUR_BACKEND_URL — плеер использует тестовый 1080p-поток, чтобы можно было сразу проверить плеер и «Рюкзак».
     */
    const val BACKEND_BASE_URL = "https://YOUR_BACKEND_URL"

    /** Секретный ключ, совпадающий с APP_API_KEY в backend/.env */
    const val BACKEND_API_KEY = "ninjago_ua_secret_2026"

    /** Публичная ссылка на Telegram для покупки Премиум-ключа и связи с автором */
    const val TELEGRAM_CONTACT_URL = "https://t.me/YOUR_TELEGRAM"

    /** Опциональный публичный GitHub Raw URL для обновления JSON без пересборки APK */
    const val GITHUB_RAW_BASE_URL =
        "https://raw.githubusercontent.com/MysteriousWraith/NinjagoApp/main/data/"

    /** Суточный лимит просмотров для бесплатных пользователей */
    const val FREE_DAILY_LIMIT = 4

    /** Тестовый открытый видеопоток для проверки встроенного плеера до подключения backend */
    const val DEMO_TEST_VIDEO_URL =
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"

    fun isBackendConfigured(): Boolean =
        BACKEND_BASE_URL.startsWith("http") && !BACKEND_BASE_URL.contains("YOUR_BACKEND_URL")

    fun buildStreamUrl(telegramMessageId: Int, explicitStreamUrl: String): String {
        if (explicitStreamUrl.isNotBlank()) return explicitStreamUrl
        if (telegramMessageId > 0 && isBackendConfigured()) {
            return "${BACKEND_BASE_URL.trimEnd('/')}/stream/$telegramMessageId"
        }
        return DEMO_TEST_VIDEO_URL
    }
}
