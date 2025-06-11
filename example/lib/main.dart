import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:studyo_music_library/core/sound_manager/core/sound_controller.dart';
import 'package:studyo_music_library/studyo_music_library.dart';
import 'package:studyo_music_library/core/sound_manager/widgets/sound_track_wrapper.dart';

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

// Auto-initialization example - no manual setup needed!
// The library automatically initializes when imported

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // No need to call initSoundSystem() anymore!
  // The library handles initialization automatically

  runApp(const MainApp());
}

// Optional: If you want to ensure initialization is complete before starting
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Wait for auto-initialization to complete (optional)
//   await StudyoMusicLibraryAutoInit.initialize();
//
//   runApp(const MainApp());
// }

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
      SoundBackground.balance,
      SoundBackground.bonus,
      SoundBackground.journal,
      SoundBackground.journal2,
      SoundBackground.profile,
      SoundBackground.teamup,
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
            ).addSound(SoundTAP.tap, SoundType.tap),

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
            ).addSound(SoundPickup.plop, SoundType.pickup, isDragWidget: true),

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
            ).addSound(SoundWhoosh.longwhoosh, SoundType.whoosh),

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
            ).addSound(SoundReview.happy, SoundType.review),

            const SizedBox(height: 16),

            // Button with notification sound
            ElevatedButton(
              onPressed: () {},
              child: const Text('Show Notification'),
            ).addSound(SoundMessages.message, SoundType.messages),

            const SizedBox(height: 16),

            // Card with SFX sound
            Card(
              child: ListTile(
                title: const Text('Play SFX'),
                subtitle: const Text('Tap to play sound effect'),
                onTap: () {},
              ),
            ).addSound(SoundWhoosh.longwhoosh, SoundType.whoosh),

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
                SoundTAP.tap,
                SoundType.tap,
              ),
              _buildSoundButton(
                'SFX',
                SoundWhoosh.longwhoosh,
                SoundType.whoosh,
              ),
              _buildSoundButton(
                'Notify',
                SoundReview.happy,
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
          const SizedBox(height: 16),
          _buildNavigationCard(
            title: 'Silent Page',
            description:
                'Navigate to Silent Page (no BGM, but changes global BGM when return)',
            onTap: () => Get.to(() => const SilentPage()),
          ),
          const SizedBox(height: 16),
          _buildNavigationCard(
            title: 'Drag Sound Demo',
            description:
                'Page with draggable objects using 3-sound-lists track system',
            onTap: () => Get.to(() => const DragSoundPage()),
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
  final bgmVolume = 0.5.obs; // Default BGM volume 50%

  @override
  void initState() {
    super.initState();
    // Set initial BGM volume
    BgmManager.instance.setBaseVolume(bgmVolume.value);
  }

  void _onDragEnd(String itemId, String targetId) {
    final item = items.firstWhere((item) => item.id == itemId);
    final isCorrect = item.target == targetId;

    setState(() {
      droppedItems[itemId] = targetId;
    });

    // Play appropriate sound
    if (isCorrect) {
      SoundController.instance.playSound(
        SoundSuccess.winning,
        SoundType.success,
        volume: 1.0,
      );
    } else {
      SoundController.instance.playSound(
        SoundDeny.delete,
        SoundType.deny,
        volume: 1.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag & Drop Game')
            .addSound(SoundClick.interfaceClick, SoundType.click),
        actions: [
          // BGM Volume Control
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.volume_up),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: Obx(() => Slider(
                        value: bgmVolume.value,
                        onChanged: (value) {
                          bgmVolume.value = value;
                          BgmManager.instance.setBaseVolume(value);
                        },
                      )),
                ),
              ],
            ),
          ),
        ],
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
                        ).addSound(
                            SoundResources.starcollect, SoundType.resources),
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
                                SoundWhoosh.longwhoosh,
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
                  SoundTransitions.opener,
                  SoundType.transitions,
                  volume: 1.0,
                );
              },
              child: const Text('Reset Game'),
            ),
          ),
        ],
      ),
    ).addBGM(SoundBackground.tetris);
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
      onWillAcceptWithDetails: (details) {
        final itemId = details.data;
        if (itemId == null) return false;
        final item = items.firstWhere((item) => item.id == itemId);
        return !droppedItems.containsKey(itemId) && item.target == targetId;
      },
      onAcceptWithDetails: (details) => _onDragEnd(details.data, targetId),
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

class PageB extends StatefulWidget {
  const PageB({super.key});

  @override
  State<PageB> createState() => _PageBState();
}

class _PageBState extends State<PageB> {
  // Define the sound track for this page
  static const trackId = 'page_b_containers';
  static final soundList = [
    SoundTAP.tap,
    SoundTAP.deepbutton,
    SoundTAP.bubble,
    SoundTAP.water,
  ];

  int currentTrackIndex = 0;
  final soundNames = ['Tap', 'Deep Button', 'Bubble', 'Water'];

  @override
  void initState() {
    super.initState();
    // Initialize track and get current index
    SoundTrackController.instance
        .setSoundTrack(trackId, soundList, SoundType.tap);
    currentTrackIndex =
        SoundTrackController.instance.getCurrentTrackIndex(trackId);
  }

  Future<void> _nextTrack() async {
    await SoundTrackController.instance.nextTrack(trackId);
    setState(() {
      currentTrackIndex =
          SoundTrackController.instance.getCurrentTrackIndex(trackId);
    });
  }

  Future<void> _previousTrack() async {
    await SoundTrackController.instance.previousTrack(trackId);
    setState(() {
      currentTrackIndex =
          SoundTrackController.instance.getCurrentTrackIndex(trackId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page B - Sound Track Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Page B with Sound Track',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ).addSound(SoundBubble.move, SoundType.bubble),
            const SizedBox(height: 10),
            const Text(
              'Each container has the same sound track.\nLeave and return to hear the next sound!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            // 4 containers with the same sound track
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Container 1
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ).addSound(soundList, SoundType.tap, trackId: trackId),

                // Container 2
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ).addSound(soundList, SoundType.tap, trackId: trackId),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Container 3
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ).addSound(soundList, SoundType.tap, trackId: trackId),

                // Container 4
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      '4',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ).addSound(soundList, SoundType.tap, trackId: trackId),
              ],
            ),

            const SizedBox(height: 40),

            // Track Navigation Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  const Text(
                    'Sound Track Control',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Current Track Info
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Text(
                      'Current: ${soundNames[currentTrackIndex]} (${currentTrackIndex + 1}/${soundList.length})',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Navigation Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _previousTrack,
                        icon: const Icon(Icons.skip_previous),
                        label: const Text('Previous'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _nextTrack,
                        icon: const Icon(Icons.skip_next),
                        label: const Text('Next'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Tap containers above to hear current sound!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    ).addBGM(SoundBackground.profile).withSoundTrack(trackId);
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
                        SoundWhoosh.longwhoosh,
                        SoundType.whoosh,
                        volume: volume.value,
                      ),
                    ),
                    _buildSoundButton(
                      'Drop Sound',
                      () => SoundController.instance.playSound(
                        SoundClip.containerdrop,
                        SoundType.clip,
                        volume: volume.value,
                      ),
                    ),
                    _buildSoundButton(
                      'Tap Sound',
                      () => SoundController.instance.playSound(
                        SoundTAP.tap,
                        SoundType.tap,
                        volume: volume.value,
                      ),
                    ),
                    _buildSoundButton(
                      'Message Sound',
                      () => SoundController.instance.playSound(
                        SoundMessages.message,
                        SoundType.messages,
                        volume: volume.value,
                      ),
                    ),
                    _buildSoundButton(
                      'Success Sound',
                      () => SoundController.instance.playSound(
                        SoundSuccess.winning,
                        SoundType.success,
                        volume: volume.value,
                      ),
                    ),
                    _buildSoundButton(
                      'Deny Sound',
                      () => SoundController.instance.playSound(
                        SoundDeny.delete,
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
                              SoundBackground.journal,
                              SoundBackground.journal2,
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

class SilentPage extends StatelessWidget {
  const SilentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Silent Page'),
        backgroundColor: Colors.grey[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.volume_off,
              size: 80,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 20),
            Text(
              'Silent Page',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'This page has no background music.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'When you enter and leave this page,\nthe global BGM track will change automatically!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Some interactive elements that still have sound effects
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Sound Effects Still Work',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Tap Effect'),
                        ).addSound(SoundTAP.tap, SoundType.tap),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Success'),
                        ).addSound(SoundSuccess.winning, SoundType.success),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Whoosh'),
                        ).addSound(SoundWhoosh.longwhoosh, SoundType.whoosh),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    ).addBgmNone(); // This is the key! No BGM but changes global track
  }
}

class DragSoundPage extends StatefulWidget {
  const DragSoundPage({super.key});

  @override
  State<DragSoundPage> createState() => _DragSoundPageState();
}

class _DragSoundPageState extends State<DragSoundPage> {
  // Define the drag sound track for this page
  static const trackId = 'drag_objects_demo';

  // Different length lists to demonstrate the sync behavior
  static final tapSounds = [
    SoundTAP.tap,
    SoundTAP.deepbutton,
    SoundTAP.bubble,
    SoundTAP.water,
  ]; // 4 sounds

  static final whooshSounds = [
    SoundWhoosh.longwhoosh,
    SoundWhoosh.whooshAccelerate,
  ]; // 2 sounds

  static final dropSounds = [
    SoundClip.itemGetsDropped,
    SoundClip.containerdrop,
  ]; // 2 sounds

  int currentTrackIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize track and get current index
    DragSoundTrackController.instance.setDragSoundTrack(
      trackId,
      tapSounds,
      whooshSounds,
      dropSounds,
      SoundType.tap,
      SoundType.whoosh,
      SoundType.clip,
    );
    currentTrackIndex =
        DragSoundTrackController.instance.getCurrentTrackIndex(trackId);
  }

  Future<void> _nextTrack() async {
    await DragSoundTrackController.instance.nextTrack(trackId);
    setState(() {
      currentTrackIndex =
          DragSoundTrackController.instance.getCurrentTrackIndex(trackId);
    });
  }

  Future<void> _previousTrack() async {
    await DragSoundTrackController.instance.previousTrack(trackId);
    setState(() {
      currentTrackIndex =
          DragSoundTrackController.instance.getCurrentTrackIndex(trackId);
    });
  }

  String _getCurrentSoundNames() {
    final tapSound =
        DragSoundTrackController.instance.getCurrentTapSound(trackId);
    final whooshSound =
        DragSoundTrackController.instance.getCurrentWhooshSound(trackId);
    final dropSound =
        DragSoundTrackController.instance.getCurrentDropSound(trackId);
    return 'Tap: ${tapSound.toString().split('.').last}\nWhoosh: ${whooshSound.toString().split('.').last}\nDrop: ${dropSound.toString().split('.').last}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag Sound Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Info Card
            Card(
              color: Colors.deepPurple[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Drag Sound Track Demo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Each draggable object uses 3 different sound lists:\n• Tap sounds (${tapSounds.length} sounds)\n• Whoosh sounds (${whooshSounds.length} sounds)\n• Drop sounds (${dropSounds.length} sounds)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.deepPurple[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.deepPurple[200]!),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Current Track: ${currentTrackIndex + 1}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getCurrentSoundNames(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.deepPurple[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Draggable Objects Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final colors = [
                    Colors.red,
                    Colors.blue,
                    Colors.green,
                    Colors.orange
                  ];
                  final emojis = ['🎮', '🎲', '⚽', '🎯'];

                  return Container(
                    decoration: BoxDecoration(
                      color: colors[index].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors[index], width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          emojis[index],
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Drag Me ${index + 1}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colors[index],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap, Drag & Drop',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors[index].withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ).addDragSound(
                    tapSounds: tapSounds,
                    whooshSounds: whooshSounds,
                    dropSounds: dropSounds,
                    tapType: SoundType.tap,
                    whooshType: SoundType.whoosh,
                    dropType: SoundType.clip,
                    trackId: trackId,
                    volume: 0.8,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Track Control Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Track Controls',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[800],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _previousTrack,
                          icon: const Icon(Icons.skip_previous),
                          label: const Text('Previous'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _nextTrack,
                          icon: const Icon(Icons.skip_next),
                          label: const Text('Next'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Leave and return to this page\nto hear the next sound set!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    ).addBgmNone().withDragSoundTrack(trackId);
  }
}
