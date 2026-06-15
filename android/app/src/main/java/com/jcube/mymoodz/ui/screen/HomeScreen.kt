package com.jcube.mymoodz.ui.screen

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutVertically
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.jcube.mymoodz.model.Mood
import com.jcube.mymoodz.ui.component.MoodGridView
import com.jcube.mymoodz.ui.component.NoteInputView
import com.jcube.mymoodz.util.TimeAgoFormatter
import com.jcube.mymoodz.viewmodel.MoodViewModel
import java.util.Date

@Composable
fun HomeScreen(
    viewModel: MoodViewModel,
    onNavigateToHub: () -> Unit
) {
    val selectedEmoji by viewModel.selectedEmoji.collectAsState()
    val selectedColor by viewModel.selectedColor.collectAsState()
    val lastMoodEntry by viewModel.lastMoodEntry.collectAsState()
    val showSuccessToast by viewModel.showSuccessToast.collectAsState()

    var note by remember { mutableStateOf("") }
    var now by remember { mutableStateOf(Date()) }

    // Update "now" every 30 seconds for relative time display
    LaunchedEffect(Unit) {
        while (true) {
            kotlinx.coroutines.delay(30_000)
            now = Date()
        }
    }

    Surface(
        color = MaterialTheme.colorScheme.background,
        modifier = Modifier.fillMaxSize()
    ) {
        Box(modifier = Modifier.fillMaxSize()) {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .verticalScroll(rememberScrollState())
                    .padding(20.dp)
            ) {
                // Header
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text(
                        text = "How are you feeling?",
                        fontSize = 22.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = selectedColor,
                        modifier = Modifier.weight(1f)
                    )

                    Icon(
                        imageVector = Icons.Default.MoreVert,
                        contentDescription = "Hub",
                        tint = selectedColor,
                        modifier = Modifier
                            .size(28.dp)
                            .clickable { onNavigateToHub() }
                    )
                }

                Spacer(modifier = Modifier.height(16.dp))

                // Last mood entry
                lastMoodEntry?.let { last ->
                    Row {
                        Text(
                            text = "Last mood: ",
                            color = Color.Gray,
                            fontSize = 14.sp
                        )
                        Text(
                            text = last.emoji,
                            fontSize = 14.sp
                        )
                        Text(
                            text = TimeAgoFormatter.format(last.timestamp, now),
                            color = Color.Gray,
                            fontSize = 14.sp
                        )
                    }
                }

                Spacer(modifier = Modifier.height(20.dp))

                // Mood Picker Grid
                MoodGridView(
                    selectedEmoji = selectedEmoji,
                    moods = Mood.ALL,
                    onMoodSelected = { viewModel.selectEmoji(it.ifEmpty { null }) }
                )

                Spacer(modifier = Modifier.height(20.dp))

                // Note Input
                NoteInputView(
                    note = note,
                    onNoteChange = { note = it },
                    selectedEmoji = selectedEmoji
                )

                Spacer(modifier = Modifier.height(20.dp))

                // Save button
                Button(
                    onClick = {
                        viewModel.saveMood(note)
                        note = ""
                    },
                    enabled = selectedEmoji != null,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(52.dp),
                    shape = RoundedCornerShape(12.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = if (selectedEmoji != null) selectedColor
                        else Color.Gray.copy(alpha = 0.4f)
                    )
                ) {
                    Text(
                        text = "Save Mood",
                        color = Color.White,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                }
            }

            // Success toast
            AnimatedVisibility(
                visible = showSuccessToast,
                enter = slideInVertically() + fadeIn(),
                exit = slideOutVertically() + fadeOut(),
                modifier = Modifier
                    .align(Alignment.TopCenter)
                    .padding(top = 16.dp)
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier
                        .clip(RoundedCornerShape(12.dp))
                        .background(Color(0xFF43A047).copy(alpha = 0.95f))
                        .padding(horizontal = 16.dp, vertical = 10.dp)
                ) {
                    Icon(
                        Icons.Default.CheckCircle,
                        contentDescription = null,
                        tint = Color.White
                    )
                    Text(
                        text = "  Mood saved successfully!",
                        color = Color.White,
                        fontWeight = FontWeight.SemiBold,
                        fontSize = 16.sp
                    )
                }
            }
        }
    }
}
