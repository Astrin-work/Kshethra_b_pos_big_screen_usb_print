import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/utils/validation.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/god_widget.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/star_dialodbox_widget.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/vazhipaddu_widget.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../utils/components/responsive_layout.dart';

class BookingFormWidget extends StatelessWidget {
  final double? crossAxisSpace;
  final double? mainAxisSpace;
  final int? crossAixisCount;

  const BookingFormWidget({
    super.key,
    this.crossAxisSpace,
    this.mainAxisSpace,
    this.crossAixisCount,
  });

  @override
  Widget build(BuildContext context) {
    final styles = AppStyles();
    SizeConfig().init(context);

    final bookingViewmodel = Provider.of<BookingViewmodel>(context);
    final counterList = bookingViewmodel.selectedGods?.counters ?? [];
    final List<dynamic> counterListWithAll = ['All', ...counterList];
    final fromLang = "en";
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Form(
                    key: bookingViewmodel.bookingKey,
                    child: TextFormField(
                      autofocus: true,
                      validator: Validation.nameValidation,
                      controller: bookingViewmodel.bookingNameController,
                      textAlign: TextAlign.start,
                      style: styles.blackRegular15,
                      decoration: InputDecoration(
                        hintText: 'Name'.tr(),
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
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 55,
                    child: MaterialButton(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: kDullPrimaryColor,width: 2),
                      ),
                      onPressed: () async {
                        await showDialog(
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
                        bookingViewmodel.validateStar();
                      },
                      child: Text(
                        bookingViewmodel.selectedStar,
                        style: styles.blackRegular15,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            if (bookingViewmodel.starError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  bookingViewmodel.starError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 15),
            GodWidget(),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Container(
            //       width: SizeConfig.screenWidth * 0.255,
            //       height: SizeConfig.screenHeight,
            //       margin: const EdgeInsets.only(right: 10),
            //       decoration: BoxDecoration(
            //         color: const Color(0xFFF2D7C7),
            //         borderRadius: BorderRadius.circular(12),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.black.withOpacity(0.08),
            //             blurRadius: 6,
            //             offset: const Offset(2, 2),
            //           ),
            //         ],
            //       ),
            //       padding: const EdgeInsets.only(left: 10, top: 15),
            //       child: ListView.builder(
            //         padding: const EdgeInsets.only(top: 0),
            //         shrinkWrap: true,
            //         itemCount: counterListWithAll.length,
            //         itemBuilder: (context, index) {
            //           final item = counterListWithAll[index];
            //           final String categoryName =
            //           item == 'All' ? 'All' : item.counterName;
            //           final bool isSelected =
            //               categoryName == bookingViewmodel.selectedCategory;
            //
            //           return GestureDetector(
            //             onTap: () {
            //               bookingViewmodel.selectCategory(index);
            //             },
            //             child: Padding(
            //               padding: const EdgeInsets.symmetric(vertical: 6),
            //               child: Container(
            //                 margin: const EdgeInsets.symmetric(horizontal: 8),
            //                 padding: const EdgeInsets.symmetric(
            //                   vertical: 12,
            //                   horizontal: 10,
            //                 ),
            //                 decoration: BoxDecoration(
            //                   color: isSelected
            //                       ? Colors.orangeAccent
            //                       : Colors.transparent,
            //                   borderRadius: BorderRadius.circular(8),
            //                 ),
            //                 child: BuildTextWidget(
            //                   text: categoryName,
            //                   fromLang: fromLang,
            //                   style: TextStyle(
            //                     fontSize: 14,
            //                     fontWeight: FontWeight.w500,
            //                     color: isSelected ? Colors.white : Colors.black87,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           );
            //         },
            //       ),
            //     ),
            //
            //     Expanded(
            //       child: Container(
            //         padding: const EdgeInsets.only( right: 8.0,bottom: 100 ),
            //         child: Column(
            //           mainAxisSize: MainAxisSize.min,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             VazhipadduWidget(
            //               crossAixisCount: crossAixisCount ?? 3,
            //               crossAxisSpace: crossAxisSpace ?? 15,
            //               mainAxisSpace: mainAxisSpace ?? 15,
            //               selectedCategoryIndex:
            //               bookingViewmodel.selectedCounterIndex,
            //               screeName: 'bookingPage',
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: SizeConfig.screenWidth * 0.255,
                    height: SizeConfig.screenHeight,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.only(left: 10, top: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2D7C7),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: counterListWithAll.length,
                        itemBuilder: (context, index) {
                          final item = counterListWithAll[index];
                          final bool isAll = item == 'All';
                          final String categoryName = isAll ? 'All' : item.counterName;
                          final bool isSelected = categoryName == bookingViewmodel.selectedCategory;

                          return GestureDetector(
                            onTap: () => bookingViewmodel.selectCategory(index),
                            child: Container(
                              margin: const EdgeInsets.only(left: 1, right: 6),
                              padding: const EdgeInsets.fromLTRB(6, 10, 10, 10),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.orangeAccent : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: BuildTextWidget(
                                text: categoryName.tr(),
                                fromLang: fromLang,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          );
                        }


                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only( left: 16,right: 8.0, bottom: 100),
                    // match top padding of left container
                    child: VazhipadduWidget(
                      crossAixisCount: crossAixisCount ?? 3,
                      crossAxisSpace: crossAxisSpace ?? 15,
                      mainAxisSpace: mainAxisSpace ?? 15,
                      selectedCategoryIndex: bookingViewmodel.selectedCounterIndex,
                      screeName: 'bookingPage',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
