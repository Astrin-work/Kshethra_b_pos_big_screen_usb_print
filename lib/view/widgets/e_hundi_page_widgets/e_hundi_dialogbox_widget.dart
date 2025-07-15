import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/utils/validation.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view/widgets/e_hundi_page_widgets/payment_method_screen_e_hundi.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/star_dialodbox_widget.dart';
import 'package:kshethra_mini/view_model/e_hundi_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../utils/components/responsive_layout.dart';
import '../../../view_model/booking_viewmodel.dart';

class EHundiDialogWidget extends StatefulWidget {
  const EHundiDialogWidget({super.key});

  @override
  State<EHundiDialogWidget> createState() => _EHundiDialogWidgetState();
}

class _EHundiDialogWidgetState extends State<EHundiDialogWidget> {
  late TextEditingController amountController;
  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<EHundiViewmodel>(context, listen: false);
    amountController = viewModel.eHundiAmountController;
    nameController = viewModel.eHundiNameController;
    phoneController = viewModel.eHundiPhoneController;
  }

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();
    SizeConfig().init(context);

    return AlertDialog(
      content: Consumer<EHundiViewmodel>(
        builder:
            (context, eHundiViewmodel, child) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: eHundiViewmodel.eHundiKey,
                      child: Column(
                        children: [
                          TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            validator:
                                (value) => Validation.numberValidation(
                                  value,
                                  "Enter an amount",
                                  "Enter a valid amount",
                                ),
                            controller: amountController,
                            textAlign: TextAlign.start,
                            style: styles.blackRegular13,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: eHundiViewmodel.clearHundiAmount,
                                icon: const Icon(Icons.close),
                              ),
                              label: RichText(
                                text: TextSpan(
                                  text: 'Amount'.tr(),
                                  style: styles.blackRegular15,
                                  children: const [
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: kDullPrimaryColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          10.kH,
                          TextFormField(
                            controller: nameController,
                            style: styles.blackRegular13,
                            decoration: InputDecoration(
                              hintText: "Enter your Name (optional)".tr(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: kDullPrimaryColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          10.kH,
                          TextFormField(
                            controller: phoneController,
                            style: styles.blackRegular13,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            decoration: InputDecoration(
                              hintText: "Phone".tr(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: kDullPrimaryColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          10.kH,
                          Consumer<BookingViewmodel>(
                            builder:
                                (context, bookingViewmodel, _) =>
                                    MaterialButton(
                                      minWidth: 250,
                                      height: 50,
                                      padding:  EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.grey,
                                          width: 1.2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) => ResponsiveLayout(
                                                pinelabDevice: StarDialogBox(),
                                                mediumDevice: StarDialogBox(
                                                  borderRadius: 25,
                                                  mainAxisSpace: 30,
                                                  crossAxisSpace: 45,
                                                ),
                                                semiMediumDevice: StarDialogBox(
                                                  borderRadius: 25,
                                                  mainAxisSpace: 30,
                                                  crossAxisSpace: 45,
                                                  axisCount: 3,
                                                ),
                                                semiLargeDevice: StarDialogBox(
                                                  borderRadius: 30,
                                                  mainAxisSpace: 30,
                                                  crossAxisSpace: 45,
                                                  axisCount: 3,
                                                ),
                                                largeDevice: StarDialogBox(
                                                  borderRadius: 35,
                                                  mainAxisSpace: 30,
                                                  crossAxisSpace: 45,
                                                  axisCount: 4,
                                                ),
                                              ),
                                        );
                                      },
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: BuildTextWidget(
                                          text: bookingViewmodel.selectedStar,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                          ),
                        ],
                      ),
                    ),
                    15.kH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            final eHundiViewModel =
                                Provider.of<EHundiViewmodel>(
                                  context,
                                  listen: false,
                                );

                            if (eHundiViewModel.eHundiKey.currentState
                                    ?.validate() ??
                                false) {
                              final amount =
                                  eHundiViewModel.eHundiAmountController.text
                                      .trim();
                              final name = nameController.text.trim();
                              final phone = phoneController.text.trim();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => PaymentMethodScreenEHundi(
                                        amount: amount,
                                        name: name,
                                        phone: phone,
                                      ),
                                ),
                              );
                            }
                          },
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: kDullPrimaryColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text("Pay".tr()),
                        ),
                        MaterialButton(
                          onPressed: () {
                            final viewModel = Provider.of<EHundiViewmodel>(
                              context,
                              listen: false,
                            );
                            viewModel.popFunction(context);
                            viewModel.clearHundiAmount();
                          },
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: kDullPrimaryColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text("Cancel".tr()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
