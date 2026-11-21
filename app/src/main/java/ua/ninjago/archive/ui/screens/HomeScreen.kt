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
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Casino
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.AssistChip
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.FilterChip
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import ua.ninjago.archive.config.AppConfig
import ua.ninjago.archive.data.model.Season
import ua.ninjago.archive.ui.viewmodel.MainUiState

@Composable
fun HomeScreen(
    state: MainUiState,
    onSelectEra: (String) -> Unit,
    onSearchChange: (String) -> Unit,
    onOpenSeason: (String) -> Unit,
    onContinueWatching: (String, String) -> Unit,
    onRandomEpisode: () -> Unit,
    onOpenTeaShop: () -> Unit
) {
    val filters = listOf(
        "all" to "Усі (0–15)",
        "classic" to "Класика (0–10)",
        "new_era" to "Нова ера (11–15)",
        "special" to "Спешли та фільми"
    )

    val q = state.searchQuery.trim().lowercase()
    val filteredSeasons = state.catalog.seasons
        .filter { state.selectedEraFilter == "all" || it.era == state.selectedEraFilter }
        .filter { s ->
            q.isEmpty() ||
                s.title.lowercase().contains(q) ||
                s.description.lowercase().contains(q) ||
                s.episodes.any { it.title.lowercase().contains(q) }
        }

    LazyColumn(
        modifier = Modifier.fillMaxSize(),
        contentPadding = PaddingValues(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        item {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = "Lego Ninjago UA Archive",
                        style = MaterialTheme.typography.headlineSmall,
                        fontWeight = FontWeight.ExtraBold
                    )
                    Text(
                        text = "${state.prefs.element.emoji} Стихія: ${state.prefs.element.labelUa} • 1080p Дубляж",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
                IconButton(onClick = onRandomEpisode) {
                    Icon(
                        imageVector = Icons.Default.Casino,
                        contentDescription = "Відкат часу",
                        tint = MaterialTheme.colorScheme.primary
                    )
                }
                IconButton(onClick = onOpenTeaShop) {
                    Icon(Icons.Default.Settings, contentDescription = "Чайна лавка Ву")
                }
            }
        }

        // Daily limit / Premium badge
        item {
            Surface(
                shape = RoundedCornerShape(14.dp),
                color = MaterialTheme.colorScheme.primaryContainer,
                modifier = Modifier.fillMaxWidth()
            ) {
                val statusText = if (state.prefs.isPremium) {
                    "⚡ Преміум-ключ активний • Повний безліміт"
                } else {
                    "🎟️ Доступно сьогодні: ${state.remainingDailyViews} з ${AppConfig.FREE_DAILY_LIMIT} серій"
                }
                Text(
                    text = statusText,
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.onPrimaryContainer,
                    fontWeight = FontWeight.SemiBold,
                    modifier = Modifier.padding(horizontal = 14.dp, vertical = 10.dp)
                )
            }
        }

        // Continue Watching with real timecode & progress bar!
        state.prefs.continueWatching?.let { cw ->
            item {
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clickable { onContinueWatching(cw.seasonId, cw.episodeId) },
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant),
                    shape = RoundedCornerShape(16.dp)
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Column(modifier = Modifier.weight(1f)) {
                                Text(
                                    text = "ПРОДОВЖИТИ ПЕРЕГЛЯД",
                                    style = MaterialTheme.typography.labelSmall,
                                    color = MaterialTheme.colorScheme.primary,
                                    fontWeight = FontWeight.Bold
                                )
                                Spacer(Modifier.height(4.dp))
                                Text(
                                    text = cw.seasonTitle,
                                    style = MaterialTheme.typography.titleMedium,
                                    fontWeight = FontWeight.Bold
                                )
                                val timeSuffix = if (cw.positionMs > 0L) " • ${formatTimecode(cw.positionMs)}" else ""
                                Text(
                                    text = "Серія ${cw.episodeNumber}: ${cw.episodeTitle}$timeSuffix",
                                    style = MaterialTheme.typography.bodySmall,
                                    color = MaterialTheme.colorScheme.onSurfaceVariant
                                )
                            }
                            Icon(
                                imageVector = Icons.Default.PlayArrow,
                                contentDescription = "Продовжити",
                                tint = MaterialTheme.colorScheme.primary
                            )
                        }
                        if (cw.durationMs > 0L && cw.positionMs > 0L) {
                            Spacer(Modifier.height(10.dp))
                            LinearProgressIndicator(
                                progress = { (cw.positionMs.toFloat() / cw.durationMs.toFloat()).coerceIn(0f, 1f) },
                                modifier = Modifier.fillMaxWidth()
                            )
                        }
                    }
                }
            }
        }

        // Search bar
        item {
            OutlinedTextField(
                value = state.searchQuery,
                onValueChange = onSearchChange,
                placeholder = { Text("Пошук сезону або серії...") },
                leadingIcon = { Icon(Icons.Default.Search, contentDescription = null) },
                singleLine = true,
                shape = RoundedCornerShape(14.dp),
                modifier = Modifier.fillMaxWidth()
            )
        }

        // Era filter chips
        item {
            LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                items(filters) { (key, label) ->
                    FilterChip(
                        selected = state.selectedEraFilter == key,
                        onClick = { onSelectEra(key) },
                        label = { Text(label) }
                    )
                }
            }
        }

        items(filteredSeasons, key = { it.id }) { season ->
            SeasonCard(season = season, onClick = { onOpenSeason(season.id) })
        }

        item {
            Card(
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(
                    containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.55f)
                ),
                shape = RoundedCornerShape(16.dp)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        text = "🐉 Повстання драконів (Dragons Rising)",
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold
                    )
                    Spacer(Modifier.height(4.dp))
                    Text(
                        text = "Заплановано в наступних оновленнях після повної бази сезонів 0–15.",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
    }
}

@Composable
private fun SeasonCard(season: Season, onClick: () -> Unit) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = season.title,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.weight(1f)
                )
                AssistChip(onClick = onClick, label = { Text("${season.episodes.size} сер.") })
            }
            if (season.subtitle.isNotBlank()) {
                Text(
                    text = season.subtitle,
                    style = MaterialTheme.typography.labelMedium,
                    color = MaterialTheme.colorScheme.primary
                )
            }
            if (season.description.isNotBlank()) {
                Spacer(Modifier.height(6.dp))
                Text(
                    text = season.description,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}
