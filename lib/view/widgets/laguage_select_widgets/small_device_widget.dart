import 'package:flutter/material.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/components/size_config.dart';
import 'lang_widget.dart';

class SmallDeviceWidget extends StatelessWidget {
  const SmallDeviceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();
    SizeConfig().init(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Select your language", style: styles.blackRegular22),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LangWidget(lang: "ആ", disc: "മലയാളം", locale: Locale('ml')),
            const SizedBox(width: 20),
            LangWidget(lang: "EN", disc: "English", locale: Locale('en')),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LangWidget(lang: "ஆ", disc: "தமிழ்", locale: Locale('ta')),
            const SizedBox(width: 20),
            LangWidget(lang: "ಆ", disc: "ಕನ್ನಡ", locale: Locale('kn')),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LangWidget(lang: "ఆ", disc: "తెలుగు", locale: Locale('te')),
            const SizedBox(width: 20),
            LangWidget(lang: "आ", disc: "हिंदी", locale: Locale('hi')),
          ],
        ),
      ],
    );
  }
}
