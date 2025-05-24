

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoId;
  final String nameOfVideo;

  const VideoPlayerPage({Key? key, required this.videoId, required this.nameOfVideo}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        enableCaption: true,
      ),
    );

    // Lock the orientation to landscape while in video player
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    // Restore orientation to allow device control when leaving the page
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เตรียมสอบ กพ. ภาค ก.'),
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
            child: Text(widget.nameOfVideo,
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

          Expanded(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              bottomActions: [
                CurrentPosition(),
                ProgressBar(isExpanded: true),
                RemainingDuration(),
                FullScreenButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

