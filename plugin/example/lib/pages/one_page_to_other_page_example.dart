import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meedu_player/meedu_player.dart';
import 'package:wakelock/wakelock.dart';

class OnePageExample extends StatefulWidget {
  @override
  _OnePageExampleState createState() => _OnePageExampleState();
}

class _OnePageExampleState extends State<OnePageExample> {
  // read the documentation https://the-meedu-app.github.io/flutter-meedu-player/#/picture-in-picture
  // to enable the pip (picture in picture) support on Android
  MeeduPlayerController? _meeduPlayerController = MeeduPlayerController(
    controlsStyle: ControlsStyle.secondary,
    pipEnabled: true, // enable  pip on android
    showPipButton: true, // use false to hide pip button in the player
  );

  StreamSubscription? _playerEventSubs;

  @override
  void initState() {
    super.initState();
    // The following line will enable the Android and iOS wakelock.
    _playerEventSubs = _meeduPlayerController!.onPlayerStatusChanged.listen(
      (PlayerStatus status) {
        if (status == PlayerStatus.playing) {
          Wakelock.enable();
        } else {
          Wakelock.disable();
        }
      },
    );

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  void dispose() {
    _meeduDispose();
    super.dispose();
  }

  Future<void> _meeduDispose() async {
    if (_meeduPlayerController != null) {
      _playerEventSubs?.cancel();
      await _meeduPlayerController!.dispose();
      _meeduPlayerController = null;
      // The next line disables the wakelock again.
      await Wakelock.disable();
    }
  }

  _init() {
    _meeduPlayerController!.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source: "https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4",
      ),
      autoplay: true,
    );
  }

  Future<void> _gotTo() async {
    final route = MaterialPageRoute(
      builder: (_) => PageTwo(),
    );
    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page 1"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: MeeduVideoPlayer(
                controller: _meeduPlayerController!,
              ),
            ),
            SizedBox(height: 2),
            TextButton(
              onPressed: this._gotTo,
              child: Text("Page 2"),
            ),
          ],
        ),
      ),
    );
  }
}

class PageTwo extends StatefulWidget {
  PageTwo({Key? key}) : super(key: key);

  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  // read the documentation https://the-meedu-app.github.io/flutter-meedu-player/#/picture-in-picture
  // to enable the pip (picture in picture) support on Android
  final _meeduPlayerController = MeeduPlayerController(
    controlsStyle: ControlsStyle.primary,
    pipEnabled: true, // enable  pip on android
    showPipButton: true, // use false to hide pip button in the player
  );

  StreamSubscription? _playerEventSubs;

  @override
  void initState() {
    super.initState();
    // The following line will enable the Android and iOS wakelock.
    _playerEventSubs = _meeduPlayerController.onPlayerStatusChanged.listen(
      (PlayerStatus status) {
        if (status == PlayerStatus.playing) {
          Wakelock.enable();
        } else {
          Wakelock.disable();
        }
      },
    );

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  void dispose() {
    // The next line disables the wakelock again.
    _playerEventSubs?.cancel();
    Wakelock.disable();
    _meeduPlayerController.dispose();
    super.dispose();
  }

  _init() {
    _meeduPlayerController.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source: "https://movietrailers.apple.com/movies/fox/the-new-mutants/the-new-mutants-trailer-1_h720p.mov",
      ),
      autoplay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page 2"),
      ),
      body: SafeArea(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: MeeduVideoPlayer(
            controller: _meeduPlayerController,
          ),
        ),
      ),
    );
  }
}
