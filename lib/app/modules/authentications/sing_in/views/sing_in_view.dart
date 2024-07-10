// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:slide_maker/app/routes/app_pages.dart';

import '../controllers/sing_in_controller.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignInView extends GetView<SignInController> {
  SignInView({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // For form validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Get.offAllNamed(Routes.HomeView);
            },
            child: Icon(Icons.cancel)),

        title: const Text(
          'SignIn',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        // backgroundColor: Colors.blueAccent, // Set app bar background color
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0), // Add padding
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Text with gradient
              Text(
                'Sign in to your account',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  // foreground: GradientTextDecoration(
                  //   gradient: LinearGradient(
                  //     colors: [Colors.blueAccent, Colors.purpleAccent],
                  //   ),
                  // ),
                ),
              ),
              const SizedBox(height: 20.0), // Add spacing

              // Email and password fields (replace with actual form fields)
              TextFormField(
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
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0), // Add spacing
              Obx(() => TextFormField(
                    controller: controller.passwordCTL,

                    autovalidateMode: AutovalidateMode
                        .onUserInteraction, // Validate on focus loss
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null; // No error messages
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          controller.showPwd.toggle();
                        },
                        child: Icon(controller.showPwd.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ), // Add password visibility toggle
                    ),
                    obscureText:
                        !controller.showPwd.value, // Hide password text
                  )),
              const SizedBox(height: 20.0), // Add spacing

              // Sign in button with rounded corners
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    controller.signInWithEmail();
                  }
                }, // Use controller's signIn method
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 10.0), // Add spacing

              // Sign in with Google button
              SignInButton(
                Buttons.Google,
                text: 'Sign in with Google',
                onPressed: () => controller.signInWithGoogle(),
              ),
              const SizedBox(height: 10.0), // Add spacing

              // Sign up button with border and text color
              TextButton(
                onPressed: () =>
                    Get.offAllNamed(Routes.SING_UP), // Navigate to signup page
                child: const Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
