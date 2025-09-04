import 'package:assessment/constants/colors.dart';
import 'package:assessment/features/location/providers/location_provider.dart';
import 'package:assessment/features/onboarding/onboarding_page.dart';
import 'package:assessment/helpers/hive_helper.dart';
import 'package:assessment/helpers/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDBHelper.initHive();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
  await NotificationHelper.init(
    onNotificationDismissed: (id) async {
      await HiveDBHelper.deleteAlarm(id);
      debugPrint("Alarm $id dismissed and deleted");
    },
  );

  runApp(const AssessmentApp());
}

class AssessmentApp extends StatelessWidget {
  const AssessmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationProvider(),
      child: MaterialApp(
        title: 'Assessment App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
          primaryColor: AppColors.primaryColor,
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.bgColor,
          textTheme: Theme.of(
            context,
          ).textTheme.apply(bodyColor: AppColors.textColor),
        ),
        home: const OnboardingPage(),
      ),
    );
  }
}
