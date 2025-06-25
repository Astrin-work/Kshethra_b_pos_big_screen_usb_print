import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view_model/e_hundi_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../view_model/home_page_viewmodel.dart';

class GodListWidget extends StatefulWidget {
  final double? crossAxisSpace;
  final double? mainAxisSpace;
  final int? axisCount;

  const GodListWidget({
    super.key,
    this.crossAxisSpace,
    this.mainAxisSpace,
    this.axisCount,
  });

  @override
  State<GodListWidget> createState() => _GodListWidgetState();
}

class _GodListWidgetState extends State<GodListWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<EHundiViewmodel>(context, listen: false).fetchEhundiGods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final fromLang = "en";
    SizeConfig().init(context);

    return Consumer<EHundiViewmodel>(
      builder: (context, viewmodel, child) {
        if (viewmodel.isLoading) {
          return const Center(child: CircularProgressIndicator(color: kDullPrimaryColor,));
        }

        final godList = viewmodel.gods;

        return GridView.builder(
          itemCount: godList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.axisCount ?? 2,
            crossAxisSpacing: widget.crossAxisSpace ?? 30,
            mainAxisSpacing: widget.mainAxisSpace ?? 25,
          ),
          itemBuilder: (context, index) {
            final god = godList[index];
            return InkWell(
              onTap: () {
                viewmodel.showEhundiDonationDialog(context);
                viewmodel.clearHundiAmount();
              },
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 2,
                            spreadRadius: 1,
                            color: kPrimaryColor,
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(god.devathaImage),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  10.kH,
                  BuildTextWidget(
                    text: god.devathaName,
                    color: kBlack,
                    fromLang:fromLang,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

