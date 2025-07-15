import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:provider/provider.dart';

class GodWidget extends StatefulWidget {
  const GodWidget({super.key});

  @override
  State<GodWidget> createState() => _GodWidgetState();
}

class _GodWidgetState extends State<GodWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<BookingViewmodel>(context, listen: false).fetchGods());
  }

  @override
  Widget build(BuildContext context) {
    // final currentLang = Provider.of<HomePageViewmodel>(context).currentLanguage;
    // AppStyles styles = AppStyles();
    SizeConfig().init(context);

    return Consumer<BookingViewmodel>(
      builder: (context, bookingViewmodel, child) {
        final godList = bookingViewmodel.gods;
        final isLoading = bookingViewmodel.isLoading;
        final fromLang = "en";
        if (isLoading) {
          return const Center(child: CircularProgressIndicator(color: kDullPrimaryColor,));
        }

        return SizedBox(
          height: SizeConfig.screenHeight*0.175,
          width: SizeConfig.screenWidth,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: godList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        bookingViewmodel.setGod(godList[index]);
                        print('------pressed-------');
                      },
                      child:
                      Container(
                        height: SizeConfig.screenHeight * 0.140,
                        width: SizeConfig.screenWidth * 0.213,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: bookingViewmodel.selectedGods == godList[index]
                                  ? kPrimaryColor
                                  : kTransparent,
                              blurRadius: 5,
                              spreadRadius: 5,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: AssetImage('assets/images/make_image.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(godList[index].devathaImage),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      )


                    ),
                    Padding(
                      padding:  EdgeInsets.only(top: 5),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: BuildTextWidget(
                          text: godList[index].devathaName,
                          fromLang: fromLang,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

