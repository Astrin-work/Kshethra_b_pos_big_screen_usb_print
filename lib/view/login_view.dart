import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/asset/assets.gen.dart';
import 'package:kshethra_mini/utils/components/responsive_layout.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/utils/validation.dart';
import 'package:kshethra_mini/view/widgets/login_widget.dart';
import 'package:kshethra_mini/view_model/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.cleanBg.path),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 200,),
              SizedBox(
                width: 300,
                child: Image.asset(Assets.icons.kshethraLogo.path),
              ),
              SizedBox(height: 50,),
              ResponsiveLayout(
                pinelabDevice: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: LoginWidget(),
                ),
                mediumDevice: Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth * 0.15,
                    right: SizeConfig.screenWidth * 0.15,
                  ),
                  child: LoginWidget(),
                ),
                largeDevice: Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth * 0.25,
                    right: SizeConfig.screenWidth * 0.25,
                  ),
                  child: LoginWidget(),
                ),
              ),
              10.kH,
              SizedBox(height:300 ,),
              SizedBox(
                width: 250,
                child: Image.asset(Assets.icons.astrinsLogo.path),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

