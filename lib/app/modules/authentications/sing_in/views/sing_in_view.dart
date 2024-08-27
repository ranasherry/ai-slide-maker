// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/utills/app_style.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/helprer_widgets/main_header_bg.dart';
import 'package:slide_maker/app/utills/size_config.dart';

import '../controllers/sing_in_controller.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignInView extends GetView<SignInController> {
  SignInView({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // For form validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              MainHeaderBG(
                width: SizeConfig.screenWidth,
                height: SizeConfig.blockSizeVertical * 35,
              ),
              GestureDetector(
                onTap: () {
                  Get.offAllNamed(Routes.HOMEVIEW1);
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 4,
                        vertical: SizeConfig.blockSizeVertical * 4),
                    height: SizeConfig.blockSizeVertical * 6,
                    width: SizeConfig.blockSizeHorizontal * 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors.textfieldcolor,
                    ),
                  ),
                ),
              ),
              // Text with gradient
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 14,
                ),
                child: Text('Sign in to your account',
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 7,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textfieldcolor),
                    )),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                        color: AppColors.textfieldcolor,
                      ),
                    ),
                    children: [
                      TextSpan(
                        text: "Already a member? \n ",
                      ),
                      TextSpan(
                        text: "Access your personalized features here",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      verticalSpace(SizeConfig.blockSizeVertical * 4),

                      // Email and password fields (replace with actual form fields)
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 90,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 8)),
                        child: TextFormField(
                          controller: controller.emailCTL,
                          autovalidateMode: AutovalidateMode
                              .onUserInteraction, // Validate on focus loss
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return 'Invalid email format';
                            }
                            return null; // No error messages
                          },
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4,
                                color: Colors.grey),
                            // border: OutlineInputBorder(),

                            filled: true,
                            fillColor: AppColors.textfieldcolor,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(
                                  SizeConfig.blockSizeHorizontal * 8)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(
                                  SizeConfig.blockSizeHorizontal * 8)),
                            ),
                          ),
                        ),
                      ),
                      verticalSpace(
                          SizeConfig.blockSizeVertical * 2), // Add spacing
                      Obx(() => Container(
                            width: SizeConfig.blockSizeHorizontal * 90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.blockSizeHorizontal * 8)),
                            child: TextFormField(
                              controller: controller.passwordCTL,

                              autovalidateMode: AutovalidateMode
                                  .onUserInteraction, // Validate on focus loss
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                if (value.length < 8) {
                                  return 'Password must be greater then 8 Charecters';
                                }
                                return null; // No error messages
                              },
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4,
                                    color: Colors.grey),
                                // border: OutlineInputBorder(),

                                filled: true,
                                fillColor: AppColors.textfieldcolor,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          SizeConfig.blockSizeHorizontal * 8)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          SizeConfig.blockSizeHorizontal * 8)),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    controller.showPwd.toggle();
                                  },
                                  child: Icon(controller.showPwd.value
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ), // Add password visibility toggle
                              ),
                              obscureText: !controller
                                  .showPwd.value, // Hide password text
                            ),
                          )),
                      verticalSpace(
                          SizeConfig.blockSizeVertical * 5), // Add spacing

                      // Sign in button with rounded corners

                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            controller.signInWithEmail();
                          }
                        },
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 7,
                          width: SizeConfig.blockSizeHorizontal * 85,
                          decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.blockSizeHorizontal * 8)),
                          child: Center(
                            child: Text("Sign In", style: AppStyle.button),
                          ),
                        ),
                      ),

                      verticalSpace(
                          SizeConfig.blockSizeVertical * 2), // Add spacing

                      // Sign in with Google button
                      // SignInButton(
                      //   Buttons.Google,
                      //   text: 'Sign in with Google',
                      //   onPressed: () => controller.signInWithGoogle(),
                      // ),
                      // const SizedBox(height: 10.0), // Add spacing

                      // Sign up button with border and text color
                      TextButton(
                        onPressed: () => Get.offAllNamed(
                            Routes.SING_UP), // Navigate to signup page
                        child: const Text(
                          'Don\'t have an account? Sign Up',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
