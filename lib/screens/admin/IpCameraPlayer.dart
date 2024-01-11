import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
class IPVideoPlayer extends StatefulWidget {
  @override
  _IPVideoPlayerState createState() => _IPVideoPlayerState();
}

class _IPVideoPlayerState extends State<IPVideoPlayer> {
  late VlcPlayerController _videoPlayerController;
  Future<void> initializePlayer() async {}
  @override
  void initState() {
    super.initState();

    _videoPlayerController = VlcPlayerController.network(
      'http://192.168.20.131:8080/video',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(4000),
        ]),
        http: VlcHttpOptions([
          VlcHttpOptions.httpReconnect(true),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Center(
        child: AspectRatio(
          aspectRatio: 3/4,
          child: VlcPlayer(
            controller: _videoPlayerController,
            placeholder: Stack(
              children: [
                Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT44t_2f9Xx2udTba25ROvWyp6BRLk9UUDfBmEJxJCkkiAXaJqMhC9zL1REOfGi3ntYqR0&usqp=CAU'),
                Center(child: CircularProgressIndicator()),
              ],
            ), aspectRatio: 3/4,
          ),
      )

    );
  }

  // @override
  // void dispose() async {
  //   super.dispose();
  //   await _videoPlayerController.stopRendererScanning();
  //   await _videoPlayerController.dispose();
  // }
}