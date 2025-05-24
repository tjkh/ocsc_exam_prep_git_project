










// ============================================== OLD CODE version 8.1.1

// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_linkify/flutter_linkify.dart';
// import 'package:ocsc_exam_prep/sqlite_db.dart';
// import 'package:ocsc_exam_prep/theme.dart';
// import 'package:ocsc_exam_prep/utils.dart';
// import 'package:share/share.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:provider/provider.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'dart:io'
//     show
//         Platform; // สำหรับตรวจว่า เป็น android หรือ iphone จะได้ส่งลิงค์ไปให้คะแนน ถูกเว็บ
// import 'aboutDialog.dart';
// import 'item_model.dart';
//
// // from: https://www.youtube.com/watch?v=8paqPlzigM0
// // also see  https://www.youtube.com/watch?v=tMCvxWXOpKg
//
// class YouTubePageView extends StatefulWidget {
//   final String fileName_youtube_url;
//   final String videoID;
//   final String myExams;
//   final String
//       createDate; // สำหรับวันที่ ของไฟล์ที่ส่งเข้า จะเอาไป update ในฐานข้อมูล ถ้า
//   // คลิกข้อใหม่หมดแล้ว ทุกข้อ  -- คือ ต้องคลิกข้อใหม่หมดทุกข้อ จึงเอาจุดแดงออกจากหน้าเมนู
//   final String title;
//   // final int currPageNum;
// //  final int currQstnNum;
// //  final int numOfQstn;
//   final String msg;
//   //final bool buyStatus;
//
//   YouTubePageView({
//     Key? key,
//     required this.fileName_youtube_url,
//     required this.videoID,
//     required this.myExams,
//     required  this.title,
//     //     this.currPageNum,
//     //    this.currQstnNum,
// //      this.numOfQstn,
//     required this.createDate,
//     //     this.buyStatus
//     required this.msg,
//   }) : super(key: key);
//
//   @override
//   // _PageViewCustomState createState() => _PageViewCustomState();
//   _YouTubeViewCustomState createState() => _YouTubeViewCustomState();
// // final PageController _pageController = PageController();
// }
//
// class _YouTubeViewCustomState extends State<YouTubePageView> {
//   late YoutubePlayerController _controller;
//   late TextEditingController _idController;
//   late TextEditingController _seekToController;
//
//   late PlayerState _playerState;
//   late YoutubeMetaData _videoMetaData;
//   double _volume = 100;
//   bool _muted = false;
//   bool _isPlayerReady = false;
//   bool isPlayToEnd = false; // สำหรับถ้าเล่นวิดีโอจนจบ
//   // จะให้ 100% เพื่อไปทำเครื่องหมายถูก ว่า ดูวิดีโอนี้จบแล้ว
//   late int percentPlayed; // สำหรับภาพ icon หน้าชื่อวิดีโอ ในหน้า mainMenu
//   int currPosInSec = 0; // สำหรับเมื่อกลับมาใหม่
//   // จะให้ไปที่ตำแหน่งเดิมที่ดูค้างไว้
//   final List<String> _ids = [
//     'liJVSwOiiwg', // how to find youtube id
//     'nPt8bK2gbaU',
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
//   @override
//   void initState() {
//     super.initState();
//     String videoID = widget.videoID;
//
//     _controller = YoutubePlayerController(
//       //    initialVideoId: _ids.first,
//       initialVideoId: videoID,
//       flags: const YoutubePlayerFlags(
//         mute: false,
//         autoPlay: true,
//         disableDragSeek: false,
//         loop: false,
//         isLive: false,
//         forceHD: false,
//         enableCaption: true,
//       ),
//     )..addListener(listener);
//     _idController = TextEditingController();
//     _seekToController = TextEditingController();
//     _videoMetaData = const YoutubeMetaData();
//     _playerState = PlayerState.unknown;
//   }
//
//   void listener() {
//     if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
//       setState(() {
//         _playerState = _controller.value.playerState;
//         _videoMetaData = _controller.metadata;
//       });
//     }
//   }
//
//   // @override
//   // void deactivate() {
//   //   // Pauses video while navigating to next page.
//   //   _controller.pause();
//   //   super.deactivate();
//   // }
//
//   @override
//   void dispose() {
//     // _controller.removeListener(listener);
//     _controller.dispose();
//     _idController.dispose();
//     _seekToController.dispose();
//     super.dispose();
//   }
//
//   //  List<String> items = <String>['1', '2', '3', '4', '5'];
//   // WebViewPlusController _controller;
//   // WebViewController _webViewController;
//   //String filePath = 'files/test.html';
//   // String filePath = 'assets/data/';
// //  var is_clicked;
//
//   // SharedPreferences buy_Status;
//   //bool is_Bought_Already;
//   // bool is_Bought_Already = true;
//
//   //Future<bool> getIsBought() async {
//   // จัดการเรื่อง ซื้อหรือยัง
//
//   // ต้องใช้ await เพื่อไปเอาข้อมูลจาก Future มาใส่ในตัวแปร จึงต้องเอามาฝากไว้ใน async  ที่นี่
//   // เอามาไว้ตรงนี้ เพื่อจะได้เรียกใช้ตอนแสดงผลในหน้าข้อสอบ ว่า จะมีปุ่มกดให้ซื้อ หรือไม่
//   // is_Bought_Already = await check_if_already_bought();
//   //  bool a = await check_if_already_bought();
// //    print("is_Bought_Already from Pref: $a");
//   // ถ้าเป็น false แสดงว่า ใน sharePref อาจจะว่างอยู่หรือมีค่าเป็น false
//   // ต้องเชคต่อใน ตาราง hashTable ว่า เป็น true หรือไม่ เพราะ รุ่นเก่า
//   // เก็บค่าไว้ใน pref แต่รุ่นใหม่ ตั้งแต่ รุ่น 2.0.0 เป็นต้นไป เก็บค่าการซื้อไว้ในตาราง
//   // ชิ่อ hashTable
//   //  if (is_Bought_Already == false) {
//   //  if (a == false) {
// //    bool b = await check_if_already_bought_from_hashTable();
//   //   is_Bought_Already = await check_if_already_bought_from_hashTable();
//   //   print("is_Bought_Already from hashTable : $b");
//   //  }
//   // if (a == true) {
//   //   // statement(s)
//   //   print("value of a, b: a is true, b no need to check");
//   //   return true;
//   // } else if (b == true) {
//   //   // statement(s)
//   //   print("value of a, b: a is false but b is true");
//   //   return true;
//   // } else {
//   //   print("value of a, b:  both a and b are false");
//   //   // statement(s)
//   //   return false;
//   // }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     String _myExams = widget.fileName_youtube_url;
//     String _title = widget.title;
//     String _createDate = widget.createDate;
//     String myMessage = widget.msg; // ข่าวสาร
//
// //    bool _buyStatus = widget.buyStatus;
//     //   print("_buyStatus: $_buyStatus");
//     print("FileName in Build context: $_myExams");
//
//     // ************************
//     return ChangeNotifierProvider<vData>(
//       create: (context) => vData(),
//       child: Consumer<vData>(
//         builder: (context, provider, child) => WillPopScope(
//           onWillPop: () async {
//             // print("currPosInSec--Willpop:  $currPosInSec");
//             var currPos = _controller.value.position;
//             int thisPos = currPos.inSeconds;
//             print("thisPos in Willpop: $thisPos");
//             var videoLength = _controller.metadata.duration;
//             int duration = videoLength.inSeconds;
//             print("videoLength (duration): $duration");
//
//             percentPlayed = ((thisPos / duration) * 100).round();
//             if (percentPlayed == 0 && isPlayToEnd == true) {
//               percentPlayed = 100;
//             }
//             print("percent played: $percentPlayed");
//
//             // int thisPos =
//             //     Provider.of<vData>(context, listen: false).currPosition;
//             print("ชื่อไฟล์ ใน Willpopscope   $_myExams");
//             print("วันที่ : $_createDate");
//
//             print(" percentPlayed -willpop : $percentPlayed");
//             String picName = "p$percentPlayed.png";
//             // thisPos = 10; // ผิดตรง thisPos --- null
//             print("picName : $picName");
//             if (percentPlayed >= 100) {
//               picName = "p100.png";
//             } else if (percentPlayed >= 90) {
//               picName = "p90.png";
//             } else if (percentPlayed >= 80) {
//               picName = "p80.png";
//             } else if (percentPlayed >= 70) {
//               picName = "p70.png";
//             } else if (percentPlayed >= 60) {
//               picName = "p60.png";
//             } else if (percentPlayed >= 50) {
//               picName = "p50.png";
//             } else if (percentPlayed >= 40) {
//               picName = "p40.png";
//             } else if (percentPlayed >= 30) {
//               picName = "p30.png";
//             } else if (percentPlayed >= 20) {
//               picName = "p20.png";
//             } else if (percentPlayed >= 0) {
//               picName = "p10.png";
//             } else {
//               picName = "p00.png";
//             }
//             print("aaxx picName - Willpop: $picName");
//             print("aaxx file name - Willpop: $_myExams");
//             print("aaxx currentPos - Willpop: ${thisPos.toString()}");
//             print("aaxx uTube Duration - Willpop: $duration");
//
//             int fileDate = int.parse(_createDate);
//
//             // ตรวจดู   isNew โดยการนับ ถ้าเป็น 0 แสดงว่า ดูหมดแล้ว อัพเดท isNew และ วันที่ด้วย หรือไม่งั้น(ยังทำของใหม่ ยังไม่หมด)ก็ ไม่ทำอะไร
//             checkAndActOnIsNewOfOcscTjkTable(
//                 whatFileName: _myExams, whatDate: fileDate);
//
//             var dbClient = await SqliteDB().db;
//
//             var queryResult = await dbClient?.rawQuery(
//                 """ SELECT * FROM OcscTjkTable WHERE file_name = '$_myExams'; """);
//             print("queryResult: $queryResult");
//             print("picName: $picName");
//
//             // ถ้ามีข้อมูลอยู่แล้ว ให้ update วันที่เป็นของไฟล์ใหม่ เพื่อเมื่อ // ไม่ใช่
//             // เข้ามาอีกครั้ง จะไดไม่มีจุดแดงหลังชื่อในหน้าเมนู  -- อย่าลืม ต้องเชคก่อนเลย พอเข้าหน้าเมนู เพราะ
//             // จะได้เปรียบเทียบวันที่ ของไฟล์ที่เข้ามา โดยเปรียบเทียบกับวันที่ ที่มีอยู่ในฐานช้อมูล
//
//             if (queryResult!.isNotEmpty) {
//               updateFileCreateDate(
//                   fileName: _myExams, createdDate: fileDate, picName: picName);
//             }
//
//             // update ข้อมูลในตาราง OcscTjkTable เพื่อว่า เวลาทำหน้าเมนู จะได้มีไอคอนความก้าวหน้า และ เวลาเปิดใหม่ จะได้ไปที่ข้อที่ทำค้างไว้ (ถ้ามี)
//             String currentPos = thisPos.toString();
//             print("currentPos to send to DB: $currentPos");
//             updateOcscTjkTbl_html(
//                 fileName: _myExams,
//                 whereToStart: currentPos,
//                 iconName: picName);
//
//             // queryResult.isNotEmpty   // ไม่ต้องเพิ่ม เพราะเพิ่มแล้ว ใน main.dart
//             //     ? updateFileCreateDate(
//             //         fileName: _myExams, createdDate: fileDate, picName: picName)
//             //     : insertFileCreateDateOcscTjkTable(
//             //         fileName: _myExams, thisDate: fileDate);
//             return true;
//           },
//           child: YoutubePlayerBuilder(
//             onExitFullScreen: () {
//               // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
//               SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//             },
//             player: YoutubePlayer(
//               controller: _controller,
//               showVideoProgressIndicator: true,
//               progressIndicatorColor: Colors.blueAccent,
//               topActions: <Widget>[
//                 const SizedBox(width: 8.0),
//                 Expanded(
//                   child: Text(
//                     _controller.metadata.title,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18.0,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.settings,
//                     color: Colors.white,
//                     size: 25.0,
//                   ),
//                   onPressed: () {
//                     log('Settings Tapped!');
//                   },
//                 ),
//               ],
//               // onReady: () {
//               //   _isPlayerReady = true;
//               //   getWhereToStart(whatFileName: widget.myExams);
//               // },
//               onEnded: (data) {
//                 // _controller.seekTo(Duration(seconds: 1));  // ให้เริ่มที่ตรงไหน
//                 // var videoLength = _controller.metadata.duration;
//                 // print("videoLength: $videoLength");
//                 // var currPos = _controller.value.position;
//                 // print("currPos: $currPos");
//                 isPlayToEnd = true;
//                 _controller.seekTo(Duration.zero);
//                 _controller.pause();
//                 setState(() {});
//               },
//             ),
//             builder: (context, player) => Scaffold(
//               appBar: AppBar(
//                 title: Text(
//                   'เตรียมสอบ ก.พ. ภาค ก.',
//                   //  style: TextStyle(color: Colors.white),
//                 ),
//                 centerTitle: true,
//                 elevation: 0,
//                 actions: [
//                   PopupMenuButton(
//                       onSelected: (selectedValue) {
//                         //print(selectedValue);
//                         handleClick(selectedValue);
//                       },
//                       itemBuilder: (BuildContext ctx) => [
//                             // PopupMenuItem(
//                             //     child: Text('ส่งเมลถึงผู้เขียน'),
//                             //     value: 'sendMyMail'),
//                             PopupMenuItem(
//                                 child: Text('ให้คะแนน App นี้'), value: 'vote'),
//                             PopupMenuItem(
//                                 child: Text('แชร์กับเพื่อน'), value: 'share'),
//                             PopupMenuItem(
//                                 child: Text(
//                                     'ส่งอีเมล ติชม เสนอแนะ หรือแจ้งข้อผิดพลาด'),
//                                 value: 'sendMyMail'),
//                             PopupMenuItem(
//                                 child: Text('เกี่ยวกับ'), value: 'about'),
//                           ])
//                 ],
//               ),
//               body: ListView(
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       //color: Colors.blue[700],
//                       color: Theme.of(context).primaryColorDark,
//                       border: Border(
//                         top: BorderSide(width: 1, color: Colors.white70),
//                       ),
//                       // color: Colors.white,
//                     ),
//                     child: Linkify(
//                       onOpen: _onOpen,
//                       textScaleFactor: 1,
//                       text: myMessage,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 14.0, color: Colors.white),
//                       linkStyle:
//                           TextStyle(fontSize: 14.0, color: Colors.yellowAccent),
//                       options: LinkifyOptions(
//                           humanize:
//                               false), // ให้แสดงตัวหนังสือ https:// ด้วย ไม่งั้นจะถูกตัดออกไป
//                     ),
//                   ),
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).primaryColorDark,
//                       // color: Colors.blue[400],
//                       border: Border(
//                         top: BorderSide(width: 1, color: Colors.white70),
//                         //  bottom: BorderSide(width: 1, color: Colors.white),
//                       ),
//                     ),
//                     child: Text(
//                       "$_title",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.blue[100],
//                       border: Border(
//                         top: BorderSide(width: 1, color: Colors.white70),
//                         bottom: BorderSide(width: 1, color: Colors.black45),
//                       ),
//                     ),
//                     // หน้า youtube ไม่ให้แสดงปุ่ม กดซื้อรุ่นเต็ม
//                     //child: (is_Bought_Already) != null  // ไม่เอา เอาจาก mainMenu ดีกว่า
//                     // child: (_buyStatus) ==
//                     //         true // buyStatus เอาจาก mainMenu จาก provider
//                     //     ? SizedBox.shrink()
//                     //     : SizedBox(
//                     //         height: 40,
//                     //         width: 120,
//                     //         child: TextButton(
//                     //           child: Text('กดซื้อรุ่นเต็ม'),
//                     //           onPressed: () {
//                     //             //print('Pressed');
//                     //             Navigator.push(
//                     //               context,
//                     //               MaterialPageRoute(
//                     //                   builder: (context) => PaymentScreen()),
//                     //             );
//                     //           },
//                     //         ),
//                     //       ),
//                   ),
//                   player,
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         _space,
//                         Text(
//                           "ถ้าต้องการไปหน้า YouTube เพื่อ ดาวน์โหลดเอกสาร(ถ้ามี) หรือ กด LIKE กด Share กดติดตาม สมัครเรียน ซื้อเอกสาร หรืออื่น ๆ ให้แตะยาวคัดลอก Video Id ไปค้นหาบน YouTube หรือ Browser นะครับ",
//                           style: TextStyle(
//                             fontSize: 14.0,
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                         _space,
//                         _text('Title', _videoMetaData.title),
//                         _space,
//                         _text('Channel', _videoMetaData.author),
//                         _space,
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           //     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           //     verticalDirection: VerticalDirection.up,
//                           //     textBaseline: TextBaseline.alphabetic,
//                           //     textDirection: TextDirection.ltr,
//                           //     mainAxisSize: MainAxisSize.max,
//                           children: <Widget>[
//                             Text(
//                               "Video Id:  ",
//                               style: TextStyle(
//                                   fontSize: 14.0,
//                                   color: Colors.blueAccent,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Expanded(
//                               child: SelectableText(
//                                 _videoMetaData.videoId,
//                                 style: TextStyle(
//                                   fontSize: 14.0,
//                                   color: Colors.blueAccent,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         //  _text('Video Id', _videoMetaData.videoId),
//                         _space,
//                         Row(
//                           children: [
//                             Expanded(
//                               child: _text(
//                                 'Playback Quality',
//                                 _controller.value.playbackQuality ?? '',
//                               ),
//                             ),
//                             const Spacer(),
//                             _text(
//                               'Playback Rate',
//                               '${_controller.value.playbackRate}x  ',
//                             ),
//                           ],
//                         ),
//                         // _space,
//                         // TextField(
//                         //   enabled: _isPlayerReady,
//                         //   controller: _idController,
//                         //   decoration: InputDecoration(
//                         //     border: InputBorder.none,
//                         //     hintText: 'Enter youtube \<video id\> or \<link\>',
//                         //     fillColor: Colors.blueAccent.withAlpha(20),
//                         //     filled: true,
//                         //     hintStyle: const TextStyle(
//                         //       fontWeight: FontWeight.w300,
//                         //       color: Colors.blueAccent,
//                         //     ),
//                         //     suffixIcon: IconButton(
//                         //       icon: const Icon(Icons.clear),
//                         //       onPressed: () => _idController.clear(),
//                         //     ),
//                         //   ),
//                         // ),
//                         // //   _space,
//                         // Row(
//                         //   children: [
//                         //     _loadCueButton('LOAD'),
//                         //     const SizedBox(width: 10.0),
//                         //     _loadCueButton('CUE'),
//                         //   ],
//                         // ),
//                         _space,
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             // IconButton(
//                             //   icon: const Icon(Icons.skip_previous),
//                             //   onPressed: _isPlayerReady
//                             //       ? () => _controller.load(_ids[
//                             //           (_ids.indexOf(_controller.metadata.videoId) -
//                             //                   1) %
//                             //               _ids.length])
//                             //       : null,
//                             // ),
//                             IconButton(
//                               icon: Icon(
//                                 _controller.value.isPlaying
//                                     ? Icons.pause
//                                     : Icons.play_arrow,
//                               ),
//                               onPressed: _isPlayerReady
//                                   ? () {
//                                       _controller.value.isPlaying
//                                           ? _controller.pause()
//                                           : _controller.play();
//                                       setState(() {});
//                                     }
//                                   : null,
//                             ),
//                             IconButton(
//                               icon: Icon(
//                                   _muted ? Icons.volume_off : Icons.volume_up),
//                               onPressed: _isPlayerReady
//                                   ? () {
//                                       _muted
//                                           ? _controller.unMute()
//                                           : _controller.mute();
//                                       setState(() {
//                                         _muted = !_muted;
//                                       });
//                                     }
//                                   : null,
//                             ),
//                             // FullScreenButton(
//                             //   controller: _controller,
//                             //   color: Colors.blueAccent,
//                             // ),
//                             // IconButton(
//                             //   icon: const Icon(Icons.skip_next),
//                             //   onPressed: _isPlayerReady
//                             //       ? () => _controller.load(_ids[
//                             //           (_ids.indexOf(_controller.metadata.videoId) +
//                             //                   1) %
//                             //               _ids.length])
//                             //       : null,
//                             // ),
//                           ],
//                         ),
//                         _space,
//                         Row(
//                           children: <Widget>[
//                             const Text(
//                               "Volume",
//                               style: TextStyle(fontWeight: FontWeight.w300),
//                             ),
//                             Expanded(
//                               child: Slider(
//                                 inactiveColor: Colors.transparent,
//                                 value: _volume,
//                                 min: 0.0,
//                                 max: 100.0,
//                                 divisions: 10,
//                                 label: '${(_volume).round()}',
//                                 onChanged: _isPlayerReady
//                                     ? (value) {
//                                         setState(() {
//                                           _volume = value;
//                                         });
//                                         _controller.setVolume(_volume.round());
//                                       }
//                                     : null,
//                               ),
//                             ),
//                           ],
//                         ),
//                         _space,
//                         AnimatedContainer(
//                           duration: const Duration(milliseconds: 800),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20.0),
//                             color: _getStateColor(_playerState),
//                           ),
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             _playerState.toString(),
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w300,
//                               color: Colors.white,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> handleClick(String value) async {
//     switch (value) {
//       case 'sendMyMail':
//         final Uri params = Uri(
//           scheme: 'mailto',
//           path: 'thongjoon@gmail.com',
//           query:
//               'subject=หัวข้อเรื่อง (โปรดระบุ)&body=สวัสดีครับ/ค่ะ', //add subject and body here
//         );
//
//         var url = params;
//         if (canLaunchUrl(url) != null) {
//           await launchUrl(url);
//         } else {
//           throw 'Could not launch $url';
//         }
//         // Utils.openEmail(
//         //   toEmail: 'thongjoon@gmail.com',
//         //   subject: 'แอพเตรียมสอบ กพ',
//         //   body: 'สวัสดีครับ/ค่ะ',
//         // );
//         break;
//       case 'vote':
//         if (Platform.isAndroid) {
//           Utils.openLink(
//               url:
//                   'https://play.google.com/store/apps/details?id=com.thongjoon.ocsc_exam_prep');
//         } else if (Platform.isIOS) {
//           // iOS-specific code
//           Utils.openLink(
//               url:
//                   'https://apps.apple.com/app/เตร-ยมสอบ-กพ-ภาค-ก/id1622156979');
//         }
//
//         break;
//       case 'share':
//         Share.share(
//             "แนะนำ แอพเตรียมสอบ กพ ใช้ได้ทั้ง Android และ iPhone ดาวโหลดที่ Play Store และ App Store");
//         break;
//       case 'about':
//         openAboutDialog();
//         break;
//     }
//   }
//
//   void openAboutDialog() {
//     Navigator.of(context).push(new MaterialPageRoute<Null>(
//         builder: (BuildContext context) {
//           return new aboutDialog();
//         },
//         fullscreenDialog: true));
//   }
//
//   Widget _text(String title, String value) {
//     return RichText(
//       text: TextSpan(
//         text: '$title : ',
//         style: const TextStyle(
//           color: Colors.blueAccent,
//           fontWeight: FontWeight.bold,
//         ),
//         children: [
//           TextSpan(
//             text: value,
//             style: const TextStyle(
//               color: Colors.blueAccent,
//               fontWeight: FontWeight.w300,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color? _getStateColor(PlayerState state) {
//     switch (state) {
//       case PlayerState.unknown:
//         return Colors.grey[700];
//       case PlayerState.unStarted:
//         return Colors.pink;
//       case PlayerState.ended:
//         return Colors.red;
//       case PlayerState.playing:
//         return Colors.blueAccent;
//       case PlayerState.paused:
//         return Colors.orange;
//       case PlayerState.buffering:
//         return Colors.yellow;
//       case PlayerState.cued:
//         return Colors.blue[900];
//       default:
//         return Colors.blue;
//     }
//   }
//
//   Widget get _space => const SizedBox(height: 10);
//
//   Widget _loadCueButton(String action) {
//     return Expanded(
//       child: MaterialButton(
//         color: Colors.blueAccent,
//         onPressed: _isPlayerReady
//             ? () {
//                 if (_idController.text.isNotEmpty) {
//                   var id = YoutubePlayer.convertUrlToId(
//                         _idController.text,
//                       ) ??
//                       '';
//                   if (action == 'LOAD') _controller.load(id);
//                   if (action == 'CUE') _controller.cue(id);
//                   FocusScope.of(context).requestFocus(FocusNode());
//                 } else {
//                   _showSnackBar('Source can\'t be empty!');
//                 }
//               }
//             : null,
//         disabledColor: Colors.grey,
//         disabledTextColor: Colors.black,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 14.0),
//           child: Text(
//             action,
//             style: const TextStyle(
//               fontSize: 18.0,
//               color: Colors.white,
//               fontWeight: FontWeight.w300,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }
//
//   void checkAndActOnIsNewOfOcscTjkTable(
//       {required String whatFileName, required int whatDate}) async {
//     final dbClient = await SqliteDB().db;
//     var count = Sqflite.firstIntValue(await dbClient!.rawQuery(
//         'SELECT COUNT (*) FROM itemTable WHERE file_name = ? AND isNew = "1" ',
//         ["$whatFileName"]));
//     // print("fileName x count xx: $whatFileName");
//     // print("x count xx: $count");
//     if (count == 0) {
//       // เท่ากับ 0 คือไม่มี ถ้ามี ก็แสดงว่า ยังทำของใหม่ ยังไม่หมด ไม่เอาจุดแดงหน้าเมนูออก
//       //    print("x count xx: isNew ใน itemTable ไม่มี");
//       updateIsNewOfOcscTjkTable(context, whatFileName,
//           whatDate); // ถ้า isNew ในตาราง OcscTjkTable เท่ากับ 0 จะไม่มีจุดแดง หน้าเมนู
//     }
//   }
//
//   void updateIsNewOfOcscTjkTable(
//       BuildContext context, String whatFileName, int whatDate) async {
//     final dbClient = await SqliteDB().db;
//     var res = await dbClient!.rawQuery('''
//     UPDATE OcscTjkTable
//     SET isNew = ?,
//     dateCreated =?
//     WHERE file_name = ?
//     ''', [0, whatDate, '$whatFileName']);
//   }
//
//   Future updateFileCreateDate(
//       {required String fileName, required int createdDate, required String picName}) async {
//     print("picName inside updateFile: $picName");
//     var dbClient = await SqliteDB().db;
//     var res = await dbClient!.rawQuery('''
//     UPDATE OcscTjkTable
//     SET dateCreated = ? , progress_pic_name = ?
//     WHERE file_name = ?
//     ''', [createdDate, picName, '$fileName']);
//
//     // print("res: $res");
//     return res;
//   }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontWeight: FontWeight.w300,
//             fontSize: 16.0,
//           ),
//         ),
//         backgroundColor: Colors.blueAccent,
//         behavior: SnackBarBehavior.floating,
//         elevation: 1.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(50.0),
//         ),
//       ),
//     );
//   }
//
//   // void sendToProvider({int seconds}) {
//   //   Provider.of<vData>(context, listen: false).newPosition(seconds);
//   // }
//
//   // void updateOcscTjkTbl_html({String fileName, whereToStart, String iconName}) {}
//   void updateOcscTjkTbl_html(
//       {required String fileName, required String whereToStart, required String iconName}) async {
//     // ปรับ isNew ให้เป็น 0 ด้วย คือเอาจุดแดงในหน้าเมนูออกไป เพราะเข้ามาแล้ว จึงไม่ใหม่
//     final dbClient = await SqliteDB().db;
//     var res = await dbClient!.rawQuery('''
//     UPDATE OcscTjkTable
//     SET progress_pic_name = ?,  isNew = ?, open_last = ?
//     WHERE file_name = ?
//     ''', ['$iconName', 0, '$whereToStart', '$fileName']);
//   }
//
//   // void getWhereToStart({String whatFileName}) {}
//   // void getWhereToStart({required String whatFileName}) async {
//   //   print("file name for open last: $whatFileName");
//   //   final dbClient = await SqliteDB().db;
//   //   var res = await dbClient!.rawQuery('''
//   //   SELECT open_last FROM OcscTjkTable
//   //   WHERE file_name = ?
//   //   ''', ['$whatFileName']);
//   //   // print("whereToStart in future2: ${res[0]['open_last']}");
//   //   // print("whereToStart in future3: $whatFileName");
//   //   // print("whereToStart in future4: ${ExamModel.fromMap(res.first)}");
//   //   //  _pageController = PageController(initialPage: res[0]['open_last']);
//   //   if (res != null) {
//   //     // ถ้าไม่มี จะไม่ส่งค่าไป _pageController จะใช้ค่าเดิม คือเริ่มที่ หน้แรก ของ pageview ซึ่งก็คือ ข้อ 1
//   //     String thisLabel = res[0]['open_last'];
//   //     // บังเอิญตอนแรก เก็บข้อสุดท้ายไว้ในฐานข้อมูล (ใน main.dart) เป็นชื่อ tbl_q ต่อด้วยเลข ต่อมาเปลียนใหม่ เอาแต่ตวเลข
//   //     // ก็เลย ต้องจัดการดึงเอาแต่ตัวเลขออกมา ก่อนที่จะนำไป parse จาก ตัวอักษร(ข้อมูลในฐานข้อมูลเก็บเป็นลักษณะ ตัวอักษร) เป็นตัวเลข ไม่งั้น Error
//   //     String numToStart = "0";
//   //     if (thisLabel.contains("tbl_q")) {
//   //       numToStart = thisLabel.substring(5, thisLabel.length);
//   //     } else {
//   //       numToStart = thisLabel;
//   //     }
//   //     print("numToStart - string from database: $thisLabel");
//   //     print("numToStart - string: $numToStart");
//   //     int thisNum = int.parse(numToStart) - 1;
//   //     _controller.seekTo(Duration(seconds: thisNum));
//   //     print("seekTo:  $thisNum");
//   //     // int thisNum = int.parse(res[0]['open_last']) -
//   //     //     1; // ในฐานข้อมูล เป็น String เลยต้องเปลี่ยนเป็น int
//   //     // ถ้าไม่ ลบ 1 จะไปเปิดหน้าต่อไป จากหน้าที่แล้ว ก็เลย ลบออก 1 เพื่อว่า ออกจากหน้าไหน เวลาเข้ามาใหม่ ให้กลับไปที่หน้าเดิม
//   //     // _pageController =
//   //     //     PageController(initialPage: thisNum); // ให้ไปเปิดหน้าที่ระบุ
//   //
//   //     //    return thisNum;
//   //   }
//   //
//   //   //  return res[0]['open_last'];
//   //   // return ExamModel.fromMap(res.first['open_last']);
//   // }
// }
//
// // *****************************
//
// Future<void> _onOpen(LinkableElement link) async {
//   // สำหรับ link ในข้อความ
//   Uri thisLink = Uri.parse(link.url);
//   if (await canLaunchUrl(thisLink)) {
//     await launchUrl(thisLink);
//   } else {
//     throw 'Could not launch $link';
//   }
// }
//
// class vData extends ChangeNotifier {
//   // สำหรับ รับค่ามาจาก วิดีโอ onEnded() แล้วส่งต่อ เช่น ส่งไป Willpopscope เพื่อ เมื่อคลิกแล้วส่งข้อมูลไปหน้าเมนู สำหรับแสดงว่า ทำไปมากน้อย กี่ข้อ
//   int currPosition =
//       50; //ส่งไปได้ แต่รับเข้ามาจาก dispose ยังไม่ได้ error เลยกำหนดเป็นดัมมี่ไว้ก่อนที่ ครึ่งหนึ่ง
//   void newPosition(int newNum) {
//     currPosition = newNum;
//     print("currPos in vData: $currPosition");
//     notifyListeners();
//   }
// }
