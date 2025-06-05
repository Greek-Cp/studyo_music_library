# Studyo Music Library - Auto-Initialization Guide

## 🎉 Simplified Usage with Auto-Initialization

Library Studyo Music sekarang mendukung **auto-initialization**! Anda tidak perlu lagi melakukan setup manual.

## ✨ Cara Penggunaan Baru (Sangat Mudah!)

### 1. Import Library
```dart
import 'package:studyo_music_library/studyo_music_library.dart';
```

### 2. Langsung Gunakan!
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Tidak perlu setup manual lagi!
  // Library otomatis menginisialisasi dirinya sendiri
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Langsung bisa digunakan!
              BgmManager.instance.push(SoundBackground.menu1);
            },
            child: Text('Play BGM'),
          ),
        ),
      ),
    );
  }
}
```

## 🔧 Cara Kerja Auto-Initialization

1. **Otomatis Setup**: Saat library di-import, sistem otomatis:
   - Mengatur `FlameAudio.audioCache.prefix`
   - Memulai preloading sounds di background
   
2. **Non-Blocking**: Preloading berjalan di background tanpa menghambat aplikasi

3. **Fail-Safe**: Jika preloading gagal, sounds akan dimuat on-demand

## 📋 Opsi Lanjutan (Opsional)

### Menunggu Initialization Selesai
Jika Anda ingin memastikan initialization selesai sebelum memulai app:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Tunggu auto-initialization selesai (opsional)
  await StudyoMusicLibraryAutoInit.initialize();
  
  runApp(MyApp());
}
```

### Cek Status Initialization
```dart
if (StudyoMusicLibraryAutoInit.isInitialized) {
  print('Library sudah siap!');
}
```

## 🆚 Perbandingan: Sebelum vs Sesudah

### ❌ Cara Lama (Manual Setup)
```dart
Future<void> initSoundSystem() async {
  FlameAudio.audioCache.prefix = 'packages/studyo_music_library/assets/';
  await BgmManager.instance.preloadAll();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSoundSystem(); // Manual setup diperlukan
  runApp(MyApp());
}
```

### ✅ Cara Baru (Auto-Initialization)
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp()); // Langsung jalan!
}
```

## 🎯 Keuntungan Auto-Initialization

1. **Lebih Mudah**: Tidak perlu setup manual
2. **Lebih Cepat**: Preloading berjalan di background
3. **Lebih Aman**: Fail-safe mechanism
4. **Backward Compatible**: Cara lama masih bisa digunakan

## 🔄 Migration Guide

Untuk mengupdate dari cara lama ke cara baru:

1. Hapus fungsi `initSoundSystem()` dari kode Anda
2. Hapus pemanggilan `await initSoundSystem()` dari `main()`
3. Import library seperti biasa
4. Langsung gunakan!

## 🐛 Troubleshooting

### Jika Sounds Tidak Dimuat
```dart
// Force re-initialization (untuk debugging)
StudyoMusicLibraryAutoInit.reset();
await StudyoMusicLibraryAutoInit.initialize();
```

### Debug Information
```dart
// Cek status library
print('Initialized: ${StudyoMusicLibraryAutoInit.isInitialized}');

// Debug BGM Manager
BgmManager.instance.debugState();
```

---

**Selamat! Library Anda sekarang jauh lebih mudah digunakan! 🎉**