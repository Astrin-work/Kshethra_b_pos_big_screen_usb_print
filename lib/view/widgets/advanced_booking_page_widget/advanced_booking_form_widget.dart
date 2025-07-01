import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/god_widget.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/vazhipaddu_widget.dart';
import 'package:provider/provider.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';

class AdvancedBookingFormWidget extends StatelessWidget {
  final double? crossAxisSpace;
  final double? mainAxisSpace;
  final int? crossAixisCount;

  const AdvancedBookingFormWidget({
    super.key,
    this.crossAxisSpace,
    this.mainAxisSpace,
    this.crossAixisCount,
  });

  @override
  Widget build(BuildContext context) {
    final bookingViewmodel = context.watch<BookingViewmodel>();
    final counterList = bookingViewmodel.selectedGods?.counters ?? [];
    final List<dynamic> counterListWithAll = ['All', ...counterList];
    final selectedCategoryIndex = bookingViewmodel.selectedAdvancedBookingCategoryIndex;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            20.kH,
            const GodWidget(),
            20.kH,
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category list
                  Container(
                    width: SizeConfig.screenWidth * 0.253,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2D7C7), // same as BookingForm
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
                      itemCount: counterListWithAll.length,
                      itemBuilder: (context, index) {
                        final isSelected = selectedCategoryIndex == index;
                        final counterName = index == 0
                            ? 'All'
                            : counterListWithAll[index].counterName;

                        return GestureDetector(
                          onTap: () {
                            bookingViewmodel.setSelectedAdvancedBookingCategoryIndex(index);
                            if (index != 0) {
                              bookingViewmodel.setSelectedCounter(index - 1);
                            } else {
                              bookingViewmodel.clearSelectedCounter();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.orangeAccent
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                counterName,
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

                  // Vazhipaddu Grid
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F5F2), // unified background
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: VazhipadduWidget(
                          crossAixisCount: crossAixisCount ?? 3,
                          crossAxisSpace: crossAxisSpace ?? 15,
                          mainAxisSpace: mainAxisSpace ?? 15,
                          screeName: 'advancedBookingPage',
                          selectedCategoryIndex: selectedCategoryIndex,
                        ),
                      ),
                    ),
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
