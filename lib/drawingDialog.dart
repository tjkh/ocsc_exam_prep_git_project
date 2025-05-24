



// ====== Perfect. Can draw, can erase, can clear, can resize,
// can be moved, มีสีให้เลือก 4 สี, ปิดแล้วเปิดใหม่ในหัวข้อเดิมยังค้างของเดิม
// แต่ถ้าขกลับออกมาึ้นเเมนูไหม่ จะเคลียอัตโนมัติ


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:ocsc_exam_prep/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawingDialog extends StatefulWidget {
  @override
  _DrawingDialogState createState() => _DrawingDialogState();
}

class _DrawingDialogState extends State<DrawingDialog> {
  late ScribbleNotifier _notifier;
  double _top = 0;
  double _left = 0;
  double _width = 0; // Will set this in didChangeDependencies
  double _height = 0; // Will set this in didChangeDependencies
  bool _isPenActive = true; // Track if the pen is active
  Color _selectedColor = Colors.black; // Default color

  @override
  void initState() {
    super.initState();
    _notifier = ScribbleNotifier();
    _notifier.setStrokeWidth(2); // Set the stroke width to 2 pixels
    _loadDrawing(); // Load drawing on initialization
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Now we can safely access MediaQuery
    _width = MediaQuery.of(context).size.width * 0.8; // 80% of screen width
    _height = MediaQuery.of(context).size.height * 0.5; // 50% of screen height

    // Center the dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _top = (MediaQuery.of(context).size.height - _height) / 2;
        _left = (MediaQuery.of(context).size.width - _width) / 2;
      });
    });
  }

  @override
  void dispose() {
    _saveDrawing(); // Save drawing when disposing the dialog
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeNotifier>(context, listen: false).darkTheme;

    return Scaffold(
      backgroundColor: Colors.pinkAccent.withOpacity(0.2),
      body: Stack(
        children: [
          Positioned(
            top: _top,
            left: _left,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  double newTop = _top + details.delta.dy;
                  double newLeft = _left + details.delta.dx;

                  double screenHeight = MediaQuery.of(context).size.height;
                  double margin = 30;

                  if (newTop < margin) {
                    _top = margin;
                  } else if (newTop + 50 > screenHeight) {
                    _top = screenHeight - 50;
                  } else {
                    _top = newTop;
                  }

                  _left = newLeft;
                });
              },
              child: Container(
                width: _width,
                height: _height,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey : Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRect(
                      child: Scribble(
                        notifier: _notifier,
                        drawPen: true, // Enables drawing with a pen
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,

                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Align buttons to the left
                              children: [
                                Text(
                                  'กระดาษทด',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    fontFamily: 'Athiti',
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                Navigator.of(context).pop();
                              },
                              child: Icon(Icons.close, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Positioned(
                    //   bottom: 0,
                    //   left: 0,
                    //   right: 0,
                    //   child: Container(
                    //     padding: EdgeInsets.all(8.0),
                    //     child: Column(
                    //       children: [
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             // Color selection squares
                    //             GestureDetector(
                    //               onTap: () {
                    //                 setState(() {
                    //                   _selectedColor = Colors.black;
                    //                   _notifier.setColor(_selectedColor);
                    //                   _isPenActive = true; // Set pen active
                    //                 });
                    //               },
                    //               child: Container(
                    //                 width: 20,
                    //                 height: 20,
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.black,
                    //                   borderRadius: BorderRadius.circular(100),  // ทำเป็นวงกลม
                    //                   border: Border(
                    //                     bottom: BorderSide(
                    //                       color: _selectedColor == Colors.black ? Colors.purple : Colors.transparent,
                    //                       width: _selectedColor == Colors.black ? 4 : 0,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             SizedBox(width: 2),
                    //             GestureDetector(
                    //               onTap: () {
                    //                 setState(() {
                    //                   _selectedColor = Colors.blue;
                    //                   _notifier.setColor(_selectedColor);
                    //                   _isPenActive = true; // Set pen active
                    //                 });
                    //               },
                    //               child: Container(
                    //                 width: 20,
                    //                 height: 20,
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.blue,
                    //                   borderRadius: BorderRadius.circular(100),  // ทำเป็นวงกลม
                    //                   border: Border(
                    //                     bottom: BorderSide(
                    //                       color: _selectedColor == Colors.blue ? Colors.deepPurpleAccent : Colors.transparent,
                    //                       width: _selectedColor == Colors.blue ? 4 : 0,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             SizedBox(width: 2),
                    //             GestureDetector(
                    //               onTap: () {
                    //                 setState(() {
                    //                   _selectedColor = Colors.red;
                    //                   _notifier.setColor(_selectedColor);
                    //                   _isPenActive = true; // Set pen active
                    //                 });
                    //               },
                    //               child: Container(
                    //                 width: 20,
                    //                 height: 20,
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.red,
                    //                   borderRadius: BorderRadius.circular(100),  // ทำเป็นวงกลม
                    //                   border: Border(
                    //                     bottom: BorderSide(
                    //                       color: _selectedColor == Colors.red ? Colors.deepPurpleAccent : Colors.transparent,
                    //                       width: _selectedColor == Colors.red ? 4 : 0,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             SizedBox(width: 2),
                    //             GestureDetector(
                    //               onTap: () {
                    //                 setState(() {
                    //                   _selectedColor = Colors.yellow;
                    //                   _notifier.setColor(_selectedColor);
                    //                   _isPenActive = true; // Set pen active
                    //                 });
                    //               },
                    //               child: Container(
                    //                 width: 20,
                    //                 height: 20,
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.yellow,
                    //                   borderRadius: BorderRadius.circular(100),  // ทำเป็นวงกลม
                    //                   border: Border(
                    //                     bottom: BorderSide(
                    //                       color: _selectedColor == Colors.yellow ? Colors.deepPurpleAccent : Colors.transparent,
                    //                       width: _selectedColor == Colors.yellow ? 4 : 0,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             SizedBox(width: 20),
                    //             Expanded(
                    //               child: IconButton(
                    //                 onPressed: () {
                    //                   setState(() {
                    //                     _isPenActive = true; // Set pen active
                    //                     _notifier.setColor(_selectedColor); // Use selected color
                    //                   });
                    //                 },
                    //                 icon: Image.asset(
                    //                   _isPenActive ? "assets/images/pen_active.png" : "assets/images/pen_not_active.png",
                    //                   scale: 18,
                    //                 ),
                    //                 tooltip: 'ดินสอ',
                    //               ),
                    //             ),
                    //             SizedBox(width: 10),
                    //             Expanded(
                    //               child: IconButton(
                    //                 onPressed: () {
                    //                   setState(() {
                    //                     _isPenActive = false; // Set eraser active
                    //                     _notifier.setEraser();
                    //                   });
                    //                 },
                    //                 icon: Image.asset(
                    //                   !_isPenActive ? "assets/images/eraser_active.png" : "assets/images/eraser_not_active.png",
                    //                   scale: 18,
                    //                 ),
                    //                 tooltip: 'ยางลบ',
                    //               ),
                    //             ),
                    //             const SizedBox(width: 10),
                    //
                    //             Expanded(
                    //               child: IconButton(
                    //                 onPressed: () {
                    //                   _notifier.clear();
                    //                 },
                    //                 icon: Image.asset(
                    //                   "assets/images/sweep_normal.png",
                    //                   scale: 18,
                    //                 ),
                    //                 tooltip: 'เคลียกระดาษทด',
                    //               ),
                    //             ),
                    //             SizedBox(width: 20),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Align buttons to the left
                              children: [
                                // Color selection squares without borders
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedColor = Colors.black;
                                      _notifier.setColor(_selectedColor);
                                      _isPenActive = true; // Set pen active
                                    });
                                  },
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                  //  color: Colors.black, // No border here
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border(
                                        bottom: BorderSide(
                                          color: _selectedColor == Colors.black ? Colors.purple : Colors.transparent,
                                          width: _selectedColor == Colors.black ? 4 : 0,
                                        )
                                      )
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedColor = Colors.blue;
                                      _notifier.setColor(_selectedColor);
                                      _isPenActive = true; // Set pen active
                                    });
                                  },
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                   // color: Colors.blue, // No border here
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        border: Border(
                                            bottom: BorderSide(
                                              color: _selectedColor == Colors.blue ? Colors.purple : Colors.transparent,
                                              width: _selectedColor == Colors.blue ? 4 : 0,
                                            )
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedColor = Colors.red;
                                      _notifier.setColor(_selectedColor);
                                      _isPenActive = true; // Set pen active
                                    });
                                  },
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    //color: Colors.red, // No border here
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        border: Border(
                                            bottom: BorderSide(
                                              color: _selectedColor == Colors.red ? Colors.purple : Colors.transparent,
                                              width: _selectedColor == Colors.red ? 4 : 0,
                                            )
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedColor = Colors.yellow;
                                      _notifier.setColor(_selectedColor);
                                      _isPenActive = true; // Set pen active
                                    });
                                  },
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    //color: Colors.yellow, // No border here
                                    decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        border: Border(
                                            bottom: BorderSide(
                                              color: _selectedColor == Colors.yellow ? Colors.purple : Colors.transparent,
                                              width: _selectedColor == Colors.yellow ? 4 : 0,
                                            )
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),

                                // Pen Button with border
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPenActive = true;
                                      _notifier.setColor(_selectedColor); // Use selected color
                                    });
                                  },
                                  child: Tooltip(
                                    message: 'ดินสอ',
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Image.asset(
                                        _isPenActive ? "assets/images/pen_active.png" : "assets/images/pen_not_active.png",
                                        scale: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),

                                // Eraser Button with border
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPenActive = false;
                                      _notifier.setEraser(); // Switch to eraser mode
                                    });
                                  },
                                  child: Tooltip(
                                    message: 'ยางลบ',
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Image.asset(
                                        !_isPenActive ? "assets/images/eraser_active.png" : "assets/images/eraser_not_active.png",
                                        scale: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),

                                // Clear Button with border
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _notifier.clear(); // Clear the drawing
                                    });
                                  },
                                  child: Tooltip(
                                    message: 'ล้างกระดาษทด',
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Image.asset(
                                        "assets/images/sweep_normal.png",
                                        scale: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Resizing Icon
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _width = (_width + details.delta.dx).clamp(230.0, MediaQuery.of(context).size.width - _left);
                            _height = (_height + details.delta.dy).clamp(200.0, MediaQuery.of(context).size.height - _top);
                          });
                        },
                        child: Icon(Icons.open_in_full, size: 24, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveDrawing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String serializedLines = jsonEncode(_notifier.currentSketch.toJson());
    prefs.setString('savedDrawing', serializedLines);
  }

  void _loadDrawing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? serializedLines = prefs.getString('savedDrawing');
    if (serializedLines != null) {
      // Load the sketch from the saved JSON
      Sketch sketch = Sketch.fromJson(jsonDecode(serializedLines));
      _notifier.setSketch(sketch: sketch);
    }
  }

  bool _isWithinDialogBounds(Offset position) {
    double x = position.dx;
    double y = position.dy;
    return x >= 0 && x <= _width && y >= 0 && y <= _height;
  }
}





