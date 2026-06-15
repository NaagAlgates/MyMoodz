package com.jcube.mymoodz.ui.navigation

import androidx.compose.runtime.Composable
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.jcube.mymoodz.ui.screen.HomeScreen
import com.jcube.mymoodz.ui.screen.MoodHubScreen
import com.jcube.mymoodz.viewmodel.MoodViewModel

sealed class Screen(val route: String) {
    data object Home : Screen("home")
    data object Hub : Screen("hub")
}

@Composable
fun MyMoodzNavGraph(viewModel: MoodViewModel = viewModel()) {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screen.Home.route) {
        composable(Screen.Home.route) {
            HomeScreen(
                viewModel = viewModel,
                onNavigateToHub = { navController.navigate(Screen.Hub.route) }
            )
        }
        composable(Screen.Hub.route) {
            MoodHubScreen(
                viewModel = viewModel,
                onBack = { navController.popBackStack() }
            )
        }
    }
}
