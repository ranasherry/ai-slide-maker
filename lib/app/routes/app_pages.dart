import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:slide_maker/app/modules/bindings/history_binding.dart';
import 'package:slide_maker/app/modules/bindings/home_view_binding.dart';
import 'package:slide_maker/app/modules/bindings/maths_solver_binding.dart';
import 'package:slide_maker/app/modules/bindings/slide_maker_binding.dart';
import 'package:slide_maker/app/modules/home/gems_view_view.dart';
import 'package:slide_maker/app/modules/home/history_view.dart';
import 'package:slide_maker/app/modules/home/home_view.dart';
import 'package:slide_maker/app/modules/home/maths_solver_view.dart';
import 'package:slide_maker/app/modules/home/short_question_view.dart';
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
      name: _Paths.HomeView,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
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
    // GetPage(
    //   name: _Paths.GemsView,
    //   page: () => GemsView(),
    //   binding: GemsViewBinding(),
    // ),
    GetPage(
      name: _Paths.MathsSolverView,
      page: () => MathsSolverView(),
      binding: MathsSolverBinding(),
    ),
    GetPage(
      name: _Paths.ShortQuestionView,
      page: () => ShortQuestionView(),
      binding: MathsSolverBinding(),
    ),
    GetPage(
      name: _Paths.HistoryView,
      page: () => HistoryView(),
      binding: HistoryBinding(),
    ),
  ];
}
