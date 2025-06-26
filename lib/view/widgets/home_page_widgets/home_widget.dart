import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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

    final bookingViewmodel = Provider.of<BookingViewmodel>(context, listen: false);
    final templeList = bookingViewmodel.templeList;

    return Consumer<HomePageViewmodel>(
      builder: (context, homepageViewmodel, child) {
        final String welcomeText = templeList.isNotEmpty
            ? "Welcome ${templeList.first.templeName}"
            : "Welcome";

        return SizedBox(
          width: SizeConfig.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              BuildTextWidget(
                text: welcomeText, // Safe and dynamic
                color: Colors.black,
                size: 28,
                fontWeight: FontWeight.w500,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // Row 1
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OptionSelectorWidget(
                    icon: SizedBox(
                      height: 52,
                      child: Image.asset(Assets.icons.pray.path),
                    ),
                    titleWidget: BuildTextWidget(
                      text: 'Vazhipaddu Booking'.tr(),
                      color: Colors.black,
                      size: 16,
                      fontWeight: FontWeight.w500,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      homepageViewmodel.bookingPageNavigate(context);
                    },
                  ),
                  const SizedBox(width: 40),
                  OptionSelectorWidget(
                    icon: SizedBox(
                      height: 45,
                      child: Image.asset(Assets.icons.preBooking.path),
                    ),
                    titleWidget: BuildTextWidget(
                      text: 'Advance Booking'.tr(),
                      color: Colors.black,
                      size: 16,
                      fontWeight: FontWeight.w500,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      homepageViewmodel.preBookingPageNavigate(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Row 2
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OptionSelectorWidget(
                    icon: SizedBox(
                      height: 50,
                      child: Image.asset(Assets.icons.donation.path),
                    ),
                    titleWidget: BuildTextWidget(
                      text: 'Donations'.tr(),
                      color: Colors.black,
                      size: 16,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                    onTap: () async {
                      try {
                        List<Getdonationmodel> donationList =
                        await ApiService().getDonation();
                        homepageViewmodel.donationPageNavigate(context);
                      } catch (e) {
                        print('Error while fetching donations: $e');
                      }
                    },
                  ),
                  const SizedBox(width: 40),
                  OptionSelectorWidget(
                    icon: SizedBox(
                      height: 50,
                      child: Image.asset(Assets.icons.eHundi.path),
                    ),
                    titleWidget: BuildTextWidget(
                      text: 'E- Bhandaram'.tr(),
                      color: Colors.black,
                      size: 16,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      homepageViewmodel.eHundiPageNavigate(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),
              SizedBox(
                height: 70,
                child: Image.asset(Assets.icons.astrinsLogo.path),
              ),
            ],
          ),
        );
      },
    );
  }
}

