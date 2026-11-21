package ua.ninjago.archive.ui.screens

import android.app.Activity
import android.content.pm.ActivityInfo
import android.net.Uri
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.annotation.OptIn
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.FastForward
import androidx.compose.material.icons.filled.FastRewind
import androidx.compose.material.icons.filled.ScreenRotation
import androidx.compose.material.icons.filled.SkipNext
import androidx.compose.material3.AssistChip
import androidx.compose.material3.Button
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackParameters
import androidx.media3.common.util.UnstableApi
import androidx.media3.datasource.DefaultDataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.source.DefaultMediaSourceFactory
import androidx.media3.ui.PlayerView
import kotlinx.coroutines.delay
import ua.ninjago.archive.config.AppConfig
import ua.ninjago.archive.data.model.Episode
import ua.ninjago.archive.data.model.Season
import ua.ninjago.archive.ui.viewmodel.ActivePlayback

@OptIn(UnstableApi::class)
@Composable
fun PlayerScreen(
    playback: ActivePlayback?,
    onSaveProgress: (Long, Long) -> Unit,
    onPlayNextEpisode: (Season, Episode) -> Unit,
    onBack: () -> Unit
) {
    val context = LocalContext.current
    val activity = context as? Activity
    var isLandscape by remember { mutableStateOf(false) }
    var playbackSpeed by remember { mutableFloatStateOf(1.0f) }

    if (playback == null) {
        Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            Text("Серію не обрано.")
        }
        return
    }

    val nextEpisode = remember(playback.season.id, playback.episode.id) {
        val idx = playback.season.episodes.indexOfFirst { it.id == playback.episode.id }
        if (idx >= 0 && idx + 1 < playback.season.episodes.size) playback.season.episodes[idx + 1] else null
    }

    val exoPlayer = remember(playback.episode.id, playback.mediaUri) {
        val httpFactory = DefaultHttpDataSource.Factory().apply {
            if (AppConfig.BACKEND_API_KEY.isNotBlank() && AppConfig.isBackendConfigured()) {
                setDefaultRequestProperties(mapOf("X-App-Key" to AppConfig.BACKEND_API_KEY))
            }
        }
        val dataSourceFactory = DefaultDataSource.Factory(context, httpFactory)
        ExoPlayer.Builder(context)
            .setMediaSourceFactory(DefaultMediaSourceFactory(dataSourceFactory))
            .build()
            .apply {
                setMediaItem(MediaItem.fromUri(Uri.parse(playback.mediaUri)))
                prepare()
                if (playback.startPositionMs > 0L) {
                    seekTo(playback.startPositionMs)
                }
                playWhenReady = true
            }
    }

    LaunchedEffect(exoPlayer) {
        while (true) {
            delay(4000L)
            val pos = exoPlayer.currentPosition.coerceAtLeast(0L)
            val dur = exoPlayer.duration.coerceAtLeast(0L)
            if (pos > 0L) onSaveProgress(pos, dur)
        }
    }

    DisposableEffect(exoPlayer) {
        onDispose {
            val pos = exoPlayer.currentPosition.coerceAtLeast(0L)
            val dur = exoPlayer.duration.coerceAtLeast(0L)
            if (pos > 0L) onSaveProgress(pos, dur)
            exoPlayer.release()
            activity?.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.Black)
    ) {
        if (!isLandscape) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 8.dp, vertical = 6.dp),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                IconButton(onClick = onBack) {
                    Icon(
                        imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                        contentDescription = "Назад",
                        tint = Color.White
                    )
                }
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = "Серія ${playback.episode.number}: ${playback.episode.title}",
                        style = MaterialTheme.typography.titleSmall,
                        color = Color.White,
                        fontWeight = FontWeight.Bold
                    )
                    Text(
                        text = playback.season.title,
                        style = MaterialTheme.typography.labelSmall,
                        color = Color.LightGray
                    )
                }
                IconButton(
                    onClick = {
                        isLandscape = !isLandscape
                        activity?.requestedOrientation =
                            if (isLandscape) ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                            else ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
                    }
                ) {
                    Icon(
                        imageVector = Icons.Default.ScreenRotation,
                        contentDescription = "Повернути екран",
                        tint = Color.White
                    )
                }
            }
        }

        Box(
            modifier = if (isLandscape) Modifier.fillMaxSize()
            else Modifier
                .fillMaxWidth()
                .aspectRatio(16f / 9f)
        ) {
            AndroidView(
                factory = { ctx ->
                    PlayerView(ctx).apply {
                        player = exoPlayer
                        useController = true
                        layoutParams = FrameLayout.LayoutParams(
                            ViewGroup.LayoutParams.MATCH_PARENT,
                            ViewGroup.LayoutParams.MATCH_PARENT
                        )
                    }
                },
                update = { view -> view.player = exoPlayer },
                modifier = Modifier.fillMaxSize()
            )
            if (isLandscape) {
                IconButton(
                    onClick = {
                        isLandscape = false
                        activity?.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
                    },
                    modifier = Modifier
                        .align(Alignment.TopEnd)
                        .padding(12.dp)
                ) {
                    Icon(
                        imageVector = Icons.Default.ScreenRotation,
                        contentDescription = "Вийти з повного екрана",
                        tint = Color.White
                    )
                }
            }
        }

        if (!isLandscape) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(MaterialTheme.colorScheme.background)
                    .weight(1f)
                    .padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                // Quick player controls: -10s, +10s, Skip Intro (+45s), Speed
                @OptIn(ExperimentalLayoutApi::class)
                FlowRow(
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    AssistChip(
                        onClick = { exoPlayer.seekTo((exoPlayer.currentPosition - 10_000L).coerceAtLeast(0L)) },
                        leadingIcon = { Icon(Icons.Default.FastRewind, contentDescription = null) },
                        label = { Text("-10с") }
                    )
                    AssistChip(
                        onClick = { exoPlayer.seekTo(exoPlayer.currentPosition + 10_000L) },
                        leadingIcon = { Icon(Icons.Default.FastForward, contentDescription = null) },
                        label = { Text("+10с") }
                    )
                    AssistChip(
                        onClick = { exoPlayer.seekTo(exoPlayer.currentPosition + 45_000L) },
                        label = { Text("⚡ Пропустити інтро") }
                    )
                    AssistChip(
                        onClick = {
                            val speeds = listOf(1.0f, 1.25f, 1.5f, 2.0f)
                            val next = speeds[(speeds.indexOf(playbackSpeed) + 1) % speeds.size]
                            playbackSpeed = next
                            exoPlayer.playbackParameters = PlaybackParameters(next)
                        },
                        label = { Text("Швидкість ${playbackSpeed}x") }
                    )
                }

                if (nextEpisode != null) {
                    Button(
                        onClick = { onPlayNextEpisode(playback.season, nextEpisode) },
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Icon(Icons.Default.SkipNext, contentDescription = null)
                        Text(
                            text = "Наступна: Серія ${nextEpisode.number} — ${nextEpisode.title}",
                            modifier = Modifier.padding(start = 6.dp)
                        )
                    }
                }

                val modeBadge = when {
                    playback.isOffline -> "🎒 Офлайн-відтворення з Рюкзака"
                    playback.isDemoStream -> "🧪 Демо-потік (підключи backend/ для серії #${playback.episode.telegramMessageId} з приватного ТГ)"
                    else -> "⚡ Прямий потік 1080p UA із закритого архіву"
                }
                Surface(
                    shape = RoundedCornerShape(12.dp),
                    color = MaterialTheme.colorScheme.primaryContainer,
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text(
                        text = modeBadge,
                        style = MaterialTheme.typography.labelMedium,
                        color = MaterialTheme.colorScheme.onPrimaryContainer,
                        modifier = Modifier.padding(12.dp)
                    )
                }

                Text(
                    text = playback.season.description,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}
