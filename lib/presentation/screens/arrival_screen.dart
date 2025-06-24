import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sizer/sizer.dart';
import 'package:toktokapp/controllers/language_controller.dart';
import 'package:toktokapp/controllers/theme_controller.dart';

class ArrivalScreen extends StatelessWidget {
  final LatLng destination;

  const ArrivalScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Obx(() => Text(
              Get.find<LanguageController>().isEnglish ? 'ع' : 'EN',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            )),
            onPressed: () => Get.find<LanguageController>().toggleLanguage(),
          ),
          Spacer(),
          IconButton(
            icon: Obx(() => Icon(Get.find<ThemeController>().isDarkMode.value
                ? Icons.light_mode
                : Icons.dark_mode)),
            onPressed: () => Get.find<ThemeController>().toggleTheme(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text(
              "Your TokTok has arrived!",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              "Destination: ${destination.latitude.toStringAsFixed(4)}, ${destination.longitude.toStringAsFixed(4)}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}