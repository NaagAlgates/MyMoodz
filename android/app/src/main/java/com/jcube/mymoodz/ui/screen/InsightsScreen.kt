package com.jcube.mymoodz.ui.screen

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.DatePicker
import androidx.compose.material3.DatePickerDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.rememberDatePickerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.nativeCanvas
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.jcube.mymoodz.data.MoodEntryEntity
import com.jcube.mymoodz.model.Mood
import com.jcube.mymoodz.ui.component.StatCard
import com.jcube.mymoodz.viewmodel.MoodViewModel
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.Date
import kotlin.math.atan2
import kotlin.math.cos
import kotlin.math.sin

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun InsightsScreen(
    viewModel: MoodViewModel,
    onBack: () -> Unit
) {
    var startDate by remember { mutableStateOf(LocalDate.now().minusMonths(1)) }
    var endDate by remember { mutableStateOf(LocalDate.now()) }
    var showStartPicker by remember { mutableStateOf(false) }
    var showEndPicker by remember { mutableStateOf(false) }
    var allMoods by remember { mutableStateOf<List<MoodEntryEntity>>(emptyList()) }
    var pieSelectedIndex by remember { mutableStateOf(-1) }

    LaunchedEffect(Unit) {
        allMoods = viewModel.getAllMoodsSync()
    }

    // Filtered moods
    val filteredMoods = remember(allMoods, startDate, endDate) {
        allMoods.filter { entry ->
            val date = Instant.ofEpochMilli(entry.timestamp.time)
                .atZone(ZoneId.systemDefault()).toLocalDate()
            date in startDate..endDate
        }
    }

    // Stats
    val moodCounts = remember(filteredMoods) {
        filteredMoods.groupBy { it.emoji }
            .map { (emoji, entries) -> emoji to entries.size }
            .sortedByDescending { it.second }
    }

    val mostFrequent = moodCounts.firstOrNull()
    val totalEntries = filteredMoods.size
    val longestStreak = remember(filteredMoods) { calculateLongestStreak(filteredMoods) }

    // Moods per day (for bar chart)
    val moodsPerDay = remember(filteredMoods, startDate, endDate) {
        val formatter = DateTimeFormatter.ofPattern("dd MMM")
        var date = startDate
        val result = mutableListOf<Pair<String, Int>>()
        while (!date.isAfter(endDate)) {
            val count = filteredMoods.count {
                val d = Instant.ofEpochMilli(it.timestamp.time).atZone(ZoneId.systemDefault()).toLocalDate()
                d == date
            }
            result.add(formatter.format(date) to count)
            date = date.plusDays(1)
        }
        result
    }

    // Weekday distribution
    val weekdayDistribution = remember(filteredMoods) {
        val order = listOf("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
        val grouped = filteredMoods.groupBy {
            val date = Instant.ofEpochMilli(it.timestamp.time).atZone(ZoneId.systemDefault()).toLocalDate()
            date.dayOfWeek.getDisplayName(java.time.format.TextStyle.FULL, java.util.Locale.getDefault())
        }
        order.map { name -> name to (grouped[name]?.size ?: 0) }
    }

    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Insights") })
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
                .padding(16.dp)
        ) {
            // Date range picker
            Text(
                text = "Insights from ${formatDate(startDate)} to ${formatDate(endDate)}",
                style = MaterialTheme.typography.bodyMedium,
                color = Color.Gray
            )

            Spacer(modifier = Modifier.height(12.dp))

            Row(
                horizontalArrangement = Arrangement.spacedBy(12.dp),
                modifier = Modifier.fillMaxWidth()
            ) {
                Button(
                    onClick = { showStartPicker = true },
                    modifier = Modifier.weight(1f),
                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFE0E0E0))
                ) {
                    Text(formatDate(startDate), color = Color.DarkGray)
                }
                Button(
                    onClick = { showEndPicker = true },
                    modifier = Modifier.weight(1f),
                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFE0E0E0))
                ) {
                    Text(formatDate(endDate), color = Color.DarkGray)
                }
                Button(
                    onClick = {
                        startDate = LocalDate.now().minusMonths(1)
                        endDate = LocalDate.now()
                    },
                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF1976D2))
                ) {
                    Text("Reset", color = Color.White)
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Stat cards
            Row(
                horizontalArrangement = Arrangement.spacedBy(12.dp),
                modifier = Modifier.fillMaxWidth()
            ) {
                StatCard(
                    title = "Most Frequent",
                    value = mostFrequent?.first ?: "🙂",
                    modifier = Modifier.weight(1f)
                )
                StatCard(
                    title = "Total Moods",
                    value = "$totalEntries 🎉",
                    modifier = Modifier.weight(1f)
                )
                StatCard(
                    title = "Longest Streak",
                    value = "$longestStreak 🔥",
                    modifier = Modifier.weight(1f)
                )
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Bar Chart: Moods Per Day
            ChartCard(title = "Mood Entries Per Day") {
                SimpleBarChart(
                    data = moodsPerDay.map { it.second.toFloat() },
                    labels = moodsPerDay.map { it.first },
                    height = 180
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Pie Chart: Mood Distribution
            ChartCard(title = "Mood Distribution") {
                SimplePieChart(
                    data = moodCounts.map { (emoji, count) ->
                        Triple(emoji, count.toFloat(), Mood.colorForEmoji(emoji))
                    },
                    selectedIndex = pieSelectedIndex,
                    onSliceSelected = { pieSelectedIndex = it },
                    height = 220
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Line Chart: Daily Trend
            ChartCard(title = "Daily Mood Trend") {
                SimpleLineChart(
                    data = moodsPerDay.map { it.second.toFloat() },
                    labels = moodsPerDay.map { it.first },
                    height = 180
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Horizontal Bar Chart: Moods by Weekday
            ChartCard(title = "Moods by Weekday") {
                SimpleHorizontalBarChart(
                    data = weekdayDistribution.map { it.second.toFloat() },
                    labels = weekdayDistribution.map { it.first.take(3) },
                    height = 180
                )
            }

            Spacer(modifier = Modifier.height(40.dp))
        }
    }

    // Date pickers
    if (showStartPicker) {
        val datePickerState = rememberDatePickerState(
            initialSelectedDateMillis = startDate.atStartOfDay(ZoneId.systemDefault()).toInstant().toEpochMilli()
        )
        DatePickerDialog(
            onDismissRequest = { showStartPicker = false },
            confirmButton = {
                Button(onClick = {
                    datePickerState.selectedDateMillis?.let { millis ->
                        startDate = Instant.ofEpochMilli(millis).atZone(ZoneId.systemDefault()).toLocalDate()
                    }
                    showStartPicker = false
                }) { Text("OK") }
            }
        ) {
            DatePicker(state = datePickerState)
        }
    }
    if (showEndPicker) {
        val datePickerState = rememberDatePickerState(
            initialSelectedDateMillis = endDate.atStartOfDay(ZoneId.systemDefault()).toInstant().toEpochMilli()
        )
        DatePickerDialog(
            onDismissRequest = { showEndPicker = false },
            confirmButton = {
                Button(onClick = {
                    datePickerState.selectedDateMillis?.let { millis ->
                        endDate = Instant.ofEpochMilli(millis).atZone(ZoneId.systemDefault()).toLocalDate()
                    }
                    showEndPicker = false
                }) { Text("OK") }
            }
        ) {
            DatePicker(state = datePickerState)
        }
    }
}

fun formatDate(date: LocalDate): String {
    return date.format(DateTimeFormatter.ofPattern("dd MMM yyyy"))
}

fun calculateLongestStreak(moods: List<MoodEntryEntity>): Int {
    val dates = moods.map {
        Instant.ofEpochMilli(it.timestamp.time).atZone(ZoneId.systemDefault()).toLocalDate()
    }.distinct().sorted()

    if (dates.isEmpty()) return 0

    var longest = 1
    var current = 1
    for (i in 1 until dates.size) {
        if (dates[i - 1].plusDays(1) == dates[i]) {
            current++
            longest = maxOf(longest, current)
        } else if (dates[i - 1] != dates[i]) {
            current = 1
        }
    }
    return longest
}

// ----- Chart Composables -----

@Composable
fun ChartCard(title: String, content: @Composable () -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(MaterialTheme.colorScheme.surface)
            .padding(16.dp)
    ) {
        Text(
            text = title,
            style = MaterialTheme.typography.titleSmall,
            fontWeight = FontWeight.SemiBold
        )
        Spacer(modifier = Modifier.height(12.dp))
        content()
    }
}

@Composable
fun SimpleBarChart(
    data: List<Float>,
    labels: List<String>,
    height: Int
) {
    val maxVal = data.maxOrNull()?.coerceAtLeast(1f) ?: 1f
    val barColor = Color(0xFF5C6BC0)

    Column(modifier = Modifier.fillMaxWidth()) {
        Canvas(
            modifier = Modifier
                .fillMaxWidth()
                .height(height.dp)
        ) {
            val barWidth = size.width / data.size * 0.6f
            val gap = size.width / data.size * 0.4f

            data.forEachIndexed { index, value ->
                val barHeight = (value / maxVal) * size.height * 0.9f
                val x = index * (barWidth + gap) + gap / 2
                drawRect(
                    color = barColor,
                    topLeft = Offset(x, size.height - barHeight),
                    size = Size(barWidth, barHeight)
                )
            }
        }
        // Labels (show every Nth label)
        Row(modifier = Modifier.fillMaxWidth()) {
            val step = maxOf(1, labels.size / 6)
            labels.forEachIndexed { index, label ->
                if (index % step == 0) {
                    Text(
                        text = label,
                        fontSize = 8.sp,
                        color = Color.Gray,
                        modifier = Modifier.weight(1f)
                    )
                } else {
                    Spacer(modifier = Modifier.weight(1f))
                }
            }
        }
    }
}

@Composable
fun SimplePieChart(
    data: List<Triple<String, Float, Color>>,
    selectedIndex: Int,
    onSliceSelected: (Int) -> Unit,
    height: Int
) {
    val total = data.sumOf { it.second.toDouble() }.toFloat().coerceAtLeast(1f)

    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = Modifier.fillMaxWidth()
    ) {
        // Pie
        Canvas(
            modifier = Modifier
                .size(height.dp)
                .pointerInput(data) {
                    detectTapGestures { offset ->
                        val center = Offset(size.width / 2f, size.height / 2f)
                        val dx = offset.x - center.x
                        val dy = offset.y - center.y
                        val dist = kotlin.math.sqrt(dx * dx + dy * dy)
                        val radius = size.width / 2f * 0.8f
                        if (dist <= radius) {
                            var angle = Math.toDegrees(atan2(dy.toDouble(), dx.toDouble())).toFloat()
                            if (angle < 0) angle += 360
                            var cumulative = 0f
                            for (i in data.indices) {
                                val sweep = (data[i].second / total) * 360f
                                if (angle >= cumulative && angle < cumulative + sweep) {
                                    onSliceSelected(if (selectedIndex == i) -1 else i)
                                    break
                                }
                                cumulative += sweep
                            }
                        }
                    }
                }
        ) {
            val radius = size.width / 2f * 0.8f
            val center = Offset(size.width / 2f, size.height / 2f)
            var startAngle = -90f

            data.forEachIndexed { index, (_, value, color) ->
                val sweep = (value / total) * 360f
                val isSelected = index == selectedIndex
                val r = if (isSelected) radius * 1.1f else radius
                drawArc(
                    color = color,
                    startAngle = startAngle,
                    sweepAngle = sweep,
                    useCenter = true,
                    topLeft = Offset(center.x - r, center.y - r),
                    size = Size(r * 2, r * 2)
                )
                startAngle += sweep
            }
            // Inner circle for donut effect
            drawCircle(
                color = Color.White,
                radius = radius * 0.5f,
                center = center
            )
        }

        Spacer(modifier = Modifier.width(12.dp))

        // Legend
        Column {
            data.forEachIndexed { index, (emoji, value, color) ->
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier.padding(vertical = 2.dp)
                ) {
                    Box(
                        modifier = Modifier
                            .size(12.dp)
                            .background(color, RoundedCornerShape(2.dp))
                    )
                    Spacer(modifier = Modifier.width(6.dp))
                    Text(
                        text = "$emoji ${((value / total) * 100).toInt()}%",
                        fontSize = 11.sp
                    )
                }
            }
        }
    }
}

@Composable
fun SimpleLineChart(
    data: List<Float>,
    labels: List<String>,
    height: Int
) {
    val maxVal = data.maxOrNull()?.coerceAtLeast(1f) ?: 1f
    val lineColor = Color(0xFF43A047)

    Canvas(
        modifier = Modifier
            .fillMaxWidth()
            .height(height.dp)
    ) {
        if (data.isEmpty()) return@Canvas

        val stepX = size.width / (data.size - 1).coerceAtLeast(1)
        val path = Path()

        data.forEachIndexed { index, value ->
            val x = index * stepX
            val y = size.height - (value / maxVal) * size.height * 0.9f

            if (index == 0) path.moveTo(x, y)
            else path.lineTo(x, y)

            // Draw point
            drawCircle(color = lineColor, radius = 4f, center = Offset(x, y))
        }

        drawPath(
            path = path,
            color = lineColor,
            style = Stroke(width = 3f, cap = StrokeCap.Round)
        )
    }
}

@Composable
fun SimpleHorizontalBarChart(
    data: List<Float>,
    labels: List<String>,
    height: Int
) {
    val maxVal = data.maxOrNull()?.coerceAtLeast(1f) ?: 1f
    val barColor = Color(0xFFEC407A)

    Column(modifier = Modifier.fillMaxWidth()) {
        data.forEachIndexed { index, value ->
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 2.dp)
            ) {
                Text(
                    text = labels.getOrElse(index) { "" },
                    fontSize = 10.sp,
                    modifier = Modifier.width(32.dp)
                )
                Spacer(modifier = Modifier.width(4.dp))
                Box(
                    modifier = Modifier
                        .weight(1f)
                        .height(16.dp)
                ) {
                    Canvas(modifier = Modifier.fillMaxSize()) {
                        val barWidth = (value / maxVal) * size.width
                        drawRect(
                            color = barColor,
                            size = Size(barWidth, size.height)
                        )
                    }
                }
                Spacer(modifier = Modifier.width(4.dp))
                Text(
                    text = value.toInt().toString(),
                    fontSize = 10.sp,
                    color = Color.Gray
                )
            }
        }
    }
}
