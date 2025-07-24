import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/model/api%20models/E_Hundi_Get_Devatha_Model.dart';
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
import '../receipt_widget/receipt_foramte_donation.dart';
import '../receipt_widget/receipt_foramte_e_bhandaram.dart';

class QrScannerComponentEHundi extends StatefulWidget {
  final String amount;
  final int noOfScreen;
  final String title;
  final String name;
  final String phone;
  final String devathaName;
  const QrScannerComponentEHundi({
    super.key,
    required this.amount,
    required this.noOfScreen,
    required this.title,
    required this.name,
    required this.phone,
    required this.devathaName,


  });

  @override
  State<QrScannerComponentEHundi> createState() =>
      _QrScannerComponentEHundiState();
}

class _QrScannerComponentEHundiState extends State<QrScannerComponentEHundi> {
  bool isLoading = false;




  Future<Map<String, dynamic>?> postEbannaramiDonation(
      BuildContext context,
      int index,
      String amount, {
        required String name,
        required String phone,
      }) async {
    try {
      // Safely access devathaName from gods list

      final bookingViewmodel = Provider.of<BookingViewmodel>(context, listen: false);
      final star = bookingViewmodel.storedSelectedStar ?? '';
      final data = {
        "devathaName":widget.devathaName,
        "amount": int.tryParse(amount) ?? 0,
        "personName": name,
        "phoneNumber": phone,
        "personStar": star,
        "paymentType": "cash",
        "transactionId": "asdf",
        "bankId": "asd",
        "bankName": "asdf",
      };

      // Print payload for debugging
      print("📤 Payload for E-Hundi Donation:");
      data.forEach((key, value) => print("  $key: $value"));

      final response = await ApiService().postEHundiDetails(data);

      if (response != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarWidget(
            msg: "Donation posted successfully!",
            color: Colors.green,
          ).build(context),
        );
        return response;
      }
    } catch (e) {
      final errorMessage = e.toString();
      debugPrint("❌ Error posting E-Hundi: $errorMessage");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarWidget(
            msg: "Failed to post donation: $errorMessage",
            color: Colors.red,
          ).build(context),
        );
      }
    }

    return null;
  }



  @override
  Widget build(BuildContext context) {
    final currentLang = Provider.of<HomePageViewmodel>(context).currentLanguage;
    final eHundiViewModel = Provider.of<EHundiViewmodel>(
      context,
      listen: false,
    );
    final int index = eHundiViewModel.selectedIndex;

    AppStyles styles = AppStyles();
    SizeConfig().init(context);
    final bookingViewModel = Provider.of<BookingViewmodel>(context, listen: false);
    final templeList = bookingViewModel.templeList;

    String templeName = 'Temple Name';
    String templeAddress = 'Temple Address';
    String templePhone = 'Temple Phone';

    if (templeList.isNotEmpty) {
      final lastTemple = templeList.last;
      templeName = lastTemple.templeName ?? templeName;
      templeAddress = lastTemple.address ?? templeAddress;
      templePhone = lastTemple.phoneNumber ?? templePhone;
    }
    return Scaffold(
      body: Consumer<HomePageViewmodel>(
        builder:
            (context, homepageViewmodel, child) => Column(
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
                          ? const CircularProgressIndicator(
                            color: kDullPrimaryColor,
                          ): MaterialButton(
                            color: Colors.green,
                            textColor: Colors.white,
                            child: const Text("Donation Print"),
                          onPressed: () async {
                            final response = await postEbannaramiDonation(
                              context,
                              index,
                              widget.amount,
                              name: widget.name,
                              phone: widget.phone,
                            );

                            final String currentDate = DateFormat("dd-MM-yyyy").format(DateTime.now());

                            if (response != null) {
                              ReceiptFormatterEBhandaram.printEBhandaramReceipt(
                                context,
                                name: response['personName'] ?? '',
                                star: response['personStar'] ?? '',
                                amount: response['amount'].toString(),
                                devathaName: response['devathaName'] ?? '',
                                receiptId: response['receiptId'].toString(),
                                receiptNumber: response['chequeId']?.toString() ?? '', // ✅ Use chequeId as receipt number
                                templeName: templeName,
                                templeAddress: templeAddress,
                                templePhone: templePhone,
                                receiptDate: currentDate,
                              );

                              print('Temple Details:');
                              print(templeName);
                              print(templeAddress);
                              print(templePhone);
                              print("Receipt No: ${response['chequeId']}");
                            }
                          }


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
