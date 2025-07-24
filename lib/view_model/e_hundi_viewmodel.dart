import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/model/api%20models/E_Hundi_Get_Devatha_Model.dart';
import 'package:kshethra_mini/view/widgets/e_hundi_page_widgets/e_hundi_dialogbox_widget.dart';
import 'package:kshethra_mini/view/widgets/e_hundi_page_widgets/qr_scanner_component_e_hundi.dart';
import 'package:provider/provider.dart';
import '../api_services/api_service.dart';
import '../utils/components/snack_bar_widget.dart';
import 'booking_viewmodel.dart';

class EHundiViewmodel extends ChangeNotifier {
  TextEditingController eHundiAmountController = TextEditingController();
  TextEditingController eHundiNameController = TextEditingController();
  TextEditingController eHundiPhoneController = TextEditingController();
  bool _isLoading = false;
  final eHundiKey = GlobalKey<FormState>();
  List<Ehundigetdevathamodel> _gods = [];
  int selectedIndex = 0;
  String? _selectedStar = "Star".tr();
  String? get selectedStar => _selectedStar;
  List<Ehundigetdevathamodel> get gods => _gods;
  bool get isLoading => _isLoading;

  Future<void> fetchEhundiGods() async {
    _isLoading = true;
    notifyListeners();

    try {
      _gods = await ApiService().getEbannaramDevetha();
    } catch (e) {
      _gods = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearHundiAmount() {
    eHundiAmountController.clear();
    eHundiNameController.clear();
    eHundiPhoneController.clear();
    notifyListeners();
  }

  void popFunction(BuildContext context) {
    Navigator.pop(context);
  }

  void backtoHomePage(BuildContext context, int noOfPage) {
    for (int i = 1; i <= noOfPage; i++) {
      popFunction(context);
    }
  }

  String setQrAmount(String amount) {
    String value = "upi://pay?pa=6282488785@superyes&am=$amount&cu=INR";
    return value;
  }

  void showEhundiDonationDialog(
    BuildContext context, {
    required String selectedDevathaName,
  }) {
    showDialog(context: context, builder: (context) => EHundiDialogWidget(selectedGod:selectedDevathaName));
  }

  // void navigateScannerPage(BuildContext context, String amount, {required String name, required String phone}) {
  //   bool valid = eHundiKey.currentState?.validate() ?? false;
  //   if (!valid) {
  //     return;
  //   }
  //   if (eHundiAmountController.text.trim() == "0") {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBarWidget(
  //         msg: "Payment request denied",
  //         color: kRed,
  //       ).build(context),
  //     );
  //     return;
  //   }
  //   popFunction(context);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => QrScannerComponent(
  //         amount: eHundiAmountController.text.trim(),
  //         noOfScreen: 3,
  //         title: 'E-Hundi',
  //       ),
  //     ),
  //   );
  // }
  void navigateToQrScanner(
    BuildContext context,
    String amount, {
    required String name,
    required String phone,
        required   String? DevathaName,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => QrScannerComponentEHundi(
              name: name,
              phone: phone,
              amount: amount,
              devathaName:DevathaName.toString(),
              noOfScreen: 1,
              title: "QR Scanner",
            ),
      ),
    );
  }

  Future<bool> postEbannaramiDonation(
    BuildContext context,
    int index,
    String amount,
    String, {
    required String name,
    required String phone,
  }) async {
    final data = {
      "devathaName": gods[index].devathaName ?? '',
      "amount": int.tryParse(amount) ?? 0,
      "personName": name,
      "phoneNumber": phone,
      "personStar": selectedStar ?? '',
      "paymentType": "cash",
      "transactionId": "asdf",
      "bankId": "asd",
      "bankName": "asdf",
    };

    try {
      await ApiService().postEHundiDetails(data);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarWidget(
            msg: "Donation posted successfully!",
            color: Colors.green,
          ).build(context),
        );
      }
      return true;
    } catch (e) {
      final errorMessage = e.toString();
      debugPrint("❌ Error posting E-Hundi: $errorMessage");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarWidget(
            msg: "Failed to post donation: $errorMessage",
            color: Colors.red,
          ).build(context),
        );
      }
      return false;
    }
  }

  void setStar(String star, BuildContext context) {
    _selectedStar = star.tr();
    popFunction(context);
    notifyListeners();
  }

  void clearSelectedStar() {
    _selectedStar = null;
    notifyListeners();
  }
}
