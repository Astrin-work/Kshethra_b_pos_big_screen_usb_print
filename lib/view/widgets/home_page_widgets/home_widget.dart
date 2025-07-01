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
import '../../../model/api models/get_donation_model.dart';
import '../build_text_widget.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Consumer2<HomePageViewmodel, BookingViewmodel>(
      builder: (context, homepageViewmodel, bookingViewmodel, child) {
        final templeList = bookingViewmodel.templeList;
        final String welcomeText = templeList.isNotEmpty
            ? "Welcome ${templeList.last.templeName}"
            : "Welcome";

        return SizedBox(
          width: SizeConfig.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.050),
              BuildTextWidget(
                text: welcomeText,
                color: Colors.black,
                size: 28,
                fontWeight: FontWeight.w500,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppStyles().blackRegular25,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OptionSelectorWidget(
                    icon: SizedBox(
                      height: SizeConfig.screenHeight * 0.052,
                      child: Image.asset(Assets.icons.pray.path),
                    ),
                    titleWidget: BuildTextWidget(
                      text: 'Vazhipaddu Booking'.tr(),
                      color: Colors.black,
                      size: 16,
                      fontWeight: FontWeight.w500,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style:AppStyles().blackSemi15 ,
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
                    titleWidget: BuildTextWidget(
                      text: 'Advance Booking'.tr(),
                      color: Colors.black,
                      size: 16,
                      fontWeight: FontWeight.w500,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style:AppStyles().blackSemi15 ,
                    ),
                    onTap: () {
                      homepageViewmodel.preBookingPageNavigate(context);
                    },
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.screenHeight * 0.020),

              /// Second Row: Donation Options
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
                      text: 'E- Bhandaram'.tr(),
                      color: Colors.black,
                      size: 16,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style:AppStyles().blackSemi15 ,
                    ),
                    onTap: () {
                      homepageViewmodel.eHundiPageNavigate(context);
                    },
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.screenHeight * 0.010),
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

