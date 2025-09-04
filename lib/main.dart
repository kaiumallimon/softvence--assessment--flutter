import 'package:assessment/constants/colors.dart';
import 'package:assessment/features/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const AssessmentApp());
}

class AssessmentApp extends StatelessWidget {
  const AssessmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assessment App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
        ),
        primaryColor: AppColors.primaryColor,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bgColor,
        textTheme: Theme.of(
          context,
        ).textTheme.apply(bodyColor: AppColors.textColor),
      ),
      home: const OnboardingPage(),
    );
  }
}
