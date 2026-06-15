package com.jcube.mymoodz.ui.screen

import android.content.Intent
import android.net.Uri
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Email
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.MailOutline
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.filled.Warning
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SettingsScreen(
    onBack: () -> Unit
) {
    val context = LocalContext.current

    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Settings") })
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
        ) {
            // Feedback Section
            SectionHeader("Feedback")
            SettingsLink(
                icon = Icons.Default.MailOutline,
                title = "Give Feedback",
                subtitle = "Send an email to the developer",
                onClick = {
                    val intent = Intent(Intent.ACTION_SENDTO).apply {
                        data = Uri.parse("mailto:me@nagaraj.com.au")
                        putExtra(Intent.EXTRA_SUBJECT, "MyMoodz Feedback")
                    }
                    context.startActivity(intent)
                }
            )
            SettingsLink(
                icon = Icons.Default.Email,
                title = "Discussion",
                subtitle = "Join the discussion forum",
                url = "https://github.com/NaagAlgates/MyMoodz/discussions"
            )
            Text(
                text = "This app is developed by one person with the help of generative AI. Your feedback helps improve the app.",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.5f),
                modifier = Modifier.padding(horizontal = 16.dp, vertical = 4.dp)
            )

            HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))

            // App Details Section
            SectionHeader("App Details")
            SettingsLink(
                icon = Icons.Default.Star,
                title = "What's New",
                url = "https://github.com/NaagAlgates/MyMoodz/releases"
            )
            SettingsLink(
                icon = Icons.Default.Favorite,
                title = "Rate this app",
                url = "https://play.google.com/store/apps/details?id=com.jcube.mymoodz"
            )
            SettingsLink(
                icon = Icons.Default.Lock,
                title = "Privacy",
                url = "https://github.com/NaagAlgates/MyMoodz/blob/docs/docs/PRIVACY_POLICY.md"
            )
            SettingsLink(
                icon = Icons.Default.Info,
                title = "MyMoodz is open source",
                url = "https://github.com/NaagAlgates/MyMoodz"
            )
            SettingsLink(
                icon = Icons.Default.Warning,
                title = "Report Issues",
                url = "https://github.com/NaagAlgates/MyMoodz/issues"
            )

            HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))

            // General Section
            SectionHeader("General")
            SettingsLink(
                icon = Icons.Default.Menu,
                title = "App Features",
                url = "https://github.com/NaagAlgates/MyMoodz/blob/docs/docs/FEATURES.md"
            )
            SettingsLink(
                icon = Icons.Default.Info,
                title = "Onboarding",
                url = "https://github.com/NaagAlgates/MyMoodz/blob/docs/docs/ONBOARDING.md"
            )
            SettingsLink(
                icon = Icons.Default.Info,
                title = "Licenses",
                url = "https://github.com/NaagAlgates/MyMoodz/blob/docs/docs/LICENSE.md"
            )

            HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))

            // About Section
            SectionHeader("About")
            SettingsLink(
                icon = Icons.Default.Person,
                title = "Developer",
                url = "https://nagaraj.com.au"
            )

            Spacer(modifier = Modifier.height(16.dp))

            Text(
                text = "v1.0.0 (1) - Development",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.4f),
                modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)
            )

            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}

@Composable
fun SectionHeader(title: String) {
    Text(
        text = title,
        style = MaterialTheme.typography.titleSmall,
        color = MaterialTheme.colorScheme.primary,
        modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)
    )
}

@Composable
fun SettingsLink(
    icon: ImageVector,
    title: String,
    subtitle: String? = null,
    url: String? = null,
    onClick: (() -> Unit)? = null
) {
    val context = LocalContext.current
    ListItem(
        headlineContent = { Text(title) },
        supportingContent = subtitle?.let { { Text(it) } },
        leadingContent = {
            Icon(icon, contentDescription = null, tint = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.7f))
        },
        modifier = Modifier.clickable {
            if (onClick != null) onClick()
            else if (url != null) {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                context.startActivity(intent)
            }
        }
    )
}
