package com.jcube.mymoodz.ui.component

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import com.jcube.mymoodz.data.MoodEntryEntity
import com.jcube.mymoodz.model.Mood

@Composable
fun EditMoodDialog(
    entry: MoodEntryEntity,
    onSave: (String, String) -> Unit,
    onDismiss: () -> Unit
) {
    var selectedEmoji by remember { mutableStateOf(entry.emoji) }
    var note by remember { mutableStateOf(entry.note ?: "") }

    androidx.compose.material3.AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("Edit Mood") },
        text = {
            Column {
                Text(
                    text = "Select Mood",
                    style = MaterialTheme.typography.labelMedium,
                    color = Color.Gray
                )
                Spacer(modifier = Modifier.height(8.dp))
                MoodGridView(
                    selectedEmoji = selectedEmoji,
                    moods = Mood.ALL,
                    onMoodSelected = { emoji ->
                        selectedEmoji = if (emoji.isEmpty()) selectedEmoji else emoji
                    }
                )
                Spacer(modifier = Modifier.height(16.dp))
                Text(
                    text = "Edit Note",
                    style = MaterialTheme.typography.labelMedium,
                    color = Color.Gray
                )
                Spacer(modifier = Modifier.height(8.dp))
                NoteInputView(
                    note = note,
                    onNoteChange = { note = it },
                    selectedEmoji = selectedEmoji
                )
            }
        },
        confirmButton = {
            Button(
                onClick = { onSave(selectedEmoji, note) },
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color(0xFF1976D2)
                )
            ) {
                Text("Save Changes", color = Color.White)
            }
        },
        dismissButton = {
            Button(onClick = onDismiss) {
                Text("Cancel")
            }
        }
    )
}
