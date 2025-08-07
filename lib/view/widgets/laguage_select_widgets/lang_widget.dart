import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/api_services/api_service.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_styles.dart';
import '../../../utils/asset/assets.gen.dart';
import '../../../utils/components/size_config.dart';
import '../../../utils/hive/hive.dart';
import '../../../view_model/home_page_viewmodel.dart';

class LangWidget extends StatefulWidget {
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
  State<LangWidget> createState() => _LangWidgetState();
}

class _LangWidgetState extends State<LangWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();
    SizeConfig().init(context);

    return Consumer<HomePageViewmodel>(
      builder: (context, homepageViewmodel, child) => InkWell(
        onTap: () async {
          if (isLoading) return;

          setState(() => isLoading = true);

          try {
            print('Selected Language: ${widget.disc} (${widget.locale.languageCode})');

            await appHive.putLanguage(widget.locale.languageCode, widget.locale.languageCode);
            print("Saved language: ${appHive.getLanguage()}");

            await appHive.putName(widget.disc, widget.locale.languageCode);
            print("Saved display name: ${appHive.getName()}");

            final bookingViewmodel = Provider.of<BookingViewmodel>(context, listen: false);
            await bookingViewmodel.fetchTempleData();

            if (bookingViewmodel.templeList.isNotEmpty) {
              print(bookingViewmodel.templeList.first.templeName);
            } else {
              print("No temple data found.");
            }

            bookingViewmodel.fetchTempleName();

            await context.setLocale(Locale(widget.locale.languageCode));
            homepageViewmodel.updateLanguage(widget.locale.languageCode);
            homepageViewmodel.homePageNavigate(context);
          } catch (e) {
            print("Error: $e");
          } finally {
            if (mounted) setState(() => isLoading = false);
          }
        },
        child: Container(
          height: SizeConfig.screenHeight * 0.12,
          width: SizeConfig.screenWidth * 0.22,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.images.langBackground.path),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: isLoading
              ? const Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(strokeWidth: 2,color: Colors.black,),
            ),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.lang, style: styles.blackRegular22),
              Text(widget.disc, style: styles.blackRegular22),
            ],
          ),
        ),
      ),
    );
  }
}
