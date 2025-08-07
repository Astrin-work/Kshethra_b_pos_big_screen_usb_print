import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/asset/assets.gen.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:provider/provider.dart';

class AdvanceBookingFloatButtonWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final void Function()? payOnTap;
  final void Function()? addOnTap;

  const AdvanceBookingFloatButtonWidget({
    super.key,
    this.height,
    this.width,
    required this.payOnTap,
    this.addOnTap,
  });

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();
    SizeConfig().init(context);

    return Consumer<BookingViewmodel>(
      builder: (context, bookingViewmodel, child) {
        final bool hasVazhipadu = bookingViewmodel.totalVazhipaduAmt > 0;
        final String addButtonText = hasVazhipadu ? "Add vazhipadu " : "Add vazhipadu";

        void handleAdd() {
          if (addOnTap != null) {
            addOnTap!();
          } else {
            bookingViewmodel.bookingAddNewDevottee();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Vazhipadu added successfully"),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
        }

        void handleCancel() {
          // Navigate to PreviewPage
          Navigator.pushNamed(context, '/preview'); // Replace with your actual route
        }

        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Add and Proceed Button
              Expanded(
                child: InkWell(
                  onTap: payOnTap,
                  child: Container(
                    height: height ?? SizeConfig.screenWidth * 0.135,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(Assets.images.homeBackground.path),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Add and Proceed   ₹${bookingViewmodel.totalVazhipaduAmt}",
                        style: styles.whiteRegular20,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Cancel Button
              InkWell(
                onTap: () {
                  bookingViewmodel.navigateToAdvpreview(context);
                },
                child: Container(
                  height: height ?? SizeConfig.screenWidth * 0.135,
                  width: width ?? SizeConfig.screenWidth * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(Assets.images.homeBackground.path),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kWhite,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Add Vazhipadu Button
              InkWell(
                onTap: handleAdd,
                child: Container(
                  height: height ?? SizeConfig.screenWidth * 0.135,
                  width: width ?? SizeConfig.screenWidth * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(Assets.images.homeBackground.path),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kWhite,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: kDullPrimaryColor),
                          Text(
                            addButtonText,
                            style: TextStyle(
                              color: kDullPrimaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
