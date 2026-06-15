package com.jcube.mymoodz

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import com.jcube.mymoodz.ui.navigation.MyMoodzNavGraph
import com.jcube.mymoodz.ui.theme.MyMoodzTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            MyMoodzTheme {
                MyMoodzNavGraph()
            }
        }
    }
}
