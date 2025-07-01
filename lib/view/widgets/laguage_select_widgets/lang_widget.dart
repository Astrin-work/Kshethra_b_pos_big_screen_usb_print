import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/model/demo_model/temple_model.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_styles.dart';
import '../../../utils/asset/assets.gen.dart';
import '../../../utils/components/size_config.dart';
import '../../../view_model/home_page_viewmodel.dart';

class LangWidget extends StatelessWidget {
  final String lang;
  final String disc;
  final Locale locale;

  const LangWidget({
    super.key,
    required this.lang,
    required this.disc,
    required this.locale,

  });

  @override
  Widget build(BuildContext context) {

    AppStyles styles = AppStyles();
    SizeConfig().init(context);
    return Consumer<HomePageViewmodel>(
      builder: (context, homepageViewmodel, child) => InkWell(
        // onTap: () {
        //   homepageViewmodel.updateLanguage(locale.languageCode);
        //   homepageViewmodel.homePageNavigate(context);
        //
        // },
        onTap: () async {
          print('hi' * 100);

          final bookingViewmodel = Provider.of<BookingViewmodel>(context, listen: false);
          await bookingViewmodel.fetchTempleData();

          if (bookingViewmodel.templeList.isNotEmpty) {
            print(bookingViewmodel.templeList.first.templeName);
          } else {
            print("No temple data found.");
          }

          await context.setLocale(Locale(locale.languageCode));
          homepageViewmodel.updateLanguage(locale.languageCode);
          homepageViewmodel.homePageNavigate(context);
        },


        child: Container(
          height:SizeConfig.screenHeight*0.15,
          width: SizeConfig.screenWidth*0.25,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.images.langBackground.path),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(lang, style: styles.blackRegular22),
              Text(disc, style: styles.blackRegular22),
            ],
          ),
        ),
      ),
    );
  }
}
