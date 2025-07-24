import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/model/user_booking_model.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/components/snack_bar_widget.dart';
import 'package:kshethra_mini/view/advance_booking_preview_view.dart';
import 'package:kshethra_mini/view/booking_preview_view.dart';
import 'package:kshethra_mini/view/card_payment_screen.dart';
import 'package:kshethra_mini/view/cash_payment.dart';
import 'package:kshethra_mini/view/widgets/advanced_booking_page_widget/cash_payment_advance_booking.dart';
import 'package:kshethra_mini/view/widgets/advanced_booking_page_widget/payment_method_screen_advance_booking.dart';
import 'package:kshethra_mini/view/widgets/advanced_booking_page_widget/qr_scanner_component_advance_booking.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/cash_payment_booking.dart';
import 'package:kshethra_mini/view/widgets/booking_page_widget/vazhipaddu_dialogbox_widget.dart';
import 'package:kshethra_mini/view/widgets/donation_page_widgets/payment_method_screen_donation.dart';
import 'package:kshethra_mini/view/widgets/donation_page_widgets/qr_scanner_component_donations.dart';
import 'package:kshethra_mini/view/widgets/e_hundi_page_widgets/payment_method_screen_e_hundi.dart';
import 'package:kshethra_mini/view/widgets/home_page_widgets/home_widget.dart';
import 'package:kshethra_mini/view/widgets/payment_method_screen.dart';
import '../api_services/api_service.dart';
import '../model/api models/get_donation_model.dart';
import '../model/api models/get_temple_model.dart';
import '../model/api models/god_model.dart';
import '../services/plutus_smart.dart';
import '../utils/components/qr_code_component.dart';
import '../utils/logger.dart';
import '../utils/validation.dart';
import '../view/advanced_booking_confirm_view.dart';
import '../view/widgets/advanced_booking_page_widget/advanced_vazhipaddu_dialog_BoxWidget.dart';
import '../view/widgets/booking_page_widget/qr_scanner_component_booking.dart';

class BookingViewmodel extends ChangeNotifier {
  final bookingKey = GlobalKey<FormState>();
  final advBookingKey = GlobalKey<FormState>();
  final Set<String> _selectedWeeklyDays = {};
  TextEditingController bookingNameController = TextEditingController();
  TextEditingController bookingPhnoController = TextEditingController();
  TextEditingController bookingRepController = TextEditingController();
  TextEditingController bookingAddressController = TextEditingController();
  TextEditingController bookingPinCodeController = TextEditingController();
  bool _isExistedDevotee = false;
  bool get isExistedDevotee => _isExistedDevotee;
  bool _isPostalAdded = false;
  bool _prasadamSelected = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool get prasadamSelected => _prasadamSelected;
  bool _isPrasadamSelected = false;
  bool get isPrasadamSelected => _isPrasadamSelected;
  bool _shouldResetPrasadam = false;
  Counter? selectedCounter;
  String selectedCategory = 'All'.tr();
  List<String> templeNameList = [];
  String? starError;
  List<UserBookingModel> _vazhipaduBookingList = [];
  List<UserBookingModel> get vazhipaduBookingList => _vazhipaduBookingList;
  List<Godmodel> _gods = [];
  List<Getdonationmodel> donations = [];
  List<GetTemplemodel> templeList = [];
  int _selectedCounterIndex = 0;
  int get selectedCounterIndex => _selectedCounterIndex;
  List<Godmodel> get gods => _gods;
  List<Map<String, dynamic>> _submittedGroups = [];
  List<Map<String, dynamic>> get submittedGroups => _submittedGroups;
  Map<String, dynamic> _fullSubmittedData = {};
  Map<String, dynamic> get fullSubmittedData => _fullSubmittedData;
  int selectedIndex = 0;

  int _noOfBookingVazhipaddu = 1;
  int get noOfBookingVazhipaddu => _noOfBookingVazhipaddu;
  int _advBookingAmt = 0;
  int get advBookingAmt => _advBookingAmt;
  int _totalAdvBookingAmt = 0;
  int get totalAdvBookingAmt => _totalAdvBookingAmt;
  int _totalVazhipaduAmt = 0;
  int get totalVazhipaduAmt => _totalVazhipaduAmt;
  int _advBookingSavedAmt = 0;
  int get advBookingSavedAmt => _advBookingSavedAmt;
  int _amtOfBookingVazhipaddu = 0;
  int get amtOfBookingVazhipaddu => _amtOfBookingVazhipaddu;
  int _repeatDays = 1;
  int get repeatDays => _repeatDays;
  Godmodel? selectedGods;
  String _selectedStar = "Star".tr();
  String get selectedStar => _selectedStar;
  String _selectedRepMethod = "Once";
  String get selectedRepMethod => _selectedRepMethod;
  String _selectedWeeklyDay = "Sun";
  String get selectedWeeklyDay => _selectedWeeklyDay;
  String _advBookOption = "";
  String get advBookOption => _advBookOption;
  String _selectedDate = "Date".tr();
  String get selectedDate => _selectedDate;
  String _postalOption = '';
  String get postalOption => _postalOption;
  double _postalAmount = 0.0;
  double get postalAmount => _postalAmount;
  double _totalAmount = 0.0;
  double get totalAmount => _totalAmount * noOfBookingVazhipaddu;
  int _selectedBookingCategoryIndex = 0;
  int get selectedBookingCategoryIndex => _selectedBookingCategoryIndex;
  int _selectedAdvancedBookingCategoryIndex = 0;
  int get selectedAdvancedBookingCategoryIndex =>
      _selectedAdvancedBookingCategoryIndex;
  List<Vazhipadus> _filteredVazhipadus = [];
  List<Vazhipadus> get filteredVazhipadus => _filteredVazhipadus;
  Vazhipadus? _selectedVazhipadu;
  Vazhipadus? get selectedVazhipadu => _selectedVazhipadu;
  String? storedSelectedStar;
  @override
  void dispose() {
    bookingNameController.dispose();
    bookingPhnoController.dispose();
    bookingRepController.dispose();
    bookingAddressController.dispose();
    super.dispose();
  }


  Vazhipadus? _selectedVazhipaddu;
  Vazhipadus? get selectedVazhipaddu => _selectedVazhipaddu;

  void selectVazhipaddu(Vazhipadus vazhipaddu) {
    _selectedVazhipaddu = vazhipaddu;
    notifyListeners();
  }







  void selectVazhipadu(Vazhipadus item) {
    _selectedVazhipadu = item;
    notifyListeners();
  }

  void selectCategory(int index) {
    _selectedCounterIndex = index;

    if (index == 0) {
      selectedCategory = 'All'.tr();

      _filteredVazhipadus = [];
      if (selectedGods != null) {
        for (var counter in selectedGods!.counters) {
          _filteredVazhipadus.addAll(counter.vazhipadus);
        }
      }
    } else if (selectedGods != null && index - 1 < selectedGods!.counters.length) {
      selectedCategory = selectedGods!.counters[index - 1].counterName;

      _filteredVazhipadus = selectedGods!.counters[index - 1].vazhipadus;
    }

    notifyListeners();
  }

  void setSelectedAdvancedBookingCategoryIndex(int index) {
    _selectedAdvancedBookingCategoryIndex = index;
    notifyListeners();
  }

  void clearSelectedCounter() {
    selectedCounter = null;
    notifyListeners();
  }

  void setSelectedCounter(int index) {
    _selectedCounterIndex = index;
    notifyListeners();
  }

  // Future<void> submitVazhipadu() async {
  //   if (vazhipaduBookingList.isEmpty) {
  //     print(' No vazhipadu bookings to submit.');
  //     return;
  //   }
  //
  //   final now = DateTime.now().toIso8601String();
  //
  //   List<Map<String, dynamic>> receipts = [];
  //
  //   for (var item in vazhipaduBookingList) {
  //     final int quantity = int.tryParse(item.count.toString()) ?? 1;
  //     final int rate = int.tryParse(item.price.toString()) ?? 0;
  //
  //     receipts.add({
  //       "personName": item.name ?? "Unknown",
  //       "personStar": item.star ?? "Unknown",
  //       "quantity": quantity,
  //       "rate": rate,
  //       "offerDate": item.date ?? now,
  //       "receiptDate": now,
  //       "type": "CB",
  //       "offerName": item.vazhipadu ?? "vazhipadu2",
  //     });
  //
  //   }
  //
  //   final postData = {
  //     "receipts": receipts,
  //     "paymentType": "upi",
  //     "transactionId": "1122",
  //     "bankId": "",
  //     "bankName": "icici",
  //   };
  //   try {
  //     final response = await ApiService().postVazhipaduDetails(postData);
  //
  //     if (response is List && response.isNotEmpty) {
  //       final List<Map<String, dynamic>> allReceipts = [];
  //
  //       for (var entry in response) {
  //         if (entry is Map<String, dynamic>) {
  //           final receiptsList = entry['receipts'];
  //           if (receiptsList is List) {
  //             allReceipts.addAll(receiptsList.cast<Map<String, dynamic>>());
  //           }
  //         }
  //       }
  //
  //       final groupedResponse = [
  //         {
  //           "serialNumber": response.first['serialNumber'],
  //           "receipts": allReceipts,
  //         },
  //       ];
  //
  //       print(" Submitted ${receipts.length} items successfully.");
  //       print("Grouped Response: $groupedResponse");
  //     } else {
  //       print(" Submitted ${receipts.length} items successfully.");
  //       print("Response: $response");
  //     }
  //   } catch (e) {
  //     print(" Failed to submit vazhipadu: $e");
  //   }
  // }
  Future<List<Map<String, dynamic>>> submitVazhipadu() async {
    if (vazhipaduBookingList.isEmpty) {
      print('No vazhipadu bookings to submit.');
      return [];
    }

    final now = DateTime.now().toIso8601String();
    List<Map<String, dynamic>> receipts = [];

    for (var item in vazhipaduBookingList) {
      final int quantity = int.tryParse(item.count.toString()) ?? 1;
      final int rate = int.tryParse(item.price.toString()) ?? 0;

      receipts.add({
        "personName": item.name ?? "Unknown",
        "personStar": item.star ?? "Unknown",
        "quantity": quantity,
        "rate": rate,
        "offerDate": item.date ?? now,
        "receiptDate": now,
        "type": "CB",
        "offerName": item.vazhipadu ?? "vazhipadu2",
      });
    }

    final postData = {
      "receipts": receipts,
      "paymentType": "upi",
      "transactionId": "1122",
      "bankId": "",
      "bankName": "icici",
    };

    try {
      final response = await ApiService().postVazhipaduDetails(postData);

      if (response is List && response.isNotEmpty) {
        final List<Map<String, dynamic>> groupedResponse = [];

        for (var entry in response) {
          if (entry is Map<String, dynamic>) {
            final serial = entry['serialNumber'];
            final receiptsList = entry['receipts'];
            if (serial != null && receiptsList is List) {
              groupedResponse.add({
                "serialNumber": serial,
                "receipts": receiptsList.cast<Map<String, dynamic>>(),
              });
            }
          }
        }

        print(" Submitted ${receipts.length} items successfully.");
        print(" Grouped Response:");
        for (var group in groupedResponse) {
          print(JsonEncoder.withIndent('  ').convert(group));
        }

        return groupedResponse;
      } else {
        print("Submitted ${receipts.length} items successfully.");
        print("Response: $response");
      }
    } catch (e) {
      print("Failed to submit vazhipadu: $e");
    }

    return [];
  }

  // Future<void> fetchTempleData() async {
  //   try {
  //     final dbName = await ApiService().getDatabaseNameFromToken();
  //     if (dbName == null || dbName.isEmpty) {
  //       print("❗ Database name is null or empty.");
  //       return;
  //     }
  //
  //     final List<GetTemplemodel> fetchedTemples = await ApiService().getTemple(dbName);
  //
  //     if (fetchedTemples.isEmpty) {
  //       print("⚠️ No temple data received.");
  //       return;
  //     }
  //
  //     // Store temple data into the list correctly
  //     templeList
  //       ..clear()
  //       ..addAll(fetchedTemples);
  //     print('----tt');
  //     print(templeList.last.templeName);
  //     print(templeList.last.templeId);
  //     print("✅ Temple data successfully fetched and stored (${templeList.length} items).");
  //     for (var temple in templeList) {
  //       print("🏛️ Temple: ${temple.templeName}");
  //     }
  //
  //     notifyListeners();
  //   } catch (e) {
  //     print(" Error fetching temple data: $e");
  //   }
  // }


  Future<void> fetchTempleData() async {
    try {
      final dbName = await ApiService().getDatabaseNameFromToken();
      if (dbName != null && dbName.isNotEmpty) {
        final data = await ApiService().getTemple(dbName);
        if (data.isNotEmpty) {
          templeList = data;
          notifyListeners();
        } else {
          print("No temple data received.");
        }
      } else {
        print("Database name missing or invalid.");
      }
    } catch (e) {
      print("Error fetching temple data: $e");
    }
  }


  Future<void> fetchTempleName() async {
    final temple = await ApiService().getSingleTempleName();

    if (temple != null) {
      print("🏛️ Temple Name: ${temple.templeName}");
      templeNameList.add(temple.templeName);
      notifyListeners(); // Notify the UI to rebuild
    } else {
      print("❌ Temple not found.");
    }
  }










  void storeGroupedResponses(List<Map<String, dynamic>> responses) {
    _submittedGroups = responses;
    notifyListeners();
  }

  // Future<void> submitAdvVazhipadu() async {
  //   if (vazhipaduBookingList.isEmpty) {
  //     print(' No advanced vazhipadu bookings to submit.');
  //     return;
  //   }
  //
  //   final List<Map<String, dynamic>> receipts =
  //       vazhipaduBookingList.map((item) {
  //         DateTime selectedDate = DateTime.now();
  //         String formattedDate =
  //             "${DateFormat('yyyy-MM-dd').format(selectedDate)}T00:00:00";
  //
  //         return {
  //           "devathaName": item.godname ?? "",
  //           "offerName": item.vazhipadu ?? "vazhipadu2",
  //           "personName": item.name ?? "",
  //           "personStar": item.star,
  //           "phoneNumber": item.phno ?? "",
  //           "address": bookingAddressController.text.trim(),
  //           "startDate": formattedDate,
  //           "repeatType": item.repMethode ?? "once",
  //           "repeatCount": int.tryParse(bookingRepController.text.trim()) ?? 1,
  //           "repeatDays": ["monday"],
  //           "rate": int.tryParse(item.price?.toString() ?? "0") ?? 0,
  //           "quantity": int.tryParse(item.count?.toString() ?? "1") ?? 1,
  //           "type": "AB",
  //           "pincode": bookingPinCodeController.text.trim(),
  //           "paymentMode": "UPI",
  //           "postalCharge": 10,
  //           "prasadham": true,
  //           "prasadhamType": "standard",
  //           "postalType": "registered",
  //         };
  //       }).toList();
  //
  //   final Map<String, dynamic> postData = {
  //     "receipts": receipts,
  //     "paymentType": "upi",
  //     "transactionId": "4444",
  //     "bankId": "333/sbi",
  //     "bankName": "canara",
  //   };
  //   print("🧾 Final POST Data:\n${jsonEncode(postData)}");
  //
  //   try {
  //     final response = await ApiService().postAdvVazhipaduDetails(postData);
  //
  //     if (response != null && response['success'] == true) {
  //       List<dynamic> successList = response['successList'];
  //       for (int i = 0; i < successList.length; i++) {
  //         final item = successList[i];
  //         print(
  //           " Booking ${i + 1}: ${item['offerName']} for ${item['personName']}",
  //         );
  //       }
  //     } else {
  //       print(" Submission failed or no successList.");
  //       print("Response: $response");
  //     }
  //   } catch (e) {
  //     if (e is DioException) {
  //       print(" DioException (400 Bad Request):");
  //       print("Status: ${e.response?.statusCode}");
  //       print("Error Body: ${e.response?.data}");
  //     } else {
  //       print(" Unexpected exception: $e");
  //     }
  //   }
  // }

  Future<List<Map<String, dynamic>>> submitAdvVazhipadu() async {
    if (vazhipaduBookingList.isEmpty) {
      print('No advanced vazhipadu bookings to submit.');
      return [];
    }

    final List<Map<String, dynamic>> receipts = vazhipaduBookingList.map((item) {
      DateTime selectedDate = DateTime.now();
      String formattedDate = "${DateFormat('yyyy-MM-dd').format(selectedDate)}T00:00:00";

      return {
        "devathaName": item.godname ?? "",
        "offerName": item.vazhipadu ?? "vazhipadu2",
        "personName": item.name ?? "",
        "personStar": item.star,
        "phoneNumber": item.phno ?? "",
        "address": bookingAddressController.text.trim(),
        "startDate": formattedDate,
        "repeatType": item.repMethode ?? "once",
        "repeatCount": int.tryParse(bookingRepController.text.trim()) ?? 1,
        "repeatDays": ["monday"],
        "rate": int.tryParse(item.price?.toString() ?? "0") ?? 0,
        "quantity": int.tryParse(item.count?.toString() ?? "1") ?? 1,
        "type": "AB",
        "pincode": bookingPinCodeController.text.trim(),
        "paymentMode": "UPI",
        "postalCharge": postalAmount != null ? postalAmount.toInt() : 0,
        "prasadham": true,
        "prasadhamType": "standard",
        "postalType": "registered",
      };
    }).toList();

    final Map<String, dynamic> postData = {
      "receipts": receipts,
      "paymentType": "upi",
      "transactionId": "4444",
      "bankId": "333/sbi",
      "bankName": "canara",
    };

    print("🧾 Final POST Data:\n${jsonEncode(postData)}");

    try {
      final response = await ApiService().postAdvVazhipaduDetails(postData);

      if (response != null && response['success'] == true) {
        List<dynamic> successList = response['successList'];
        for (int i = 0; i < successList.length; i++) {
          final item = successList[i];
          print(" Booking ${i + 1}: ${item['offerName']} for ${item['personName']}");
        }

        return successList.cast<Map<String, dynamic>>();
      } else {
        print(" Submission failed or no successList.");
        print("Response: $response");
      }
    } catch (e) {
      if (e is DioException) {
        print(" DioException (400 Bad Request):");
        print("Status: ${e.response?.statusCode}");
        print("Error Body: ${e.response?.data}");
      } else {
        print(" Unexpected exception: $e");
      }
    }

    return []; // fallback
  }


  void onConfirmPayment(BuildContext context) {
    int countdown = 5;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future.delayed(const Duration(seconds: 1), () {
              if (countdown > 1) {
                setState(() {
                  countdown--;
                });
              } else {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeWidget()),
                  (route) => false,
                );
              }
            });

            return AlertDialog(
              content: Text(
                "Redirecting to home in $countdown...",
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> fetchGods() async {
    _isLoading = true;
    notifyListeners();

    try {
      _gods = await ApiService().getDevatha();

      if (_gods.isNotEmpty) {
        selectedGods = _gods[0];
      }
    } catch (e) {
      print("Error fetching gods: $e");
      _gods = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  set repeatDays(int value) {
    _repeatDays = value;
    _updatePostalAmount();
    recalculateTotalAmount();
    notifyListeners();
  }

  void _updatePostalAmount() {
    if (_postalOption == 'Ordinary Post') {
      _postalAmount = 5.0 * _repeatDays;
    } else if (_postalOption == 'Speed Post') {
      _postalAmount = 45.0 * _repeatDays;
    } else {
      _postalAmount = 0.0;
    }
  }

  void togglePrasadam(bool value) {
    _prasadamSelected = value;

    if (!_prasadamSelected) {
      if (_isPostalAdded) {
        _totalVazhipaduAmt -= _postalAmount.toInt();
        _isPostalAdded = false;
      }
      _postalOption = '';
      _postalAmount = 0.0;
    }
    notifyListeners();
  }

  void setShouldResetPrasadam(bool value) {
    _shouldResetPrasadam = value;
  }

  void resetPrasadamSelection() {
    _prasadamSelected = false;
    _postalOption = '';
    _postalAmount = 0.0;
    notifyListeners();
  }

  void selectPostalOption(String option) {
    if (_isPostalAdded) {
      _totalVazhipaduAmt -= _postalAmount.toInt();
      _isPostalAdded = false;
    }

    _postalOption = option.trim();

    if (_postalOption.isNotEmpty) {
      _updatePostalAmount();
      _totalVazhipaduAmt += _postalAmount.toInt();
      _isPostalAdded = true;
    } else {
      _postalAmount = 0.0;
    }

    recalculateTotalAmount();

    notifyListeners();
  }

  void updateRepeatDays(int days) {
    _repeatDays = days;
    notifyListeners();
  }

  void recalculateTotalAmount() {
    _totalAmount = combinedTotalAmount.toDouble();

    notifyListeners();
  }

  // void setBookingPage() {
  //   _advBookOption = "";
  //   _advBookingSavedAmt = 0;
  //   _totalAdvBookingAmt = 0;
  //   _selectedGod = bList[0];
  //   _selectedStar = "Star".tr();
  //   _selectedDate = "Date".tr();
  //   bookingAddressController.clear();
  //   bookingNameController.clear();
  //   _isExistedDevotee = false;
  //   _vazhipaduBookingList = [];
  //   _totalVazhipaduAmt = 0;
  //   bookingPhnoController.clear();
  // }

  int get combinedTotalAmount {
    int total = 0;

    for (var booking in _vazhipaduBookingList) {
      final int unitPrice = int.tryParse(booking.price ?? '0') ?? 0;
      final int count = int.tryParse(booking.count ?? '1') ?? 1;
      final int repeat = booking.repMethode == 'Once' ? 1 : repeatDays;
      final int baseTotal = unitPrice * count * repeat;

      total += baseTotal;
    }
    print("-----------postals-----------");
    print(postalAmount);
    print(_postalAmount);
    print(_postalOption);
    if (isPrasadamSelected) {
      total += postalAmount.toInt();
    }

    return total;
  }

  void setBookingPage() {
    _advBookOption = "";
    _advBookingSavedAmt = 0;
    _totalAdvBookingAmt = 0;
    if (_gods.isNotEmpty) {
      selectedGods = _gods[0];
    } else {
      selectedGods = null;
    }
    _selectedStar = "Star".tr();
    _selectedDate = "Date".tr();
    bookingAddressController.clear();
    bookingNameController.clear();
    _isExistedDevotee = false;
    _vazhipaduBookingList = [];
    _totalVazhipaduAmt = 0;
    bookingPhnoController.clear();
  }

  void clearBookingControllers() {
    bookingNameController.clear();
    bookingPhnoController.clear();
    bookingRepController.clear();
    bookingAddressController.clear();
  }

  void popFunction(BuildContext context) {
    Navigator.pop(context);
  }

  String setQrAmount(String amount) {
    String value = "upi://pay?pa=6282488785@superyes&am=$amount&cu=INR";
    return value;
  }

  void backtoHomePage(BuildContext context, int noOfPage) {
    for (int i = 1; i <= noOfPage; i++) {
      popFunction(context);
    }
  }

  void navigateAdvBookingPreview(BuildContext context) {
    if (_totalVazhipaduAmt == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Please select a Vazhippadu",
          color: kRed,
        ).build(context),
      );
      return;
    }

    selectedGods = gods[0];
    _selectedStar = "Star".tr();
    bookingNameController.clear();
    _isExistedDevotee = false;

    final selectedDays = selectedWeeklyDays;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AdvancedBookingPreviewView(
          selectedRepMethod: selectedRepMethod,
          selectedDays: selectedDays,
          totalAmount:_amtOfBookingVazhipaddu,
        ),
      ),
    );

    notifyListeners();
  }


  void navigateBookingPreviewView(BuildContext context) {
    final name = bookingNameController.text.trim();
    final isStarValid = _selectedStar != "Star".tr() && _selectedStar.isNotEmpty;
    final isNameValid = Validation.nameValidation(name) == null;
    final hasVazhipadu = _totalVazhipaduAmt != 0;

    if (!hasVazhipadu) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Please select a Vazhippadu",
          color: kGrey,
        ).build(context),
      );
      return;
    }

    if (!isNameValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Please enter a valid name",
          color: kGrey,
        ).build(context),
      );
      return;
    }

    if (!isStarValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Please select a star",
          color: kGrey,
        ).build(context),
      );
      return;
    }

    if (_gods.isNotEmpty) {
      selectedGods = _gods[0];
    }
    _isExistedDevotee = false;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingPreviewView(
          page: 'booking',
          selectedRepMethod: selectedRepMethod,
        ),
      ),
    );

    notifyListeners();
  }

  void setAdvBookOption(String value) {
    _advBookOption = value;
    notifyListeners();
  }

  void selectBookingDate(BuildContext context) async {
    DateTime? value = await showDatePicker(
      context: context,
      firstDate: getTomorrow(),
      lastDate: getOneYear(),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: kDullPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (value != null) {
      _selectedDate = formatDateTime(value);
      notifyListeners();
    }
  }

  String formatDateTime(DateTime dateTime) {
    String year = dateTime.year.toString();
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    return '$day/$month/$year';
  }

  DateTime getTomorrow() {
    return DateTime.now().add(Duration(days: 1));
  }

  DateTime getOneYear() {
    return DateTime.now().add(Duration(days: 365));
  }

  void bookingRepOnchange(
    String value,
    Vazhipadus selectedVazhipaadu,
    Map<String, double> postalRates,
    double amount,
  ) {
    int? repCount = int.tryParse(value.trim());

    if (repCount == null || repCount <= 0) {
      _repeatDays = 1;
      _totalVazhipaduAmt = _advBookingSavedAmt;
      notifyListeners();
      return;
    }

    _repeatDays = repCount;
    print("Number of repeat days: $_repeatDays");

    int unitPrice = selectedVazhipaadu.cost;
    int quantity = noOfBookingVazhipaddu;
    int baseAmount = unitPrice * quantity;

    _totalVazhipaduAmt = baseAmount * _repeatDays;

    print("---------------------- Total Calculation -------------------");
    print("Unit Price: ₹$unitPrice");
    print("Quantity: $quantity");
    print("Repeat Days: $_repeatDays");
    print("Base Amount: ₹$baseAmount");
    print("Total Vazhipaadu Amount (without postal): ₹$_totalVazhipaduAmt");

    if (_postalOption.isNotEmpty) {
      _updatePostalAmount();
      _totalVazhipaduAmt += _postalAmount.toInt();
      _isPostalAdded = true;
    }

    print("Total Postal Amount: ₹$_postalAmount");
    print("Final Total Vazhipaadu Amount (with postal): ₹$_totalVazhipaduAmt");

    notifyListeners();
  }

  void navigateAdvancedBookingConfirm(
      BuildContext context,
      Vazhipadus selectedVazhipaadu,
      BookingViewmodel bookingViewmodel,
      ) {
    _selectedRepMethod = "Once";
    _selectedWeeklyDay = "Sun";
    bookingRepController.text = "1";

    int unitPrice = selectedVazhipaadu.cost;
    int quantity = bookingViewmodel.noOfBookingVazhipaddu;
    _totalVazhipaduAmt = _advBookingSavedAmt + (quantity * unitPrice);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => AdvancedBookingConfirmView(
          selectedVazhipaadu: selectedVazhipaadu,
          totalAmount: _totalVazhipaduAmt,
        ),
      ),
    );

    print("-----------amount------------");
    print(_totalVazhipaduAmt);
  }


  // void advBookingAddVazhipadu(
  //     Map<String, dynamic> selectedVazhipaadu,
  //     BuildContext context,
  //     ) {
  //   bool valid = advBookingKey.currentState?.validate() ?? false;
  //   if (!valid) return;
  //
  //   if (_advBookOption == "") {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBarWidget(
  //         msg: "Select one option from Star or Date",
  //         color: kGrey,
  //       ).build(context),
  //     );
  //     return;
  //   }
  //
  //   final int repeatCount = selectedRepMethod == "Once"
  //       ? 1
  //       : int.tryParse(bookingRepController.text) ?? 1;
  //
  //   final double itemPrice = selectedVazhipaadu["price"] ?? 0.0;
  //   final double postalAmt = prasadamSelected ? postalAmount : 0.0;
  //
  //
  //   _totalVazhipaduAmt = ((itemPrice * repeatCount) + postalAmt) as int;
  //   _advBookingSavedAmt = _totalVazhipaduAmt;
  //   print(totalVazhipaduAmt);
  //   print(totalAdvBookingAmt);
  //
  //
  //   setVazhipaduAdvBookingList(selectedVazhipaadu, context);
  //   bookingAddNewDevottee();
  //   popFunction(context);
  // }
  void advBookingAddVazhipadu(
    Vazhipadus selectedVazhipaadu,
    BuildContext context,
  ) {
    bool valid = advBookingKey.currentState?.validate() ?? false;
    if (!valid) return;

    if (_advBookOption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Select one option from Star or Date",
          color: kGrey,
        ).build(context),
      );
      return;
    }

    final int repeatCount =
        selectedRepMethod == "Once"
            ? 1
            : int.tryParse(bookingRepController.text.trim()) ?? 1;

    final double itemPrice = selectedVazhipaadu.cost.toDouble(); // from model
    final double postalAmt = prasadamSelected ? postalAmount : 0.0;

    _totalVazhipaduAmt = ((itemPrice * repeatCount) + postalAmt).toInt();
    _advBookingSavedAmt = _totalVazhipaduAmt;

    print(_totalVazhipaduAmt);
    print(_totalAdvBookingAmt);

    setVazhipaduAdvBookingList(selectedVazhipaadu, context);
    bookingAddNewDevottee();
    popFunction(context);
  }

  void updateTotalAmount(double value) {
    _totalAmount = value;
    notifyListeners();
  }

  void setGod(Godmodel value) {
    selectedGods = value;
    notifyListeners();
  }


  void clearBookingForm() {
    bookingNameController.clear();
    bookingPhnoController.clear();
    _selectedStar = "Star";
    selectedGods = null;
    _isExistedDevotee = false;
    notifyListeners();
  }


  // void setGod(BookingModel value) {
  //   _selectedGod = value;
  //   notifyListeners();
  // }

  // void showVazhipadduDialogBox(
  //     BuildContext context,
  //     Map<String, dynamic> selectedVazhipaadu,
  //     ) {
  //   bool valid = bookingKey.currentState?.validate() ?? false;
  //   if (!valid) return;
  //
  //   _noOfBookingVazhipaddu = 1;
  //   int x = int.tryParse(selectedVazhipaadu["prize"]?.toString() ?? "0") ?? 0;
  //   _amtOfBookingVazhipaddu = 1 * x;
  //
  //   if (_selectedStar != "Star") {
  //     showDialog(
  //       context: context,
  //       builder: (context) => VazhipadduDialogBoxWidget(
  //         selectedVazhippadu: selectedVazhipaadu,
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBarWidget(msg: "Select your star", color: kGrey).build(context),
  //     );
  //   }
  //
  //   notifyListeners();
  // }

  void showVazhipadduDialogBox(
    BuildContext context,
    Vazhipadus selectedVazhipaadu,
  ) {
    bool valid = bookingKey.currentState?.validate() ?? false;
    if (!valid) return;

    _noOfBookingVazhipaddu = 1;
    _amtOfBookingVazhipaddu = selectedVazhipaadu.cost;

    if (_selectedStar != "Star") {
      showDialog(
        context: context,
        builder:
            (context) => VazhipadduDialogBoxWidget(
              selectedVazhippadu: selectedVazhipaadu,
            ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(msg: "Select your star", color: kGrey).build(context),
      );
    }

    notifyListeners();
  }

  void showAdvancedVazhipadduDialogBox(
    BuildContext context,
    Vazhipadus selectedVazhipaadu,
  ) {
    _noOfBookingVazhipaddu = 1;
    _amtOfBookingVazhipaddu = selectedVazhipaadu.cost;

    showDialog(
      context: context,
      builder:
          (context) => AdvancedVazhipadduDialogBoxwidget(
            selectedVazhippadu: selectedVazhipaadu,
          ),
    );

    notifyListeners();
  }

  void resetDialogState() {
    _noOfBookingVazhipaddu = 1;
    _amtOfBookingVazhipaddu = 0;
  }

  void addNoOfBookingVazhipaddu(int ammount) {
    _noOfBookingVazhipaddu++;
    _amtOfBookingVazhipaddu = _noOfBookingVazhipaddu * ammount;
    notifyListeners();
  }

  void removeNoOfBookingVazhipaddu(int ammount) {
    if (_noOfBookingVazhipaddu > 1) {
      _noOfBookingVazhipaddu--;
      _amtOfBookingVazhipaddu = _noOfBookingVazhipaddu * ammount;
    }
    notifyListeners();
  }
  void setStar(String star, BuildContext context) {
    _selectedStar = star;             // This is your UI selection state
    storedSelectedStar = star;        // This stores the selected star separately
    popFunction(context);             // Close the dialog
    notifyListeners();                // Notify UI
    print("Stored Star: $storedSelectedStar");
  }


  void clearSelectedStar() {
    _selectedStar = "";
    notifyListeners();
  }

  void bookingAddNewDevottee() {
    bookingNameController.clear();
    bookingPhnoController.clear();
    _selectedStar = "Star".tr();
    _isExistedDevotee = false;
    notifyListeners();
  }

  void setVazhipaduBookingList(
    String vazhipaduName,
    String vazhipaduPrice,
    BuildContext context,
  ) {
    final newBooking = UserBookingModel(
      name: bookingNameController.text.trim(),
      phno: bookingPhnoController.text.trim(),
      star: _selectedStar.tr(),
      godname: selectedGods?.devathaName.toString(),
      vazhipadu: vazhipaduName,
      price: vazhipaduPrice,
      count: _noOfBookingVazhipaddu.toString(),
      totalPrice: _amtOfBookingVazhipaddu.toString(),
    );

    _vazhipaduBookingList.add(newBooking);

    print("Added new booking: ${newBooking.toString()}");

    print("Current Booking List:");
    for (var booking in _vazhipaduBookingList) {
      print(booking.toString());
    }

    _totalVazhipaduAmt += _amtOfBookingVazhipaddu;
    _isExistedDevotee = true;
    popFunction(context);
    notifyListeners();
  }

  // void setVazhipaduAdvBookingList(
  //     Map<String, dynamic> selectedVazhipaadu,
  //     BuildContext context,
  //     ) {
  //   bool valid = advBookingKey.currentState?.validate() ?? false;
  //   if (!valid) return;
  //
  //   if (_advBookOption.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBarWidget(
  //         msg: "Select one option from Star or Date",
  //         color: kGrey,
  //       ).build(context),
  //     );
  //     return;
  //   }
  //
  //   int repetitions = int.tryParse(bookingRepController.text.trim()) ?? 1;
  //   if (repetitions == 0) repetitions = 1;
  //
  //   int unitPrice = selectedVazhipaadu["prize"] ?? 0;
  //   int totalAmount = unitPrice *  noOfBookingVazhipaddu;
  //
  //   _vazhipaduBookingList.add(
  //     UserBookingModel(
  //       name: bookingNameController.text.trim(),
  //       phno: bookingPhnoController.text.trim(),
  //       star: _selectedStar.tr(),
  //       date: _selectedDate,
  //       option: _advBookOption == "star".tr() ? _selectedStar : _selectedDate,
  //       repMethode: _selectedRepMethod,
  //       day: _selectedRepMethod == "Weekly" ? _selectedWeeklyDay : '',
  //       godname: selectedGods?.devathaName.toString(),
  //       vazhipadu: selectedVazhipaadu["vazhi"] ?? "",
  //       price: unitPrice.toString(),
  //       count: noOfBookingVazhipaddu.toString(),
  //       totalPrice: totalAmount.toString(),
  //     ),
  //   );
  //   print('------------tyr----------');
  //   print(unitPrice);
  //   print(noOfBookingVazhipaddu);
  //   print(totalAmount);
  //   _totalAdvBookingAmt += totalAmount;
  //   log(_totalAdvBookingAmt.toString(), name: "adv booking");
  //
  //   popFunction(context);
  //   navigateAdvBookingPreview(context);
  //   notifyListeners();
  // }

  // int calculateVazhipaduTotal({
  //   required String? price,
  //   required String? count,
  //   required String repMethod,
  //   required int repeatDays,
  //   required bool includePostal,
  //   required int postalAmount,
  // }) {
  //   final int unitPrice = int.tryParse(price ?? '0') ?? 0;
  //   final int quantity = int.tryParse(count ?? '1') ?? 1;
  //   final int repeat = repMethod == 'Once' ? 1 : repeatDays;
  //   final int baseTotal = unitPrice * quantity * repeat;
  //   final int postal = includePostal ? postalAmount : 0;
  //
  //   return baseTotal + postal;
  // }

  void setVazhipaduAdvBookingList(
      Vazhipadus selectedVazhipaadu,
      BuildContext context,
      ) {
    bool valid = advBookingKey.currentState?.validate() ?? false;
    if (!valid) return;


    if (_selectedStar.isEmpty || _selectedStar == "Star" ||
        _selectedDate.isEmpty || _selectedDate == "Date") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Please select both Star and Date",
          color: kRed,
        ).build(context),
      );
      return;
    }

    int repetitions = int.tryParse(bookingRepController.text.trim()) ?? 1;
    if (repetitions == 0) repetitions = 1;

    int unitPrice = selectedVazhipaadu.cost;
    int totalAmount = unitPrice * noOfBookingVazhipaddu;

    _vazhipaduBookingList.add(
      UserBookingModel(
        name: bookingNameController.text.trim(),
        phno: bookingPhnoController.text.trim(),
        star: _selectedStar.tr(),
        date: _selectedDate,
        option: _selectedStar,
        repMethode: _selectedRepMethod,
        day: _selectedRepMethod == "Weekly" ? _selectedWeeklyDay : '',
        godname: selectedGods?.devathaName.toString(),
        vazhipadu: selectedVazhipaadu.offerName,
        price: unitPrice.toString(),
        count: noOfBookingVazhipaddu.toString(),
        totalPrice: totalAmount.toString(),
      ),
    );

    _totalAdvBookingAmt += totalAmount;
    log(_totalAdvBookingAmt.toString(), name: "adv booking");

    popFunction(context);
    navigateAdvBookingPreview(context);
    notifyListeners();
  }
  int calculateBookingTotalAmt() {
    if (_vazhipaduBookingList.isEmpty) return 0;

    UserBookingModel value = _vazhipaduBookingList.last;
    return int.tryParse(value.totalPrice ?? '0') ?? 0;
  }

  void addVazhipaddToExisting(
    String vazhipaduName,
    int price,
    BuildContext context,
  ) {
    final lastDevotee = _vazhipaduBookingList.last;
    final newBooking = UserBookingModel(
      name: lastDevotee.name,
      phno: lastDevotee.phno,
      star: lastDevotee.star,
      date: lastDevotee.date,
      option: lastDevotee.option,
      repMethode: lastDevotee.repMethode,
      day: lastDevotee.day,
      godname: selectedGods?.devathaName.toString(),
      vazhipadu: vazhipaduName,
      price: price.toString(),
      count: _noOfBookingVazhipaddu.toString(),
      totalPrice: (_noOfBookingVazhipaddu * price).toString(),
    );

    _vazhipaduBookingList.add(newBooking);
    _totalVazhipaduAmt += _noOfBookingVazhipaddu * price;

    log(_totalVazhipaduAmt.toString(), name: "Existing Devotee");

    popFunction(context);
    notifyListeners();
  }

  void vazhipaduDelete(int index) {
    final booking = _vazhipaduBookingList[index];

    int amount = int.tryParse(booking.totalPrice ?? '0') ?? 0;
    _totalVazhipaduAmt -= amount;

    _vazhipaduBookingList.removeAt(index);

    print("Deleted amount: $amount");
    notifyListeners();
  }

  void advBookingDelete(int index) {
    if (index < 0 || index >= vazhipaduBookingList.length) return;

    final booking = vazhipaduBookingList[index];
    int amount = int.tryParse(booking.totalPrice ?? '0') ?? 0;

    _totalAdvBookingAmt -= amount;

    vazhipaduBookingList.removeAt(index);

    print("Deleted advanced booking combined amount: $amount");
    print("Updated total advanced booking amount: $_totalAdvBookingAmt");

    notifyListeners();
  }

  // void bookingPreviewSecondFloatButton(
  //   BuildContext context,
  //   int? amount,
  //   int noOfScreens,
  //   String title,
  // ) {
  //   if (totalVazhipaduAmt == 0) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBarWidget(
  //         msg: "Payment request denied !",
  //         color: kRed,
  //       ).build(context),
  //     );
  //     return;
  //   }
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => PaymentMethodScreen()),
  //   );
  //   notifyListeners();
  // }
  void bookingPreviewSecondFloatButton(
      BuildContext context,
      int? amount,
      int noOfScreens,
      String title,
      String? type,
      ) {
    if (totalVazhipaduAmt == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Payment request denied!",
          color: kRed,
        ).build(context),
      );
      return;
    }

    final normalizedType = type?.trim().toLowerCase();

    switch (normalizedType) {
      case 'booking':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentMethodScreen()),
        );
        break;
      case 'advance':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentMethodScreenAdvanceBooking()),
        );
        break;
      case 'donation':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentMethodScreenDonation()),
        );
        break;
      case 'ehundi':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentMethodScreenEHundi(devathaName: selectedGods.toString(), star:selectedStar,)),
        );
        break;
      default:
        print("Unknown payment type received: $type");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarWidget(
            msg: "Unknown payment type!",
            color: kRed,
          ).build(context),
        );
    }

    notifyListeners();
  }



  void validateStar() {
    starError = Validation.validateStarSelection(selectedStar);
    notifyListeners();
  }

  void navigateToQrScannerBooking(BuildContext context, int int) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => QrScannerComponentBooking(
          amount: "$totalVazhipaduAmt",
          noOfScreen: 1,
          title: "QR Scanner",
          name: '',
          phone: '',
          acctHeadName: '',
        ),
      ),
    );
  }


  void navigateToQrScannerAdvanceBooking(BuildContext context, int int) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => QrScannerComponentAdvanceBooking(
          amount: "$totalVazhipaduAmt",
          noOfScreen: 1,
          title: "QR Scanner",
          name: '',
          phone: '',
          acctHeadName: '',
        ),
      ),
    );
  }


  void navigateToQrScanner(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => QrScannerComponentDonations(
              amount: "$totalVazhipaduAmt",
              noOfScreen: 1,
              title: "QR Scanner",
              name: '',
              phone: '',
              acctHeadName: '', address: '',
            ),
      ),
    );
  }

  void navigateToQrScannerAdv(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => QrScannerComponentAdvanceBooking(
          amount: "$totalVazhipaduAmt",
          noOfScreen: 1,
          title: "QR Scanner",
          name: '',
          phone: '',
          acctHeadName: '',
        ),
      ),
    );
  }



  void navigateToQr(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => QrScannerComponent(
              amount: "$totalVazhipaduAmt",
              noOfScreen: 1,
              title: "QR Scanner",
            ),
      ),
    );
  }
  // void navigateToBookingCashPayment(BuildContext context, int total) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => CashPaymentBooking(amount: total)),
  //   );
  // }


  void navigateToCashPaymentAdv(BuildContext context, int total) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CashPaymentAdvanceBooking(amount: total)),
    );
  }

  void navigateToCashPaymentAdvanceBooking(BuildContext context, int total) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CashPaymentAdvanceBooking(amount: total),
      ),
    );
  }

  void navigateCardScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CardPaymentScreen()),
    );
  }

  void switchSelectedRepMethod(String method) {
    _selectedRepMethod = method;
    notifyListeners();
  }

  bool toggleSelectedRepMethod(String method) {
    return _selectedRepMethod == method;
  }

  // bool toggleSelectedRepMethod(String value) {
  //   return _selectedRepMethod == value;
  // }
  void switchSelectedWeeklyDay(String day) {
    _selectedWeeklyDays.clear();
    _selectedWeeklyDays.add(day);
    notifyListeners();
  }

  bool toggleSelectedWeeklyDay(String day) {
    return _selectedWeeklyDays.contains(day);
  }

  int get totalBookingAmount {
    int total = 0;
    for (var booking in vazhipaduBookingList) {
      total += int.tryParse(booking.totalPrice?.toString() ?? '0') ?? 0;
    }
    return total;
  }

  List<String> get selectedWeeklyDays => _selectedWeeklyDays.toList();
}
