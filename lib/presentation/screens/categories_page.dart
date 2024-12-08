import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_news_app/controllers/state_controller.dart';
import 'package:global_news_app/data/data_providers/models/news_model.dart';
import 'package:global_news_app/data/services/api_data_service.dart';
import 'package:global_news_app/presentation/widgets/article_tile.dart';
import 'package:global_news_app/presentation/widgets/filter_bottomsheet.dart';
import 'package:global_news_app/utils/constants/text_style.dart';
import 'package:global_news_app/utils/constants/theme.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with AutomaticKeepAliveClientMixin<CategoriesPage> {
  final StateController stateController = Get.find();
  bool isLoading = true;
  List<NewsModel> newsList = [];
  String? country;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Reset filters
    // stateController.selectedMainCategory = "top-headlines";
    // stateController.selectedSubCategory = null;
    // stateController.selectedSource = null;
    // stateController.selectedCountry = null;
    // stateController.selectedCountryKey = null;
    getNews(country);
  }

  Future<void> getNews(String? country) async {
    setState(() {
      isLoading = true;
    });
    List<NewsModel> list = await ApiDataService().getFeaturedNews(country);
    if (mounted) {
      setState(() {
        newsList = list;
        isLoading = false;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Stack(
        children: [
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : newsList.isEmpty
                  ? Center(
                      child: Text(
                        'No news found',
                        style: TextStyle(
                          fontSize: CFGTextStyle.subTitleFontSize,
                          fontWeight: CFGTextStyle.regularFontWeight,
                          color: CFGTextStyle.defaultFontColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        return ArticleTile(
                          article: newsList[index],
                          isSaved: false,
                          onDelete: () {},
                        );
                      },
                    ),

          //Filter Button
          Positioned(
            top: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: () async {
                // Show the bottom sheet and await the result
                showModalBottomSheet(
                    //To make the bottom sheet full width of the screen
                    // constraints: BoxConstraints(
                    //   maxWidth: mediaQuerySize.width,
                    // ),
                    barrierColor: const Color(0x20000000),
                    isScrollControlled: true,
                    enableDrag: true,
                    isDismissible: true,
                    elevation: 0,
                    backgroundColor: CFGTheme.bgColorScreen,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: const FilterBottomSheet(),
                      );
                    }).then((list) {
                  // Check if the list is not null
                  if (list != null) {
                    setState(() {
                      newsList = list;
                    });
                    debugPrint('================================');
                    debugPrint('Received news list: $list');
                  } else {
                    debugPrint('No news list returned');
                  }
                });
              },
              style: ButtonStyle(
                  elevation: const WidgetStatePropertyAll(4),
                  side: WidgetStatePropertyAll(
                      BorderSide(color: CFGTheme.button)),
                  backgroundColor:
                      WidgetStatePropertyAll(CFGTheme.bgColorScreen)),
              child: Text(
                "Show Filter",
                style: TextStyle(
                  fontSize: CFGTextStyle.defaultFontSize,
                  fontWeight: CFGTextStyle.mediumFontWeight,
                  color: CFGTextStyle.defaultFontColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
