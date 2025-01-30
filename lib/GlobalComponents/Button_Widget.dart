// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mobile_pos/constant.dart';
import 'Loading_Animation.dart';

class ButtonWidget extends StatelessWidget {
  final String btnText;
  final VoidCallback? onPress;
  final Color? color;
  final bool? isloading;

  const ButtonWidget({
    super.key,
    required this.btnText,
    this.onPress,
    this.color = AppColors.primaryColor,
    this.isloading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isloading == true ? null : onPress,
      style: ElevatedButton.styleFrom(
        shadowColor: const Color.fromARGB(255, 237, 137, 144),
        //primary: Theme.of(context).secondaryHeaderColor,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      child: isloading!
          ? const SpinKitWave(
              color: Colors.white,
              type: SpinKitWaveType.start,
              size: 20,
            )
          : Text(
              btnText.toUpperCase(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
    );
  }
}
