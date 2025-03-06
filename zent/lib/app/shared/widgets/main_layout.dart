// lib/shared/layouts/main_layout.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/controllers/sidebar_controller.dart';
import 'package:zent/app/shared/widgets/appbar.dart';
import 'package:zent/app/shared/widgets/sidebar/sidebar.dart';

class MainLayout extends StatelessWidget {
  final String pageTitle;
  final Widget child;

  const MainLayout({
    super.key,
    required this.pageTitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebarController = Get.find<SidebarController>();

    return Scaffold(
      // Remove drawer and appBar from Scaffold
      body: Obx(() => Row(
            children: [
              // Sidebar with animated width
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: sidebarController.isOpen.value ? 212 : 0,
                height: double.infinity,
                child: const Sidebar(),
              ),

              // Main content with custom AppBar at the top
              Expanded(
                child: Column(
                  children: [
                    CustomAppBar(
                      pageTitle: pageTitle,
                      onMenuPressed: () => sidebarController.toggleSidebar(),
                    ),
                    Expanded(child: child),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
