package ua.ninjago.archive.ui.screens

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import ua.ninjago.archive.data.model.Episode
import ua.ninjago.archive.data.model.Season
import ua.ninjago.archive.ui.viewmodel.MainUiState

@Composable
fun ProfileScreen(
    state: MainUiState,
    bookmarkedPairs: List<Pair<Season, Episode>>,
    downloadedPairs: List<Pair<Season, Episode>>,
    onWatchEpisode: (Season, Episode) -> Unit,
    onDeleteDownload: (String) -> Unit,
    onOpenTeaShop: () -> Unit,
    onOpenTelegram: () -> Unit
) {
    val watchedCount = state.prefs.watchedEpisodeIds.size

    LazyColumn(
        modifier = Modifier.fillMaxSize(),
        contentPadding = PaddingValues(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        item {
            Text(
                text = "🥋 Профіль Ніндзя",
                style = MaterialTheme.typography.headlineSmall,
                fontWeight = FontWeight.ExtraBold
            )
            Text(
                text = "Переглянуто: $watchedCount • В обраному: ${bookmarkedPairs.size} • У Рюкзаку: ${downloadedPairs.size}",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            Spacer(Modifier.height(10.dp))
            Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                Button(onClick = onOpenTeaShop, modifier = Modifier.weight(1f)) {
                    Text("🍵 Чайна лавка")
                }
                OutlinedButton(onClick = onOpenTelegram, modifier = Modifier.weight(1f)) {
                    Text("✈️ Telegram")
                }
            }
        }

        // Offline Backpack («Рюкзак»)
        item {
            Text(
                text = "🎒 Рюкзак (Офлайн-серії)",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )
        }
        if (downloadedPairs.isEmpty()) {
            item {
                Text(
                    text = "Поки що порожньо. Натисни іконку завантаження біля будь-якої серії, щоб дивитися її без інтернету.",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        } else {
            items(downloadedPairs, key = { "dl_${it.second.id}" }) { (season, ep) ->
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clickable { onWatchEpisode(season, ep) },
                    shape = RoundedCornerShape(14.dp),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface)
                ) {
                    Row(
                        modifier = Modifier.padding(12.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                text = "Серія ${ep.number}: ${ep.title}",
                                style = MaterialTheme.typography.titleSmall,
                                fontWeight = FontWeight.Bold
                            )
                            Text(
                                text = season.title,
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                        IconButton(onClick = { onWatchEpisode(season, ep) }) {
                            Icon(Icons.Default.PlayArrow, contentDescription = "Дивитись", tint = MaterialTheme.colorScheme.primary)
                        }
                        IconButton(onClick = { onDeleteDownload(ep.id) }) {
                            Icon(Icons.Default.Delete, contentDescription = "Видалити")
                        }
                    }
                }
            }
        }

        // Bookmarks («Обране»)
        item {
            Spacer(Modifier.height(4.dp))
            Text(
                text = "🔖 Обране (Закладки)",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )
        }
        if (bookmarkedPairs.isEmpty()) {
            item {
                Text(
                    text = "Додавай улюблені серії в закладки, щоб швидко повертатися до них.",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        } else {
            items(bookmarkedPairs, key = { "bm_${it.second.id}" }) { (season, ep) ->
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clickable { onWatchEpisode(season, ep) },
                    shape = RoundedCornerShape(14.dp),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface)
                ) {
                    Row(
                        modifier = Modifier.padding(12.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                text = "Серія ${ep.number}: ${ep.title}",
                                style = MaterialTheme.typography.titleSmall,
                                fontWeight = FontWeight.Bold
                            )
                            Text(
                                text = season.title,
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                        Icon(
                            imageVector = Icons.Default.PlayArrow,
                            contentDescription = "Дивитись",
                            tint = MaterialTheme.colorScheme.primary
                        )
                    }
                }
            }
        }

        // Hall of Fame
        item {
            Spacer(Modifier.height(4.dp))
            Text(
                text = "🏆 Зал Слави",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )
            Text(
                text = "Дякуємо кожному, хто підтримує український архів Ninjago",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }

        items(state.hallOfFame.ranks, key = { it.id }) { rank ->
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(14.dp),
                colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface)
            ) {
                Column(modifier = Modifier.padding(14.dp)) {
                    Text(
                        text = "${rank.badge} ${rank.title}",
                        style = MaterialTheme.typography.titleSmall,
                        fontWeight = FontWeight.Bold
                    )
                    Text(
                        text = rank.subtitle,
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.primary
                    )
                    Spacer(Modifier.height(6.dp))
                    rank.members.forEach { member ->
                        val suffix = if (member.note.isNotBlank()) " — ${member.note}" else ""
                        Text(text = "• ${member.name}$suffix", style = MaterialTheme.typography.bodySmall)
                    }
                }
            }
        }
    }
}
