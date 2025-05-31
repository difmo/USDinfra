import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdinfra/Customs/custom_textfield.dart';
import 'package:usdinfra/Utils/validators.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/controllers/login_controller.dart';

class LoginWithMob extends StatelessWidget {
  const LoginWithMob({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: isWeb ? 500 : double.infinity),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo with fade-in animation
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 800),
                    child: Image.asset(
                      'assets/animations/logo.png',
                      height: isWeb ? 200 : 150,
                      width: isWeb ? 200 : 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Title with subtle slide animation
                  AnimatedSlide(
                    offset: const Offset(0, 0),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: isWeb ? 32 : 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        fontFamily: AppFontFamily.primaryFont,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Subtitle with accessibility support
                  Text(
                    'Log in with your mobile number to continue',
                    style: TextStyle(
                      fontSize: isWeb ? 18 : 16,
                      color: Colors.grey[600],
                      fontFamily: AppFontFamily.primaryFont,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                    semanticsLabel:
                        'Log in with your mobile number to continue',
                  ),
                  const SizedBox(height: 48),
                  // Decorative divider
                  Container(
                    width: 60,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Section title
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: isWeb ? 26 : 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      fontFamily: AppFontFamily.primaryFont,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Mobile input field with soft shadow and rounded corners

                  CustomInputField(
                    controller: controller.mobileController,
                    hintText: "Enter your mobile number.",
                    onChanged: controller.validateMobile,
                    inputType: TextInputType.number,
                    // validator: Validators.validateMobileNumber,
                  ),

                  const SizedBox(height: 24),
                  // Send OTP button with hover effect and animation
                  Obx(
                    () => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.sendOtp,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              AppColors.primary.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          shadowColor: Colors.grey.withOpacity(0.3),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ).copyWith(
                          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.hovered)) {
                                return AppColors.primary.withOpacity(0.1);
                              }
                              return null;
                            },
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                'Send OTP',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: AppFontFamily.primaryFont,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Optional footer text for accessibility
                  Text(
                    'We’ll send a one-time password to your mobile number',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                      fontFamily: AppFontFamily.primaryFont,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
