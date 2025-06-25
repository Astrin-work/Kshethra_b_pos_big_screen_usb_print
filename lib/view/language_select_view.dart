import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/asset/assets.gen.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/widgets/laguage_select_widgets/language_box.dart';
import 'package:kshethra_mini/view_model/home_page_viewmodel.dart';
import 'package:provider/provider.dart';

class LanguageSelectView extends StatelessWidget {
  const LanguageSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Consumer<HomePageViewmodel>(
        builder:
            (context, homepageViewmodel, child) => Column(
              children: [
                Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    image: DecorationImage(
                      image: AssetImage(
                        Assets.images.loardShivaBackground.path,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: SizeConfig.screenWidth * 0.05,
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(left: 100,top: 100),
                        child: Image.asset(
                          fit: BoxFit.fill,
                          // width: SizeConfig.screenWidth * 0.4,
                          width: 100,
                          Assets.icons.astrinsKshethraLogo.path,
                        ),
                      ),
                    ),
                  ),
                ),
                LanguageBox(),
              ],
            ),
      ),
    );
  }
}







