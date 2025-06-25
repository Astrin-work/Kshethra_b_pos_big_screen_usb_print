import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../model/api models/god_model.dart';
import '../../../view_model/home_page_viewmodel.dart';

class VazhipadduDialogBoxWidget extends StatelessWidget {
  // final Map<String, dynamic> selectedVazhippadu;
  final Vazhipadus selectedVazhippadu;
  const VazhipadduDialogBoxWidget({
    super.key,
    required this.selectedVazhippadu,
    // required this.selectedVazhippadu,
  });

  @override
  Widget build(BuildContext context) {
    final fromLang = "en";
    AppStyles styles = AppStyles();
    SizeConfig().init(context);
    return AlertDialog(
      title: Consumer<BookingViewmodel>(
        builder:
            (context, bookingViewmodel, child) => Column(
              children: [
                BuildTextWidget(
                  text: selectedVazhippadu.offerName,
                  size: 22,
                  fontWeight: FontWeight.w400,
                  fromLang: fromLang,
                ),
                10.kH,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        bookingViewmodel.removeNoOfBookingVazhipaddu(
                          selectedVazhippadu.cost,
                        );
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(360),
                          boxShadow: [
                            BoxShadow(
                              color: kGrey4,
                              blurRadius: 2,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(Icons.remove),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 70,
                      decoration: BoxDecoration(
                        border: Border.all(color: kBlack),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "${bookingViewmodel.noOfBookingVazhipaddu}",
                          style: styles.blackRegular15,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        bookingViewmodel.addNoOfBookingVazhipaddu(
                          selectedVazhippadu.cost,
                        );
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(360),
                          boxShadow: [
                            BoxShadow(
                              color: kGrey4,
                              blurRadius: 2,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
                10.kH,
                Container(
                  height: 40,
                  width: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color: kBlack),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "₹ ${bookingViewmodel.amtOfBookingVazhipaddu}",
                      style: styles.blackRegular15,
                    ),
                  ),
                ),
                15.kH,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      minWidth: 101,
                      onPressed: () {
                        if (bookingViewmodel.isExistedDevotee) {
                          bookingViewmodel.addVazhipaddToExisting(
                            selectedVazhippadu.offerName,
                            selectedVazhippadu.cost,
                            context,
                          );
                        } else {
                          bookingViewmodel.setVazhipaduBookingList(
                            selectedVazhippadu.offerName,
                            selectedVazhippadu.cost.toString(),
                            context,
                          );
                        }
                      },

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: kWhite,
                      child: Text(
                        "Continue".tr(),
                        style: styles.blackRegular15,
                      ),
                    ),
                    MaterialButton(
                      minWidth: 101,
                      onPressed: () {
                        bookingViewmodel.popFunction(context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: kWhite,
                      child: Text("Cancel".tr(), style: styles.blackRegular15),
                      // Text("Cancel", style: styles.blackRegular15),
                    ),
                  ],
                ),
              ],
            ),
      ),
    );
  }
}
