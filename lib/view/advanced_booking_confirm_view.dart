import 'package:flutter/material.dart';
import 'package:kshethra_mini/view/widgets/advanced_booking_page_widget/advance_booking_float_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import 'package:kshethra_mini/utils/components/responsive_layout.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/widgets/advanced_booking_page_widget/advance_booking_confirm_form.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/booking_float_button_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';

import '../model/api models/god_model.dart';
import '../utils/components/snack_bar_widget.dart';

class AdvancedBookingConfirmView extends StatelessWidget {
  final Vazhipadus selectedVazhipaadu;
  final int totalAmount;

  const AdvancedBookingConfirmView({
    super.key,
    required this.selectedVazhipaadu,
    required this.totalAmount,
  });

  void _handlePayTap(BuildContext context, BookingViewmodel viewmodel) {
    final isFormValid = viewmodel.advBookingKey.currentState?.validate() ?? false;

    final selectedStar = viewmodel.selectedStar.trim();
    final selectedDate = viewmodel.selectedDate.trim();
    final name = viewmodel.bookingNameController.text.trim();
    final phone = viewmodel.bookingPhnoController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Please enter a name",
          color: Colors.redAccent,
        ).build(context),
      );
      return;
    }

    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Please enter a valid phone number",
          color: Colors.redAccent,
        ).build(context),
      );
      return;
    }

    if (selectedStar.isEmpty || selectedStar == "Star" || selectedStar == "നക്ഷത്രം") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Please select a star",
          color: Colors.redAccent,
        ).build(context),
      );
      return;
    }

    // Validate date
    if (selectedDate.isEmpty || selectedDate == "Date" || selectedDate == "തീയതി") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Please select a date",
          color: Colors.redAccent,
        ).build(context),
      );
      return;
    }

    if (!isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Please fill all required fields",
          color: Colors.redAccent,
        ).build(context),
      );
      return;
    }

    // Proceed if everything is valid
    viewmodel.popFunction(context);
    viewmodel.setVazhipaduAdvBookingList(selectedVazhipaadu, context);
  }

  void _handlePayTapAdv(BuildContext context, BookingViewmodel viewmodel) {
    final isFormValid = viewmodel.advBookingKey.currentState?.validate() ?? false;

    final name = viewmodel.bookingNameController.text.trim();
    final phone = viewmodel.bookingPhnoController.text.trim();
    final selectedStar = viewmodel.selectedStar.trim();
    final selectedDate = viewmodel.selectedDate.trim();

    String? error;

    if (name.isEmpty) {
      error = "Please enter a name";
    } else if (phone.isEmpty || phone.length < 10) {
      error = "Please enter a valid phone number";
    } else if (selectedStar.isEmpty || selectedStar == "Star" || selectedStar == "നക്ഷത്രം") {
      error = "Please select a star";
    } else if (selectedDate.isEmpty || selectedDate == "Date" || selectedDate == "തീയതി") {
      error = "Please select a date";
    } else if (!isFormValid) {
      error = "Please fill all required fields";
    }

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: error,
          color: Colors.redAccent,
        ).build(context),
      );
      return;
    }

    // Proceed if all validations pass
    viewmodel.popFunction(context);
    viewmodel.setVazhipaduAdvBookingList(selectedVazhipaadu, context);
  }


  void _handleAddTap(BuildContext context, BookingViewmodel viewmodel) {
    final isValid = viewmodel.advBookingKey.currentState?.validate() ?? false;

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Please fill all required fields",
          color: Colors.grey,
        ).build(context),
      );
      return;
    }

    viewmodel.bookingAddNewDevottee();
    viewmodel.popFunction(context);
    viewmodel.advBookingAddVazhipadu(selectedVazhipaadu, context);
  }

  void _handleAddTapAdv(BuildContext context, BookingViewmodel viewmodel) {
    final isValid = viewmodel.advBookingKey.currentState?.validate() ?? false;

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Please fill all required fields",
          color: Colors.grey,
        ).build(context),
      );
      return;
    }

    bool isAdded = viewmodel.advBookingAddVazhipadu(selectedVazhipaadu, context);
    if (isAdded) {
      // ✅ Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: " Vazhipadu added successfully!",
          color: Colors.green,
        ).build(context),
      );

      print(" Vazhipadu added successfully!");

      viewmodel.bookingAddNewDevottee();
      viewmodel.popFunction(context);
    } else {
      //
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: " Failed to add Vazhipadu.",
          color: Colors.red,
        ).build(context),
      );

      print("❌ Failed to add Vazhipadu.");
    }
  }





  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Consumer<BookingViewmodel>(
      builder: (context, bookingViewmodel, child) => Scaffold(
        floatingActionButton: ResponsiveLayout(
          pinelabDevice: AdvanceBookingFloatButtonWidget(
            payOnTap: () => _handlePayTap(context, bookingViewmodel),
            addOnTap: () => _handleAddTapAdv(context, bookingViewmodel,),
          ),
          mediumDevice: AdvanceBookingFloatButtonWidget(
            height: 65,
            payOnTap: () => _handlePayTapAdv(context, bookingViewmodel),
            addOnTap: () => _handleAddTapAdv(context, bookingViewmodel, ),
          ),
          largeDevice: AdvanceBookingFloatButtonWidget(
            height: 75,
            payOnTap: () => _handlePayTap(context, bookingViewmodel),
            addOnTap: () => _handleAddTapAdv(context, bookingViewmodel,),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppBarWidget(title: selectedVazhipaadu.offerName),
              ResponsiveLayout(
                pinelabDevice: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: AdvancedBookingConfirmForm(
                    selectedVazhipaadu: selectedVazhipaadu,
                  ),
                ),
                mediumDevice: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 0.125,
                  ),
                  child: AdvancedBookingConfirmForm(
                    selectedVazhipaadu: selectedVazhipaadu,
                  ),
                ),
                largeDevice: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 0.125,
                  ),
                  child: AdvancedBookingConfirmForm(
                    selectedVazhipaadu: selectedVazhipaadu,
                  ),
                ),
              ),
              const SizedBox(height: 125),
            ],
          ),
        ),
      ),
    );
  }
}
