import 'package:ecommerce_app/common/styles/spacing_style.dart';
import 'package:ecommerce_app/common/widgets/login_signup/form_divider.dart';
import 'package:ecommerce_app/common/widgets/login_signup/social_buttons.dart';
import 'package:ecommerce_app/features/authentication/screens/login/widgets/login_form.dart';
import 'package:ecommerce_app/features/authentication/screens/login/widgets/login_header.dart';
import 'package:ecommerce_app/utils/constants/sizes.dart';
import 'package:ecommerce_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              // Logo, Title and Subtitle
              const TLoginHeader(),

              // Form
              const TLoginForm(),

              // Divider
              TFormDivider(dividerText: TTexts.orSignInWith.capitalize!),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Footer
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
