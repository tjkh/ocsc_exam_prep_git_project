


// '_qUaKhdi7Uk', 'ระเบียบสำนักนายกรัฐมนตรีว่าด้วยหลักเกณฑ์การปฏิบัติเกี่ยวกับความรับผิดทางละเมิดของเจ้าหน้าที่ พ.ศ. 2539'

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'video_player_page.dart'; // Import the video player page

class VideoListMath extends StatefulWidget {
  final String myPageName;
  final String msgToShow;
  final String createdDate;

  const VideoListMath({
    Key? key,
    required this.myPageName,
    required this.msgToShow,
    required this.createdDate,
  }) : super(key: key);

  @override
  State<VideoListMath> createState() => _VideoListState();
}

class _VideoListState extends State<VideoListMath> {


  final List<List<String>> lessons = [
    ['OwsW2J5Ic4s', 'คิดลัด สมการเส้นตรง'],
    ['ekwLWgeR5rQ', 'Lesson 1: ฟังหูไว้หู'],
    ['Nra0NfxQEoc', 'Lesson 2: Chuwi Freebook N100 vs Hi10 Max'],
    ['_WoCV4c6XOE', 'Lesson 3: Building UI'],
    ['KmzdUe0RSJo', 'Lesson 4: Networking'],
    ['6jZDSSZZxjQ', 'Lesson 5: Database Integration'],
    ['p2lYr3vM_1w', 'Lesson 6: Advanced Flutter'],
    ['7QUtEmBT_-w', 'Lesson 7: Deployment'],
    ['34_PXCzGw1M', 'Lesson 8: Best Practices'],
  ];

  List<bool> viewedLessons = [];


  @override
  void initState() {
    super.initState();
    loadViewedLessons();
  }

  Future<void> loadViewedLessons() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    viewedLessons = List.generate(lessons.length, (index) {
      return prefs.getBool('lesson_$index') ?? false; // Default to false if not set
    });
    setState(() {});
  }

  Future<void> markLessonAsViewed(int index) async {
    viewedLessons[index] = true; // Mark as viewed
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lesson_$index', true); // Save to SharedPreferences
    setState(() {});
  }

  Future<void> clearAllViewedLessons() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int index = 0; index < viewedLessons.length; index++) {
      viewedLessons[index] = false; // Reset the viewed status
      await prefs.setBool('lesson_$index', false); // Save to SharedPreferences
    }
    setState(() {}); // Update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เตรียมสอบ กพ. ภาค ก.'),
        actions: [
          Tooltip(
            message: 'ล้าง \u{02713} หน้าหัวข้อ',
            child: IconButton(
                icon: ImageIcon(AssetImage('assets/icons/no_check_mark.png'),
                  size: 24.0, // Set the desired size),
                ),
                onPressed: clearAllViewedLessons // Clear all check marks
            ),
          ),
        ],

      ),

      body: Column(
        children: [
          Container(
            // สำหรับชื่อ ชุดข้อสอบ
            width: double.infinity,
            decoration: BoxDecoration(
              //  color: Colors.redAccent,
              color: Theme.of(context).primaryColorDark,
              border: const Border(
                top: BorderSide(width: 1, color: Colors.white70),
                //   bottom: BorderSide(width: 1, color: Colors.white),
              ),
            ),
            child: Text(widget.myPageName,
              textAlign: TextAlign.center,
              // style: TextStyle(
              //   color: Colors.white,
              //   fontSize: 16.0,
              // ),
              style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white54,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            // สำหรับชื่อ ชุดข้อสอบ
            width: double.infinity,
            decoration: BoxDecoration(
              //  color: Colors.redAccent,
              color: Theme.of(context).primaryColorDark,
              border: const Border(
                top: BorderSide(width: 1, color: Colors.white70),
                //   bottom: BorderSide(width: 1, color: Colors.white),
              ),
            ),
            child: const Text('ต้องมีอินเทอร์เน็ต จึงจะใช้งานได้',
              textAlign: TextAlign.center,
              // style: TextStyle(
              //   color: Colors.white,
              //   fontSize: 16.0,
              // ),
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white54,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align to the top
                    children: [
                      if (viewedLessons[index]) // Show check mark if viewed
                        const Icon(Icons.check, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded( // Use Expanded to take available space
                        child: Text(
                          lessons[index][1], // Lesson name from the combined list
                          style: const TextStyle(
                            fontSize: 16.0, // Optional: Set a consistent font size
                          ),
                          softWrap: true, // Enable text wrapping
                          maxLines: 3, // Optional: Limit to 3 lines; remove if you want unlimited lines
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    // Navigate to video player page with the video ID from the combined list
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerPage(
                          videoId: lessons[index][0],
                          nameOfVideo:lessons[index][1],
                        ),
                      ),
                    );

                    // Mark lesson as viewed after coming back
                    markLessonAsViewed(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



