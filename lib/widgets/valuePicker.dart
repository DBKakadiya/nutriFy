import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:nutrime/resources/resource.dart';

class ValuePicker extends StatefulWidget {
  final Axis direction;
  final int? initialValue;
  final ValueChanged<int>? onChanged;
  final Function? onOutOfConstraints;
  final bool enableOnOutOfConstraintsAnimation;
  final bool withSpring;
  final int minValue;
  final int maxValue;

  const ValuePicker(
      {Key? key,
      required this.initialValue,
      required this.onChanged,
      this.onOutOfConstraints,
      this.enableOnOutOfConstraintsAnimation = true,
      this.direction = Axis.horizontal,
      this.withSpring = true,
      this.maxValue = 100,
      this.minValue = 0})
      : super(key: key);

  @override
  _NumberSelectionState createState() => _NumberSelectionState();
}

class _NumberSelectionState extends State<ValuePicker>
    with TickerProviderStateMixin {
  late bool _isHorizontal = widget.direction == Axis.horizontal;
  late final AnimationController _controller = AnimationController(
      vsync: this, lowerBound: -0.5, upperBound: 0.5, value: 0);
  late Animation _animation = _isHorizontal
      ? _animation = Tween<Offset>(
              begin: const Offset(0.0, 0.0), end: const Offset(1.5, 0.0))
          .animate(_controller)
      : _animation = Tween<Offset>(
              begin: const Offset(0.0, 0.0), end: const Offset(0.0, 1.5))
          .animate(_controller);
  late int _value = widget.initialValue ?? 0;
  late double _startAnimationPosX;
  late double _startAnimationPosY;

  late double _startAnimationOutOfConstraintsPosX;
  late double _startAnimationOutOfConstraintsPosY;

  late final AnimationController _backgroundColorController =
      AnimationController(
          vsync: this, duration: const Duration(milliseconds: 350), value: 0)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _backgroundColorController.animateTo(0, curve: Curves.easeIn);
          }
        });
  final ColorTween _backgroundColorTween = ColorTween();
  late final Animation<Color?> _backgroundColor =
      _backgroundColorController.drive(
          _backgroundColorTween.chain(CurveTween(curve: Curves.fastOutSlowIn)));

  @override
  void initState() {
    print('----initialVal------${widget.initialValue}');
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _backgroundColorController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    _isHorizontal = widget.direction == Axis.horizontal;
    _backgroundColorTween
      ..begin = colorIndigo
      ..end = colorIndigo;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _backgroundColorTween
      ..begin = colorIndigo
      ..end = colorIndigo;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _isHorizontal
          ? deviceHeight(context) * 0.07
          : deviceHeight(context) * 0.15,
      child: FittedBox(
        child: AnimatedBuilder(
          animation: _backgroundColorController,
          builder: (BuildContext context, Widget? child) => Material(
            type: MaterialType.canvas,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(50),
            color: _backgroundColor.value,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.remove, size: 23, color: colorWhite),
                  onPressed: () => _changeValue(adding: false, fromButtons: true),
                ),
                GestureDetector(
                  onHorizontalDragStart: _onPanStart,
                  onHorizontalDragUpdate: _onPanUpdate,
                  onHorizontalDragEnd: _onPanEnd,
                  child: SlideTransition(
                    position: _animation as Animation<Offset>,
                    child: Container(
                      height: deviceHeight(context) * 0.07,
                      width: deviceWidth(context) * 0.14,
                      decoration: const BoxDecoration(
                          color: colorWhite,
                          shape: BoxShape.circle
                      ),
                      alignment: Alignment.center,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              child: child, scale: animation);
                        },
                        child: Text(
                          '$_value%',
                          key: ValueKey<int>(_value),
                          style: textStyle16Medium(colorIndigo),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.add, size: 23, color: colorWhite),
                  onPressed: () => _changeValue(adding: true, fromButtons: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double offsetFromGlobalPos(Offset globalPosition) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset local = box.globalToLocal(globalPosition);
    _startAnimationPosX = ((local.dx * 0.75) / box.size.width) - 0.4;
    _startAnimationPosY = ((local.dy * 0.75) / box.size.height) - 0.4;

    _startAnimationOutOfConstraintsPosX =
        ((local.dx * 0.25) / box.size.width) - 0.4;
    _startAnimationOutOfConstraintsPosY =
        ((local.dy * 0.25) / box.size.height) - 0.4;

    if (_isHorizontal) {
      return ((local.dx * 0.75) / box.size.width) - 0.4;
    } else {
      return ((local.dy * 0.75) / box.size.height) - 0.4;
    }
  }

  void _onPanStart(DragStartDetails details) {
    _controller.stop();
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    _controller.stop();

    if (_controller.value <= -0.20) {
      _isHorizontal ? _changeValue(adding: false) : _changeValue(adding: true);
    } else if (_controller.value >= 0.20) {
      _isHorizontal ? _changeValue(adding: true) : _changeValue(adding: false);
    }
  }

  void _changeValue({required bool adding, bool fromButtons = false}) async {
    if (fromButtons) {
      _startAnimationPosX = _startAnimationPosY = adding ? 0.5 : -0.5;
      _startAnimationOutOfConstraintsPosX =
          _startAnimationOutOfConstraintsPosY = adding ? 0.25 : 0.25;
    }

    bool valueOutOfConstraints = false;
    if (adding && _value + 5 <= widget.maxValue) {
      setState(() => _value=(_value+5));
    } else if (!adding && _value - 5 >= widget.minValue) {
      setState(() => _value=(_value-5));
    } else {
      valueOutOfConstraints = true;
    }

    if (widget.withSpring) {
      final SpringDescription _kDefaultSpring =
          SpringDescription.withDampingRatio(
        mass: valueOutOfConstraints && widget.enableOnOutOfConstraintsAnimation
            ? 0.4
            : 0.9,
        stiffness:
            valueOutOfConstraints && widget.enableOnOutOfConstraintsAnimation
                ? 1000
                : 250.0,
        ratio: 0.6,
      );
      if (_isHorizontal) {
        _controller.animateWith(SpringSimulation(
            _kDefaultSpring,
            valueOutOfConstraints && widget.enableOnOutOfConstraintsAnimation
                ? _startAnimationOutOfConstraintsPosX
                : _startAnimationPosX,
            0.0,
            0.0));
      } else {
        _controller.animateWith(SpringSimulation(
            _kDefaultSpring,
            valueOutOfConstraints && widget.enableOnOutOfConstraintsAnimation
                ? _startAnimationOutOfConstraintsPosY
                : _startAnimationPosY,
            0.0,
            0.0));
      }
    } else {
      _controller.animateTo(0.0,
          curve: Curves.bounceOut, duration: const Duration(milliseconds: 500));
    }

    if (valueOutOfConstraints) {
      if (widget.onOutOfConstraints != null) widget.onOutOfConstraints!();
      if (widget.enableOnOutOfConstraintsAnimation) {
        _backgroundColorController.forward();
      }
    } else if (widget.onChanged != null) {
      widget.onChanged!(_value);
    }
  }
}
