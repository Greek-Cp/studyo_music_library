import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:studyo_music_library/core/sound_manager/bgm_manager.dart';
import 'package:studyo_music_library/core/sound_manager/sound_enums.dart';

// Route Observer for tracking navigation
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

// GetX Controller for BGM
class BGMController extends GetxController {
  final RxBool isPlaying = false.obs;
  final RxDouble volume = 1.0.obs;
  final RxInt currentIndex = 0.obs;

  void toggleBGM() {
    if (isPlaying.value) {
      BgmManager.instance.pause();
    } else {
      BgmManager.instance.resume();
    }
    isPlaying.toggle();
  }

  void setVolume(double value) {
    volume.value = value;
    BgmManager.instance.setBaseVolume(value);
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
}

Future<void> initSoundSystem() async {
  // pastikan AudioCache selalu mencari di bawah "assets/"
  FlameAudio.audioCache.prefix = 'assets/';

  // preload absolut? tidak perlu—kita pakai path relatif + prefix di bawah
  await BgmManager.instance.preloadAll();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSoundSystem();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sound Test App',
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BGMController controller = Get.put(BGMController());

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              SoundTestPage(),
              NavigationTestPage(),
            ],
          )),
      bottomNavigationBar: Obx(() => NavigationBar(
            selectedIndex: controller.currentIndex.value,
            onDestinationSelected: controller.changePage,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.music_note),
                label: 'Sound Test',
              ),
              NavigationDestination(
                icon: Icon(Icons.navigation),
                label: 'Navigation',
              ),
            ],
          )),
    ).addBGMGlobal([
      BackgroundSound.balance,
      BackgroundSound.bonus,
      BackgroundSound.journal,
      BackgroundSound.journal2,
      BackgroundSound.profile,
      BackgroundSound.profile_1,
      BackgroundSound.teamup,
      BackgroundSound.teamup_1,
    ]);
  }
}

class SoundTestPage extends StatelessWidget {
  const SoundTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sound Test Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container with click sound
            Container(
              height: 100,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
            ).addSound(TAPSound.tap, SoundType.tap),

            // Draggable widget with sound
            Draggable<String>(
              data: 'draggable',
              feedback: Container(
                width: 100,
                height: 100,
                color: Colors.green.withOpacity(0.5),
                child: const Center(child: Text('Dragging...')),
              ),
              childWhenDragging: Container(
                width: 100,
                height: 100,
                color: Colors.grey,
                child: const Center(child: Text('Dragged')),
              ),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.green,
                child: const Center(child: Text('Drag Me')),
              ),
            ).addSound(TAPSound.tap, SoundType.tap, isDragWidget: true),

            const SizedBox(height: 16),

            // Widget with SFX on appear
            Container(
              height: 100,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('This widget plays SFX when it appears'),
              ),
            ).addSound(WhooshSound.longwhoosh, SoundType.whoosh),

            const SizedBox(height: 16),

            // Widget with notification sound
            Container(
              height: 100,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('This widget plays notification when it appears'),
              ),
            ).addSound(ReviewSound.happy, SoundType.review),

            const SizedBox(height: 16),

            // Button with notification sound
            ElevatedButton(
              onPressed: () {},
              child: const Text('Show Notification'),
            ).addSound(MessagesSound.message, SoundType.messages),

            const SizedBox(height: 16),

            // Card with SFX sound
            Card(
              child: ListTile(
                title: const Text('Play SFX'),
                subtitle: const Text('Tap to play sound effect'),
                onTap: () {},
              ),
            ).addSound(WhooshSound.longwhoosh, SoundType.whoosh),

            const SizedBox(height: 16),

            // Custom widget with multiple sounds
            _buildCustomWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Text(
            'Custom Widget with Multiple Sounds',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSoundButton(
                'Click',
                TAPSound.tap,
                SoundType.tap,
              ),
              _buildSoundButton(
                'SFX',
                WhooshSound.longwhoosh,
                SoundType.whoosh,
              ),
              _buildSoundButton(
                'Notify',
                ReviewSound.happy,
                SoundType.review,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoundButton(String label, dynamic sound, SoundType type) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(label),
    ).addSound(sound, type);
  }
}

class NavigationTestPage extends StatelessWidget {
  const NavigationTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Test'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNavigationCard(
            title: 'Page A',
            description: 'Navigate to Page A with specific BGM',
            onTap: () => Get.to(() => const PageA()),
          ),
          const SizedBox(height: 16),
          _buildNavigationCard(
            title: 'Page B',
            description: 'Navigate to Page B with different BGM',
            onTap: () => Get.to(() => const PageB()),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
}

class PageA extends StatelessWidget {
  const PageA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page A'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is Page A',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    ).addBGM(BackgroundSound.tetris);
  }
}

class PageB extends StatelessWidget {
  const PageB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page B'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is Page B',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    ).addBGM(BackgroundSound.profile);
  }
}
