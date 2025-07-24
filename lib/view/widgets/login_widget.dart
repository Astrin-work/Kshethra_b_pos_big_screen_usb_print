import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api_services/api_service.dart';
import '../../utils/app_color.dart';
import '../../utils/app_styles.dart';
import '../../utils/components/size_config.dart';
import '../../utils/validation.dart';
import '../../view_model/auth_viewmodel.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();
    SizeConfig().init(context);
    return Center(
      child: Consumer<AuthViewmodel>(
        builder:
            (context, authViewmodel, child) => SingleChildScrollView(
          child: Form(
            key: authViewmodel.loginKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator:
                      (value) => Validation.emptyValidation(
                    value,
                    "Enter your Username",
                  ),
                  controller: authViewmodel.userNameController,
                  style: styles.whiteRegular18,
                  decoration: InputDecoration(
                    hintText: "User Name",
                    hintStyle: styles.whiteRegular18,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                25.kH,
                TextFormField(
                  validator:
                      (value) => Validation.emptyValidation(
                    value,
                    "Enter your Password",
                  ),
                  controller: authViewmodel.passwordController,
                  style: styles.whiteRegular18,
                  obscureText: !authViewmodel.isPassVissible,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: authViewmodel.tooglePass,
                      icon:
                      authViewmodel.isPassVissible
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                    ),
                    hintText: "Password",
                    hintStyle: styles.whiteRegular18,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                55.kH,
                MaterialButton(
                  onPressed: authViewmodel.isLoading
                      ? null
                      : () async {
                    authViewmodel.setLoading(true);
                    print('-----------Device Details--------------');
                    await ApiService().printDeviceDetails();
                    await authViewmodel.selectLanguagePageNavigate(context);

                    authViewmodel.setLoading(false);
                  },
                  minWidth: 150,
                  height: 45,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: kWhite,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: authViewmodel.isLoading
                        ? const SizedBox(
                      key: ValueKey('loader'),
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: kBlack,
                      ),
                    )
                        : Text(
                      "LOGIN",
                      key: const ValueKey('loginText'),
                      style: styles.blackRegular18,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}