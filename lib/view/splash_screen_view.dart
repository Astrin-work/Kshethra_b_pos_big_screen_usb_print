import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/asset/assets.gen.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view_model/auth_viewmodel.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    AuthViewmodel().navigateHomeOrLogin(context);
    return Scaffold(
      body: Center(
        child: Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.images.splashBackground.path),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(

            children: [
              15.kH,
              Spacer(),
              SizedBox(
                width: 280,
                child: Image.asset(Assets.icons.kshethraLogo.path),
              ),
              Spacer(),
              SizedBox(
                width: 150,
                child: Image.asset(Assets.icons.astrinsLogo.path),
              ),
              15.kH,
            ],
          ),
        ),
      ),
    );
  }
}
