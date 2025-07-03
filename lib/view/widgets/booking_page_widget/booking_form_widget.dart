import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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

            Form(
              key: bookingViewmodel.bookingKey,
              child: TextFormField(
                autofocus: true,
                validator: Validation.nameValidation,
                controller: bookingViewmodel.bookingNameController,
                textAlign: TextAlign.center,
                style: styles.blackRegular15,
                decoration: InputDecoration(
                  hintText: 'Name'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              minWidth: SizeConfig.screenWidth,
              height: 55,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ResponsiveLayout(
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
              child: Text(
                bookingViewmodel.selectedStar,
                style: styles.blackRegular15,
              ),
            ),
            const SizedBox(height: 15),
            GodWidget(),
            // Padding(
            //   padding: const EdgeInsets.only(left: 10),
            //   child: Align(alignment: Alignment.center,
            //     child: BuildTextWidget(
            //       text: "vazhipadukal",
            //       fromLang: fromLang,
            //       style: TextStyle(
            //         fontSize: 30,
            //         fontWeight: FontWeight.w500,
            //         color:  Colors.black,
            //       ),
            //     ),
            //   ),
            // ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  width: SizeConfig.screenWidth * 0.253,
                  height: SizeConfig.screenHeight,
                  margin: const EdgeInsets.only(right: 10),
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
                  padding: const EdgeInsets.only(left: 8, top: 10),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shrinkWrap: true,
                    itemCount: counterListWithAll.length,
                    itemBuilder: (context, index) {
                      final item = counterListWithAll[index];
                      final String categoryName = item == 'All' ? 'All' : item.counterName;
                      final bool isSelected = categoryName == bookingViewmodel.selectedCategory;

                      return GestureDetector(
                        onTap: () {
                          bookingViewmodel.selectCategory(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.orangeAccent : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: BuildTextWidget(
                              text: categoryName,
                              fromLang: fromLang,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:  EdgeInsets.only(left: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color:  Color(0xFFF9F5F2),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset:  Offset(2, 2),
                          ),
                        ],
                      ),
                      padding:  EdgeInsets.all(8.0),
                      child: VazhipadduWidget(
                        crossAixisCount: crossAixisCount ?? 3,
                        crossAxisSpace: crossAxisSpace ?? 15,
                        mainAxisSpace: mainAxisSpace ?? 15,
                        selectedCategoryIndex: bookingViewmodel.selectedCounterIndex,
                        screeName: 'bookingPage',
                      ),
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
