import os
import re
from contextlib import asynccontextmanager
from typing import Optional

from fastapi import FastAPI, Header, HTTPException, Request
from fastapi.responses import StreamingResponse
from telethon import TelegramClient

TG_API_ID = int(os.environ.get("TG_API_ID", "0"))
TG_API_HASH = os.environ.get("TG_API_HASH", "")
TG_BOT_TOKEN = os.environ.get("TG_BOT_TOKEN", "")
TG_CHANNEL_ID = int(os.environ.get("TG_CHANNEL_ID", "-1004438841209"))
APP_API_KEY = os.environ.get("APP_API_KEY", "").strip()

client: Optional[TelegramClient] = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    global client
    if TG_API_ID and TG_API_HASH and TG_BOT_TOKEN:
        client = TelegramClient("ninjago_bot", TG_API_ID, TG_API_HASH)
        await client.start(bot_token=TG_BOT_TOKEN)
    yield
    if client:
        await client.disconnect()


app = FastAPI(title="Lego Ninjago UA Archive Streamer", lifespan=lifespan)


def check_auth(x_app_key: Optional[str]):
    if APP_API_KEY and x_app_key != APP_API_KEY:
        raise HTTPException(status_code=403, detail="Forbidden")


@app.get("/")
async def health():
    return {
        "status": "ok",
        "app": "Lego Ninjago UA Archive",
        "telegram_connected": client is not None and client.is_connected(),
        "channel_id": TG_CHANNEL_ID,
    }


@app.get("/stream/{message_id}")
async def stream_episode(
    message_id: int,
    request: Request,
    x_app_key: Optional[str] = Header(default=None),
):
    check_auth(x_app_key)
    if not client or not client.is_connected():
        raise HTTPException(status_code=503, detail="Telegram client is not configured")

    msg = await client.get_messages(TG_CHANNEL_ID, ids=message_id)
    if not msg or not msg.file:
        raise HTTPException(status_code=404, detail="Episode file not found in channel")

    file_size = msg.file.size
    mime_type = msg.file.mime_type or "video/mp4"

    range_header = request.headers.get("range")
    start = 0
    end = file_size - 1
    status_code = 200

    if range_header:
        match = re.match(r"bytes=(\d+)-(\d*)", range_header)
        if match:
            start = int(match.group(1))
            if match.group(2):
                end = min(int(match.group(2)), file_size - 1)
            status_code = 206

    if start >= file_size or start > end:
        raise HTTPException(status_code=416, detail="Requested Range Not Satisfiable")

    content_length = end - start + 1

    async def file_iterator():
        bytes_remaining = content_length
        async for chunk in client.iter_download(
            msg.media,
            offset=start,
            request_size=512 * 1024,
        ):
            if bytes_remaining <= 0:
                break
            if len(chunk) > bytes_remaining:
                yield chunk[:bytes_remaining]
                break
            yield chunk
            bytes_remaining -= len(chunk)

    headers = {
        "Accept-Ranges": "bytes",
        "Content-Length": str(content_length),
        "Content-Type": mime_type,
    }
    if status_code == 206:
        headers["Content-Range"] = f"bytes {start}-{end}/{file_size}"

    return StreamingResponse(
        file_iterator(),
        status_code=status_code,
        headers=headers,
        media_type=mime_type,
    )
