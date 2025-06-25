import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/asset/assets.gen.dart';
import 'package:kshethra_mini/utils/components/back_button_component.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';


class AppBarWidget extends StatelessWidget {
  final String title;
  const AppBarWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {

    AppStyles styles = AppStyles();
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.screenHeight * 0.2,
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        image: DecorationImage(
          image: AssetImage(Assets.images.homeBackground.path),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          BackButtonComponent(),
          SizedBox(height:80 ,),
          Text(title.tr(), style: TextStyle(fontSize: 30,fontWeight: FontWeight.w300)),
          // BuildTextWidget(text: title, size: 20),
        ],
      ),
    );
  }
}
