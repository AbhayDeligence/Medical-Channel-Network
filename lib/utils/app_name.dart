import 'package:flutter/material.dart';

class AppName extends StatelessWidget {
  final double fontSize;
  const AppName({Key? key, required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          height: 20,
          image: AssetImage('assets/images/icon.png'),
          fit: BoxFit.cover,
        ),
        SizedBox(
          width: 10,
        ),
        RichText(
          text: TextSpan(
            text: 'Medical',
            style: TextStyle(
                fontFamily: 'Archivo',
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                color: Colors.blue[800]),
            children: <TextSpan>[
              TextSpan(
                  text: ' Channel',
                  style: TextStyle(
                      fontFamily: 'Archivo', color: Colors.blue[800])),
            ],
          ),
        ),
      ],
    );
  }
}
