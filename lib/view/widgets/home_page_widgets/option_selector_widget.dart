import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/asset/assets.gen.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';

class OptionSelectorWidget extends StatelessWidget {
  final void Function()? onTap;
  final Widget icon;
  final String? title;
  final Widget? titleWidget;

  const OptionSelectorWidget({
    super.key,
    required this.icon,
    this.title,
    this.titleWidget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();
    SizeConfig().init(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: SizeConfig.screenHeight * 0.16,
        width: SizeConfig.screenWidth * 0.32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(Assets.images.langBackground.path),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 8),
            titleWidget ??
                Text(
                  title ?? '',
                  textAlign: TextAlign.center,
                  style: styles.blackRegular18,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
          ],
        ),

      ),
    );
  }
}
