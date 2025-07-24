import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:kshethra_mini/view_model/donation_viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../api_services/api_service.dart';
import '../../../utils/components/snack_bar_widget.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/components/app_bar_widget.dart';
import '../../../utils/components/size_config.dart';
import '../../../view/payment_complete_screen.dart';
import '../../../view/widgets/build_text_widget.dart';
import '../receipt_widget/receipt_foramte_donation.dart';

class QrScannerComponentDonations extends StatelessWidget {
  final String amount;
  final int noOfScreen;
  final String title;
  final String name;
  final String phone;
  final String acctHeadName;
  final String address;


  const QrScannerComponentDonations({
    super.key,
    required this.amount,
    required this.noOfScreen,
    required this.title,
    required this.name,
    required this.phone,
    required this.acctHeadName,
    required this.address,
  });

  // ✅ Fixed: This returns a Map, not bool
  Future<Map<String, dynamic>?> postDonation(BuildContext context) async {
    final donationData = {
      "name": name,
      "phoneNumber": phone,
      "acctHeadName": acctHeadName,
      "amount": amount,
      "address": address,
      "paymentType": "Cash",
      "transactionId": "txn_${DateTime.now().millisecondsSinceEpoch}",
      "bankId": "CASH001",
      "bankName": "Cash Payment",
    };

    try {
      final response = await ApiService().postDonationDetails(donationData);
      print("✅ API Response: $response");

      if (response.isEmpty) {
        throw Exception("❌ No receipt data found.");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Donation posted successfully!",
          color: Colors.green,
        ).build(context),
      );

      return response;
    } catch (e) {
      print("❌ API Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Failed to post donation: $e",
          color: Colors.red,
        ).build(context),
      );
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    final styles = AppStyles();
    SizeConfig().init(context);

    return Scaffold(
      body: Column(
        children: [
          AppBarWidget(title: title.tr()),
          SizedBox(
            height: SizeConfig.screenHeight * 0.8,
            width: SizeConfig.screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BuildTextWidget(
                  text: 'amount_with_currency'.tr(
                    namedArgs: {'amount': amount},
                  ),
                  color: kBlack,
                  size: 50,
                  fontWeight: FontWeight.w400,
                ),
                BuildTextWidget(
                  text: 'scan_qr_to_pay'.tr(),
                  color: kBlack,
                  size: 18,
                  fontWeight: FontWeight.w300,
                  textAlign: TextAlign.center,
                ),
                QrImageView(
                  size: 300,
                  data: context.watch<DonationViewmodel>().setQrAmount(amount),
                ),
                Text("demotemple@okicici", style: styles.blackRegular13),
                MaterialButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: const Text("Donation Print"),
                  onPressed: () async {
                    final viewmodel = context.read<BookingViewmodel>();
                    try {
                      final response = await postDonation(context);

                      if (response!.isEmpty) {
                        throw Exception("No receipt data found.");
                      }


                      final templeList = viewmodel.templeList;
                      String templeName = 'Temple Name';
                      String templeAddress = 'Temple Address';
                      String templePhone = 'Temple Phone';

                      if (templeList.isNotEmpty) {
                        final lastTemple = templeList.last;
                        templeName = lastTemple.templeName ?? templeName;
                        templeAddress = lastTemple.address ?? templeAddress;
                        templePhone = lastTemple.phoneNumber ?? templePhone;
                      }

                      // 🕒 Get current system date/time
                      final String currentDate = DateFormat("dd-MM-yyyy").format(DateTime.now());

                      await ReceiptForamteDonation.printDonationReceipt(
                        context,
                        receiptNo: response['receiptId']?.toString() ?? '',
                        date: currentDate, // Use system date
                        name: response['name'] ?? '',
                        phoneNumber: response['phoneNumber'] ?? '',
                        address: response['address'] ?? '',
                        amount: response['amount'].toString(),
                        acctHead: response['acctHeadName'] ?? '',
                        templeName: templeName,
                        templeAddress: templeAddress,
                        templePhone: templePhone,
                        dateTime: currentDate, phone: '', groupedReceipts: [], postDonation: [],
                      );
                      print('---------- Passing Details ---------');
                      print("Receipt No: ${response['receiptId']}");
                      print("Date: $currentDate");
                      print("Name: ${response['name']}");
                      print("Phone: ${response['phoneNumber']}");
                      print("Address: ${response['address']}");
                      print("Amount: ${response['amount']}");
                      print("Account Head: ${response['acctHeadName']}");
                      print("Temple: $templeName, $templeAddress, $templePhone");

                      // ✅ Navigate to success screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentCompleteScreen(
                            noOfScreen: noOfScreen,
                            amount: amount,
                          ),
                        ),
                      );
                    } catch (e) {
                      print("❌ Error during print: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed to print receipt. ${e.toString()}"),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
