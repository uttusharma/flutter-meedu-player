import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx.dart';
import 'package:meedu_player/meedu_player.dart';
import 'package:meedu_player/src/helpers/utils.dart';

class PlayerSlider extends StatelessWidget {
  const PlayerSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          child: LayoutBuilder(builder: (ctx, constraints) {
            return RxBuilder(
              observables: [_.buffered, _.duration],
              builder: (__) {
                // convert the bufferedLoaded to a percent using the video duration as a 100%
                double percent = 0;
                if (_.buffered.value.isNotEmpty) {
                  final loaded = _.buffered.value.last.end;
                  percent = loaded.inSeconds / _.duration.value.inSeconds;
                }
                // draw the  bufferedLoaded as a container
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  color: Colors.white30,
                  width: constraints.maxWidth * percent,
                  height: 3,
                );
              },
            );
          }),
        ),
        RxBuilder(
          observables: [_.sliderPosition, _.duration],
          builder: (__) {
            final int value = _.sliderPosition.value.inSeconds;
            final double max = _.duration.value.inSeconds.toDouble();
            if (value > max || max <= 0) {
              return Container();
            }
            return Container(
              constraints: BoxConstraints(
                maxHeight: 30,
              ),
              padding: EdgeInsets.only(bottom: 8),
              alignment: Alignment.center,
              child: SliderTheme(
                data: SliderThemeData(
                  trackShape: MSliderTrackShape(),
                  thumbColor: _.colorTheme,
                  activeTrackColor: _.colorTheme,
                  trackHeight: 10,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4.0),
                ),
                child: Slider(
                  min: 0,
                  divisions: _.duration.value.inSeconds,
                  value: value.toDouble(),
                  onChangeStart: (v) {
                    _.onChangedSliderStart();
                  },
                  onChangeEnd: (v) {
                    _.onChangedSliderEnd();
                    _.seekTo(
                      Duration(seconds: v.floor()),
                    );
                  },
                  label: printDuration(_.sliderPosition.value),
                  max: max,
                  onChanged: _.onChangedSlider,
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class MSliderTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    SliderThemeData? sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = 1;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2 + 4;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
