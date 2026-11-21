# Бесплатный прокси-сервер для приватного Telegram-канала

Этот сервер позволяет **Lego Ninjago UA Archive** проигрывать 1080p-серии из твоего **закрытого Telegram-канала (`-1004438841209`)** прямо во встроенном плеере приложения с перемоткой и скачиванием в «Рюкзак». Пользователи вообще не видят твой канал!

## Как запустить бесплатно (0 грн/мес) за 5 минут через Hugging Face Spaces

1. В Telegram открой `@BotFather` → `/newbot` → скопируй `TG_BOT_TOKEN`.
2. Добавь этого бота **Администратором** в свой закрытый канал с сериями (достаточно права чтения сообщений).
3. Получи `TG_API_ID` и `TG_API_HASH` на сайте `my.telegram.org` (раздел **API development tools**).
4. Зарегистрируйся на **Hugging Face** → создай новый **Space** → выбери SDK **Docker** (Blank) → **Public** или **Private** (для Android без токена нужен Public Space, но доступ к `/stream/` защищён твоим `APP_API_KEY`).
5. Загрузи в Space три файла из этой папки: `Dockerfile`, `requirements.txt`, `main.py`.
6. В **Settings → Variables and secrets** добавь секреты:
   - `TG_API_ID`
   - `TG_API_HASH`
   - `TG_BOT_TOKEN`
   - `TG_CHANNEL_ID` = `-1004438841209`
   - `APP_API_KEY` = `ninjago_ua_secret_2026` (или свой пароль)
7. Скопируй URL вида `https://ТВОЙ_НИК-имя-спейса.hf.space` и вставь его в `AppConfig.kt` (`BACKEND_BASE_URL`).

Готово! Теперь `S00E01` (`telegramMessageId = 3`) заиграет прямо внутри твоего Android-приложения.
