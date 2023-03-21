import 'package:flutter/material.dart';
class BouncingButton extends StatefulWidget {
  final String text;
 final VoidCallback callback;
 final Color btnColor;
 final Color shadowColor;

  const BouncingButton(
      {Key? key, required this.text,required this.callback,required this.btnColor,required this.shadowColor})
      : super(key: key);

  @override
  _BouncingButtonState createState() => _BouncingButtonState();
}
class _BouncingButtonState extends State<BouncingButton> with SingleTickerProviderStateMixin {
  double _scale=0;
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Center(
      child: GestureDetector(
        onTap: (){
          widget.callback();
        },
        onTapDown: _tapDown,
        onTapUp: _tapUp,
        child: Transform.scale(
          scale: _scale,
          child:

          Material(
            borderRadius: BorderRadius.circular(20.0),
            shadowColor: widget.shadowColor,
            color: widget.btnColor,
            elevation: 7.0,
            child:
           Center(
                child: Text(
                widget.text,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
              ),

          ),



        ),
      ),
    );
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }
  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }
}