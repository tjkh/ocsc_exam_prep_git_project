import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

// chatGPT writes this class
class PdfView extends StatefulWidget {
  final String title;
  final String msg;
  final String myExams;
  final String createDate;

  const PdfView({
    Key? key,
    required this.title,
    required this.msg,
    required this.myExams,
    required this.createDate,
  }) : super(key: key);

  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  File? pdfFile;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/${widget.myExams}';
      final tempFile = File(tempPath);

      if (!await tempFile.exists()) {
        ByteData data = await rootBundle.load('assets/data/${widget.myExams}');
        List<int> bytes = data.buffer.asUint8List();
        await tempFile.writeAsBytes(bytes);
      }

      setState(() {
        pdfFile = tempFile;
      });

      print("PDF loaded: ${tempFile.path}");
    } catch (e) {
      print("Error loading PDF: $e");
    }
  }

  Future<void> _onOpen(LinkableElement link) async {
    Uri thisLink = Uri.parse(link.url);
    if (await canLaunchUrl(thisLink)) {
      await launchUrl(thisLink);
    } else {
      throw 'Could not launch ${link.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.white),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              border: const Border(
                top: BorderSide(width: 1, color: Colors.white70),
              ),
            ),
            child: Linkify(
              onOpen: _onOpen,
              text: widget.msg,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14.0, color: Colors.white),
            ),
          ),
          Expanded(
            child: pdfFile != null
                ? SfPdfViewer.file(
              pdfFile!,
              key: _pdfViewerKey,
            )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_linkify/flutter_linkify.dart';
// //import 'package:ocsc_exam_prep/sqlite_db.dart';
// //import 'package:sqflite/sqflite.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:path_provider/path_provider.dart';
//
// class PdfView extends StatefulWidget {
//   final String msg;
//   final String title;
//   final String myExams;
//   final String createDate;
//
//   PdfView({
//     Key? key,
//     required this.title,
//     required this.msg,
//     required this.myExams,
//     required this.createDate,
//   }) : super(key: key);
//
//   @override
//   _PdfViewState createState() => _PdfViewState();
// }
//
// class _PdfViewState extends State<PdfView> {
//   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
//   String picName = "p100.png";
//   File? pdfFile;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadPdf();
//   }
//
//
//
//   Future<void> _loadPdf() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final filePath = File('${directory.path}/${widget.myExams}');
//
//     print("pdf directory: $directory");
//     print("pdf filePath: $filePath");
//
//     if (await filePath.exists()) {
//       setState(() {
//         pdfFile = filePath;
//       });
//     } else {
//       print("PDF file not found: ${filePath.path}");
//     }
//   }
//
//
//
//   Future<void> _onOpen(LinkableElement link) async {
//     Uri thisLink = Uri.parse(link.url);
//     if (await canLaunchUrl(thisLink)) {
//       await launchUrl(thisLink);
//     } else {
//       throw 'Could not launch ${link.url}';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("เตรียมสอบ ก.พ. ภาค ก."),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.bookmark, color: Colors.white),
//             onPressed: () {
//               _pdfViewerKey.currentState?.openBookmarkView();
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColorDark,
//               border: const Border(
//                 top: BorderSide(width: 1, color: Colors.white70),
//               ),
//             ),
//             child: Linkify(
//               onOpen: _onOpen,
//               text: widget.msg,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 14.0, color: Colors.white),
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColorDark,
//               border: const Border(
//                 top: BorderSide(width: 1, color: Colors.white70),
//               ),
//             ),
//             child: Text(
//               widget.title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 18.0,
//                 color: Colors.white54,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Expanded(
//             child: pdfFile != null
//                 ? SfPdfViewer.file(
//               pdfFile!,
//               key: _pdfViewerKey,
//             )
//                 : const Center(child: CircularProgressIndicator()),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//



//000000000000000000000000000000000000000000000
// import 'dart:async';
// import 'dart:io';
// // ไฟล์เดิม ที่ "D:\02\show pdf code.txt"
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_linkify/flutter_linkify.dart';
// import 'package:ocsc_exam_prep/sqlite_db.dart';
// import 'package:path_provider/path_provider.dart';
// // import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// // void main() {
// //   runApp(MaterialApp(
// //     home: PdfView(),
// //   ));
// // }
//
// class pdfView extends StatefulWidget {
//   late final String msg;
//   late final String title;
//   late final String myExams;
//   late final String createDate;
//
//
//   pdfView({Key? key, required this.title, required this.msg, required String this.myExams, required String this.createDate}) : super(key: key);
//
//   @override
//   initState() {
//
//     String _createDate = createDate;
//
//   }
//
//
//
//   @override
//   _pdfViewState createState() => _pdfViewState();
// }
//
// class _pdfViewState extends State<pdfView> {
//   String? pathPDF;
//   String? errorMessage;
//   int currentPage = 0;
//   bool isReady = false;
//   final PdfViewerController _pdfViewerController = PdfViewerController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadFromAsset();
//   }
//
//   @override
//   void dispose() {
//     _pdfViewerController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadFromAsset() async {
//     try {
//       var dir = await getApplicationDocumentsDirectory();
//       File file = File("${dir.path}/${widget.myExams}");
//       if (!file.existsSync()) {
//         var data = await rootBundle.load('assets/data/${widget.myExams}');
//         var bytes = data.buffer.asUint8List();
//         await file.writeAsBytes(bytes, flush: true);
//         print("PDF file copied to: ${file.path}");
//       } else {
//         print("PDF file already exists at: ${file.path}");
//       }
//
//       // Verify the file is readable
//       if (file.existsSync()) {
//         print("File size: ${await file.length()} bytes");
//         setState(() {
//           pathPDF = file.path;
//           isReady = true;
//         });
//       } else {
//         throw Exception("Failed to copy PDF file to device storage.");
//       }
//     } catch (e) {
//       print("Error loading PDF: $e");
//       setState(() {
//         errorMessage = "Error loading PDF: $e";
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (pathPDF != null && isReady) {
//       return SfPdfViewer.file(
//         File(pathPDF!),
//         controller: _pdfViewerController,
//         initialPageNumber: currentPage + 1, // SfPdfViewer uses 1-based indexing
//         onPageChanged: (details) {
//           setState(() {
//             currentPage = details.newPageNumber - 1; // Convert to 0-based indexing
//           });
//           int totalPages = _pdfViewerController.pageCount;
//           print('Page changed: ${details.newPageNumber}/$totalPages');
//         },
//         onDocumentLoaded: (details) {
//           setState(() {
//             isReady = true;
//           });
//           print("PDF document loaded successfully");
//         },
//         onDocumentLoadFailed: (details) {
//           setState(() {
//             errorMessage = "Failed to load PDF: ${details.description}";
//           });
//           print("PDF load failed: ${details.description}");
//         },
//       );
//     } else if (errorMessage != null) {
//       return Center(
//         child: Text(
//           errorMessage!,
//           style: const TextStyle(color: Colors.red, fontSize: 16),
//           textAlign: TextAlign.center,
//         ),
//       );
//     } else {
//       return const Center(child: CircularProgressIndicator());
//     }
//   }
// }



// ********************* GROK CREATED  *********************


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_linkify/flutter_linkify.dart';
// import 'package:ocsc_exam_prep/sqlite_db.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:io';
//
// // Main PdfView class with app bar, message, and title
// class PdfView extends StatefulWidget {
//   final String msg;
//   final String title;
//   final String myExams;
//   final String createDate;
//
//   const PdfView({
//     Key? key,
//     required this.title,
//     required this.msg,
//     required this.myExams,
//     required this.createDate,
//   }) : super(key: key);
//
//   @override
//   _PdfViewState createState() => _PdfViewState();
// }
//
// class _PdfViewState extends State<PdfView> {
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: true,
//       onPopInvoked: (didPop) async {
//         if (didPop) {
//           return;
//         }
//         int _currQstnNum = 10;
//         int _numOfQstn = 10;
//
//         int myProgress = (_currQstnNum / _numOfQstn * 100).round();
//         String picName = "p100.png";
//         int fileDate = int.parse(widget.createDate);
//         updateOcscTjkTbl_open_last(
//             whatFileName: widget.myExams, whereToStart: _currQstnNum.toString());
//
//         checkAndActOnIsNewOfOcscTjkTable(
//             whatFileName: widget.myExams, whatDate: fileDate);
//
//         var dbClient = await SqliteDB().db;
//
//         var queryResult = await dbClient!.rawQuery(
//             """ SELECT * FROM OcscTjkTable WHERE file_name = '${widget.myExams}'; """);
//         print("queryResult: $queryResult");
//         print("picName: $picName");
//
//         if (queryResult.isNotEmpty) {
//           updateFileCreateDate(
//               fileName: widget.myExams, createdDate: fileDate, picName: picName);
//         }
//
//         print("widget.myExams: ${widget.myExams}");
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("เตรียมสอบ ก.พ. ภาค ก."),
//         ),
//         body: Column(
//           children: [
//             Container(
//               // สำหรับแสดงข้อความจาก pastebin
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Theme.of(context).primaryColorDark,
//                 border: const Border(
//                   top: BorderSide(width: 1, color: Colors.white70),
//                 ),
//               ),
//               child: Linkify(
//                 onOpen: _onOpen,
//                 textScaleFactor: 1,
//                 text: "${widget.msg}",
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 14.0, color: Colors.white),
//                 linkStyle: const TextStyle(fontSize: 14.0, color: Colors.yellowAccent),
//                 options: const LinkifyOptions(humanize: false),
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Theme.of(context).primaryColorDark,
//                 border: const Border(
//                   top: BorderSide(width: 1, color: Colors.white70),
//                 ),
//               ),
//               child: Text(
//                 "${widget.title}",
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 18.0,
//                   color: Colors.white54,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 child: pdfView(
//                   myExams: widget.myExams,
//                   title: widget.title,
//                   createDate: widget.createDate,
//                   msg: widget.msg,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _onOpen(LinkableElement link) async {
//     print("this link: $link");
//     Uri thisLink = Uri.parse(link.url);
//     print("this link: $thisLink");
//     if (await canLaunchUrl(thisLink)) {
//       await launchUrl(thisLink);
//     } else {
//       throw 'Could not launch $link';
//     }
//   }
//
//   void updateOcscTjkTbl_open_last(
//       {String? whatFileName, String? whereToStart}) async {
//     final dbClient = await SqliteDB().db;
//     var res = await dbClient!.rawQuery('''
//     UPDATE OcscTjkTable
//     SET open_last = ?
//     WHERE file_name = ?
//     ''', ['$whereToStart', '$whatFileName']);
//   }
//
//   void checkAndActOnIsNewOfOcscTjkTable(
//       {String? whatFileName, int? whatDate}) async {
//     final dbClient = await SqliteDB().db;
//     var count = Sqflite.firstIntValue(await dbClient!.rawQuery(
//         'SELECT COUNT (*) FROM itemTable WHERE file_name = ? AND isClicked = "false" AND isNew = "1" ',
//         ["$whatFileName"]));
//     print(
//         "file: $whatFileName  count isNew before going back to MainMenu  x count xx: $count ");
//     if (count == 0) {
//       updateIsNewOfOcscTjkTable(context, whatFileName!, whatDate!);
//     } else {
//       updateIsNewOfOcscTjkTableToOne(context, whatFileName!, whatDate!);
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
//   void updateIsNewOfOcscTjkTableToOne(
//       BuildContext context, String whatFileName, int whatDate) async {
//     final dbClient = await SqliteDB().db;
//     var res = await dbClient!.rawQuery('''
//     UPDATE OcscTjkTable
//     SET isNew = ?,
//     dateCreated =?
//     WHERE file_name = ?
//     ''', [1, whatDate, '$whatFileName']);
//   }
//
//   Future updateFileCreateDate({
//     required String fileName,
//     required int createdDate,
//     required String picName,
//   }) async {
//     print("picName inside updateFile: $picName");
//     var dbClient = await SqliteDB().db;
//     var res = await dbClient!.rawQuery('''
//     UPDATE OcscTjkTable
//     SET dateCreated = ? , progress_pic_name = ?
//     WHERE file_name = ?
//     ''', [createdDate, picName, '$fileName']);
//     return res;
//   }
// }
//
// // pdfView class for rendering the PDF, updated to match the parameters
// class pdfView extends StatefulWidget {
//   final String myExams;
//   final String title;
//   final String createDate;
//   final String msg;
//
//   const pdfView({
//     Key? key,
//     required this.myExams,
//     required this.title,
//     required this.createDate,
//     required this.msg,
//   }) : super(key: key);
//
//   @override
//   _pdfViewState createState() => _pdfViewState();
// }
//
// class _pdfViewState extends State<pdfView> {
//   String? pathPDF;
//   String? errorMessage;
//   int currentPage = 0;
//   bool isReady = false;
//   final PdfViewerController _pdfViewerController = PdfViewerController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadFromAsset();
//   }
//
//   @override
//   void dispose() {
//     _pdfViewerController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadFromAsset() async {
//     try {
//       var dir = await getApplicationDocumentsDirectory();
//       File file = File("${dir.path}/${widget.myExams}");
//       if (!file.existsSync()) {
//         var data = await rootBundle.load('assets/data/${widget.myExams}');
//         var bytes = data.buffer.asUint8List();
//         await file.writeAsBytes(bytes, flush: true);
//         print("PDF file copied to: ${file.path}");
//       } else {
//         print("PDF file already exists at: ${file.path}");
//       }
//
//       // Verify the file is readable
//       if (file.existsSync()) {
//         print("File size: ${await file.length()} bytes");
//         setState(() {
//           pathPDF = file.path;
//           isReady = true;
//         });
//       } else {
//         throw Exception("Failed to copy PDF file to device storage.");
//       }
//     } catch (e) {
//       print("Error loading PDF: $e");
//       setState(() {
//         errorMessage = "Error loading PDF: $e";
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (pathPDF != null && isReady) {
//       return SfPdfViewer.file(
//         File(pathPDF!),
//         controller: _pdfViewerController,
//         initialPageNumber: currentPage + 1, // SfPdfViewer uses 1-based indexing
//         onPageChanged: (details) {
//           setState(() {
//             currentPage = details.newPageNumber - 1; // Convert to 0-based indexing
//           });
//           int totalPages = _pdfViewerController.pageCount;
//           print('Page changed: ${details.newPageNumber}/$totalPages');
//         },
//         onDocumentLoaded: (details) {
//           setState(() {
//             isReady = true;
//           });
//           print("PDF document loaded successfully");
//         },
//         onDocumentLoadFailed: (details) {
//           setState(() {
//             errorMessage = "Failed to load PDF: ${details.description}";
//           });
//           print("PDF load failed: ${details.description}");
//         },
//       );
//     } else if (errorMessage != null) {
//       return Center(
//         child: Text(
//           errorMessage!,
//           style: const TextStyle(color: Colors.red, fontSize: 16),
//           textAlign: TextAlign.center,
//         ),
//       );
//     } else {
//       return const Center(child: CircularProgressIndicator());
//     }
//   }
// }

// ************************ ORIGINAL CODE *****************************

//
// import 'dart:async';
// import 'dart:io';
// // ไฟล์เดิม ที่ "D:\02\show pdf code.txt"
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_linkify/flutter_linkify.dart';
// import 'package:ocsc_exam_prep/sqlite_db.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// // void main() {
// //   runApp(MaterialApp(
// //     home: PdfView(),
// //   ));
// // }
//
// class PdfView extends StatefulWidget {
//   late final String msg;
//   late final String title;
//   late final String myExams;
//   late final String createDate;
//
//
//   PdfView({Key? key, required this.title, required this.msg, required String this.myExams, required String this.createDate}) : super(key: key);
//
//   @override
//   initState() {
//
//     String _createDate = createDate;
//
//   }
//
//
//
//   @override
//   _PdfViewState createState() => _PdfViewState();
// }
//
// class _PdfViewState extends State<PdfView> {
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: true,
//       onPopInvoked: (didPop) async {
//         if (didPop) {
//           return;
//         }
//         int _currQstnNum = 10;
//         int _numOfQstn = 10;
//
//         int myProgress = (_currQstnNum / _numOfQstn * 100).round();
//         String picName = "p100.png";
//         int fileDate = int.parse(widget.createDate);
//         updateOcscTjkTbl_open_last(
//             whatFileName: widget.myExams, whereToStart: _currQstnNum.toString());
//
//         checkAndActOnIsNewOfOcscTjkTable(
//             whatFileName: widget.myExams, whatDate: fileDate);
//
//         var dbClient = await SqliteDB().db;
//
//         var queryResult = await dbClient!.rawQuery(
//             """ SELECT * FROM OcscTjkTable WHERE file_name = '${widget.myExams}'; """);
//         print("queryResult: $queryResult");
//         print("picName: $picName");
//
//         if (queryResult.isNotEmpty) {
//           updateFileCreateDate(
//               fileName: widget.myExams, createdDate: fileDate, picName: picName);
//         }
//
//         print("widget.myExams: ${widget.myExams}");
//       },
//
// //    return WillPopScope(  // เข้ามาแล้วออกไป ใส่เครื่องหมายถูกหน้าเมนู ให้เลย
// //
// //        onWillPop: () async {
// //           int _currQstnNum = 10;
// //           int _numOfQstn = 10;
// //
// //          int myProgress = (_currQstnNum / _numOfQstn * 100).round();
// //          String picName = "p100.png";
// //          int fileDate = int.parse(widget.createDate);
// //          updateOcscTjkTbl_open_last(
// //              whatFileName: widget.myExams, whereToStart: _currQstnNum.toString());
// //
// //          checkAndActOnIsNewOfOcscTjkTable(
// //              whatFileName: widget.myExams, whatDate: fileDate);
// //
// //           var dbClient = await SqliteDB().db;
// //
// //           var queryResult = await dbClient!.rawQuery(
// //               """ SELECT * FROM OcscTjkTable WHERE file_name = '${widget.myExams}'; """);
// //           print("queryResult: $queryResult");
// //           print("picName: $picName");
// //
// //           // ถ้ามีข้อมูลอยู่แล้ว ให้ update วันที่เป็นของไฟล์ใหม่ เพื่อเมื่อ // ไม่ใช่
// //           // เข้ามาอีกครั้ง จะไดไม่มีจุดแดงหลังชื่อในหน้าเมนู  -- อย่าลืม ต้องเชคก่อนเลย พอเข้าหน้าเมนู เพราะ
// //           // จะได้เปรียบเทียบวันที่ ของไฟล์ที่เข้ามา โดยเปรียบเทียบกับวันที่ ที่มีอยู่ในฐานช้อมูล
// //
// //           if (queryResult.isNotEmpty) {
// //             updateFileCreateDate(
// //                 fileName: widget.myExams, createdDate: fileDate, picName: picName);
// //           }
// //
// // print("widget.myExams: ${ widget.myExams}");
// //           return true;
// //        },
//
//      child: Scaffold(
//        appBar: AppBar(
//          title: Text("เตรียมสอบ ก.พ. ภาค ก."),
//        ),
//        body: Column(
//          children: [
//
//            Container( // สำหรับแสดงข้อความจาก pastebin
//              width: double.infinity,
//              decoration: BoxDecoration(
//                //  color: Colors.blue[700],
//                color: Theme
//                    .of(context)
//                    .primaryColorDark,
//                border: const Border(
//                  top: BorderSide(width: 1, color: Colors.white70),
//                ),
//                // color: Colors.white,
//              ),
//              child: Linkify( // สำหรับให้คลิกไปที่ลิงค์ได้ ถ้ามี https://
//                onOpen: _onOpen,
//                textScaleFactor: 1,
//                // text: myMessage,
//                text: "${widget.msg}",
//                textAlign: TextAlign.center,
//                style: TextStyle(fontSize: 14.0, color: Colors.white),
//                // style: TextStyle(
//                //     fontSize: 18.0,
//                //     color: Colors.white54,
//                //     fontWeight: FontWeight.bold),
//
//                linkStyle: const TextStyle( // กำหนดสีของลิงค์
//                    fontSize: 14.0, color: Colors.yellowAccent),
//                options: const LinkifyOptions(
//                    humanize:
//                    false), // ให้แสดงตัวหนังสือ https:// ด้วย ไม่งั้นจะถูกตัดออกไป
//              ),
//            ),
//
//            Container(
//              width: double.infinity,
//              decoration: BoxDecoration(
//                //  color: Colors.redAccent,
//                color: Theme.of(context).primaryColorDark,
//                border: const Border(
//                  top: BorderSide(width: 1, color: Colors.white70),
//                  //   bottom: BorderSide(width: 1, color: Colors.white),
//                ),
//              ),
//              child: Text("${widget.title}",
//                textAlign: TextAlign.center,
//                // style: TextStyle(
//                //   color: Colors.white,
//                //   fontSize: 16.0,
//                // ),
//                style: TextStyle(
//                    fontSize: 18.0,
//                    color: Colors.white54,
//                    fontWeight: FontWeight.bold),),
//            ),
//
//            Expanded(
//              child: Container(
//                child: PDFScreen(
//                  path: 'assets/data/${widget.myExams}', // ส่งไป แต่ไม่ได้ใช้
//                  fileName: '${widget.myExams}',
//                ),
//              ),
//            ),
//
//          ]
//        ),
//      ),
//    );
//   }
//
//
//   Future<void> _onOpen(LinkableElement link) async {
//     print("this link: $link");
//     // สำหรับ link ในข้อความ
//     Uri thisLink = Uri.parse(link.url); // แปลง LinkableElement เป็น Uri
//     print("this link: $thisLink");
//     if (await canLaunchUrl(thisLink)) {
//       await launchUrl(thisLink);
//     } else {
//       throw 'Could not launch $link';
//     }
//   }
//
//   void updateOcscTjkTbl_open_last(
//       {String? whatFileName, String? whereToStart}) async {
//     final dbClient = await SqliteDB().db;
//     var res = await dbClient!.rawQuery('''
//     UPDATE OcscTjkTable
//     SET open_last = ?
//     WHERE file_name = ?
//     ''', ['$whereToStart', '$whatFileName']);
//   }
//
//   void checkAndActOnIsNewOfOcscTjkTable(
//       {String? whatFileName, int? whatDate}) async {
//     final dbClient = await SqliteDB().db;
//     var count = Sqflite.firstIntValue(await dbClient!.rawQuery(
//         'SELECT COUNT (*) FROM itemTable WHERE file_name = ? AND isClicked = "false" AND isNew = "1" ',
//         ["$whatFileName"]));
//     // print("fileName x count xx: $whatFileName");
//     print(
//         "file: $whatFileName  count isNew before going back to MainMenu  x count xx: $count ");
//     if (count == 0) {
//       // เท่ากับ 0 คือไม่มี ถ้ามี ก็แสดงว่า ยังทำของใหม่ ยังไม่หมด ไม่เอาจุดแดงหน้าเมนูออก
//       //    print("x count xx: isNew ใน itemTable ไม่มี");
//       updateIsNewOfOcscTjkTable(context, whatFileName!,
//           whatDate!); // ถ้า isNew ในตาราง OcscTjkTable เท่ากับ 0 จะไม่มีจุดแดง หน้าเมนู
//     } else {
//       // ถ้ายังมี NEW อยู่ ปรับให้มีจุดแดง ในหน้า mainMenu โดยให้ isNew = 1
//       updateIsNewOfOcscTjkTableToOne(context, whatFileName!, whatDate!);
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
//   void updateIsNewOfOcscTjkTableToOne(
//       BuildContext context, String whatFileName, int whatDate) async {
//     final dbClient = await SqliteDB().db;
//     var res = await dbClient!.rawQuery('''
//     UPDATE OcscTjkTable
//     SET isNew = ?,
//     dateCreated =?
//     WHERE file_name = ?
//     ''', [1, whatDate, '$whatFileName']);
//   }
//
//
//   Future updateFileCreateDate(
//       {required String fileName,
//         required int createdDate,
//         required String picName}) async {
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
//
//
//
//
//
// }
//
//
// class PDFScreen extends StatefulWidget {
//   final String? path;  // ไม่ได้ใช้
//   final String? title;
//   final String? fileName;
//
//   PDFScreen({Key? key, this.path, this.title, this.fileName}) : super(key: key);
//
//   @override
//   _PDFScreenState createState() => _PDFScreenState();
// }
//
// class _PDFScreenState extends State<PDFScreen> {
//   final Completer<PDFViewController> _controller = Completer<PDFViewController>();
//   int? pages = 0;
//   int? currentPage = 0;
//   bool isReady = false;
//   String errorMessage = '';
//   String? pathPDF;
//   String? pdfName;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _loadFromAsset();  // load pdf file
//   }
//
//   Future<void> _loadFromAsset() async {
//     try {
//       var dir = await getApplicationDocumentsDirectory();
//       File file = File("${dir.path}/${widget.fileName}");
//       if (!file.existsSync()) {
//         var data = await rootBundle.load(widget.path!);
//         var bytes = data.buffer.asUint8List();
//         await file.writeAsBytes(bytes, flush: true);
//         print("PDF file copied to: ${file.path}");
//       } else {
//         print("PDF file already exists at: ${file.path}");
//       }
//
//       // Verify the file is readable
//       if (file.existsSync()) {
//         print("File size: ${await file.length()} bytes");
//         setState(() {
//           pathPDF = file.path;
//         });
//       } else {
//         throw Exception("Failed to copy PDF file to device storage.");
//       }
//     } catch (e) {
//       print("Error loading PDF: $e");
//       setState(() {
//         errorMessage = "Error loading PDF: $e";
//       });
//     }
//   }
//
//  //  Future<void> _loadFromAsset() async {
//  //    try {
//  //      var dir = await getApplicationDocumentsDirectory();
//  // //     File file = File("${dir.path}/goodGvnce2.pdf");
//  //      File file = File("${dir.path}/${widget.fileName}");
//  //      if (!file.existsSync()) {
//  //        var data = await rootBundle.load(widget.path!);
//  //        var bytes = data.buffer.asUint8List();
//  //        await file.writeAsBytes(bytes, flush: true);
//  //      }
//  //
//  //      print("file.path: ${file.path}");
//  //      setState(() {
//  //        pathPDF = file.path;
//  //      });
//  //    } catch (e) {
//  //      throw Exception('Error parsing asset file!');
//  //    }
//  //  }
//
//   @override
//   Widget build(BuildContext context) {
//     if (pathPDF != null) {
//       return Stack(
//         children: [
//           PDFView(
//           filePath: pathPDF!,
//           enableSwipe: true,
//           swipeHorizontal: true,
//           autoSpacing: false,
//           pageFling: true,
//           pageSnap: true,
//           defaultPage: currentPage!,
//           fitPolicy: FitPolicy.BOTH,
//           preventLinkNavigation: false,
//           onRender: (_pages) {
//             setState(() {
//               pages = _pages;
//               isReady = true;
//             });
//           },
//           onError: (error) {
//             setState(() {
//               errorMessage = error.toString();
//             });
//             print(error.toString());
//           },
//           onPageError: (page, error) {
//             setState(() {
//               errorMessage = '$page: ${error.toString()}';
//             });
//             print('$page: ${error.toString()}');
//           },
//           onViewCreated: (PDFViewController pdfViewController) {
//             _controller.complete(pdfViewController);
//           },
//           onLinkHandler: (String? uri) {
//             print('goto uri: $uri');
//           },
//           onPageChanged: (int? page, int? total) {
//             print('page change: $page/$total');
//             setState(() {
//               currentPage = page;
//             });
//
//           },
//
//         ),
//           if (errorMessage.isNotEmpty)
//             Center(
//               child: Text(
//                 errorMessage,
//                 style: TextStyle(color: Colors.red, fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//         ],
//       );
//
//     } else {
//       return const Center(child: CircularProgressIndicator());
//     }
//   }
// }
//
//
//
