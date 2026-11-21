package ua.ninjago.archive.ui.theme

import androidx.compose.material3.ColorScheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import ua.ninjago.archive.data.model.AppThemeMode
import ua.ninjago.archive.data.model.ElementStyle

private fun accentFor(element: ElementStyle): Pair<Color, Color> = when (element) {
    ElementStyle.FIRE -> Color(0xFFE53935) to Color(0xFFFFB300)
    ElementStyle.ICE -> Color(0xFF4FC3F7) to Color(0xFFB3E5FC)
    ElementStyle.EARTH -> Color(0xFFFF8F00) to Color(0xFF8D6E63)
    ElementStyle.LIGHTNING -> Color(0xFF2979FF) to Color(0xFFFFEA00)
    ElementStyle.WATER -> Color(0xFF00ACC1) to Color(0xFF4DD0E1)
    ElementStyle.ENERGY -> Color(0xFF00E676) to Color(0xFFFFD600)
}

private fun buildScheme(element: ElementStyle, mode: AppThemeMode): ColorScheme {
    val (primary, secondary) = accentFor(element)
    return when (mode) {
        AppThemeMode.GARMADON_SHADOW -> darkColorScheme(
            primary = Color(0xFFCC66FF),
            onPrimary = Color(0xFF14091E),
            primaryContainer = Color(0xFF32174D),
            onPrimaryContainer = Color(0xFFF3D9FF),
            secondary = primary,
            onSecondary = Color(0xFF0D0A14),
            tertiary = secondary,
            background = Color(0xFF0D0A14),
            onBackground = Color(0xFFEDE7F6),
            surface = Color(0xFF161024),
            onSurface = Color(0xFFEDE7F6),
            surfaceVariant = Color(0xFF231938),
            onSurfaceVariant = Color(0xFFC5B6DF),
            outline = Color(0xFF6B4C9A)
        )
        AppThemeMode.DARK -> darkColorScheme(
            primary = primary,
            onPrimary = Color(0xFF101216),
            primaryContainer = primary.copy(alpha = 0.22f),
            onPrimaryContainer = Color(0xFFF5F5F7),
            secondary = secondary,
            onSecondary = Color(0xFF101216),
            background = Color(0xFF111318),
            onBackground = Color(0xFFF1F3F7),
            surface = Color(0xFF1A1D24),
            onSurface = Color(0xFFF1F3F7),
            surfaceVariant = Color(0xFF252A34),
            onSurfaceVariant = Color(0xFFB8C0CC)
        )
        AppThemeMode.LIGHT -> lightColorScheme(
            primary = primary,
            onPrimary = Color.White,
            primaryContainer = primary.copy(alpha = 0.14f),
            onPrimaryContainer = Color(0xFF1A1C20),
            secondary = secondary,
            onSecondary = Color(0xFF1A1C20),
            background = Color(0xFFF7F5F0),
            onBackground = Color(0xFF1C1B1F),
            surface = Color(0xFFFFFFFF),
            onSurface = Color(0xFF1C1B1F),
            surfaceVariant = Color(0xFFECE7DD),
            onSurfaceVariant = Color(0xFF4B4740)
        )
    }
}

@Composable
fun NinjagoArchiveTheme(
    element: ElementStyle,
    themeMode: AppThemeMode,
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = buildScheme(element, themeMode),
        content = content
    )
}
