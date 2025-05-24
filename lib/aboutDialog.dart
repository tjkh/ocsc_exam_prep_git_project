import 'package:flutter/material.dart';

class aboutDialog extends StatefulWidget {
  @override
  State<aboutDialog> createState() => _aboutDialogState();
}

class _aboutDialogState extends State<aboutDialog> {
  late Image aboutPageBkg;
  @override
  void initState() {
    super.initState();
    aboutPageBkg = Image.asset("assets/images/page_about.png");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(aboutPageBkg.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('เกี่ยวกับแอพ เตรียมสอบ กพ'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            // image: AssetImage('assets/images/beach03.png'),  // ช้า ต้องรอให้โหลดเสร็จ
            image: aboutPageBkg.image,
            fit: BoxFit.cover,
          ),
        ),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.all(25.0),
                child: new Container(
                  height: 175.0,
                  width: 175.0,
                  // child: new Image.asset('assets/images/pro_version2.png'),
                ),
              ),
              // new Text(
              //   "ครูทองจุล ขันขาว",
              //   style: new TextStyle(
              //       fontSize: 18.0,
              //       fontWeight: FontWeight.w100,
              //       color: Colors.black87),
              // ),
              // new Text(
              //   "กศ.บ., M.S., Diploma in Applied Linguistics",
              //   style: new TextStyle(
              //       fontSize: 14.0,
              //       fontWeight: FontWeight.w100,
              //       color: Colors.black87),
              // ),
              // // new Padding(
              //     padding:
              //         new EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0)),
              // new Text(
              //   'We appreciate your feedback ! !',
              //   style: new TextStyle(
              //       fontSize: 13.0,
              //       fontWeight: FontWeight.w600,
              //       color: Colors.black87),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
