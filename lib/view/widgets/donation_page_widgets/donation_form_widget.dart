import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/asset/assets.gen.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/utils/validation.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view_model/donation_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../api_services/api_service.dart';
import '../../../model/api models/get_donation_model.dart';

class DonationFormWidget extends StatefulWidget {
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final int? crossAxisCount;

  const DonationFormWidget({
    super.key,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
    this.crossAxisCount,
  });

  @override
  _DonationFormWidgetState createState() => _DonationFormWidgetState();
}

class _DonationFormWidgetState extends State<DonationFormWidget> {
  late TextEditingController donationNameController;
  late TextEditingController donationPhnoController;
  late TextEditingController donationAddressController;
  List<Getdonationmodel> donations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    donationNameController = TextEditingController();
    donationPhnoController = TextEditingController();
    donationAddressController = TextEditingController();
    fetchDonations();
  }

  Future<void> fetchDonations() async {
    try {
      final fetchedDonations = await ApiService().getDonation();
      setState(() {
        donations = fetchedDonations;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching donations: $e");
    }
  }


  @override
  void dispose() {
    donationNameController.dispose();
    donationPhnoController.dispose();
    donationAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fromLang = "en";
    AppStyles styles = AppStyles();
    SizeConfig().init(context);

    return Consumer<DonationViewmodel>(
      builder: (context, donationViewmodel, child) => isLoading
          ? Center(child: CircularProgressIndicator(color: kDullPrimaryColor,))
          : SizedBox(
        child: Form(
          key: donationViewmodel.donationFormKey,
          child: Column(
            children: [
              25.kH,
              TextFormField(
                autofocus: true,
                validator: Validation.nameValidation,
                controller: donationNameController,
                textAlign: TextAlign.center,
                style: styles.blackRegular15,
                decoration: InputDecoration(
                  hintText: "Name".tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color:kDullPrimaryColor ,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              25.kH,
              TextFormField(
                keyboardType: TextInputType.number,
                validator: Validation.phoneValidation,
                controller: donationPhnoController,
                textAlign: TextAlign.center,
                style: styles.blackRegular15,
                maxLength: 10,
                decoration: InputDecoration(
                  hintText: "Phone".tr(),
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color:kDullPrimaryColor ,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              25.kH,
              TextFormField(
                autofocus: true,
                controller: donationAddressController,
                textAlign: TextAlign.center,
                style: styles.blackRegular15,
                decoration: InputDecoration(
                  hintText: "Address".tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color:kDullPrimaryColor ,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              25.kH,
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: donations.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: widget.mainAxisSpacing/1,
                  crossAxisSpacing: widget.crossAxisSpacing/6   ,
                  crossAxisCount: widget.crossAxisCount ?? 3,
                ),
                itemBuilder: (context, index) {
                  final donationItem = donations[index];
                  return InkWell(
                    onTap: () {
                      donationViewmodel.showDonationDialog(
                        context,
                        donationNameController.text,
                        donationPhnoController.text,
                        donationItem.acctHeadName,
                        donationAddressController.text,
                      );

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: AssetImage(Assets.images.homeBackground.path),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: kWhite,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BuildTextWidget(
                                text:
                                donationItem.acctHeadName,
                                fromLang:fromLang ,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              15.kH,
            ],
          ),
        ),
      ),
    );
  }
}

