import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class MainHeaderBG extends StatelessWidget {
  MainHeaderBG({required this.width, required this.height});

  double width;
  double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.headerContainerColor,
        // gradient: LinearGradient(colors: AppColors.headerContainerGradient),
        // image: DecorationImage(
        //     image: AssetImage(
        //       AppImages.slide_background,
        //     ),
        //     fit: BoxFit.cover)
      ),
      child: SvgPicture.asset(
        AppImages.HeaderMainBgSVG,
        // height: SizeConfig.blockSizeHorizontal * 40,
        fit: BoxFit.cover,
        // colorFilter:
        // ColorFilter.mode(Colors.green, BlendMode.softLight),
        semanticsLabel: 'Acme Logo',
        placeholderBuilder: (BuildContext context) => Container(
            padding: const EdgeInsets.all(30.0),
            child: const CircularProgressIndicator()),
      ),
    );
  }
}
