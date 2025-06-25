import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/asset/assets.gen.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';

class VazhipadduWidget extends StatelessWidget {
  final double? crossAxisSpace;
  final double? mainAxisSpace;
  final int? crossAixisCount;
  final String screeName;

  const VazhipadduWidget({
    super.key,
    this.crossAxisSpace,
    this.mainAxisSpace,
    this.crossAixisCount,
    required this.screeName,
  });

  @override
  Widget build(BuildContext context) {
    final fromLang = "en";
    AppStyles styles = AppStyles();
    SizeConfig().init(context);

    return Consumer<BookingViewmodel>(
      builder: (context, bookingViewmodel, child) {
        final vazhipadus = bookingViewmodel.selectedGods?.vazhipadus ?? [];

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vazhipadus.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: mainAxisSpace ?? 30,
            crossAxisSpacing: crossAxisSpace ?? 40,
            crossAxisCount: crossAixisCount ?? 2,
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
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BuildTextWidget(
                            text: item.offerName,
                            fromLang: fromLang,
                            textAlign: TextAlign.center,
                            size: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          const SizedBox(height: 4),
                          BuildTextWidget(
                            text: "₹ ${item.cost.toString()}",
                            fromLang: fromLang,
                            textAlign: TextAlign.center,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
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
