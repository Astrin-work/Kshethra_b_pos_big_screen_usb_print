import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/widgets/laguage_select_widgets/language_box.dart';
import 'package:kshethra_mini/view_model/home_page_viewmodel.dart';
import 'package:provider/provider.dart';

class LanguageSelectView extends StatelessWidget {
  const LanguageSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Consumer<HomePageViewmodel>(
        builder: (context, homepageViewmodel, child) {
          return const _ImageSliderWithLanguageBox();
        },
      ),
    );
  }
}

class _ImageSliderWithLanguageBox extends StatefulWidget {
  const _ImageSliderWithLanguageBox();

  @override
  State<_ImageSliderWithLanguageBox> createState() =>
      _ImageSliderWithLanguageBoxState();
}

class _ImageSliderWithLanguageBoxState
    extends State<_ImageSliderWithLanguageBox> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<String> _imagePaths = [
    'assets/images/god1.jpg',
    'assets/images/1633515167_Pariyanampetta Pooram Kaala Vela.png',
    'assets/images/temple_image3.jpg',
    'assets/images/temple_image7.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage =
        _currentPage == _imagePaths.length - 1 ? 0 : _currentPage + 1;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage = nextPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight * 0.53,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              child: PageView.builder(
                controller: _pageController,
                itemCount: _imagePaths.length,
                itemBuilder: (context, index) {
                  bool isActive = index == _currentPage;
                  return AnimatedScale(
                    scale: isActive ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 600),
                    child: Image.asset(
                      _imagePaths[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ),
          const LanguageBox(),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:kshethra_mini/utils/components/size_config.dart';
// import 'package:kshethra_mini/view/widgets/laguage_select_widgets/language_box.dart';
// import 'package:kshethra_mini/view_model/home_page_viewmodel.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
//
// class LanguageSelectView extends StatelessWidget {
//   const LanguageSelectView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Scaffold(
//       body: Consumer<HomePageViewmodel>(
//         builder: (context, homepageViewmodel, child) {
//           return const _VideoWithLanguageBox();
//         },
//       ),
//     );
//   }
// }
//
// class _VideoWithLanguageBox extends StatefulWidget {
//   const _VideoWithLanguageBox();
//
//   @override
//   State<_VideoWithLanguageBox> createState() => _VideoWithLanguageBoxState();
// }
//
// class _VideoWithLanguageBoxState extends State<_VideoWithLanguageBox> {
//   late VideoPlayerController _controller;
//   bool _isVideoInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset('assets/videos/pariyanampatta_short.mp4')
//       ..initialize().then((_) {
//         setState(() {
//           _isVideoInitialized = true;
//           _controller.setLooping(true);
//           _controller.play();
//         });
//       });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           if (_isVideoInitialized)
//             SizedBox(
//               width: SizeConfig.screenWidth,
//               height: SizeConfig.screenHeight * 0.53,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(25),
//                   bottomRight: Radius.circular(25),
//                 ),
//                 child: FittedBox(
//                   fit: BoxFit.cover,
//                   child: SizedBox(
//                     width: _controller.value.size.width,
//                     height: _controller.value.size.height,
//                     child: VideoPlayer(_controller),
//                   ),
//                 ),
//               ),
//             )
//           else
//             SizedBox(
//               width: SizeConfig.screenWidth,
//               height: SizeConfig.screenHeight * 0.53,
//               child: const Center(child: CircularProgressIndicator()),
//             ),
//           const LanguageBox(),
//         ],
//       ),
//     );
//   }
// }
