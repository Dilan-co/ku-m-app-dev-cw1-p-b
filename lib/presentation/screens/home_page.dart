import 'package:flutter/material.dart';
import 'package:global_news_app/presentation/screens/categories_page.dart';
import 'package:global_news_app/presentation/screens/featured_page.dart';
import 'package:global_news_app/presentation/screens/saved_page.dart';
import 'package:global_news_app/presentation/screens/search_page.dart';
import 'package:global_news_app/utils/constants/size.dart';
import 'package:global_news_app/utils/constants/text_style.dart';
import 'package:global_news_app/utils/constants/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController pageController = PageController();
  int selectedIndex = 0;

  // Screens for each bottom nav item
  final List<Widget> screens = [
    FeaturedPage(key: UniqueKey()),
    CategoriesPage(key: UniqueKey()),
    SearchPage(key: UniqueKey()),
    SavedPage(key: UniqueKey()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    //Initializing MediaQuery for padding
    CFGSize().init(context);
    return Scaffold(
      backgroundColor: CFGTheme.bgColorScreen,
      body: Padding(
        padding: EdgeInsets.only(
          left: CFGSize.bodyLRPadding,
          right: CFGSize.bodyLRPadding,
          // top: CFGSize.bodyTBPadding,
          // bottom: CFGSize.bodyTBPadding,
        ),
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: screens,
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: CFGTheme.bgColorScreen),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.shifting,
          elevation: 10,
          useLegacyColorScheme: true,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          unselectedIconTheme: const IconThemeData(opacity: 0.5),
          unselectedItemColor: CFGTheme.buttonOverlay,
          selectedIconTheme: const IconThemeData(opacity: 1),
          selectedItemColor: CFGTheme.button,
          unselectedLabelStyle: TextStyle(
              color: CFGTextStyle.defaultFontColor,
              fontFamily: CFGTextStyle.clashGrotesk,
              fontSize: CFGTextStyle.smallTitleFontSize,
              fontWeight: CFGTextStyle.mediumFontWeight),
          selectedLabelStyle: TextStyle(
              color: CFGTextStyle.defaultFontColor,
              fontFamily: CFGTextStyle.clashGrotesk,
              fontSize: CFGTextStyle.smallTitleFontSize,
              fontWeight: CFGTextStyle.mediumFontWeight),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.star,
                color: CFGTheme.button,
              ),
              label: "Featured",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.category,
                color: CFGTheme.button,
              ),
              label: "Categories",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: CFGTheme.button,
              ),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark,
                color: CFGTheme.button,
              ),
              label: "Saved",
            ),
          ],
        ),
      ),
    );
  }
}
