package ua.ninjago.archive.ui.screens

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.height
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp

fun formatTimecode(ms: Long): String {
    val totalSeconds = (ms / 1000L).coerceAtLeast(0L)
    val mins = totalSeconds / 60L
    val secs = totalSeconds % 60L
    return "%02d:%02d".format(mins, secs)
}

@Composable
fun WuLimitScrollDialog(
    quote: String,
    onDismiss: () -> Unit,
    onOpenTeaShop: () -> Unit,
    onOpenTelegram: () -> Unit
) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(text = "📜 Сувій Сенсея Ву", fontWeight = FontWeight.Bold) },
        text = {
            Column {
                Text(
                    text = quote,
                    style = MaterialTheme.typography.bodyMedium,
                    fontStyle = FontStyle.Italic
                )
                Spacer(Modifier.height(12.dp))
                Text(
                    text = "Денний безкоштовний ліміт серій вичерпано. Повертайся завтра або активуй Преміум-ключ у Чайній лавці Ву для повного безліміту.",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        },
        confirmButton = { Button(onClick = onOpenTeaShop) { Text("Ввести ключ") } },
        dismissButton = { OutlinedButton(onClick = onOpenTelegram) { Text("Telegram") } }
    )
}
