import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:record/record.dart';
import '../../../../core/themes.dart';

class BottomButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onTap;

  const BottomButton(this.title, this.icon, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Get.context!.theme.colorScheme.secondary,
        child: InkWell(
          onTap: () async {
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: FittedBox(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 75, color: Colors.white),
                      const SizedBox(width: 20),
                      Text(title, style: dts.copyWith(fontSize: 25)),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
