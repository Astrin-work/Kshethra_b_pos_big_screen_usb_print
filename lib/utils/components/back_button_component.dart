import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/asset/assets.gen.dart';

class BackButtonComponent extends StatelessWidget {
  const BackButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 7.0,top: 10),
        child: Container(
          height: 30,
          alignment: Alignment.topLeft,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              //     color: kWhite,
              Assets.icons.backArrow.path,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
