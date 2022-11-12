import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tankdrum_learning/widgets/sound_note_ui/sound_note.ub.dart';

class ExampleAnimatedBorderPainter extends StatefulWidget {
  const ExampleAnimatedBorderPainter({Key? key}) : super(key: key);

  @override
  State<ExampleAnimatedBorderPainter> createState() =>
      _ExampleAnimatedBorderPainterState();
}

class _ExampleAnimatedBorderPainterState
    extends State<ExampleAnimatedBorderPainter> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 5000,
      ),
    );
    _controller2 = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void _startAnimation1() {
    _controller1.reset();
    _controller1.animateTo(1.0, curve: Curves.linear);
  }

  void _startAnimation2() {
    _controller2.reset();
    _controller2.animateTo(1.0, duration: const Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPaint(
            foregroundPainter: AnimatedBorderPainter(
              animation: _controller1,
              strokeColor: Colors.black,
              pathType: PathType.rRect,
              animationDirection: AnimationDirection.clockwise,
              startingPercentage: 25,
              radius: const Radius.circular(100),
            ),
            child: ElevatedButton(
              onPressed: _startAnimation1,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text('Click me also!'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomPaint(
            foregroundPainter: AnimatedBorderPainter(
              animation: _controller2,
              strokeColor: Colors.deepOrange,
              startingPercentage: 0,
              pathType: PathType.circle,
              radius: const Radius.circular(100),
              animationDirection: AnimationDirection.clockwise,
            ),
            child: SoundNoteUb(15, onTouchPlay: _startAnimation2).ui,
          ),
        ],
      ),
    );
  }
}

class AnimatedBorderPainter extends CustomPainter {
  final Animation<double> _animation;
  final PathType _pathType;
  final double _strokeWidth;
  final Color _strokeColor;
  final int _startingPercentage;
  final AnimationDirection _animationDirection;

  AnimatedBorderPainter({
    required animation,
    PathType pathType = PathType.rect,
    double strokeWidth = 4.0,
    Color strokeColor = Colors.blueGrey,
    Radius radius = const Radius.circular(100),
    int startingPercentage = 0,
    AnimationDirection animationDirection = AnimationDirection.clockwise,
  })  : assert(strokeWidth > 0, 'strokeWidth must be greater than 0.'),
        assert(startingPercentage >= 0 && startingPercentage <= 100,
            'startingPercentage must lie between 0 and 100.'),
        _animation = animation,
        _pathType = pathType,
        _strokeWidth = strokeWidth,
        _strokeColor = strokeColor,
        _startingPercentage = startingPercentage,
        _animationDirection = animationDirection,
        super(repaint: animation);

  late Path _originalPath;
  late Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final animationPercent = _animation.value;

    // Construct original path once when animation starts
    if (animationPercent == 0.0) {
      _originalPath = _createOriginalPath(size);
      _paint = Paint()
        ..strokeWidth = _strokeWidth
        ..style = PaintingStyle.stroke
        ..color = _strokeColor;
    }

    final currentPath = _createAnimatedPath(
      _originalPath,
      animationPercent,
    );

    final pathMetrics = currentPath.computeMetrics().toList();
    int count = 0;
    for (final pathMetric in pathMetrics) {
      final a = count > 0
          ? 1 / (_startingPercentage / 100)
          : 1 / (1 - (_startingPercentage / 100));
      Path extractPath =
          pathMetric.extractPath(0.0, pathMetric.length * animationPercent * a);
      try {
        final metric = extractPath.computeMetrics().first;
        final offset = metric.getTangentForOffset(metric.length)!.position;
        if (count == 0 && pathMetrics.length > 1) {
          if (animationPercent < (1 / a)) {
            canvas.drawCircle(offset, 5, _paint);
          }
        } else {
          canvas.drawCircle(offset, 5, _paint);
        }
      } catch (error) {
        debugPrint('error $error');
      }
      count++;
    }

    // canvas.drawPath(currentPath, _paint);
  }

  @override
  bool shouldRepaint(AnimatedBorderPainter oldDelegate) => true;

  Path _createOriginalPath(Size size) {
    switch (_pathType) {
      case PathType.rect:
        return _createOriginalPathRect(size);
      case PathType.rRect:
        return _createOriginalPathRRect(size);
      case PathType.circle:
        return _createOriginalPathCircle(size);
    }
  }

  Path _createOriginalPathRect(Size size) {
    Path originalPath = Path()
      ..addRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..lineTo(0, -(_strokeWidth / 2));
    if (_startingPercentage > 0 && _startingPercentage < 100) {
      return _createPathForStartingPercentage(
          originalPath, PathType.rect, size);
    }
    return originalPath;
  }

  Path _createOriginalPathRRect(Size size) {
    Path originalPath = Path()
      ..addRRect(
        RRect.fromLTRBAndCorners(0, 0, size.width, size.height,
            bottomLeft: const Radius.circular(100),
            bottomRight: const Radius.circular(100)),
      );
    if (_startingPercentage > 0 && _startingPercentage < 100) {
      return _createPathForStartingPercentage(originalPath, PathType.rRect);
    }
    return originalPath;
  }

  Path _createOriginalPathCircle(Size size) {
    Path originalPath = Path()
      ..addOval(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    if (_startingPercentage > 0 && _startingPercentage < 100) {
      return _createPathForStartingPercentage(originalPath, PathType.circle);
    }
    return originalPath;
  }

  Path _createPathForStartingPercentage(Path originalPath, PathType pathType,
      [Size? size]) {
    // Assumes that original path consists of one subpath only
    final pathMetrics = originalPath.computeMetrics().first;
    final pathCutoffPoint = (_startingPercentage / 100) * pathMetrics.length;
    final firstSubPath = pathMetrics.extractPath(0, pathCutoffPoint);
    final secondSubPath =
        pathMetrics.extractPath(pathCutoffPoint, pathMetrics.length);
    if (pathType == PathType.rect) {
      Path path = Path()
        ..addPath(secondSubPath, Offset.zero)
        ..lineTo(0, -(_strokeWidth / 2))
        ..addPath(firstSubPath, Offset.zero);
      switch (_startingPercentage) {
        case 25:
          path.lineTo(size!.width + _strokeWidth / 2, 0);
          break;
        case 50:
          path.lineTo(size!.width - _strokeWidth / 2, size.height);
          break;
        case 75:
          path.lineTo(0, size!.height + _strokeWidth / 2);
          break;
        default:
      }
      return path;
    }
    return Path()
      ..addPath(secondSubPath, Offset.zero)
      ..addPath(firstSubPath, Offset.zero);
  }

  Path _createAnimatedPath(
    Path originalPath,
    double animationPercent,
  ) {
    // ComputeMetrics can only be iterated once!
    final totalLength = originalPath
        .computeMetrics()
        .fold(0.0, (double prev, PathMetric metric) => prev + metric.length);

    final currentLength = totalLength * animationPercent;

    return _extractPathUntilLength(originalPath, currentLength);
  }

  Path _extractPathUntilLength(
    Path originalPath,
    double length,
  ) {
    var currentLength = 0.0;

    final path = Path();

    var metricsIterator = _animationDirection == AnimationDirection.clockwise
        ? originalPath.computeMetrics().iterator
        : originalPath.computeMetrics().toList().reversed.iterator;

    while (metricsIterator.moveNext()) {
      var metric = metricsIterator.current;

      var nextLength = currentLength + metric.length;

      final isLastSegment = nextLength > length;
      if (isLastSegment) {
        final remainingLength = length - currentLength;
        final pathSegment = _animationDirection == AnimationDirection.clockwise
            ? metric.extractPath(0.0, remainingLength)
            : metric.extractPath(
                metric.length - remainingLength, metric.length);

        path.addPath(pathSegment, Offset.zero);
        break;
      } else {
        // There might be a more efficient way of extracting an entire path
        final pathSegment = metric.extractPath(0.0, metric.length);
        path.addPath(pathSegment, Offset.zero);
      }

      currentLength = nextLength;
    }

    return path;
  }
}

enum PathType {
  rect,
  rRect,
  circle,
}

enum AnimationDirection {
  clockwise,
  counterclockwise,
}
