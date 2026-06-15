package com.jcube.mymoodz.data

import androidx.room.Entity
import androidx.room.PrimaryKey
import java.util.Date
import java.util.UUID

@Entity(tableName = "mood_entries")
data class MoodEntryEntity(
    @PrimaryKey
    val id: UUID = UUID.randomUUID(),
    val emoji: String,
    val note: String? = null,
    val timestamp: Date = Date(),
    val modifiedAt: Date? = null,
    val isPinned: Boolean = false
)
