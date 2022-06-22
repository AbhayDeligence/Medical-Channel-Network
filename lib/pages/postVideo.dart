import 'package:flutter/material.dart';
import 'package:news_app/services/app_service.dart';
import 'package:news_app/utils/cached_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PostVideo extends StatefulWidget {
  final dynamic data;
  PostVideo({this.data});
  @override
  State<PostVideo> createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo> {
  YoutubePlayerController? _controller;
  @override
  void initState() {
    _controller = YoutubePlayerController(
        initialVideoId:
            AppService.getYoutubeVideoIdFromUrl(widget.data['videoUrl']),
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          forceHD: false,
          loop: true,
          controlsVisibleAtStart: false,
          enableCaption: false,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        thumbnail: CustomCacheImage(
          imageUrl:
              'https://img.youtube.com/vi/${AppService.getYoutubeVideoIdFromUrl(widget.data['videoUrl'])}/0.jpg',
          radius: 0,
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            top: true,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      child: player,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.keyboard_backspace,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ), 
                Expanded(
                  child: ListTile(
                    title: Text(
                      widget.data!['username'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      widget.data!['textContent'],
                      style: TextStyle(fontSize: 15),
                    ),
                    isThreeLine: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}
