package com.jcube.mymoodz.ui.screen

import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DateRange
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import com.jcube.mymoodz.viewmodel.MoodViewModel

data class HubTab(
    val title: String,
    val icon: ImageVector
)

@Composable
fun MoodHubScreen(
    viewModel: MoodViewModel,
    onBack: () -> Unit
) {
    val selectedColor by viewModel.selectedColor.collectAsState()
    var selectedTab by remember { mutableIntStateOf(0) }

    val tabs = listOf(
        HubTab("Timeline", Icons.Default.DateRange),
        HubTab("Insights", Icons.Default.Favorite),
        HubTab("Settings", Icons.Default.Settings)
    )

    Scaffold(
        bottomBar = {
            NavigationBar(
                containerColor = androidx.compose.material3.MaterialTheme.colorScheme.surface
            ) {
                tabs.forEachIndexed { index, tab ->
                    NavigationBarItem(
                        selected = selectedTab == index,
                        onClick = { selectedTab = index },
                        icon = {
                            Icon(
                                tab.icon,
                                contentDescription = tab.title,
                                tint = if (selectedTab == index) selectedColor
                                       else androidx.compose.ui.graphics.Color.Gray
                            )
                        },
                        label = {
                            Text(
                                tab.title,
                                color = if (selectedTab == index) selectedColor
                                        else androidx.compose.ui.graphics.Color.Gray
                            )
                        }
                    )
                }
            }
        }
    ) { padding ->
        when (selectedTab) {
            0 -> TimelineScreen(viewModel = viewModel, onBack = onBack)
            1 -> InsightsScreen(viewModel = viewModel, onBack = onBack)
            2 -> SettingsScreen(onBack = onBack)
        }
    }
}
