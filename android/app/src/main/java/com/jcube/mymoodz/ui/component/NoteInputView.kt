package com.jcube.mymoodz.ui.component

import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.animateDpAsState
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.onFocusChanged
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.jcube.mymoodz.model.Mood

@Composable
fun NoteInputView(
    note: String,
    onNoteChange: (String) -> Unit,
    selectedEmoji: String?,
    modifier: Modifier = Modifier
) {
    var isFocused by remember { mutableStateOf(false) }
    val borderColor by animateColorAsState(
        targetValue = if (isFocused && selectedEmoji != null) {
            Mood.colorForEmoji(selectedEmoji).copy(alpha = 0.8f)
        } else {
            Color.Gray.copy(alpha = 0.4f)
        },
        label = "borderColor"
    )

    val shape = RoundedCornerShape(10.dp)

    BasicTextField(
        value = note,
        onValueChange = onNoteChange,
        modifier = modifier
            .fillMaxWidth()
            .heightIn(min = 100.dp, max = 200.dp)
            .background(Color(0xFFF5F5F5), shape)
            .border(1.dp, borderColor, shape)
            .padding(12.dp)
            .onFocusChanged { isFocused = it.isFocused },
        textStyle = TextStyle(fontSize = 16.sp, color = Color(0xFF333333)),
        cursorBrush = SolidColor(Mood.colorForEmoji(selectedEmoji ?: "")),
        decorationBox = { innerTextField ->
            if (note.isEmpty()) {
                Text(
                    text = "Add a short note (optional)",
                    color = Color.Gray,
                    fontSize = 16.sp
                )
            }
            innerTextField()
        }
    )
}
