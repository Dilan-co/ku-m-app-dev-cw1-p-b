import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:global_news_app/controllers/state_controller.dart';
import 'package:global_news_app/data/services/database_service.dart';
import 'package:global_news_app/presentation/screens/home_page.dart';
import 'package:global_news_app/utils/constants/size.dart';
import 'package:global_news_app/utils/constants/theme.dart';
import 'package:global_news_app/utils/helpers/local_storage_path.dart';

void main() {
  // Splash Screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initialization();
  }

  void initialization() async {
    //This is where you can initialize the resources needed by your app while the splash screen is displayed.

    //Status Bar & Nav Bar colors
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: CFGTheme.bgColorScreen,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: CFGTheme.bgColorScreen,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    //Initialize GetX State Controller
    Get.put(StateController());
    //Initialize SQFLite Database
    await DatabaseService().database;
    //Getting Local Storage Path
    localStoragePath();
    //Removing Splash Screen after initializing
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
