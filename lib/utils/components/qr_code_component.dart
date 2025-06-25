import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/payment_complete_screen.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view_model/home_page_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';


class QrScannerComponent extends StatelessWidget {
  final String amount;
  final int noOfScreen;
  final String title;
  const QrScannerComponent({
    super.key,
    required this.amount,
    required this.noOfScreen,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    final currentLang = Provider.of<HomePageViewmodel>(context).currentLanguage;
    AppStyles styles = AppStyles();
    SizeConfig().init(context);
    return Scaffold(
      body: Consumer<HomePageViewmodel>(
        builder:

            (context, homepageViewmodel, child) => Column(
              children: [
                AppBarWidget(title: title.tr()),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.8,
                  width: SizeConfig.screenWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BuildTextWidget(
                        text: "Amount ₹" "$amount",
                        color: kBlack,
                        size: 23,
                        fontWeight: FontWeight.w400,

                      ),
                      // Text("Amount ₹ $amount", style: styles.blackRegular22),
                      BuildTextWidget(
                        text:   "Scan this QR Code to pay",
                        color: kBlack,
                        size: 18,
                        fontWeight: FontWeight.w300,

                        textAlign: TextAlign.center,
                      ),

                      QrImageView(
                        size: 300,
                        data: homepageViewmodel.setQrAmount(amount),
                      ),
                      Text("demotemple@okicici", style: styles.blackRegular13),
                      MaterialButton(
                        child: Text("data"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentCompleteScreen(
                                amount: amount,
                                noOfScreen: noOfScreen,
                              ),
                            ),
                          );
                        },
                      ),

                    ],
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
