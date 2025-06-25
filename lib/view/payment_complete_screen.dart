import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/asset/assets.gen.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view_model/home_page_viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PaymentCompleteScreen extends StatelessWidget {
  final String amount;
  final int noOfScreen;
  const PaymentCompleteScreen({
    super.key,
    required this.amount,
    required this.noOfScreen,
  });

  @override
  Widget build(BuildContext context) {
    final currentLang = Provider.of<HomePageViewmodel>(context).currentLanguage;
    AppStyles styles = AppStyles();
    SizeConfig().init(context);
    return Scaffold(
      body: Consumer<HomePageViewmodel>(
        builder:
            (context, homepageViewmodel, child) => SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    12.kH,
                    // Text("Amount : ₹ $amount", style: styles.blackRegular22),
                    BuildTextWidget(
                      text: "Amount ₹ $amount",
                      color: kBlack,
                      size: 23,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.45,
                      child: Lottie.asset(Assets.gifs.paymentSuccess,repeat: false),
                    ),
                    Text(
                      "Your payment was sucessfull".tr(),
                      style: styles.blackRegular18,
                      textAlign: TextAlign.center,
                    ),
                    Text("Thank You !", style: styles.primBold22).tr(),
                    25.kH,
                    MaterialButton(
                      onPressed: () {
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => HomeView()),
                        //   (Route<dynamic> route) => false,
                        // );
                        homepageViewmodel.backtoHomePageView(context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minWidth: SizeConfig.screenWidth * .05,
                      color: kPrimaryColor,
                      child: Text(
                        "Back to Home".tr(),
                        style: styles.blackRegular15,
                      ),
                    ),
                    12.kH,
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
