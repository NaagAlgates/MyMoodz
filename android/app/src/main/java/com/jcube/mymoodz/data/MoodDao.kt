package com.jcube.mymoodz.data

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import kotlinx.coroutines.flow.Flow
import java.util.UUID

@Dao
interface MoodDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(entry: MoodEntryEntity)

    @Update
    suspend fun update(entry: MoodEntryEntity)

    @Delete
    suspend fun delete(entry: MoodEntryEntity)

    @Query("SELECT * FROM mood_entries ORDER BY isPinned DESC, timestamp DESC")
    fun getAllMoods(): Flow<List<MoodEntryEntity>>

    @Query("SELECT * FROM mood_entries ORDER BY timestamp DESC LIMIT 1")
    suspend fun getLatestMood(): MoodEntryEntity?

    @Query("SELECT * FROM mood_entries WHERE id = :id LIMIT 1")
    suspend fun getEntryById(id: UUID): MoodEntryEntity?

    @Query("SELECT * FROM mood_entries ORDER BY isPinned DESC, timestamp DESC")
    suspend fun getAllMoodsSync(): List<MoodEntryEntity>
}
