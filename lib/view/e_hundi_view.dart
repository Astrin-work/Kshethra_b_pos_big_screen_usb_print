import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import 'package:kshethra_mini/utils/components/responsive_layout.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/widgets/e_hundi_page_widgets/god_list_widget.dart';

class EHundiView extends StatelessWidget {
  const EHundiView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarWidget(title: "E-Bhandaram".tr()),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20,
                bottom: 15,
                top: 10,
              ),
              child: ResponsiveLayout(
                pinelabDevice: GodListWidget(),
                mediumDevice: GodListWidget(
                  axisCount: 3,
                  mainAxisSpace: 35,
                  crossAxisSpace: 40,
                ),
                largeDevice: GodListWidget(
                  axisCount: 4,
                  mainAxisSpace: 35,
                  crossAxisSpace: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




