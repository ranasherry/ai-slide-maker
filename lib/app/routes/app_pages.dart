import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:slide_maker/app/modules/bindings/settings_view_binding.dart';
import 'package:slide_maker/app/modules/bindings/slide_assistant_binding.dart';
import 'package:slide_maker/app/modules/home/settings_screen_view.dart';
import 'package:slide_maker/app/modules/home/slide_assistant.dart';
import 'package:slide_maker/app/modules/home/sub_home_view.dart';
import 'package:slide_maker/app/modules/home/sub_slide_maker_view.dart';
import 'package:slide_maker/app/modules/invitation_maker/bindings/weddinginvitation_binding.dart';
import 'package:slide_maker/app/modules/invitation_maker/views/b.templates/b_template1.dart';
import 'package:slide_maker/app/modules/invitation_maker/views/wedding_invite_view.dart';

import '../modules/bindings/gems_view_binding.dart';
import '../modules/bindings/history_binding.dart';
import '../modules/bindings/history_slide_binding.dart';
import '../modules/bindings/home_view_binding.dart';
import '../modules/bindings/maths_solver_binding.dart';
import '../modules/bindings/slide_maker_binding.dart';
import '../modules/bindings/splash_binding.dart';
import '../modules/home/gems_view_view.dart';
import '../modules/home/history_slide_view.dart';
import '../modules/home/history_view.dart';
import '../modules/home/home_view.dart';
import '../modules/home/maths_solver_view.dart';
import '../modules/home/short_question_view.dart';
import '../modules/home/slide_maker_view.dart';
import '../modules/home/splash_screen.dart';
import '../modules/intro_screens/bindings/intro_screens_binding.dart';
import '../modules/intro_screens/views/intro_screens_view.dart';
import '../modules/invitation_maker/bindings/invitation_maker_binding.dart';
import '../modules/invitation_maker/views/invitation_maker_view.dart';
import '../modules/pdfPermission/bindings/pdf_permission_binding.dart';
import '../modules/pdfPermission/views/pdf_permission_view.dart';
import '../modules/pdfView/bindings/pdf_view_binding.dart';
import '../modules/pdfView/views/pdf_view_view.dart';
import '../modules/ppt_uploader/bindings/ppt_uploader_binding.dart';
import '../modules/ppt_uploader/views/ppt_uploader_view.dart';
import '../modules/showPDF/bindings/show_p_d_f_binding.dart';
import '../modules/showPDF/views/show_p_d_f_view.dart';
import '../modules/showppt/bindings/ppt_list_binding.dart';
import '../modules/showppt/bindings/show_ppt_binding.dart';
import '../modules/showppt/views/ppt_list_viewer.dart';
import '../modules/showppt/views/show_p_p_t_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SplashScreen;
  // static const INITIAL = Routes.SHOW_P_D_F;
  // static const INITIAL = Routes.PPT_UPLOADER;

  static final routes = [
    GetPage(
      name: _Paths.HomeView,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SubHomeView,
      page: () => SubHomeView(),
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
    GetPage(
      name: _Paths.ShowPPTView,
      page: () => ShowPPTView(),
      binding: ShowPPTBinding(),
    ),
    GetPage(
      name: _Paths.HistorySlideView,
      page: () => HistorySlideView(),
      binding: HistorySlideBinding(),
    ),
    GetPage(
      name: _Paths.PPT_UPLOADER,
      page: () => PptUploaderView(),
      binding: PptUploaderBinding(),
    ),
    GetPage(
      name: _Paths.PPTListView,
      page: () => PPTListView(),
      binding: PPTListBinding(),
    ),
    GetPage(
      name: _Paths.INTRO_SCREENS,
      page: () => const IntroScreensView(),
      binding: IntroScreensBinding(),
    ),
    GetPage(
      name: _Paths.INVITATION_MAKER,
      page: () => const InvitationMakerView(),
      binding: InvitationMakerBinding(),
    ),
    GetPage(
      name: _Paths.WeddingInvitationView,
      page: () => const WeddingInvitationView(),
      binding: WeddingInvitationBinding(),
    ),
    GetPage(
      name: _Paths.BirthdayTemplate,
      page: () => const BirthdayTemplate(),
      // binding: ,
    ),
    GetPage(
      name: _Paths.SettingsView,
      page: () => const SettingsView(),
      binding: SettingsViewbinding(),
    ),

    GetPage(
      name: _Paths.SubSlideView,
      page: () => const SubSlideView(),
      // binding: ,
    ),
    GetPage(
      name: _Paths.AiSlideAssistant,
      page: () => const AiSlideAssistant(),
      binding: AiSlideAssistantBinding(),
    ),
  ];
}
