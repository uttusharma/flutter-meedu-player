# meedu_player

<a target="blank" href="https://pub.dev/packages/meedu_player"><img src="https://img.shields.io/pub/v/meedu_player?include_prereleases&style=flat-square"/></a>
<img src="https://img.shields.io/github/last-commit/the-meedu-app/flutter-meedu-player/master?style=flat-square"/>
<img src="https://img.shields.io/github/license/the-meedu-app/flutter-meedu-player?style=flat-square"/>

> Modern video player UI for [video_player](https://pub.dev/packages/video_player)

<img src="assets/pip.gif" alt="meedu_player pip" width="160" />
<img src="assets/q2.gif" alt="meedu_player" width="160" />
<br/>
<img src="assets/full.gif" alt="meedu_player" width="300" />
<img src="https://user-images.githubusercontent.com/15864336/94494352-9924d100-01b4-11eb-9c0f-54c88868331b.png" alt="meedu_player" width="300" />


<br/>
<br/>

| Features  | iOS | Android |
| ------------- | ------------- | ------------- |
| Videos from Network  | ✅  | ✅ |
| Videos from Assets  | ✅  | ✅ |
| Videos from local files  | ✅  | ✅ |
| Looping  | ✅  | ✅ |
| Autoplay  | ✅  | ✅ |
| Mute / Sound  | ✅  | ✅ |
| Fullscreen  | ✅  | ✅ |
| Launch Player as Fullscreen  | ✅  | ✅ |
| Playback Speed  | ✅  | ✅ |
| fastForward / Rewind  | ✅  | ✅ |
| srt subtitles  | ✅  | ✅ |
| Customize  | partially  | partially |
| Picture in Picture  | ❌  | ✅ |

<br/>

> For correctly works don't use a device simulator (iOS) or emulator (Android)




# Add to project

Add the following to your `pubspec.yaml`:

```
dependencies:
  meedu_player: ^${$.var.version}
```

---

# Configuration

> If you want to use urls with `http://` you need a little configuration.

## Android

On Android go to your `<project root>/android/app/src/main/AndroidManifest.xml`:

Add the next permission
`<uses-permission android:name="android.permission.INTERNET"/>`

And add `android:usesCleartextTraffic="true"` in your Application tag.
<br/>

## iOS

Warning: The video player is not functional on iOS simulators. An iOS device must be used during development/testing.

Add the following entry to your Info.plist file, located in `<project root>/ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

In your `Podfile` you need set a minimum target version like 9.0 or higher

```
platform :ios, '9.0'
```

---

# How to use

Fisrt you need to import the `meedu_player` plugin and create an instance of `MeeduPlayerController`

```dart
import 'package:meedu_player/meedu_player.dart';
.
.
.
final _meeduPlayerController = MeeduPlayerController();
```

> When you create an instance of `MeeduPlayerController` you can pass params like `controlsStyle, colorTheme, placeholder, etc`.

Now you can use the `MeeduVideoPlayer` widget to show your video, the `MeeduVideoPlayer` widget takes the size of its parent container (we recomend to use an  AspectRatio widget)
```dart
 AspectRatio(
    aspectRatio: 16 / 9,
    child: MeeduVideoPlayer(
        controller: _meeduPlayerController,
    ),
),
```

In this moment you only can watch a **black** `Container` that is because you need to set a `DataSource` and pass it to your `MeeduPlayerController` instance.

<br/>

To play a video from **network**
```dart
 _meeduPlayerController.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source: "https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4",
      ),
      autoplay: true,
);
```

<br/>

To play a video from **assets** (Make sure that your asset is defined in your `pubspec.yaml`)
```dart
 _meeduPlayerController.setDataSource(
      DataSource(
        type: DataSourceType.asset,
        source: "assets/video/big-buck-bunny-360p.mp4",
      ),
      autoplay: true,
);
```
<br/>

To play a video from a local **File**
```dart
 _meeduPlayerController.setDataSource(
      DataSource(
        type: DataSourceType.file,
        file: <YOUR INSTANCE OF FILE>,
      ),
      autoplay: true,
);
```



> **IMPORTANT:** When you don't need more the player you need to call to `dispose` to release the player
```dart
 _meeduPlayerController.dispose();
```

---

# Basic example

> We are using [wakelock](https://pub.dev/packages/wakelock) to keep the screen on when the video player is using

```dart
import 'package:flutter/material.dart';
import 'package:meedu_player/meedu_player.dart';
import 'package:wakelock/wakelock.dart';

class BasicExamplePage extends StatefulWidget {
  BasicExamplePage({Key? key}) : super(key: key);

  @override
  _BasicExamplePageState createState() => _BasicExamplePageState();
}

class _BasicExamplePageState extends State<BasicExamplePage> {
  final _meeduPlayerController = MeeduPlayerController(
    controlsStyle: ControlsStyle.primary,
  );

  @override
  void initState() {
    super.initState();
// The following line will enable the Android and iOS wakelock.
    Wakelock.enable();

    // Wait until the fisrt render the avoid posible errors when use an context while the view is rendering
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  void dispose() {
    // The next line disables the wakelock again.
    Wakelock.disable();
    _meeduPlayerController.dispose();// release the video player
    super.dispose();
  }

    /// play a video from network
  _init() {
    _meeduPlayerController.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source: "https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4",
      ),
      autoplay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
```






