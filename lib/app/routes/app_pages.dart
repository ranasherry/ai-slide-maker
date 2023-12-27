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
import 'package:slide_maker/app/modules/pdfPermission/bindings/pdf_permission_binding.dart';
import 'package:slide_maker/app/modules/pdfPermission/views/pdf_permission_view.dart';
import 'package:slide_maker/app/modules/pdfView/bindings/pdf_view_binding.dart';
import 'package:slide_maker/app/modules/pdfView/views/pdf_view_view.dart';
import 'package:slide_maker/app/modules/showPDF/bindings/show_p_d_f_binding.dart';
import 'package:slide_maker/app/modules/showPDF/views/show_p_d_f_view.dart';

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
    GetPage(
      name: _Paths.PDF_PERMISSION,
      page: () => PdfPermissionView(),
      binding: PdfPermissionBinding(),
    ),
    GetPage(
      name: _Paths.PDF_VIEW,
      page: () => PdfViewView(),
      binding: PdfViewBinding(),
    ),
    GetPage(
      name: _Paths.SHOW_P_D_F,
      page: () => ShowPDFView(),
      binding: ShowPDFBinding(),
    ),
  ];
}
