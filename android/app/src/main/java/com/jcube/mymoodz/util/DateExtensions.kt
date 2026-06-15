package com.jcube.mymoodz.util

import java.time.LocalDate
import java.time.ZoneId
import java.util.Date

fun Date.toLocalDate(): LocalDate {
    return this.toInstant().atZone(ZoneId.systemDefault()).toLocalDate()
}

fun LocalDate.toDate(): Date {
    return Date.from(this.atStartOfDay(ZoneId.systemDefault()).toInstant())
}

fun Date.stripTime(): Date {
    return this.toLocalDate().toDate()
}

fun Date.addingDays(days: Int): Date {
    return this.toLocalDate().plusDays(days.toLong()).toDate()
}
