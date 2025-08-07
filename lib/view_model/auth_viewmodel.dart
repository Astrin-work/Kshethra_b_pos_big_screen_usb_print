import 'package:flutter/material.dart';

import 'package:kshethra_mini/view/language_select_view.dart';
import 'package:kshethra_mini/view/login_view.dart';

import '../api_services/api_service.dart';
import '../utils/app_color.dart';
import '../utils/components/snack_bar_widget.dart';
import '../utils/hive/hive.dart';

class AuthViewmodel extends ChangeNotifier {
  // final ApiService _apiService = ApiService();
  final loginKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: "");
  bool _isPassVissible = false;
  bool get isPassVissible => _isPassVissible;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final ValueNotifier<bool> isLoginLoading = ValueNotifier<bool>(false);

  void tooglePass() {
    _isPassVissible = !_isPassVissible;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // void navigateHomeOrLogin(BuildContext context) {
  //   Future.delayed(const Duration(seconds: 3)).then(
  //         (_) => Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const LoginView()),
  //     ),
  //   );
  // }

  void navigateHomeOrLogin(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

    if (!context.mounted) return;

    final isLoggedIn = AppHive().getIsUserLoggedIn() == true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => isLoggedIn ? const LanguageSelectView() : const LoginView(),
      ),
    );
  }



  Future<void> selectLanguagePageNavigate(BuildContext context) async {
    bool valid = loginKey.currentState?.validate() ?? false;
    if (valid) {
      final username = userNameController.text.trim();
      final password = passwordController.text.trim();

      try {
        final token = await ApiService().login(username, password);
        print('Token: $token');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarWidget(msg: "Login successful", color: Colors.green).build(context),
        );
        appHive.putIsUserLoggedIn(isLoggedIn: true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LanguageSelectView()),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    }
  }


  void setLoginLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void logout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBarWidget(msg: "Logout successful", color: kRed).build(context),
    );

    // Clear login status
    AppHive().putIsUserLoggedIn(isLoggedIn: false);

    // Clear tokens
    AppHive().putToken(token: ""); // or pass null if your Hive logic allows
    AppHive().putRefreshToken( token: ''); // or pass null if your Hive logic allows

    // Clear all other Hive data if needed
    AppHive().clearHive();

    // Navigate to login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginView()),
          (route) => false,
    );
  }

}
