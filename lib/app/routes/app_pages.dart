import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:slide_maker/app/modules/bindings/slide_maker_binding.dart';
import 'package:slide_maker/app/modules/home/gems_view_view.dart';
import 'package:slide_maker/app/modules/home/slide_maker_view.dart';

import '../modules/bindings/gems_view_binding.dart';
import '../modules/bindings/splash_binding.dart';
import '../modules/home/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SplashScreen;

  static final routes = [
    GetPage(
      name: _Paths.SplashScreen,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.SlideMakerView,
      page: () => SlideMakerView(),
      binding: SlideMakerBinding(),
    ),
    GetPage(
      name: _Paths.GemsView,
      page: () => GemsView(),
      binding: GemsViewBinding(),
    ),
  ];
}
