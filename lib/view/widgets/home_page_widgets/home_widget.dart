import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/asset/assets.gen.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/widgets/home_page_widgets/option_selector_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:kshethra_mini/view_model/home_page_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../api_services/api_service.dart';
import '../build_text_widget.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final fromLang = "en";
    return Consumer2<HomePageViewmodel, BookingViewmodel>(
      builder: (context, homepageViewmodel, bookingViewmodel, child) {
        final templeList = bookingViewmodel.templeNameList;
        final templeName = templeList.isNotEmpty
            ? templeList.last
            : 'Temple name not available';
        return SizedBox(
          width: SizeConfig.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.025),
              BuildTextWidget(
                text: 'Welcome'.tr(),
                color: Colors.black,
                size: 28,
                fontWeight: FontWeight.w500,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppStyles().blackRegular25,
                // fromLang: fromLang,
              ),
              BuildTextWidget(
                text: templeName,
                color: Colors.black,
                size: 28,
                fontWeight: FontWeight.w500,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppStyles().blackRegular25,
                fromLang: fromLang,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OptionSelectorWidget(
                    icon: SizedBox(
                      height: SizeConfig.screenHeight * 0.052,
                      child: Image.asset(Assets.icons.pray.path),
                    ),
                    titleWidget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BuildTextWidget(
                          text:'Vazhipaddu'.tr(),
                          color: Colors.black,
                          size: 16,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                          style: AppStyles().blackSemi15,
                          fromLang: fromLang,
                        ),
                        BuildTextWidget(
                          text: 'Booking'.tr(),
                          color: Colors.black,
                          size: 16,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                          style: AppStyles().blackSemi15,
                          fromLang: fromLang,
                        ),
                      ],
                    ),

                    onTap: () {
                      homepageViewmodel.bookingPageNavigate(context);
                    },
                  ),
                  SizedBox(width: SizeConfig.screenWidth * 0.05),
                  OptionSelectorWidget(
                    icon: SizedBox(
                      height: SizeConfig.screenHeight * 0.045,
                      child: Image.asset(Assets.icons.preBooking.path),
                    ),
                    titleWidget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BuildTextWidget(
                          text:'Adavance'.tr(),
                          color: Colors.black,
                          size: 16,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                          style: AppStyles().blackSemi15,
                          fromLang: fromLang,
                        ),
                        BuildTextWidget(
                          text: 'Booking'.tr(),
                          color: Colors.black,
                          size: 16,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                          style: AppStyles().blackSemi15,
                          fromLang: fromLang,
                        ),
                      ],
                    ),

                    onTap: () {
                      homepageViewmodel.preBookingPageNavigate(context);
                    },
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.screenHeight * 0.020),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OptionSelectorWidget(
                    icon: SizedBox(
                      height: SizeConfig.screenHeight * 0.050,
                      child: Image.asset(Assets.icons.donation.path),
                    ),
                    titleWidget: BuildTextWidget(
                      text: 'Donations'.tr(),
                      color: Colors.black,
                      size: 16,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style:AppStyles().blackSemi15 ,
                    ),
                    onTap: () async {
                      try {
                        await ApiService().getDonation();
                        homepageViewmodel.donationPageNavigate(context);
                      } catch (e) {
                        print('Error while fetching donations: $e');
                      }
                    },
                  ),
                  SizedBox(width: SizeConfig.screenWidth * 0.05),
                  OptionSelectorWidget(
                    icon: SizedBox(
                      height: SizeConfig.screenHeight * 0.050,
                      child: Image.asset(Assets.icons.eHundi.path),
                    ),
                    titleWidget: BuildTextWidget(
                      text: 'E-Bhandaram'.tr(),
                      color: Colors.black,
                      size: 16,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style:AppStyles().blackSemi15 ,
                      // fromLang: fromLang,
                    ),
                    onTap: () {
                      homepageViewmodel.eHundiPageNavigate(context);
                    },
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.screenHeight * 0.030),
              SizedBox(
                height: SizeConfig.screenHeight * 0.070,
                child: Image.asset(Assets.icons.astrinsLogo.path),
              ),
            ],
          ),
        );
      },
    );
  }

}

