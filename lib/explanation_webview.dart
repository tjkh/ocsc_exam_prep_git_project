// // from https://github.com/shah-xad/flutter_tex/blob/master/example/lib/tex_view_image_video_example.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_tex/flutter_tex.dart';
//
// class ExplanationWebView extends StatelessWidget {
//   final TeXViewRenderingEngine renderingEngine;
// //  final WebViewPlusController _controller;
//   ExplanationWebView(
//       {Key?
//           key, // ทำให้ Key เป็น non-null คือ เป็น null ได้ เวลาเรียกใช้งาน จะได้ไม่ต้องใส่ key มาด้วย
//       required this.itmNum,
//       required this.total,
//       required this.expltn,
//       required this.isDarkMode,
//       this.renderingEngine = const TeXViewRenderingEngine.katex()})
//       : super(key: key);
//
//   final int itmNum;
//   final int total;
//   final String expltn; // ข้อความคำอธิบายที่ส่งเข้ามา ถ้ามีภาพ
//   // จะอยู่ระหว่างคำว่า texPic.....texPic&lt;br&gt;&lt;/br&gt;&lt;br&gt;&lt;/br&gt;&lt;br&gt;&lt;/br&gt;&lt;br&gt;&lt;/br&gt;&lt;br&gt;&lt;/br&gt;
//   // ที่ต้องมีขึ้นบรรทัดใหม่ต่อท้าย เพราะไม่งั้นภาพถูกตัดเหลือครึ่งเดียว
//   final bool isDarkMode;
//   String expltn_tex = ""; // สำหรับข้อความ คำอธิบาย
//   String? expltn_picName; // สำหรับ ชื่อไฟล์ภาพของข้อนี้ ถ้ามีส่งมาด้วย
//   bool isPic = false; // สำหรับเชคว่า ข้อนี้ มีรูปภาพมาหรือไม่ จะได้เอาไปแสดง
//   List<String> expltnArr = [];
//   String? emptySpace;
//   @override
//   Widget build(BuildContext context) {
//     if (expltn.contains("texPic")) {
//       expltnArr = expltn.split("texPic");
//       // var expltnArr = expltn.split('texPic');
//       // expltn_tex = expltnArr[0];
//       // expltn_picName = expltnArr[1];
//       final expltn_tex = expltnArr[0];
//       final expltn_picName = expltnArr[1];
//       emptySpace = expltnArr[2];
//
//       isPic = true;
//     } else {
//       expltn_tex = expltn;
//       isPic = false;
//     }
//     return SafeArea(
//         minimum: const EdgeInsets.all(1.0),
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text('เตรียมสอบ ก.พ. ภาค ก.'),
//           ),
//           body: Column(children: [
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.blue[400],
//                 border: Border(
//                   top: BorderSide(width: 1, color: Colors.white70),
//                   bottom: BorderSide(width: 1, color: Colors.white),
//                 ),
//               ),
//               child: Text(
//                 "คำอธิบาย ข้อ $itmNum/$total",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18.0,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: TeXView(
//                 renderingEngine: renderingEngine,
//                 style: !isDarkMode
//                     ? TeXViewStyle(
//                         fontStyle: TeXViewFontStyle(
//                             fontSize: 15, sizeUnit: TeXViewSizeUnit.pt),
//                         padding: const TeXViewPadding.all(10),
//                         contentColor: Colors.black,
//                         // backgroundColor:
//                         //     Color(0xFFFFFF), // Black = 0x000000
//                         //    borderRadius: const TeXViewBorderRadius.all(10),
//                         //  textAlign: TeXViewTextAlign.center,
//                         //   width: 250,
//                         margin: const TeXViewMargin.zeroAuto())
//                     : TeXViewStyle(
//                         fontStyle: TeXViewFontStyle(
//                             fontSize: 15, sizeUnit: TeXViewSizeUnit.pt),
//                         padding: const TeXViewPadding.all(10),
//                         contentColor: Colors.white,
//                         // backgroundColor:
//                         //     Color(0xFFFFFF), // Black = 0x000000
//                         //    borderRadius: const TeXViewBorderRadius.all(10),
//                         //  textAlign: TeXViewTextAlign.center,
//                         //   width: 250,
//                         margin: const TeXViewMargin.zeroAuto()),
//                 // child: TeXViewColumn(
//                 //     style: !isDarkMode
//                 //         ? TeXViewStyle(
//                 //             fontStyle: TeXViewFontStyle(
//                 //                 fontSize: 15, sizeUnit: TeXViewSizeUnit.pt),
//                 //             padding: const TeXViewPadding.all(10),
//                 //             contentColor: Colors.black,
//                 //             // backgroundColor:
//                 //             //     Color(0xFFFFFF), // Black = 0x000000
//                 //             //    borderRadius: const TeXViewBorderRadius.all(10),
//                 //             //  textAlign: TeXViewTextAlign.center,
//                 //             //   width: 250,
//                 //             margin: const TeXViewMargin.zeroAuto())
//                 //         : TeXViewStyle(
//                 //             fontStyle: TeXViewFontStyle(
//                 //                 fontSize: 15, sizeUnit: TeXViewSizeUnit.pt),
//                 //             padding: const TeXViewPadding.all(10),
//                 //             contentColor: Colors.white,
//                 //             // backgroundColor:
//                 //             //     Color(0xFFFFFF), // Black = 0x000000
//                 //             //    borderRadius: const TeXViewBorderRadius.all(10),
//                 //             //  textAlign: TeXViewTextAlign.center,
//                 //             //   width: 250,
//                 //             margin: const TeXViewMargin.zeroAuto()),
//                 //     children: [
//                 //       TeXViewDocument(expltn_tex),
//                 //       //  TeXViewDocument('Image Loaded From Assets'),
//                 //       if (isPic) // ถ้ามีภาพส่งมาด้วย
//                 //         ...[
//                 //         TeXViewContainer(
//                 //           child: TeXViewImage.asset(
//                 //               "assets/data/images/$expltn_picName"),
//                 //           style: TeXViewStyle(
//                 //             margin: TeXViewMargin.all(10),
//                 //             borderRadius: TeXViewBorderRadius.all(20),
//                 //           ),
//                 //         ),
//                 //       ],
//                 //       //   TeXViewDocument('Video loaded form Youtube link'),
//                 //       //   TeXViewVideo.youtube(
//                 //       //       "https://www.youtube.com/watch?v=YiNbVEXV_NM&lc=Ugyg4ljzrK0D6YfrO854AaABAg"),
//                 //       //        ]))
//                 //     ]),
//
//                 // start pasting here
//
//                 child: TeXViewColumn(children: [
//                   TeXViewDocument(expltn_tex),
//                   // TeXViewDocument(
//                   //     r"""<h2>Flutter \( \rm\\TeX \) Image Example</h2>""",
//                   //     style: TeXViewStyle(textAlign: TeXViewTextAlign.center)),
//
//                   if (isPic) // ถ้ามีภาพส่งมาด้วย
//                     ...[
//                     TeXViewContainer(
//                       child: TeXViewImage.asset(
//                           "assets/data/images/$expltn_picName"),
//                       style: TeXViewStyle(
//                         margin: TeXViewMargin.all(10),
//                         borderRadius: TeXViewBorderRadius.all(20),
//                       ),
//                     ),
//                     TeXViewDocument("$emptySpace"),
//                   ],
//
//                   // TeXViewDocument('Image Loaded From Assets'),
//                   // TeXViewContainer(
//                   //   child: TeXViewImage.asset(
//                   //       'assets/data/images/nbr_9183664104159.png'),
//                   //   style: TeXViewStyle(
//                   //     margin: TeXViewMargin.all(10),
//                   //     borderRadius: TeXViewBorderRadius.all(20),
//                   //   ),
//                   // ),
//                   // if (isPic) // ถ้ามีภาพส่งมาด้วย
//                   //   ...[
//                   //   TeXViewContainer(
//                   //     child: TeXViewImage.asset(
//                   //         "assets/data/images/nbr_9183664104159.png"),
//                   //     style: TeXViewStyle(
//                   //       margin: TeXViewMargin.all(10),
//                   //       borderRadius: TeXViewBorderRadius.all(20),
//                   //     ),
//                   //   ),
//                   // ],
//                   // TeXViewDocument('Video loaded form Youtube link'),
//                   // TeXViewVideo.youtube(
//                   //     "https://www.youtube.com/watch?v=YiNbVEXV_NM&lc=Ugyg4ljzrK0D6YfrO854AaABAg"),
//                   // TeXViewDocument(
//                   //     'Image Loaded From Network, this may take some time according to your network speed'),
//                   // TeXViewContainer(
//                   //   child: TeXViewImage.network(
//                   //       'https://raw.githubusercontent.com/shah-xad/flutter_tex/master/example/assets/flutter_tex_banner.png'),
//                   //   style: TeXViewStyle(
//                   //     margin: TeXViewMargin.all(10),
//                   //     borderRadius: TeXViewBorderRadius.all(20),
//                   //   ),
//                   // ),
//                   // TeXViewContainer(
//                   //   child: TeXViewImage.asset(
//                   //       'assets/data/images/nbr_9183664104159.png'),
//                   //   style: TeXViewStyle(
//                   //     margin: TeXViewMargin.all(10),
//                   //     borderRadius: TeXViewBorderRadius.all(20),
//                   //   ),
//                   // ),
//                 ]),
//               ), //end TeXView here
//             ),
//             //       Text("afdlkjasdfk asfdf f"),
//           ]),
//         ));
//   }
// }
