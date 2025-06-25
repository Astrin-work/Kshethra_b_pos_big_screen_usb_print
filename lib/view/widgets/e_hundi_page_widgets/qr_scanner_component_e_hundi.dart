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

import '../../../api_services/api_service.dart';
import '../../../utils/components/snack_bar_widget.dart';
import '../../../view_model/booking_viewmodel.dart';
import '../../../view_model/e_hundi_viewmodel.dart';

class QrScannerComponentEHundi extends StatefulWidget {
  final String amount;
  final int noOfScreen;
  final String title;
  final String name;
  final String phone;

  const QrScannerComponentEHundi({
    super.key,
    required this.amount,
    required this.noOfScreen,
    required this.title,
    required this.name,
    required this.phone,
  });

  @override
  State<QrScannerComponentEHundi> createState() => _QrScannerComponentEHundiState();
}

class _QrScannerComponentEHundiState extends State<QrScannerComponentEHundi> {
  bool isLoading = false;

  Future<bool> postEbannaramiDonation(BuildContext context, int index) async {
    final eHundiViewModel = Provider.of<EHundiViewmodel>(context, listen: false);
    final bookingViewModel = Provider.of<BookingViewmodel>(context, listen: false);

    final data = {
      "devathaName": eHundiViewModel.gods[index].devathaName,
      "amount": widget.amount,
      "personName": widget.name,
      "phoneNumber": widget.phone,
      "personStar": bookingViewModel.selectedStar,
      "paymentType": "lsk",
      "transactionId": "11221",
      "bankId": "131333",
      "bankName": "sbi"
    };

    try {
      await ApiService().postEHundiDetails(data);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarWidget(
            msg: "Donation posted successfully!",
            color: Colors.green,
          ).build(context),
        );
      }
      return true;
    } catch (e) {
      final errorMessage = e.toString();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarWidget(
            msg: "Failed to post donation: $errorMessage",
            color: Colors.red,
          ).build(context),
        );
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = Provider.of<HomePageViewmodel>(context).currentLanguage;
    final eHundiViewModel = Provider.of<EHundiViewmodel>(context, listen: false);
    final int index = eHundiViewModel.selectedIndex;

    AppStyles styles = AppStyles();
    SizeConfig().init(context);

    return Scaffold(
      body: Consumer<HomePageViewmodel>(
        builder: (context, homepageViewmodel, child) => Column(
          children: [
            AppBarWidget(title: widget.title.tr()),
            SizedBox(
              height: SizeConfig.screenHeight * 0.8,
              width: SizeConfig.screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BuildTextWidget(
                    text: "Amount ₹${widget.amount}",
                    color: kBlack,
                    size: 23,
                    fontWeight: FontWeight.w400,
                  ),
                  BuildTextWidget(
                    text: "Scan this QR Code to pay",
                    color: kBlack,
                    size: 18,
                    fontWeight: FontWeight.w300,
                    textAlign: TextAlign.center,
                  ),
                  QrImageView(
                    size: 300,
                    data: homepageViewmodel.setQrAmount(widget.amount),
                  ),
                  Text("demotemple@okicici", style: styles.blackRegular13),
                  isLoading
                      ? const CircularProgressIndicator(color: kDullPrimaryColor,)
                      : MaterialButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    child: const Text("Submit Payment"),
                    onPressed: () async {
                      setState(() => isLoading = true);
                      final success = await postEbannaramiDonation(context, index);
                      setState(() => isLoading = false);
                      if (success && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentCompleteScreen(
                              amount: widget.amount,
                              noOfScreen: widget.noOfScreen,
                            ),
                          ),
                        );
                      }
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

