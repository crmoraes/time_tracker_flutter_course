import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/common_widget/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({Key? key,
    required String text,
    required Color color,
    required Color textColor,
    VoidCallback? onPressed,
  }) : super(key: key,
    child: Text(text, style: TextStyle(color: textColor, fontSize: 15.0,)),
    color: color,
    onPressed: onPressed,
  );
}