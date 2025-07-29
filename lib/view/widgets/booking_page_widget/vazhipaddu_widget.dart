import 'package:flutter/material.dart';
import 'package:kshethra_mini/model/api%20models/god_model.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/asset/assets.gen.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';

class VazhipadduWidget extends StatelessWidget {
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final int? crossAxisCount;
  final String screeName;
  final int selectedCategoryIndex;

  const VazhipadduWidget({
    super.key,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.crossAxisCount,
    required this.screeName,
    required this.selectedCategoryIndex,
    required double crossAxisSpace,
    required double mainAxisSpace,
    required int crossAixisCount,
  });

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();
    SizeConfig().init(context);
    const fromLang = "en";

    return Consumer<BookingViewmodel>(
      builder: (context, bookingViewmodel, _) {
        final selectedGod = bookingViewmodel.selectedGods;
        if (selectedGod == null || selectedGod.counters.isEmpty) {
          return const Center(child: Text("No vazhipadu available"));
        }

        List<Vazhipadus> vazhipadus = [];

        final counterIndex = selectedCategoryIndex;
        if (counterIndex >= 0 && counterIndex < selectedGod.counters.length) {
          vazhipadus = selectedGod.counters[counterIndex].vazhipadus;
        }

        if (vazhipadus.isEmpty) {
          return const Center(child: Text("No vazhipadu found"));
        }

        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.72,
          height: MediaQuery.of(context).size.height * 0.54,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              padding: const EdgeInsets.only(bottom: 270),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: vazhipadus.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount ?? 3,
                mainAxisSpacing: mainAxisSpacing ?? 14,
                crossAxisSpacing: crossAxisSpacing ?? 20,
                childAspectRatio: 0.90,
              ),
              itemBuilder: (context, index) {
                final item = vazhipadus[index];
                final isSelected = bookingViewmodel.selectedVazhipaddu == item;

                return InkWell(
                  onTap: () {
                    if (item.limit >= 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "  Contact Counter",
                            style: styles.whiteRegular15,
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    bookingViewmodel.selectVazhipaddu(item);
                    if (screeName == "bookingPage") {
                      bookingViewmodel.showVazhipadduDialogBox(context, item);
                    } else {
                      bookingViewmodel.showAdvancedVazhipadduDialogBox(context, item);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(Assets.images.homeBackground.path),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: isSelected ? null : kWhite,
                        gradient: isSelected
                            ? LinearGradient(
                          colors: [
                            Colors.orange.shade100,
                            Colors.deepOrange.shade50,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : null,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BuildTextWidget(
                            text: item.offerName,
                            fromLang: fromLang,
                            textAlign: TextAlign.center,
                            size: 13,
                            fontWeight: FontWeight.w400,
                            maxLines: 4,
                            style: AppStyles().blackRegular15,
                          ),
                          const SizedBox(height: 5),
                          BuildTextWidget(
                            text: "₹ ${item.cost}/-",
                            fromLang: fromLang,
                            textAlign: TextAlign.center,
                            size: 13,
                          ),
                          if (item.limit >= 1)
                            BuildTextWidget(
                              text: fromLang == 'ml'
                                  ? "പരിമിതി കവിയുന്നു"
                                  : "Limit Exceeded",
                              fromLang: fromLang,
                              textAlign: TextAlign.center,
                              size: 14,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );

  }
}
