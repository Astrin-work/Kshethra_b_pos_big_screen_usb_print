import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/utils/validation.dart';
import 'package:kshethra_mini/view_model/donation_viewmodel.dart';
import 'package:provider/provider.dart';

class DonationDialogWidget extends StatelessWidget {
  final String name;
  final String phone;
  final String acctHeadName;

  const DonationDialogWidget({
    super.key,
    required this.name,
    required this.phone,
    required this.acctHeadName,
  });

  // Future<bool> postDonation(BuildContext context) async {
  //   final donationViewmodel = Provider.of<DonationViewmodel>(
  //     context,
  //     listen: false,
  //   );
  //
  //   final donationData = {
  //     "name": name,
  //     "phoneNumber": phone,
  //     "acctHeadName": acctHeadName,
  //     "amount": donationViewmodel.donationAmountController.text.trim(),
  //     "paymentType": "UPI",
  //     "transactionId": "txn_${DateTime.now().millisecondsSinceEpoch}",
  //     "bankId": "BANK001",
  //     "bankName": "Test Bank",
  //   };
  //
  //   try {
  //     await ApiService().postDonationDetails(donationData);
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Donation posted successfully!")));
  //     return true;
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Failed to post donation: $e")));
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();
    SizeConfig().init(context);

    return AlertDialog(
      title: Consumer<DonationViewmodel>(
        builder:
            (context, donationViewmodel, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Amount".tr(),
                    style: styles.blackRegular18,
                  ),
                ),
                10.kH,
                Form(
                  key: donationViewmodel.donationKey,
                  child: TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    validator:
                        (value) => Validation.numberValidation(
                          value,
                          "Enter a amount",
                          "Invalid amount",
                        ),
                    controller: donationViewmodel.donationAmountController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: donationViewmodel.clearDonationAmount,
                        icon: Icon(Icons.close),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                10.kH,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        final donationViewmodel =
                            Provider.of<DonationViewmodel>(
                              context,
                              listen: false,
                            );

                        if (donationViewmodel.donationKey.currentState
                                ?.validate() ??
                            false) {
                          final amount =
                              donationViewmodel.donationAmountController.text
                                  .trim();
                          print("-----------amount---------");
                          print(amount);
                          donationViewmodel.navigateToPaymentMethodPage(
                            context,
                            amount,
                            name,
                            phone,
                            acctHeadName,
                          );
                        }
                      },
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: kDullPrimaryColor, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text("Pay".tr()),
                    ),

                    MaterialButton(
                      onPressed: () {
                        donationViewmodel.popFunction(context);
                        donationViewmodel.clearDonationAmount();
                      },
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: kDullPrimaryColor, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text("Cancel".tr()),
                    ),
                  ],
                ),
              ],
            ),
      ),
    );
  }
}
