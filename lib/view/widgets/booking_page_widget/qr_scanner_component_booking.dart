import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/payment_complete_screen.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view/widgets/receipt_widget/receipt_foramte_booking.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:kshethra_mini/view_model/home_page_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScannerComponentBooking extends StatelessWidget {
  final String amount;
  final int noOfScreen;
  final String title;
  final String name;
  final String phone;
  final String acctHeadName;

  const QrScannerComponentBooking({
    super.key,
    required this.amount,
    required this.noOfScreen,
    required this.title,
    required this.name,
    required this.phone,
    required this.acctHeadName,
  });

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

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
                        text: 'amount_with_currency'.tr(
                          namedArgs: {'amount': amount.toString()},
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
                        data: homepageViewmodel.setQrAmount(amount),
                      ),
                      Text("demotemple@okicici", style: styles.blackRegular13),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            color: Colors.green,
                            textColor: Colors.white,
                            child: const Text("Booking Print"),
                            onPressed: () async {
                              final viewmodel = context.read<BookingViewmodel>();

                              try {
                                final response = await viewmodel.submitVazhipadu();

                                if (response.isEmpty) {
                                  throw Exception("No receipt data found.");
                                }

                                final templeList = viewmodel.templeList;
                                String templeName = 'Temple Name';
                                String templeAddress = 'Temple Address';
                                String templePhone = 'Temple Phone';

                                if (templeList.isNotEmpty) {
                                  final lastTemple = templeList.last;
                                  templeName = lastTemple.templeName;
                                  templeAddress = lastTemple.address;
                                  templePhone = lastTemple.phoneNumber;
                                }

                                final Map<String, Map<String, dynamic>> groupedMap = {};

                                for (final booking in response) {
                                  final serialNumber = booking['serialNumber']?.toString() ?? '';
                                  final poojaDate = DateFormat('dd/MM/yyyy').format(
                                    DateTime.tryParse(booking['startDate']?.toString() ?? '') ??
                                        DateTime.now(),
                                  );
                                  final postalCharge = double.tryParse(
                                    booking['postalCharge']?.toString() ?? '0',
                                  )?.toStringAsFixed(2) ?? '0.00';
                                  final devatha = viewmodel.selectedGods?.devathaName.toString() ?? '';

                                  final receiptList = booking['receipts'] as List<dynamic>? ?? [];

                                  if (!groupedMap.containsKey(serialNumber)) {
                                    groupedMap[serialNumber] = {
                                      'serialNumber': serialNumber,
                                      'poojaDate': poojaDate,
                                      'postalCharge': postalCharge,
                                      'devatha': devatha,
                                      'receipts': <Map<String, dynamic>>[],
                                    };
                                  }

                                  for (final receipt in receiptList) {
                                    final name = receipt['personName'] ?? '';
                                    final star = receipt['personStar'] ?? '';
                                    final offerName = receipt['offerName']?.toString() ?? '';
                                    final quantity = int.tryParse(
                                      receipt['quantity']?.toString() ?? '1',
                                    ) ?? 1;
                                    final rate = double.tryParse(
                                      receipt['rate']?.toString() ?? '0',
                                    ) ?? 0;

                                    groupedMap[serialNumber]!['receipts'].add({
                                      'offerName': offerName,
                                      'quantity': quantity,
                                      'rate': rate,
                                      'personName': name,
                                      'personStar': star,
                                    });
                                  }
                                }

                                final List<Map<String, dynamic>> groupedReceipts = groupedMap.values.toList();

                                for (int i = 0; i < groupedReceipts.length; i++) {
                                  print("Printing receipt ${i + 1} of ${groupedReceipts.length}");

                                  await ReceiptFormatterBooking.printGroupedReceipts(
                                    context,
                                    groupedReceipts: [groupedReceipts[i]],
                                    templeName: templeName,
                                    templeAddress: templeAddress,
                                    templePhone: templePhone,
                                  );

                                  print("Finished printing receipt ${i + 1}");
                                  await Future.delayed(const Duration(seconds: 2));
                                }


                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentCompleteScreen(
                                      amount: viewmodel.totalAmount.toStringAsFixed(2),
                                      noOfScreen: viewmodel.vazhipaduBookingList.length,
                                    ),
                                  ),
                                );
                              } catch (e) {
                                debugPrint("❌ Error during print: $e");

                              }
                            },
                          ),
                        ],
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
