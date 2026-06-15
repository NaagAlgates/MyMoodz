package com.jcube.mymoodz.viewmodel

import android.app.Application
import androidx.compose.ui.graphics.Color
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.jcube.mymoodz.data.AppDatabase
import com.jcube.mymoodz.data.MoodEntryEntity
import com.jcube.mymoodz.data.MoodRepository
import com.jcube.mymoodz.model.Mood
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.util.UUID

class MoodViewModel(application: Application) : AndroidViewModel(application) {

    private val repository: MoodRepository

    // All moods reactive stream
    private val _allMoods = MutableStateFlow<List<MoodEntryEntity>>(emptyList())
    val allMoods: StateFlow<List<MoodEntryEntity>> = _allMoods.asStateFlow()

    // Selected mood state
    private val _selectedEmoji = MutableStateFlow<String?>(null)
    val selectedEmoji: StateFlow<String?> = _selectedEmoji.asStateFlow()

    private val _selectedColor = MutableStateFlow(Color.Gray)
    val selectedColor: StateFlow<Color> = _selectedColor.asStateFlow()

    // Last mood entry
    private val _lastMoodEntry = MutableStateFlow<MoodEntryEntity?>(null)
    val lastMoodEntry: StateFlow<MoodEntryEntity?> = _lastMoodEntry.asStateFlow()

    // Toast
    private val _showSuccessToast = MutableStateFlow(false)
    val showSuccessToast: StateFlow<Boolean> = _showSuccessToast.asStateFlow()

    init {
        val db = AppDatabase.getInstance(application)
        repository = MoodRepository(db.moodDao())

        // Observe all moods
        viewModelScope.launch {
            repository.allMoods.collect { moods ->
                _allMoods.value = moods
            }
        }

        // Load last mood
        refreshLastMood()
    }

    fun selectEmoji(emoji: String?) {
        _selectedEmoji.value = emoji
        _selectedColor.value = if (emoji != null) Mood.colorForEmoji(emoji) else Color.Gray
    }

    fun saveMood(note: String) {
        val emoji = _selectedEmoji.value ?: return
        viewModelScope.launch {
            repository.saveMood(emoji, note.ifBlank { null })
            refreshLastMood()
            _selectedEmoji.value = null
            _selectedColor.value = Color.Gray
            _showSuccessToast.value = true
            kotlinx.coroutines.delay(2000)
            _showSuccessToast.value = false
        }
    }

    fun deleteMood(entry: MoodEntryEntity) {
        viewModelScope.launch {
            repository.deleteMood(entry)
        }
    }

    fun updateMood(entry: MoodEntryEntity, newEmoji: String?, newNote: String?) {
        viewModelScope.launch {
            repository.updateMood(entry, newEmoji, newNote)
        }
    }

    fun togglePin(entry: MoodEntryEntity) {
        viewModelScope.launch {
            repository.togglePin(entry)
        }
    }

    suspend fun getEntryById(id: UUID): MoodEntryEntity? {
        return repository.getEntryById(id)
    }

    suspend fun getAllMoodsSync(): List<MoodEntryEntity> {
        return repository.getAllMoodsSync()
    }

    fun refreshMoods() {
        viewModelScope.launch {
            _allMoods.value = repository.getAllMoodsSync()
        }
    }

    private fun refreshLastMood() {
        viewModelScope.launch {
            _lastMoodEntry.value = repository.getLatestMood()
        }
    }
}
