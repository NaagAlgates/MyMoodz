package com.jcube.mymoodz.model

import androidx.compose.ui.graphics.Color

data class Mood(
    val emoji: String,
    val label: String,
    val color: Color
) {
    companion object {
        val ALL = listOf(
            Mood("😄", "Happy", Color(0xFFF9A825)),
            Mood("😌", "Calm", Color(0xFF4FC3F7)),
            Mood("😐", "Neutral", Color(0xFF90A4AE)),
            Mood("😢", "Sad", Color(0xFF3949AB)),
            Mood("😡", "Angry", Color(0xFFD32F2F)),
            Mood("🤯", "Stressed", Color(0xFFF57C00)),
            Mood("😴", "Tired", Color(0xFF5C6BC0)),
            Mood("😰", "Anxious", Color(0xFF26C6DA)),
            Mood("🤣", "Excited", Color(0xFF43A047)),
            Mood("🥰", "Loved", Color(0xFFEC407A)),
            Mood("🤔", "Confused", Color(0xFF303F9F)),
            Mood("🤗", "Hopeful", Color(0xFF66BB6A))
        )

        fun colorForEmoji(emoji: String): Color {
            return ALL.find { it.emoji == emoji }?.color ?: Color.Gray
        }

        fun labelForEmoji(emoji: String): String {
            return ALL.find { it.emoji == emoji }?.label ?: "Unknown"
        }
    }
}

enum class SortOption(val label: String) {
    NEWEST("Created (Newest First)"),
    OLDEST("Created (Oldest First)"),
    MOOD_LABEL("Mood A–Z"),
    EMOJI("Emoji"),
    EDITED_NEWEST("Edited (Newest First)"),
    EDITED_OLDEST("Edited (Oldest First)")
}

enum class FilterOption(val label: String) {
    ALL("All Time"),
    TODAY("Today"),
    THIS_WEEK("This Week"),
    THIS_MONTH("This Month")
}
