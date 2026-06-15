package com.jcube.mymoodz.ui.component

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.FavoriteBorder
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.jcube.mymoodz.data.MoodEntryEntity
import com.jcube.mymoodz.model.Mood
import com.jcube.mymoodz.util.TimeAgoFormatter
import java.util.Date

@Composable
fun MoodRow(
    entry: MoodEntryEntity,
    now: Date,
    onEdit: () -> Unit,
    onDelete: () -> Unit,
    onTogglePin: () -> Unit,
    modifier: Modifier = Modifier
) {
    val moodColor = Mood.colorForEmoji(entry.emoji)

    Column(
        modifier = modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(12.dp))
            .background(
                if (entry.isPinned) moodColor.copy(alpha = 0.15f)
                else Color(0xFFF8F8F8)
            )
            .padding(16.dp)
    ) {
        Row(
            verticalAlignment = Alignment.Top,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text(
                text = entry.emoji,
                fontSize = 32.sp
            )

            Spacer(modifier = Modifier.width(12.dp))

            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = Mood.labelForEmoji(entry.emoji),
                    fontWeight = FontWeight.SemiBold,
                    fontSize = 16.sp
                )
                Text(
                    text = TimeAgoFormatter.format(entry.timestamp, now),
                    fontSize = 12.sp,
                    color = Color.Gray
                )
                if (entry.modifiedAt != null) {
                    Text(
                        text = "Edited ${TimeAgoFormatter.format(entry.modifiedAt, now)}",
                        fontSize = 11.sp,
                        color = moodColor.copy(alpha = 0.7f)
                    )
                }
            }

            // Pin button
            IconButton(
                onClick = onTogglePin,
                modifier = Modifier.size(36.dp)
            ) {
                Icon(
                    imageVector = if (entry.isPinned) Icons.Default.Favorite else Icons.Default.FavoriteBorder,
                    contentDescription = "Pin",
                    tint = if (entry.isPinned) moodColor else Color.Gray,
                    modifier = Modifier.size(20.dp)
                )
            }

            // Edit button
            IconButton(
                onClick = onEdit,
                modifier = Modifier.size(36.dp)
            ) {
                Icon(
                    imageVector = Icons.Default.Edit,
                    contentDescription = "Edit",
                    tint = Color(0xFF1976D2),
                    modifier = Modifier.size(20.dp)
                )
            }

            // Delete button
            IconButton(
                onClick = onDelete,
                modifier = Modifier.size(36.dp)
            ) {
                Icon(
                    imageVector = Icons.Default.Delete,
                    contentDescription = "Delete",
                    tint = Color(0xFFD32F2F),
                    modifier = Modifier.size(20.dp)
                )
            }
        }

        if (!entry.note.isNullOrBlank()) {
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = entry.note,
                fontSize = 14.sp,
                color = if (entry.isPinned) moodColor.copy(alpha = 0.9f)
                        else Color(0xFF795548)
            )
        }
    }
}
