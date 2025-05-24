import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
//import 'package:flutter_html_math/flutter_html_math.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:google_fonts/google_fonts.dart';

class Explanation extends StatelessWidget {
  Explanation(
      {Key? key,
      required this.itmNum,
      required this.total,
      required this.expltn})
      : super(key: key);

  final int itmNum;
  final int total;
  final String expltn;

  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     minimum: const EdgeInsets.all(1.0),
  //     child: Scaffold(
  //       appBar: AppBar(
  //         title: Text('เตรียมสอบ ก.พ. ภาค ก.'),
  //       ),
  //       body: Column(
  //         children: [
  //           Container(
  //             width: double.infinity,
  //             decoration: BoxDecoration(
  //               color: Colors.blue[400],
  //               border: Border(
  //                 top: BorderSide(width: 1, color: Colors.white70),
  //                 bottom: BorderSide(width: 1, color: Colors.white),
  //               ),
  //             ),
  //             child: Text(
  //               "คำอธิบาย ข้อ $itmNum/$total",
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 18.0,
  //               ),
  //             ),
  //           ),
  //           Expanded(
  //             child: SingleChildScrollView(
  //               scrollDirection: Axis.vertical,
  //               child: SingleChildScrollView(
  //                 scrollDirection: Axis.horizontal,
  //                 child: ConstrainedBox(
  //                   constraints: BoxConstraints(
  //                     minWidth: MediaQuery.of(context).size.width,
  //                   ),
  //                   child: Html(
  //                     data: expltn,
  //                     extensions: [
  //                       TagExtension(
  //                         tagsToExtend: {"tex"},
  //                         builder: (extensionContext) {
  //                           return Math.tex(
  //                             extensionContext.innerHtml,
  //                             mathStyle: MathStyle.text,
  //                             textStyle: extensionContext.styledElement?.style.generateTextStyle(),
  //                             onErrorFallback: (FlutterMathException e) {
  //                               return Text(e.message);
  //                             },
  //                           );
  //                         },
  //                       ),
  //                       TableHtmlExtension(),
  //                     ],
  //                     style: {
  //                       "table": Style(
  //                         border: Border.all(width: 1), // Default border
  //                         width: Width(100, Unit.percent), // Default width
  //                       ),
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }



// original
 @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text('เตรียมสอบ ก.พ. ภาค ก.'),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[400],
                border: Border(
                  top: BorderSide(width: 1, color: Colors.white70),
                  bottom: BorderSide(width: 1, color: Colors.white),
                ),
              ),
              child: Text(
                "คำอธิบาย ข้อ $itmNum/$total",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Html(data: "$expltn",
                  extensions: [   // ทำให้ใช้ สัญลักษณ์คณิตศาสตร์ เช่น เศษส่วน รูท เป็นต้น
                    // แต่ยังมีปัญหา overflow ต้องอย่าให้ <tex>... </tex> ในไฟล์ xml ยาว ไม่งั้น overfolw
                    TagExtension(
                        tagsToExtend: {"tex"},
                        builder: (extensionContext) {
                          return Math.tex(
                            extensionContext.innerHtml,
                            mathStyle: MathStyle.text,
                            textStyle: extensionContext.styledElement?.style.generateTextStyle(),
                            onErrorFallback: (FlutterMathException e) {
                              //optionally try and correct the Tex string here
                              return Text(e.message);
                            },
                          );
                        }
                    ),
                    // สำหรับ ตารางในส่วนคำอธิบาย -- ยังใช้ไม่ได้ คือ ตารางไม่มีเส้นขอบ และไม่เต็มหน้า
                  // ถ้าจะใช้ตาราง ทำมาเป็นภาพดีกว่า
                    TableHtmlExtension(), // Ensure this extension is added
                  ],
                  style: {
                    "table": Style(
                      border: Border.all(width: 1), // Border around the table
                   //   borderCollapse: BorderCollapse.separate,
                    ),
                    "tr": Style(
                     border: Border(
                       bottom: BorderSide(width: 1, color: Colors.black),
                       top: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.black),
                     ),
                    ),
                    "td": Style(
                      border: Border(
                        right: BorderSide(width: 1, color: Colors.black),
                      ),
                 //     padding: EdgeInsets.all(8), // Optional padding
                    ),
                    "th": Style(
                      border: Border(
                        right: BorderSide(width: 1, color: Colors.black),
                      ),
                 //     padding: EdgeInsets.all(8), // Optional padding
                    ),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
