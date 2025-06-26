import 'package:flutter/material.dart';
import 'package:kshethra_mini/model/api%20models/god_model.dart';
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
    required double mainAxisSpace, required int crossAixisCount,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    const fromLang = "en";

    return Consumer<BookingViewmodel>(
      builder: (context, bookingViewmodel, _) {
        final selectedGod = bookingViewmodel.selectedGods;
        if (selectedGod == null || selectedGod.counters.isEmpty) {
          return const Center(child: Text("No vazhipadu available"));
        }

        List<Vazhipadus> vazhipadus = [];

        if (selectedCategoryIndex == 0) {
          for (var counter in selectedGod.counters) {
            vazhipadus.addAll(counter.vazhipadus);
          }
        } else {
          final counterIndex = selectedCategoryIndex - 1;
          if (counterIndex >= 0 && counterIndex < selectedGod.counters.length) {
            vazhipadus = selectedGod.counters[counterIndex].vazhipadus;
          }
        }

        if (vazhipadus.isEmpty) {
          return const Center(child: Text("No vazhipadu found"));
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vazhipadus.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount ?? 3,
            mainAxisSpacing: mainAxisSpacing ?? 20,
            crossAxisSpacing: crossAxisSpacing ?? 20,
          ),
          itemBuilder: (context, index) {
            final item = vazhipadus[index];

            return InkWell(
              onTap: () {
                if (screeName == "bookingPage") {
                  bookingViewmodel.showVazhipadduDialogBox(context, item);
                } else {
                  bookingViewmodel.showAdvancedVazhipadduDialogBox(context, item);
                }
              },
              child: Container(
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
                    color: kWhite,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BuildTextWidget(
                        text: item.offerName ?? '',
                        fromLang: fromLang,
                        textAlign: TextAlign.center,
                        size: 15,
                        fontWeight: FontWeight.w400,

                      ),
                      const SizedBox(height: 6),
                      BuildTextWidget(
                        text: "₹ ${item.cost ?? '0'}/-",
                        fromLang: fromLang,
                        textAlign: TextAlign.center,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
