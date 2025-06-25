import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/components/responsive_layout.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/utils/validation.dart';
import 'package:kshethra_mini/view/widgets/advanced_booking_page_widget/rep_check_box_widget.dart';
import 'package:kshethra_mini/view/widgets/advanced_booking_page_widget/weeklywidget.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/star_dialodbox_widget.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../model/api models/god_model.dart';

class AdvancedBookingConfirmForm extends StatefulWidget {
  final Vazhipadus selectedVazhipaadu;

  const AdvancedBookingConfirmForm({
    super.key,
    required this.selectedVazhipaadu,
  });

  @override
  State<AdvancedBookingConfirmForm> createState() =>
      _AdvancedBookingConfirmFormState();
}

class _AdvancedBookingConfirmFormState
    extends State<AdvancedBookingConfirmForm> {
  final TextEditingController _nameController = TextEditingController(
    // text: "Anurag mc",
  );
  final TextEditingController _phoneController = TextEditingController(
    // text: "7510431565",
  );
  final TextEditingController _repDaysController = TextEditingController(
    // text: "1",
  );
  final TextEditingController _addressController = TextEditingController(
    // text: "mannam chira (H) vellamunda po",
  );
  final TextEditingController _pinCodeController = TextEditingController(
    // text: "670731",
  );
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<BookingViewmodel>(
        context,
        listen: false,
      ).resetPrasadamSelection();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _repDaysController.dispose();
    _addressController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  double _TottalAmount = 0.0;
  final Map<String, double> postalRates = {"Postal".tr(): 5.0, "Speed Post": 45.0};
  final fromLang = "en";
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();
    SizeConfig().init(context);

    return Consumer<BookingViewmodel>(
      builder:
          (context, bookingViewmodel, child) => Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 20),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: bookingViewmodel.advBookingKey,
              child: Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    validator: Validation.nameValidation,
                    controller: bookingViewmodel.bookingNameController,
                    textAlign: TextAlign.center,
                    style: styles.blackRegular15,
                    decoration: InputDecoration(
                      hintText: "Name".tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  25.kH,
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) => Validation.phoneValidation(value),
                    controller: bookingViewmodel.bookingPhnoController,
                    textAlign: TextAlign.center,
                    style: styles.blackRegular15,
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: "Phone".tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  25.kH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          bookingViewmodel.setAdvBookOption("star".tr());
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
                        child: Container(
                          height: 55,
                          width: 125,
                          decoration:
                              bookingViewmodel.selectedStar.isNotEmpty
                                  ? BoxDecoration(
                                    color: kDullPrimaryColor,
                                    borderRadius: BorderRadius.circular(15),
                                  )
                                  : BoxDecoration(
                                    color: kScaffoldColor,
                                    border: Border.all(color: kBlack, width: 1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                          child: Center(
                            child: Text(
                              bookingViewmodel.selectedStar.isNotEmpty
                                  ? bookingViewmodel.selectedStar
                                  : "Star",
                              style:
                                  bookingViewmodel.selectedStar.isNotEmpty
                                      ? styles.whiteSemi15
                                      : styles.blackSemi15,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          bookingViewmodel.setAdvBookOption("date".tr());
                          bookingViewmodel.selectBookingDate(context);
                        },
                        child: Container(
                          height: 55,
                          width: 125,
                          decoration:
                              bookingViewmodel.selectedDate.isNotEmpty
                                  ? BoxDecoration(
                                    color: kDullPrimaryColor,
                                    borderRadius: BorderRadius.circular(15),
                                  )
                                  : BoxDecoration(
                                    color: kScaffoldColor,
                                    border: Border.all(color: kBlack, width: 1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                          child: Center(
                            child: Text(
                              bookingViewmodel.selectedDate.isNotEmpty
                                  ? bookingViewmodel.selectedDate
                                  : "Date",
                              style:
                                  bookingViewmodel.selectedDate.isNotEmpty
                                      ? styles.whiteSemi15
                                      : styles.blackSemi15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  25.kH,
                  Align(
                    alignment: Alignment.topLeft,
                    child: BuildTextWidget(text:
                    "Repeat Type :",
                      size: 18,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const RepCheckBoxWidget(),
                  Visibility(
                    visible: bookingViewmodel.selectedRepMethod == "Weekly",
                    child: const WeeklyWidget(),
                  ),
                  25.kH,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (bookingViewmodel.selectedRepMethod != "Once")
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              BuildTextWidget(text:
                                "Number of Times To Repeat",
                                size: 18,
                                textAlign: TextAlign.center,
                                fromLang:fromLang,
                              ),
                              Text(":", style: styles.blackSemi18),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.2,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator:
                                      (value) => Validation.numberValidation(
                                        value,
                                        "Count",
                                        "Enter valid days",
                                      ),
                                  controller: _repDaysController,
                                  onChanged: (value) {
                                    bookingViewmodel.bookingRepOnchange(
                                      value,
                                      widget.selectedVazhipaadu,
                                      postalRates,
                                      _TottalAmount,
                                    );
                                    print(postalRates);
                                  },
                                  textAlign: TextAlign.center,
                                  style: styles.blackRegular15,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (bookingViewmodel.selectedRepMethod != "Once") 15.kH,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Need Prasadam? ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "(If Required)",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),

                                  ),
                                ],
                              ),
                            ),
                            value: bookingViewmodel.prasadamSelected,
                            onChanged: (value) {
                              bookingViewmodel.togglePrasadam(value!);
                            },
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
                        ),
                        15.kH,
                        if (bookingViewmodel.prasadamSelected)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select Postel Option".tr(),
                                style: styles.blackRegular15,
                              ),
                              20.kH,
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                      postalRates.keys.map((option) {
                                        final isSelected =
                                            bookingViewmodel.postalOption ==
                                            option;
                                        final totalCharge =
                                            bookingViewmodel.postalAmount;
                                        return Row(
                                          children: [
                                            Radio<String>(
                                              value: option,
                                              groupValue:
                                                  bookingViewmodel.postalOption,
                                              onChanged: (value) {
                                                if (value != null) {
                                                  print("Clicked: '$value'");
                                                  print(
                                                    "Before: '${bookingViewmodel.postalOption}'",
                                                  );
                                                  bookingViewmodel
                                                      .selectPostalOption(
                                                        value,
                                                      );
                                                  print(
                                                    "After: '${bookingViewmodel.postalOption}'",
                                                  );
                                                }
                                              },
                                              activeColor: kPrimaryColor,
                                            ),
                                            Text(
                                              option,
                                              style: styles.blackRegular15,
                                            ),
                                            if (isSelected)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  left: 8,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: Colors.grey.shade400,
                                                  ),
                                                ),
                                                child: Text(
                                                  "₹${totalCharge.toStringAsFixed(2)}",
                                                  style: styles.blackRegular13,
                                                ),
                                              ),
                                            const SizedBox(width: 20),
                                          ],
                                        );
                                      }).toList(),
                                ),
                              ),
                              10.kH,
                              TextFormField(
                                validator:
                                    (value) => Validation.emptyValidation(
                                      value,
                                      "Enter your address",
                                    ),
                                controller:
                                    bookingViewmodel.bookingAddressController,
                                maxLines: 4,
                                style: styles.blackRegular15,
                                decoration: InputDecoration(
                                  hintText: "Address".tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              10.kH,
                              TextFormField(
                                validator:
                                    (value) => Validation.emptyValidation(
                                      value,
                                      "Enter your Pincode",
                                    ),
                                maxLength: 6,
                                keyboardType: TextInputType.number,
                                controller:
                                    bookingViewmodel.bookingPinCodeController,
                                maxLines: 1,
                                style: styles.blackRegular15,
                                decoration: InputDecoration(
                                  hintText: "Pincode".tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
