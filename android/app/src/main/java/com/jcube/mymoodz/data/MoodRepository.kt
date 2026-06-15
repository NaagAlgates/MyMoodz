package com.jcube.mymoodz.data

import kotlinx.coroutines.flow.Flow
import java.util.Date
import java.util.UUID

class MoodRepository(private val dao: MoodDao) {

    val allMoods: Flow<List<MoodEntryEntity>> = dao.getAllMoods()

    suspend fun saveMood(emoji: String, note: String?) {
        dao.insert(
            MoodEntryEntity(
                emoji = emoji,
                note = note,
                timestamp = Date()
            )
        )
    }

    suspend fun getLatestMood(): MoodEntryEntity? = dao.getLatestMood()

    suspend fun getAllMoodsSync(): List<MoodEntryEntity> = dao.getAllMoodsSync()

    suspend fun getEntryById(id: UUID): MoodEntryEntity? = dao.getEntryById(id)

    suspend fun updateMood(entry: MoodEntryEntity, newEmoji: String?, newNote: String?) {
        dao.update(
            entry.copy(
                emoji = newEmoji ?: entry.emoji,
                note = newNote,
                modifiedAt = Date()
            )
        )
    }

    suspend fun deleteMood(entry: MoodEntryEntity) {
        dao.delete(entry)
    }

    suspend fun togglePin(entry: MoodEntryEntity) {
        dao.update(entry.copy(isPinned = !entry.isPinned))
    }
}
