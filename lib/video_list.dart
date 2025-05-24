


// '_qUaKhdi7Uk', 'ระเบียบสำนักนายกรัฐมนตรีว่าด้วยหลักเกณฑ์การปฏิบัติเกี่ยวกับความรับผิดทางละเมิดของเจ้าหน้าที่ พ.ศ. 2539'

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'video_player_page.dart'; // Import the video player page

class VideoList extends StatefulWidget {
  final String myPageName;
  final String msgToShow;
  final String createdDate;

  const VideoList({
    Key? key,
    required this.myPageName,
    required this.msgToShow,
    required this.createdDate,
  }) : super(key: key);

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {


  final List<List<String>> lessons = [
    ['_qUaKhdi7Uk', 'พ.ร.บ.ความรับผิดทางละเมิดของเจ้าหน้าที่ พ.ศ. 2539 (ดร.ฐิติญา จิตมั่น)'],
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



//========== original code: show all videos. Can scroll to select and play.

// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// class VideoList extends StatefulWidget {
//   final String msgToShow;
//   final String createdDate;
//
//   const VideoList({Key? key, required this.msgToShow, required this.createdDate}) : super(key: key);
//
//   @override
//   State<VideoList> createState() => _VideoListState();
// }
//
// class _VideoListState extends State<VideoList> {
//   final List<String> videoIds = [
//     'gQDByCdjUXw',
//     'iLnmTe5Q2Qw',
//     '_WoCV4c6XOE',
//     'KmzdUe0RSJo',
//     '6jZDSSZZxjQ',
//     'p2lYr3vM_1w',
//     '7QUtEmBT_-w',
//     '34_PXCzGw1M',
//   ];
//
//   List<bool> viewedVideos = [];
//   int viewedCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     viewedVideos = List<bool>.filled(videoIds.length, false); // Initialize all as not viewed
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video List'),
//       ),
//       body: ListView.builder(
//         itemCount: videoIds.length,
//         itemBuilder: (context, index) {
//           return Column(
//             children: [
//               YoutubePlayer(
//                 controller: YoutubePlayerController(
//                   initialVideoId: videoIds[index],
//                   flags: const YoutubePlayerFlags(
//                     autoPlay: false,
//                   ),
//                 ),
//                 bottomActions: [
//                   CurrentPosition(),
//                   ProgressBar(isExpanded: true),
//                   RemainingDuration(),
//                   FullScreenButton(),
//                 ],
//                 onEnded: (data) {
//                   // Mark video as viewed when it ends
//                   setState(() {
//                     viewedVideos[index] = true;
//                     viewedCount++;
//                   });
//                 },
//               ),
//               const Divider(),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pop(context, viewedCount); // Return the count of viewed videos
//         },
//         child: const Icon(Icons.check),
//       ),
//     );
//   }
// }





//
// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// class VideoList extends StatefulWidget {
//   final String msgToShow;
//   final String createdDate;
//
//   const VideoList({Key? key, required this.msgToShow, required this.createdDate}) : super(key: key);
//
//   @override
//   State<VideoList> createState() => _VideoListState();
// }
//
// class _VideoListState extends State<VideoList> {
//   final List<String> videoIds = [
//     'gQDByCdjUXw',
//     'iLnmTe5Q2Qw',
//     '_WoCV4c6XOE',
//     'KmzdUe0RSJo',
//     '6jZDSSZZxjQ',
//     'p2lYr3vM_1w',
//     '7QUtEmBT_-w',
//     '34_PXCzGw1M',
//   ];
//
//   final List<String> lessonNames = [
//     'Lesson 1: Introduction to Flutter',
//     'Lesson 2: State Management',
//     'Lesson 3: Building UI',
//     'Lesson 4: Networking',
//     'Lesson 5: Database Integration',
//     'Lesson 6: Advanced Flutter',
//     'Lesson 7: Deployment',
//     'Lesson 8: Best Practices',
//   ];
//
//   String selectedVideoId = '';
//   String? selectedLesson;
//   List<String> filteredLessons = [];
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     filteredLessons = List.from(lessonNames);
//   }
//
//   void filterLessons(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         filteredLessons = List.from(lessonNames);
//       });
//     } else {
//       setState(() {
//         filteredLessons = lessonNames
//             .where((lesson) => lesson.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       });
//       if (filteredLessons.isEmpty) {
//         setState(() {
//           filteredLessons = ['search not found'];
//         });
//       }
//     }
//   }
//
//   void updateSelectedVideo(int index) {
//     final newVideoId = videoIds[index];
//     if (newVideoId != selectedVideoId) { // Check if the new video ID is different
//       setState(() {
//         selectedVideoId = '';
//         selectedVideoId = newVideoId; // Update to the new video ID
//         print("selectedVideoId: $selectedVideoId");
//         selectedLesson = lessonNames[index]; // Highlight the selected lesson
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video Lessons'),
//       ),
//       body: Row(
//         children: [
//           // Left pane: Lesson names with search
//           Container(
//             width: 250, // Default width
//             color: Colors.grey[200],
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     controller: searchController,
//                     decoration: const InputDecoration(
//                       labelText: 'Search Lessons',
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: filterLessons,
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: filteredLessons.length,
//                     itemBuilder: (context, index) {
//                       final lessonName = filteredLessons[index];
//                       return ListTile(
//                         title: Text(
//                           lessonName,
//                           style: TextStyle(
//                             fontWeight: lessonName == selectedLesson ? FontWeight.bold : FontWeight.normal,
//                             color: lessonName == selectedLesson ? Colors.blue : Colors.black,
//                           ),
//                         ),
//                         onTap: () {
//                           if (lessonName != 'search not found') {
//                             updateSelectedVideo(index); // Update the selected video
//                           }
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Right pane: Video player
//           Expanded(
//             child: selectedVideoId.isNotEmpty
//                 ? YoutubePlayer(
//               controller: YoutubePlayerController(
//                 initialVideoId: selectedVideoId,
//                 flags: const YoutubePlayerFlags(
//                   autoPlay: false,
//                 ),
//               ),
//               bottomActions: [
//                 CurrentPosition(),
//                 ProgressBar(isExpanded: true),
//                 RemainingDuration(),
//                 FullScreenButton(),
//               ],
//             )
//                 : Center(child: const Text('Select a lesson to play video')),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//
//
//     super.dispose();
//     print("dispose controller");
//   }
// }
//
//





// play next video need to exit page.

// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// class VideoList extends StatefulWidget {
//   final String msgToShow;
//   final String createdDate;
//
//   const VideoList({Key? key, required this.msgToShow, required this.createdDate}) : super(key: key);
//
//   @override
//   State<VideoList> createState() => _VideoListState();
// }
//
// class _VideoListState extends State<VideoList> {
//   final List<String> videoIds = [
//     'gQDByCdjUXw',
//     'iLnmTe5Q2Qw',
//     '_WoCV4c6XOE',
//     'KmzdUe0RSJo',
//     '6jZDSSZZxjQ',
//     'p2lYr3vM_1w',
//     '7QUtEmBT_-w',
//     '34_PXCzGw1M',
//   ];
//
//   final List<String> lessonNames = [
//     'Lesson 1: Introduction to Flutter',
//     'Lesson 2: State Management',
//     'Lesson 3: Building UI',
//     'Lesson 4: Networking',
//     'Lesson 5: Database Integration',
//     'Lesson 6: Advanced Flutter',
//     'Lesson 7: Deployment',
//     'Lesson 8: Best Practices',
//   ];
//
//   String selectedVideoId = '';
//   String? selectedLesson;
//   List<String> filteredLessons = [];
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     filteredLessons = List.from(lessonNames);
//   }
//
//   void filterLessons(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         filteredLessons = List.from(lessonNames);
//       });
//     } else {
//       setState(() {
//         filteredLessons = lessonNames
//             .where((lesson) => lesson.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       });
//       if (filteredLessons.isEmpty) {
//         setState(() {
//           filteredLessons = ['search not found'];
//         });
//       }
//     }
//   }
//
//   void updateSelectedVideo(int index) {
//     final newVideoId = videoIds[index];
//     if (newVideoId != selectedVideoId) { // Check if the new video ID is different
//       setState(() {
//         selectedVideoId = '';
//         selectedVideoId = newVideoId; // Update to the new video ID
//         print("selectedVideoId: $selectedVideoId");
//         selectedLesson = lessonNames[index]; // Highlight the selected lesson
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video Lessons'),
//       ),
//       body: Row(
//         children: [
//           // Left pane: Lesson names with search
//           Container(
//             width: 250, // Default width
//             color: Colors.grey[200],
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     controller: searchController,
//                     decoration: const InputDecoration(
//                       labelText: 'Search Lessons',
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: filterLessons,
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: filteredLessons.length,
//                     itemBuilder: (context, index) {
//                       final lessonName = filteredLessons[index];
//                       return ListTile(
//                         title: Text(
//                           lessonName,
//                           style: TextStyle(
//                             fontWeight: lessonName == selectedLesson ? FontWeight.bold : FontWeight.normal,
//                             color: lessonName == selectedLesson ? Colors.blue : Colors.black,
//                           ),
//                         ),
//                         onTap: () {
//                           if (lessonName != 'search not found') {
//                             updateSelectedVideo(index); // Update the selected video
//                           }
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Right pane: Video player
//           Expanded(
//             child: selectedVideoId.isNotEmpty
//                 ? YoutubePlayer(
//               controller: YoutubePlayerController(
//                 initialVideoId: selectedVideoId,
//                 flags: const YoutubePlayerFlags(
//                   autoPlay: false,
//                 ),
//               ),
//               bottomActions: [
//                 CurrentPosition(),
//                 ProgressBar(isExpanded: true),
//                 RemainingDuration(),
//                 FullScreenButton(),
//               ],
//             )
//                 : Center(child: const Text('Select a lesson to play video')),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
// }



// ========= show all video === original code

// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// class VideoList extends StatefulWidget {
//   final String msgToShow;
//   final String createdDate;
//   final String title;
//
//   const VideoList({Key? key, required this.msgToShow, required this.createdDate, required this.title}) : super(key: key);
//
//   @override
//   State<VideoList> createState() => _VideoListState();
// }
//
// class _VideoListState extends State<VideoList> {
//   final List<String> videoIds = [
//     'gQDByCdjUXw',
//     'iLnmTe5Q2Qw',
//     '_WoCV4c6XOE',
//     'KmzdUe0RSJo',
//     '6jZDSSZZxjQ',
//     'p2lYr3vM_1w',
//     '7QUtEmBT_-w',
//     '34_PXCzGw1M',
//   ];
//
//   final List<String> lessonNames = [
//     'Lesson 1: Introduction to Flutter',
//     'Lesson 2: State Management',
//     'Lesson 3: Building UI',
//     'Lesson 4: Networking',
//     'Lesson 5: Database Integration',
//     'Lesson 6: Advanced Flutter',
//     'Lesson 7: Deployment',
//     'Lesson 8: Best Practices',
//   ];
//
//   String selectedVideoId = '';
//   List<String> filteredLessons = [];
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     filteredLessons = List.from(lessonNames); // Initialize with all lesson names
//   }
//
//   void filterLessons(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         filteredLessons = List.from(lessonNames);
//       });
//     } else {
//       setState(() {
//         filteredLessons = lessonNames
//             .where((lesson) => lesson.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       });
//       if (filteredLessons.isEmpty) {
//         setState(() {
//           filteredLessons = ['search not found'];
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video Lessons'),
//       ),
//       body: Row(
//         children: [
//           // Left pane: Lesson names with search
//           Expanded(
//             flex: 1,
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     controller: searchController,
//                     decoration: const InputDecoration(
//                       labelText: 'Search Lessons',
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: filterLessons,
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: filteredLessons.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(filteredLessons[index]),
//                         onTap: () {
//                           if (filteredLessons[index] != 'search not found') {
//                             // Set selected video based on the index
//                             setState(() {
//                               selectedVideoId = videoIds[index]; // Ensure index matches
//                             });
//                           }
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Right pane: Video player
//           Expanded(
//             flex: 2,
//             child: selectedVideoId.isNotEmpty
//                 ? YoutubePlayer(
//               controller: YoutubePlayerController(
//                 initialVideoId: selectedVideoId,
//                 flags: const YoutubePlayerFlags(
//                   autoPlay: false,
//                 ),
//               ),
//               bottomActions: [
//                 CurrentPosition(),
//                 ProgressBar(isExpanded: true),
//                 RemainingDuration(),
//                 FullScreenButton(),
//               ],
//             )
//                 : Center(child: const Text('Select a lesson to play video')),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
// }

