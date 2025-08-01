// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:kshethra_mini/view_model/home_page_viewmodel.dart';
// import 'package:kshethra_mini/view/widgets/google_translator_service.dart';
//
// class BuildTextWidget extends StatefulWidget {
//   final String text;
//   final Color? color;
//   final double? size;
//   final FontWeight? fontWeight;
//   final int? maxLines;
//   final TextAlign? textAlign;
//   final String? fromLang;
//   final bool? softWrap;
//   final TextOverflow? overflow;
//   final Function(String)? onTranslated;
//   final TextStyle? style;
//
//   const BuildTextWidget({
//     Key? key,
//     required this.text,
//     this.color = Colors.black,
//     this.size = 14.0,
//     this.fontWeight = FontWeight.normal,
//     this.maxLines = 1,
//     this.textAlign = TextAlign.left,
//     this.fromLang,
//     this.softWrap,
//     this.overflow,
//     this.onTranslated,
//     this.style, // ✅ Accept custom style
//   }) : super(key: key);
//
//   @override
//   State<BuildTextWidget> createState() => _BuildTextWidgetState();
// }
//
// class _BuildTextWidgetState extends State<BuildTextWidget> {
//   String? translatedText;
//   bool _isTranslating = false;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final toLang = Provider.of<HomePageViewmodel>(context).currentLanguage;
//     _translate(widget.text, widget.fromLang, toLang);
//   }
//
//   @override
//   void didUpdateWidget(covariant BuildTextWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     final toLang = Provider.of<HomePageViewmodel>(context, listen: false).currentLanguage;
//     if (oldWidget.text != widget.text || oldWidget.fromLang != widget.fromLang) {
//       _translate(widget.text, widget.fromLang, toLang);
//     }
//   }
//
//   Future<void> _translate(String text, String? fromLang, String toLang) async {
//     if (text.isEmpty || toLang.isEmpty || toLang == 'en') {
//       setState(() {
//         translatedText = text;
//         _isTranslating = false;
//       });
//       return;
//     }
//
//     setState(() => _isTranslating = true);
//
//     try {
//       final translator = GoogleTranslatorService();
//       final result = await translator.translateText(
//         text,
//         toLang,
//         sourceLang: fromLang ?? 'auto',
//       );
//
//       if (!mounted) return;
//       setState(() {
//         translatedText = result;
//         _isTranslating = false;
//       });
//       widget.onTranslated?.call(result);
//     } catch (e) {
//       debugPrint("Translation failed: $e");
//       if (!mounted) return;
//       setState(() {
//         translatedText = text;
//         _isTranslating = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isTranslating || translatedText == null) {
//       return const SizedBox.shrink();
//     }
//
//     return Text(
//       translatedText!,
//       maxLines: widget.maxLines,
//       softWrap: widget.softWrap ?? true,
//       overflow: widget.overflow ?? TextOverflow.ellipsis,
//       textAlign: widget.textAlign,
//       style: widget.style ?? TextStyle(
//         color: widget.color,
//         fontSize: widget.size,
//         fontWeight: widget.fontWeight,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class BuildTextWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextStyle? style;
  final String? fromLang; // Optional language field

  const BuildTextWidget({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.size = 14.0,
    this.fontWeight = FontWeight.normal,
    this.maxLines = 1,
    this.textAlign = TextAlign.left,
    this.softWrap,
    this.overflow,
    this.style,
    this.fromLang, // Included but unused in this version
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
      style: style ??
          TextStyle(
            color: color,
            fontSize: size,
            fontWeight: fontWeight,
          ),
    );
  }
}

