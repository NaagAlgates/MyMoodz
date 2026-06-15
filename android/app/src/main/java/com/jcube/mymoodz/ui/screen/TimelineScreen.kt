package com.jcube.mymoodz.ui.screen

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowDropDown
import androidx.compose.material.icons.filled.List
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SearchBar
import androidx.compose.material3.SegmentedButton
import androidx.compose.material3.SegmentedButtonDefaults
import androidx.compose.material3.SingleChoiceSegmentedButtonRow
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.jcube.mymoodz.data.MoodEntryEntity
import com.jcube.mymoodz.model.FilterOption
import com.jcube.mymoodz.model.Mood
import com.jcube.mymoodz.model.SortOption
import com.jcube.mymoodz.ui.component.CalendarView
import com.jcube.mymoodz.ui.component.EditMoodDialog
import com.jcube.mymoodz.ui.component.MoodRow
import com.jcube.mymoodz.viewmodel.MoodViewModel
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId
import java.util.Date

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TimelineScreen(
    viewModel: MoodViewModel,
    onBack: () -> Unit
) {
    val allMoods by viewModel.allMoods.collectAsState()
    val selectedColor by viewModel.selectedColor.collectAsState()

    var isCalendarView by remember { mutableStateOf(false) }
    var searchText by remember { mutableStateOf("") }
    var sortOption by remember { mutableStateOf(SortOption.NEWEST) }
    var filterOption by remember { mutableStateOf(FilterOption.ALL) }
    var selectedDate by remember { mutableStateOf(LocalDate.now()) }
    var editingEntry by remember { mutableStateOf<MoodEntryEntity?>(null) }
    var now by remember { mutableStateOf(Date()) }
    var showSearch by remember { mutableStateOf(false) }

    // Sort/Filter menu states
    var showSortMenu by remember { mutableStateOf(false) }
    var showFilterMenu by remember { mutableStateOf(false) }

    LaunchedEffect(Unit) {
        while (true) {
            kotlinx.coroutines.delay(30_000)
            now = Date()
        }
    }

    LaunchedEffect(Unit) {
        viewModel.refreshMoods()
    }

    // Apply filters
    val filteredMoods = remember(allMoods, searchText, sortOption, filterOption) {
        var result = allMoods.toList()

        // Search filter
        if (searchText.isNotBlank()) {
            val query = searchText.lowercase()
            result = result.filter { entry ->
                entry.emoji.lowercase().contains(query) ||
                Mood.labelForEmoji(entry.emoji).lowercase().contains(query) ||
                (entry.note?.lowercase()?.contains(query) ?: false)
            }
        }

        // Time filter
        val today = LocalDate.now()
        result = result.filter { entry ->
            val entryDate = entry.timestamp.toInstant().atZone(ZoneId.systemDefault()).toLocalDate()
            when (filterOption) {
                FilterOption.ALL -> true
                FilterOption.TODAY -> entryDate == today
                FilterOption.THIS_WEEK -> {
                    val startOfWeek = today.with(java.time.DayOfWeek.MONDAY)
                    entryDate >= startOfWeek && entryDate <= today
                }
                FilterOption.THIS_MONTH -> entryDate.month == today.month && entryDate.year == today.year
            }
        }

        // Sort
        result = when (sortOption) {
            SortOption.NEWEST -> result.sortedByDescending { it.timestamp }
            SortOption.OLDEST -> result.sortedBy { it.timestamp }
            SortOption.MOOD_LABEL -> result.sortedBy { Mood.labelForEmoji(it.emoji) }
            SortOption.EMOJI -> result.sortedBy { it.emoji }
            SortOption.EDITED_NEWEST -> result.sortedByDescending { it.modifiedAt ?: Date(0) }
            SortOption.EDITED_OLDEST -> result.sortedBy { it.modifiedAt ?: Date(0) }
        }.let { sorted ->
            // Pinned items always first
            sorted.sortedByDescending { it.isPinned }
        }

        result
    }

    // Calendar-specific filtered entries
    val calendarMoodDates = remember(allMoods) {
        allMoods.mapNotNull { it.timestamp }
    }

    val selectedDayEntries = remember(filteredMoods, selectedDate) {
        filteredMoods.filter { entry ->
            val entryDate = entry.timestamp.toInstant().atZone(ZoneId.systemDefault()).toLocalDate()
            entryDate == selectedDate
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Timeline") },
                actions = {
                    if (!isCalendarView) {
                        IconButton(onClick = { showSearch = !showSearch }) {
                            Icon(Icons.Default.Search, contentDescription = "Search")
                        }
                        // Sort
                        Box {
                            IconButton(onClick = { showSortMenu = true }) {
                                Icon(Icons.Default.ArrowDropDown, contentDescription = "Sort")
                            }
                            DropdownMenu(
                                expanded = showSortMenu,
                                onDismissRequest = { showSortMenu = false }
                            ) {
                                SortOption.entries.forEach { option ->
                                    DropdownMenuItem(
                                        text = { Text(option.label) },
                                        onClick = {
                                            sortOption = option
                                            showSortMenu = false
                                        }
                                    )
                                }
                            }
                        }
                        // Filter
                        Box {
                            IconButton(onClick = { showFilterMenu = true }) {
                                Icon(Icons.Default.List, contentDescription = "Filter")
                            }
                            DropdownMenu(
                                expanded = showFilterMenu,
                                onDismissRequest = { showFilterMenu = false }
                            ) {
                                FilterOption.entries.forEach { option ->
                                    DropdownMenuItem(
                                        text = { Text(option.label) },
                                        onClick = {
                                            filterOption = option
                                            showFilterMenu = false
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
        ) {
            // Segmented toggle: List / Calendar
            SingleChoiceSegmentedButtonRow(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 8.dp)
            ) {
                SegmentedButton(
                    selected = !isCalendarView,
                    onClick = { isCalendarView = false },
                    shape = SegmentedButtonDefaults.itemShape(index = 0, count = 2)
                ) {
                    Text("List View")
                }
                SegmentedButton(
                    selected = isCalendarView,
                    onClick = { isCalendarView = true },
                    shape = SegmentedButtonDefaults.itemShape(index = 1, count = 2)
                ) {
                    Text("Calendar View")
                }
            }

            // Search bar
            AnimatedVisibility(visible = showSearch && !isCalendarView) {
                SearchBar(
                    query = searchText,
                    onQueryChange = { searchText = it },
                    onSearch = {},
                    active = false,
                    onActiveChange = {},
                    placeholder = { Text("Search mood or note") },
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp)
                ) {}
            }

            if (isCalendarView) {
                // Calendar view
                LazyColumn(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(horizontal = 16.dp)
                ) {
                    item {
                        CalendarView(
                            selectedDate = selectedDate,
                            moodDates = calendarMoodDates,
                            moodColor = selectedColor,
                            onDateSelected = { selectedDate = it }
                        )
                        Spacer(modifier = Modifier.height(16.dp))
                    }

                    if (selectedDayEntries.isNotEmpty()) {
                        item {
                            Text(
                                text = "${java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy").format(selectedDate)}:",
                                style = MaterialTheme.typography.titleMedium,
                                fontWeight = androidx.compose.ui.text.font.FontWeight.SemiBold,
                                color = selectedColor,
                                modifier = Modifier.padding(bottom = 8.dp)
                            )
                        }
                        items(selectedDayEntries, key = { it.id }) { entry ->
                            MoodRow(
                                entry = entry,
                                now = now,
                                onEdit = { editingEntry = entry },
                                onDelete = { viewModel.deleteMood(entry) },
                                onTogglePin = { viewModel.togglePin(entry) },
                                modifier = Modifier.padding(vertical = 4.dp)
                            )
                        }
                    } else {
                        item {
                            Text(
                                text = "No moods recorded on this day",
                                color = androidx.compose.ui.graphics.Color.Gray,
                                modifier = Modifier.padding(16.dp)
                            )
                        }
                    }
                }
            } else {
                // List view
                if (filteredMoods.isEmpty()) {
                    Box(
                        contentAlignment = Alignment.Center,
                        modifier = Modifier.fillMaxSize()
                    ) {
                        Text(
                            text = "No mood entries yet",
                            color = androidx.compose.ui.graphics.Color.Gray
                        )
                    }
                } else {
                    LazyColumn(
                        modifier = Modifier
                            .fillMaxSize()
                            .padding(horizontal = 16.dp)
                    ) {
                        items(filteredMoods, key = { it.id }) { entry ->
                            MoodRow(
                                entry = entry,
                                now = now,
                                onEdit = { editingEntry = entry },
                                onDelete = { viewModel.deleteMood(entry) },
                                onTogglePin = { viewModel.togglePin(entry) },
                                modifier = Modifier.padding(vertical = 4.dp)
                            )
                        }
                    }
                }
            }
        }
    }

    // Edit dialog
    editingEntry?.let { entry ->
        EditMoodDialog(
            entry = entry,
            onSave = { newEmoji, newNote ->
                viewModel.updateMood(entry, newEmoji, newNote.ifBlank { null })
                editingEntry = null
            },
            onDismiss = { editingEntry = null }
        )
    }
}
