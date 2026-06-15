package com.jcube.mymoodz.ui.component

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.spring
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.jcube.mymoodz.model.Mood

@OptIn(ExperimentalLayoutApi::class)
@Composable
fun MoodGridView(
    selectedEmoji: String?,
    moods: List<Mood>,
    onMoodSelected: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    FlowRow(
        horizontalArrangement = Arrangement.spacedBy(12.dp, Alignment.CenterHorizontally),
        verticalArrangement = Arrangement.spacedBy(16.dp),
        modifier = modifier.fillMaxWidth()
    ) {
        moods.forEach { mood ->
            val isSelected = selectedEmoji == mood.emoji
            val scale by animateFloatAsState(
                targetValue = if (isSelected) 1.2f else 1.0f,
                animationSpec = spring(dampingRatio = 0.5f),
                label = "scale"
            )

            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                modifier = Modifier.clickable {
                    onMoodSelected(if (isSelected) "" else mood.emoji)
                }
            ) {
                Box(
                    contentAlignment = Alignment.Center,
                    modifier = Modifier
                        .size(64.dp)
                        .scale(scale)
                        .clip(CircleShape)
                        .background(
                            mood.color.copy(alpha = if (isSelected) 0.4f else 0.15f)
                        )
                ) {
                    Text(
                        text = mood.emoji,
                        fontSize = 28.sp
                    )
                }
                Text(
                    text = mood.label,
                    fontSize = 12.sp,
                    fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Normal,
                    color = if (isSelected) mood.color else androidx.compose.ui.graphics.Color.Gray
                )
            }
        }
    }
}
