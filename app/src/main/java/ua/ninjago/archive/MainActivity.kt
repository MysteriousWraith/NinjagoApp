package ua.ninjago.archive

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.MusicNote
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Timeline
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import ua.ninjago.archive.config.AppConfig
import ua.ninjago.archive.ui.screens.HomeScreen
import ua.ninjago.archive.ui.screens.MusicScreen
import ua.ninjago.archive.ui.screens.PlayerScreen
import ua.ninjago.archive.ui.screens.ProfileScreen
import ua.ninjago.archive.ui.screens.SeasonDetailScreen
import ua.ninjago.archive.ui.screens.TeaShopSettingsScreen
import ua.ninjago.archive.ui.screens.TimelineScreen
import ua.ninjago.archive.ui.screens.WuLimitScrollDialog
import ua.ninjago.archive.ui.theme.NinjagoArchiveTheme
import ua.ninjago.archive.ui.viewmodel.MainViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            val vm: MainViewModel = viewModel()
            val state by vm.uiState.collectAsState()

            NinjagoArchiveTheme(
                element = state.prefs.element,
                themeMode = state.prefs.themeMode
            ) {
                NinjagoAppRoot(
                    vm = vm,
                    onOpenExternalUrl = { url -> openExternalUrl(url) }
                )
            }
        }
    }

    private fun openExternalUrl(url: String) {
        runCatching {
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
        }
    }
}

@Composable
private fun NinjagoAppRoot(
    vm: MainViewModel,
    onOpenExternalUrl: (String) -> Unit
) {
    val state by vm.uiState.collectAsState()
    val navController = rememberNavController()
    val snackbarHostState = remember { SnackbarHostState() }

    LaunchedEffect(state.statusMessage) {
        state.statusMessage?.let { msg ->
            snackbarHostState.showSnackbar(msg)
            vm.clearStatusMessage()
        }
    }

    state.limitDialogQuote?.let { quote ->
        WuLimitScrollDialog(
            quote = quote,
            onDismiss = { vm.dismissLimitDialog() },
            onOpenTeaShop = {
                vm.dismissLimitDialog()
                navController.navigate("tea_shop")
            },
            onOpenTelegram = {
                vm.dismissLimitDialog()
                onOpenExternalUrl(AppConfig.TELEGRAM_CONTACT_URL)
            }
        )
    }

    val backStack by navController.currentBackStackEntryAsState()
    val currentRoute = backStack?.destination?.route
    val showBottomBar = currentRoute in listOf("home", "timeline", "music", "profile")

    if (state.isLoading) {
        Box(
            modifier = Modifier.fillMaxSize().padding(32.dp),
            contentAlignment = Alignment.Center
        ) {
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                CircularProgressIndicator()
                Spacer(Modifier.height(20.dp))
                Text(
                    text = state.loadingQuote,
                    style = MaterialTheme.typography.bodyMedium,
                    fontStyle = FontStyle.Italic,
                    textAlign = TextAlign.Center
                )
            }
        }
        return
    }

    Scaffold(
        snackbarHost = { SnackbarHost(snackbarHostState) },
        bottomBar = {
            if (showBottomBar) {
                NavigationBar {
                    NavigationBarItem(
                        selected = currentRoute == "home",
                        onClick = { navController.navigate("home") { launchSingleTop = true; popUpTo("home") } },
                        icon = { Icon(Icons.Default.Home, contentDescription = null) },
                        label = { Text("Головна") }
                    )
                    NavigationBarItem(
                        selected = currentRoute == "timeline",
                        onClick = { navController.navigate("timeline") { launchSingleTop = true; popUpTo("home") } },
                        icon = { Icon(Icons.Default.Timeline, contentDescription = null) },
                        label = { Text("Таймлайн") }
                    )
                    NavigationBarItem(
                        selected = currentRoute == "music",
                        onClick = { navController.navigate("music") { launchSingleTop = true; popUpTo("home") } },
                        icon = { Icon(Icons.Default.MusicNote, contentDescription = null) },
                        label = { Text("Музика") }
                    )
                    NavigationBarItem(
                        selected = currentRoute == "profile",
                        onClick = { navController.navigate("profile") { launchSingleTop = true; popUpTo("home") } },
                        icon = { Icon(Icons.Default.Person, contentDescription = null) },
                        label = { Text("Профіль") }
                    )
                }
            }
        }
    ) { innerPadding ->
        NavHost(
            navController = navController,
            startDestination = "home",
            modifier = Modifier.padding(innerPadding)
        ) {
            composable("home") {
                HomeScreen(
                    state = state,
                    onSelectEra = vm::setEraFilter,
                    onSearchChange = vm::setSearchQuery,
                    onOpenSeason = { id -> navController.navigate("season/$id") },
                    onContinueWatching = { seasonId, epId ->
                        val pair = vm.findEpisodePair(seasonId, epId)
                        if (pair != null) {
                            vm.openEpisodeInPlayer(pair.first, pair.second) { navController.navigate("player") }
                        } else {
                            navController.navigate("season/$seasonId")
                        }
                    },
                    onRandomEpisode = { vm.launchRandomEpisode { navController.navigate("player") } },
                    onOpenTeaShop = { navController.navigate("tea_shop") }
                )
            }
            composable(
                route = "season/{seasonId}",
                arguments = listOf(navArgument("seasonId") { type = NavType.StringType })
            ) { entry ->
                val seasonId = entry.arguments?.getString("seasonId")
                val season = state.catalog.seasons.find { it.id == seasonId }
                SeasonDetailScreen(
                    season = season,
                    state = state,
                    onBack = { navController.popBackStack() },
                    onWatchEpisode = { s, ep ->
                        vm.openEpisodeInPlayer(s, ep) { navController.navigate("player") }
                    },
                    onToggleBookmark = vm::toggleBookmark,
                    onDownloadEpisode = vm::downloadToBackpack,
                    onDeleteDownload = vm::removeFromBackpack
                )
            }
            composable("player") {
                PlayerScreen(
                    playback = state.activePlayback,
                    onSaveProgress = vm::savePlayerProgress,
                    onPlayNextEpisode = { s, ep -> vm.openEpisodeInPlayer(s, ep) { } },
                    onBack = {
                        vm.closePlayer()
                        navController.popBackStack()
                    }
                )
            }
            composable("timeline") {
                TimelineScreen(
                    state = state,
                    onOpenSeason = { id -> navController.navigate("season/$id") }
                )
            }
            composable("music") {
                MusicScreen(
                    state = state,
                    onToggleTrack = vm::toggleAudioStream
                )
            }
            composable("profile") {
                ProfileScreen(
                    state = state,
                    bookmarkedPairs = vm.allBookmarkedPairs(),
                    downloadedPairs = vm.allDownloadedPairs(),
                    onWatchEpisode = { s, ep ->
                        vm.openEpisodeInPlayer(s, ep) { navController.navigate("player") }
                    },
                    onDeleteDownload = vm::removeFromBackpack,
                    onOpenTeaShop = { navController.navigate("tea_shop") },
                    onOpenTelegram = { onOpenExternalUrl(AppConfig.TELEGRAM_CONTACT_URL) }
                )
            }
            composable("tea_shop") {
                TeaShopSettingsScreen(
                    state = state,
                    onBack = { navController.popBackStack() },
                    onSelectElement = vm::setElement,
                    onSelectThemeMode = vm::setThemeMode,
                    onActivateKey = vm::activatePremiumKey,
                    onOpenTelegram = { onOpenExternalUrl(AppConfig.TELEGRAM_CONTACT_URL) }
                )
            }
        }
    }
}
