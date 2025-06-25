import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // For Locale
import '../../../utils/app_styles.dart';
import '../../../utils/asset/assets.gen.dart';
import '../../../utils/components/size_config.dart';
import 'lang_widget.dart';

class LargeDeviceWidget extends StatelessWidget {
  const LargeDeviceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();
    SizeConfig().init(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50,),
        Text("Select your language",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w400),),
        SizedBox(height: 100),

        Wrap(
          spacing: 40,          // No horizontal space between items
          runSpacing:50 ,       // Minimal vertical space between rows
          alignment: WrapAlignment.center,
          children: const [
            LangWidget(lang: "EN", disc: "English", locale: Locale('en')),
            LangWidget(lang: "മ", disc: "മലയാളം", locale: Locale('ml')),
            LangWidget(lang: "ஆ", disc: "தமிழ்", locale: Locale('ta')),
            LangWidget(lang: "ಆ", disc: "ಕನ್ನಡ", locale: Locale('kn')),
            LangWidget(lang: "ఆ", disc: "తెలుగు", locale: Locale('te')),
            LangWidget(lang: "आ", disc: "हिंदी", locale: Locale('hi')),

          ],
        ),
        SizedBox(height: 80,),
        Image.asset(
          fit: BoxFit.fill,
          // width: SizeConfig.screenWidth * 0.4,
          height: 70,
          Assets.icons.astrinsLogo.path,
        )
      ],
    );
  }
}
