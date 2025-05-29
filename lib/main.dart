import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:collection/collection.dart';
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
              ManualTestPage(),
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
              NavigationDestination(
                icon: Icon(Icons.settings),
                label: 'Manual Test',
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

class PageA extends StatefulWidget {
  const PageA({super.key});

  @override
  State<PageA> createState() => _PageAState();
}

class _PageAState extends State<PageA> {
  final List<DragItem> items = [
    DragItem(id: 'apple', label: '🍎', target: 'fruit'),
    DragItem(id: 'banana', label: '🍌', target: 'fruit'),
    DragItem(id: 'carrot', label: '🥕', target: 'vegetable'),
    DragItem(id: 'broccoli', label: '🥦', target: 'vegetable'),
    DragItem(id: 'dog', label: '🐕', target: 'animal'),
    DragItem(id: 'cat', label: '🐱', target: 'animal'),
  ];

  final Map<String, String> droppedItems = {};

  void _onDragEnd(String itemId, String targetId) {
    final item = items.firstWhere((item) => item.id == itemId);
    final isCorrect = item.target == targetId;

    setState(() {
      droppedItems[itemId] = targetId;
    });

    // Play appropriate sound
    if (isCorrect) {
      SoundController.instance.playSound(
        SuccessSound.winning,
        SoundType.success,
        volume: 1.0,
      );
    } else {
      SoundController.instance.playSound(
        DenySound.delete,
        SoundType.deny,
        volume: 1.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag & Drop Game'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // Draggable Items
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[100],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Drag Items',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              final isDropped =
                                  droppedItems.containsKey(item.id);

                              return Draggable<String>(
                                data: isDropped ? null : item.id,
                                feedback: Material(
                                  elevation: 4,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        item.label,
                                        style: const TextStyle(fontSize: 40),
                                      ),
                                    ),
                                  ),
                                ),
                                childWhenDragging: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isDropped
                                        ? Colors.grey[300]
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.label,
                                      style: const TextStyle(fontSize: 40),
                                    ),
                                  ),
                                ),
                              ).addSound(
                                WhooshSound.longwhoosh,
                                SoundType.whoosh,
                                isDragWidget: true,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Drop Targets
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[200],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Drop Here',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children: [
                              _buildDropTarget('fruit', '🍎'),
                              _buildDropTarget('vegetable', '🥕'),
                              _buildDropTarget('animal', '🐕'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Reset Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  droppedItems.clear();
                });
                SoundController.instance.playSound(
                  TransitionsSound.opener,
                  SoundType.transitions,
                  volume: 1.0,
                );
              },
              child: const Text('Reset Game'),
            ),
          ),
        ],
      ),
    ).addBGM(BackgroundSound.tetris);
  }

  Widget _buildDropTarget(String targetId, String emoji) {
    return DragTarget<String>(
      builder: (context, candidateItems, rejectedItems) {
        final isActive = candidateItems.isNotEmpty;
        final droppedItem = droppedItems.entries
            .firstWhereOrNull((entry) => entry.value == targetId);

        return Container(
          decoration: BoxDecoration(
            color: isActive ? Colors.blue[100] : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? Colors.blue : Colors.grey,
              width: isActive ? 2 : 1,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 40),
                ),
                if (droppedItem != null)
                  Text(
                    items
                        .firstWhere((item) => item.id == droppedItem.key)
                        .label,
                    style: const TextStyle(fontSize: 40),
                  ),
              ],
            ),
          ),
        );
      },
      onWillAccept: (itemId) {
        if (itemId == null) return false;
        final item = items.firstWhere((item) => item.id == itemId);
        return !droppedItems.containsKey(itemId) && item.target == targetId;
      },
      onAccept: (itemId) => _onDragEnd(itemId, targetId),
    );
  }
}

class DragItem {
  final String id;
  final String label;
  final String target;

  DragItem({
    required this.id,
    required this.label,
    required this.target,
  });
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

class ManualTestPage extends StatelessWidget {
  const ManualTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final volume = 1.0.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Sound Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Volume Control
            Obx(() => Column(
                  children: [
                    Text('Volume: ${(volume.value * 100).toStringAsFixed(0)}%'),
                    Slider(
                      value: volume.value,
                      onChanged: (value) => volume.value = value,
                    ),
                  ],
                )),
            const SizedBox(height: 20),

            // Sound Test Buttons
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSoundButton(
                      'Whoosh Sound',
                      () => SoundController.instance.playSound(
                        WhooshSound.longwhoosh,
                        SoundType.whoosh,
                        volume: volume.value,
                      ),
                    ),
                    _buildSoundButton(
                      'Drop Sound',
                      () => SoundController.instance.playSound(
                        ClipSound.containerdrop,
                        SoundType.clip,
                        volume: volume.value,
                      ),
                    ),
                    _buildSoundButton(
                      'Tap Sound',
                      () => SoundController.instance.playSound(
                        TAPSound.tap,
                        SoundType.tap,
                        volume: volume.value,
                      ),
                    ),
                    _buildSoundButton(
                      'Message Sound',
                      () => SoundController.instance.playSound(
                        MessagesSound.message,
                        SoundType.messages,
                        volume: volume.value,
                      ),
                    ),
                    _buildSoundButton(
                      'Success Sound',
                      () => SoundController.instance.playSound(
                        SuccessSound.winning,
                        SoundType.success,
                        volume: volume.value,
                      ),
                    ),
                    _buildSoundButton(
                      'Deny Sound',
                      () => SoundController.instance.playSound(
                        DenySound.delete,
                        SoundType.deny,
                        volume: volume.value,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BGM Controls
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'BGM Controls',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                SoundController.instance.setGlobalBGM([
                              BackgroundSound.journal,
                              BackgroundSound.journal2,
                            ]),
                            child: const Text('Start BGM'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => SoundController.instance.stopBGM(),
                            child: const Text('Stop BGM'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(label),
      ),
    );
  }
}
