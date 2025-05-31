import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/controllers/login_controller.dart';
import 'package:usdinfra/routes/app_routes.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);

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
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Decorative divider
                    Container(
                      width: 60,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 159, 159),
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
                    // Title with slide animation
                    AnimatedSlide(
                      offset: const Offset(0, 0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      child: Text(
                        'Verify OTP',
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
                    // Subtitle with mobile number
                    Obx(() => Text(
                          'OTP sent to +91 ${controller.mobileNumber.value}',
                          style: TextStyle(
                            fontSize: isWeb ? 18 : 16,
                            color: Colors.grey[600],
                            fontFamily: AppFontFamily.primaryFont,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                          semanticsLabel:
                              'OTP sent to +91 ${controller.mobileNumber.value}',
                        )),
                    const SizedBox(height: 32),
                    // OTP input field with modern styling
                    OtpTextField(
                      numberOfFields: 6,
                      borderColor: Colors.grey[300]!,
                      focusedBorderColor: AppColors.primary,
                      fieldWidth: 45,
                      // fieldHeight: isWeb ? 60 : 50,
                      textStyle: TextStyle(
                        fontSize: isWeb ? 20 : 18,
                        fontFamily: AppFontFamily.primaryFont,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      showFieldAsBox: true,
                      borderWidth: 1,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 2),
                        ),
                      ),
                      onCodeChanged: (String code) {
                        controller.otpController.text = code;
                      },
                      onSubmit: controller.verifyOtp,
                    ),
                    const SizedBox(height: 24),
                    // Verify OTP button with hover effect
                    Obx(() => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () async {
                                    await controller.verifyOtp(
                                        controller.otpController.text);
                                    // Get.toNamed(AppRoutes.homePage);
                                  },
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
                              overlayColor:
                                  WidgetStateProperty.resolveWith<Color?>(
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
                                    'Verify OTP',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontFamily: AppFontFamily.primaryFont,
                                    ),
                                  ),
                          ),
                        )),
                    const SizedBox(height: 16),
                    // Footer text for accessibility
                    Text(
                      'Enter the 6-digit code sent to your mobile number',
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
      ),
    );
  }
}
