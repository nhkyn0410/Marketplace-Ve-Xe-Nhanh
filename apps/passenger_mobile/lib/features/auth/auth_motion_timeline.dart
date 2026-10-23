import 'dart:math' as math;

import 'package:flutter/animation.dart';

enum AuthMotionProperty {
  opacity,
  x,
  y,
  scale,
  rotationDegrees,
  rotationRadians,
}

enum _MotionEase {
  linear,
  easeOut,
  easeInOut,
  expo,
  move,
  logo,
  springA,
  springB,
}

class _MotionTrack {
  const _MotionTrack(this.milliseconds, this.values, this.easings)
    : assert(milliseconds.length == values.length),
      assert(easings.length == milliseconds.length - 1);

  final List<double> milliseconds;
  final List<double> values;
  final List<_MotionEase> easings;

  double valueAt(double timeMs) {
    if (timeMs <= milliseconds.first) return values.first;

    for (var index = 0; index < milliseconds.length - 1; index++) {
      final startMs = milliseconds[index];
      final endMs = milliseconds[index + 1];
      if (timeMs > endMs) continue;

      final segmentProgress = (timeMs - startMs) / (endMs - startMs);
      final eased = _curveFor(easings[index]).transform(segmentProgress);
      return values[index] + (values[index + 1] - values[index]) * eased;
    }

    return values.last;
  }
}

class _SpringCurve extends Curve {
  const _SpringCurve({
    required this.decay,
    required this.frequency,
    required this.sinCoefficient,
  });

  final double decay;
  final double frequency;
  final double sinCoefficient;

  @override
  double transformInternal(double t) {
    return 1 -
        math.exp(-t * decay) *
            (math.cos(t * frequency) +
                sinCoefficient * math.sin(t * frequency));
  }
}

const _springA = _SpringCurve(
  decay: 7.6657,
  frequency: 6.7605,
  sinCoefficient: 1.1339,
);
const _springB = _SpringCurve(
  decay: 7.1866,
  frequency: 22.3441,
  sinCoefficient: 0.3216,
);

Curve _curveFor(_MotionEase ease) => switch (ease) {
  _MotionEase.linear => Curves.linear,
  _MotionEase.easeOut => Curves.easeOut,
  _MotionEase.easeInOut => Curves.easeInOut,
  _MotionEase.expo => const Cubic(0.16, 1, 0.3, 1),
  _MotionEase.move => const Cubic(0.2, 0.7, 0.2, 1),
  _MotionEase.logo => const Cubic(0.65, 0, 0.35, 1),
  _MotionEase.springA => _springA,
  _MotionEase.springB => _springB,
};

/// Timeline 4 giây được chép trực tiếp từ Figma Motion Context.
///
/// Mỗi easing áp dụng cho đoạn từ keyframe cùng chỉ số đến keyframe kế tiếp.
/// Giá trị mặc định là trạng thái nghỉ của thuộc tính khi node không có track đó.
abstract final class AuthMotionTimeline {
  static const duration = Duration(milliseconds: 4000);

  static const animatedNodeIds = <String>{
    '1255:215',
    '1255:216',
    '1255:217',
    '1255:219',
    '1255:221',
    '1255:223',
    '1255:225',
    '1255:227',
    '1255:229',
    '1255:231',
    '1255:233',
    '1255:235',
    '1255:237',
    '1255:239',
    '1256:214',
    '1256:217',
    '1256:221',
    '1256:237',
    '1256:242',
    '1259:235',
    '1259:237',
    '1257:221',
    '1257:222',
    '1257:223',
    '1259:238',
    '1259:240',
    '1257:229',
    '1257:234',
    '1257:242',
    '1257:245',
    '1257:251',
    '1257:253',
    '1259:253',
    '1259:260',
    '1259:261',
  };

  static double value(
    String nodeId,
    AuthMotionProperty property,
    double progress,
  ) {
    final track = _tracks[nodeId]?[property];
    if (track == null) return _defaultValue(property);
    final clampedProgress = progress.clamp(0.0, 1.0);
    return track.valueAt(clampedProgress * duration.inMilliseconds);
  }

  static double valueAtMilliseconds(
    String nodeId,
    AuthMotionProperty property,
    double milliseconds,
  ) {
    return value(nodeId, property, milliseconds / duration.inMilliseconds);
  }

  static double _defaultValue(AuthMotionProperty property) {
    return switch (property) {
      AuthMotionProperty.opacity || AuthMotionProperty.scale => 1,
      _ => 0,
    };
  }

  static const _linear = _MotionEase.linear;
  static const _out = _MotionEase.easeOut;
  static const _inOut = _MotionEase.easeInOut;
  static const _expo = _MotionEase.expo;
  static const _move = _MotionEase.move;
  static const _logo = _MotionEase.logo;
  static const _springA = _MotionEase.springA;
  static const _springB = _MotionEase.springB;

  static final _tracks = <String, Map<AuthMotionProperty, _MotionTrack>>{
    '1255:215': {
      AuthMotionProperty.opacity: _MotionTrack(
        [0, 600, 1000, 4000],
        [0, 0, 1, 1],
        [_linear, _out, _linear],
      ),
      AuthMotionProperty.y: _MotionTrack([0, 600, 1500, 4000], [70, 70, 0, 0], [
        _linear,
        _springA,
        _linear,
      ]),
    },
    '1255:216': {
      AuthMotionProperty.scale: _MotionTrack(
        [0, 1600, 2600, 3600, 4000],
        [1, 1, 1.14, 1, 1],
        [_linear, _inOut, _inOut, _linear],
      ),
    },
    '1255:217': {
      AuthMotionProperty.scale: _MotionTrack(
        [0, 1750, 2750, 3750, 4000],
        [1, 1, 1.1, 1, 1],
        [_linear, _inOut, _inOut, _linear],
      ),
    },
    '1255:219': {
      AuthMotionProperty.opacity: _MotionTrack(
        [0, 500, 950, 4000],
        [0, 0, 0.38, 0.38],
        [_linear, _out, _linear],
      ),
      AuthMotionProperty.y: _MotionTrack([0, 500, 1100, 4000], [36, 36, 0, 0], [
        _linear,
        _expo,
        _linear,
      ]),
    },
    '1255:221': {
      AuthMotionProperty.opacity: _MotionTrack(
        [0, 800, 1300, 4000],
        [0, 0, 0.6, 0.6],
        [_linear, _out, _linear],
      ),
      AuthMotionProperty.x: _MotionTrack([0, 800, 4000], [-18, -18, 8], [
        _linear,
        _linear,
      ]),
    },
    '1255:223': {
      AuthMotionProperty.opacity: _MotionTrack(
        [0, 560, 1000, 4000],
        [0, 0, 0.9, 0.9],
        [_linear, _out, _linear],
      ),
      AuthMotionProperty.y: _MotionTrack([0, 560, 1200, 4000], [52, 52, 0, 0], [
        _linear,
        _expo,
        _linear,
      ]),
    },
    '1255:225': {
      AuthMotionProperty.opacity: _MotionTrack(
        [0, 600, 1100, 4000],
        [0, 0, 0.95, 0.95],
        [_linear, _out, _linear],
      ),
      AuthMotionProperty.x: _MotionTrack([0, 600, 4000], [-34, -34, 12], [
        _linear,
        _linear,
      ]),
    },
    '1255:227': {
      AuthMotionProperty.opacity: _MotionTrack(
        [0, 700, 1200, 4000],
        [0, 0, 0.88, 0.88],
        [_linear, _out, _linear],
      ),
      AuthMotionProperty.x: _MotionTrack([0, 700, 4000], [38, 38, -10], [
        _linear,
        _linear,
      ]),
    },
    '1255:229': {
      AuthMotionProperty.y: _MotionTrack([0, 620, 1300, 4000], [76, 76, 0, 0], [
        _linear,
        _expo,
        _linear,
      ]),
    },
    '1255:231': {
      AuthMotionProperty.opacity: _MotionTrack(
        [0, 1040, 1160, 4000],
        [0, 0, 1, 1],
        [_linear, _out, _linear],
      ),
      AuthMotionProperty.scale: _MotionTrack(
        [0, 1040, 1490, 4000],
        [0.2, 0.2, 1, 1],
        [_linear, _springB, _linear],
      ),
      AuthMotionProperty.y: _MotionTrack(
        [0, 1040, 1440, 4000],
        [10, 10, 0, 0],
        [_linear, _out, _linear],
      ),
    },
    '1255:233': {
      AuthMotionProperty.opacity: _MotionTrack(
        [0, 1100, 1220, 4000],
        [0, 0, 1, 1],
        [_linear, _out, _linear],
      ),
      AuthMotionProperty.scale: _MotionTrack(
        [0, 1100, 1550, 4000],
        [0.2, 0.2, 1, 1],
        [_linear, _springB, _linear],
      ),
      AuthMotionProperty.y: _MotionTrack(
        [0, 1100, 1500, 4000],
        [10, 10, 0, 0],
        [_linear, _out, _linear],
      ),
    },
    '1255:235': {
      AuthMotionProperty.opacity: _MotionTrack(
        [0, 1160, 1280, 4000],
        [0, 0, 1, 1],
        [_linear, _out, _linear],
      ),
      AuthMotionProperty.scale: _MotionTrack(
        [0, 1160, 1610, 4000],
        [0.2, 0.2, 1, 1],
        [_linear, _springB, _linear],
      ),
      AuthMotionProperty.y: _MotionTrack(
        [0, 1160, 1560, 4000],
        [10, 10, 0, 0],
        [_linear, _out, _linear],
      ),
    },
    '1255:237': {
      AuthMotionProperty.opacity: _MotionTrack(
        [0, 1220, 1340, 4000],
        [0, 0, 1, 1],
        [_linear, _out, _linear],
      ),
      AuthMotionProperty.scale: _MotionTrack(
        [0, 1220, 1670, 4000],
        [0.2, 0.2, 1, 1],
        [_linear, _springB, _linear],
      ),
      AuthMotionProperty.y: _MotionTrack(
        [0, 1220, 1620, 4000],
        [10, 10, 0, 0],
        [_linear, _out, _linear],
      ),
    },
    '1255:239': {
      AuthMotionProperty.opacity: _MotionTrack(
        [0, 1280, 1400, 4000],
        [0, 0, 1, 1],
        [_linear, _out, _linear],
      ),
      AuthMotionProperty.scale: _MotionTrack(
        [0, 1280, 1730, 4000],
        [0.2, 0.2, 1, 1],
        [_linear, _springB, _linear],
      ),
      AuthMotionProperty.y: _MotionTrack(
        [0, 1280, 1680, 4000],
        [10, 10, 0, 0],
        [_linear, _out, _linear],
      ),
    },
    '1256:214': {
      AuthMotionProperty.x: _MotionTrack(
        [0, 850, 2050, 4000],
        [-330, -330, 0, 0],
        [_linear, _move, _linear],
      ),
    },
    '1256:217': {
      AuthMotionProperty.opacity: _MotionTrack(
        [0, 850, 1000, 1350, 1650, 4000],
        [0, 0, 0.85, 0.85, 0, 0],
        [_linear, _out, _linear, _out, _linear],
      ),
    },
    '1256:221': {
      AuthMotionProperty.rotationDegrees: _MotionTrack(
        [0, 1700, 1980, 2400, 4000],
        [0, 0, 1.1, 0, 0],
        [_linear, _out, _springA, _linear],
      ),
      AuthMotionProperty.y: _MotionTrack(
        [0, 1700, 1980, 2350, 2800, 3200, 3600, 4000],
        [0, 0, 1.2, 0, -0.7, 0, -0.7, 0],
        [_linear, _out, _springA, _inOut, _inOut, _inOut, _inOut],
      ),
    },
    '1256:237': {
      AuthMotionProperty.rotationRadians: _MotionTrack(
        [0, 850, 2050, 4000],
        [-30, -30, 0, 0],
        [_linear, _move, _linear],
      ),
    },
    '1256:242': {
      AuthMotionProperty.rotationRadians: _MotionTrack(
        [0, 850, 2050, 4000],
        [-30, -30, 0, 0],
        [_linear, _move, _linear],
      ),
    },
    '1259:235': {
      AuthMotionProperty.x: _MotionTrack(
        [0, 1050, 3600, 4000],
        [-44, -44, 0, 0],
        [_linear, _out, _linear],
      ),
      AuthMotionProperty.y: _MotionTrack(
        [0, 1050, 1750, 4000],
        [640, 640, 0, 0],
        [_linear, _expo, _linear],
      ),
    },
    '1259:237': {
      AuthMotionProperty.y: _MotionTrack(
        [0, 1120, 1850, 4000],
        [640, 640, 0, 0],
        [_linear, _expo, _linear],
      ),
    },
    '1257:221': _reveal(1450, 1770, 1950),
    '1257:222': _reveal(1580, 1900, 2080),
    '1257:223': _reveal(1620, 1940, 2120),
    '1259:238': _reveal(1690, 2010, 2190),
    '1259:240': {
      AuthMotionProperty.x: _MotionTrack(
        [0, 2500, 3200, 4000],
        [0, 0, 500, 500],
        [_linear, _inOut, _linear],
      ),
    },
    '1257:229': _reveal(1760, 2080, 2260),
    '1257:234': _reveal(1830, 2150, 2330),
    '1257:242': _reveal(1900, 2220, 2400),
    '1257:245': _reveal(1950, 2270, 2450),
    '1257:251': _reveal(2020, 2340, 2520),
    '1257:253': _reveal(2080, 2400, 2580),
    '1259:253': {
      AuthMotionProperty.opacity: _MotionTrack(
        [0, 980, 1160, 4000],
        [0, 0, 1, 1],
        [_linear, _out, _linear],
      ),
    },
    '1259:260': {
      AuthMotionProperty.opacity: _MotionTrack(
        [0, 450, 950, 4000],
        [1, 1, 0, 0],
        [_linear, _inOut, _linear],
      ),
    },
    '1259:261': {
      AuthMotionProperty.opacity: _MotionTrack(
        [0, 1020, 1160, 4000],
        [1, 1, 0, 0],
        [_linear, _out, _linear],
      ),
      AuthMotionProperty.scale: _MotionTrack(
        [0, 450, 1000, 4000],
        [1, 1, 0.489, 0.489],
        [_linear, _logo, _linear],
      ),
      AuthMotionProperty.x: _MotionTrack(
        [0, 450, 1000, 4000],
        [0, 0, -109.289, -109.289],
        [_linear, _logo, _linear],
      ),
      AuthMotionProperty.y: _MotionTrack(
        [0, 450, 1000, 4000],
        [0, 0, -353.659, -353.659],
        [_linear, _logo, _linear],
      ),
    },
  };

  static Map<AuthMotionProperty, _MotionTrack> _reveal(
    double holdUntil,
    double opacityUntil,
    double translateUntil,
  ) {
    return {
      AuthMotionProperty.opacity: _MotionTrack(
        [0, holdUntil, opacityUntil, 4000],
        [0, 0, 1, 1],
        [_linear, _out, _linear],
      ),
      AuthMotionProperty.y: _MotionTrack(
        [0, holdUntil, translateUntil, 4000],
        [20, 20, 0, 0],
        [_linear, _expo, _linear],
      ),
    };
  }
}
