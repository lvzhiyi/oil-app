package com.maiyoubei.businessapp

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity   // ← 你这句缺了
import com.maiyoubei.businessapp.databinding.ActivitySplashBinding

class SplashActivity : AppCompatActivity() {

    private lateinit var binding: ActivitySplashBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivitySplashBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // 延迟跳转到 Flutter 主入口
        binding.root.postDelayed({
            startActivity(Intent(this, MainActivity::class.java))
            finish()
        }, 1500)
    }
}