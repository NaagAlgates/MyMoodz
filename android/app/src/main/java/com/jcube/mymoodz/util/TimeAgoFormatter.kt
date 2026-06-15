package com.jcube.mymoodz.util

import java.util.Date
import java.util.concurrent.TimeUnit

object TimeAgoFormatter {
    fun format(date: Date, now: Date = Date()): String {
        val seconds = TimeUnit.MILLISECONDS.toSeconds(now.time - date.time)

        val minute = 60L
        val hour = 3600L
        val day = 86400L
        val week = 604800L
        val month = 2592000L

        return when {
            seconds < 30 -> "Just now"
            seconds < 60 -> "30 sec ago"
            seconds < hour -> {
                val mins = (seconds / minute).toInt()
                "${mins} min${if (mins == 1) "" else "s"} ago"
            }
            seconds < day -> {
                val formatter = java.text.SimpleDateFormat("h:mm a", java.util.Locale.getDefault())
                formatter.format(date)
            }
            seconds < 2 * day -> "Yesterday"
            seconds < week -> {
                val days = (seconds / day).toInt()
                "${days} days ago"
            }
            seconds < 2 * week -> "A week ago"
            seconds < month -> {
                val weeks = (seconds / week).toInt()
                "${weeks} weeks ago"
            }
            seconds < 2 * month -> "A month ago"
            else -> {
                val months = (seconds / month).toInt()
                if (months <= 0) "Just now" else "${months} months ago"
            }
        }
    }
}
