import 'package:flutter/material.dart';
import 'package:global_news_app/data/models/news_model.dart';
import 'package:global_news_app/data/services/api_data_service.dart';
import 'package:global_news_app/presentation/widgets/article_tile.dart';
import 'package:global_news_app/utils/constants/color.dart';
import 'package:global_news_app/utils/constants/size.dart';
import 'package:global_news_app/utils/constants/text_style.dart';
import 'package:global_news_app/utils/constants/theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textController = TextEditingController();

  bool isLoading = false;
  List<NewsModel>? newsList;
  String? query;

  Future<void> getNews(String? query) async {
    if (query != null && query != "") {
      setState(() {
        isLoading = true;
      });
      List<NewsModel> list = await ApiDataService().getNewsSearchResults(query);
      if (mounted) {
        setState(() {
          newsList = list;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              //Query
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    left: 5,
                    right: 5,
                  ),
                  child: TextFormField(
                    //
                    minLines: 1,
                    maxLines: 2,
                    enabled: true,
                    controller: textController,
                    textCapitalization: TextCapitalization.sentences,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: CFGTextStyle.clashGrotesk,
                      fontSize: CFGTextStyle.titleFontSize,
                      fontWeight: CFGTextStyle.mediumFontWeight,
                      color: CFGTextStyle.defaultFontColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 10,
                        bottom: 10,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(CFGSize.tileRadius),
                        borderSide:
                            BorderSide(color: CFGTheme.button, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(CFGSize.tileRadius),
                        borderSide: BorderSide(
                          color: CFGColor.midGrey,
                          width: 1.0,
                        ),
                      ),
                      fillColor: CFGTheme.bgColorScreen,
                      filled: true,
                      hintText: "Search",
                      hintStyle: TextStyle(
                        letterSpacing: 1,
                        fontFamily: CFGTextStyle.clashGrotesk,
                        fontSize: CFGTextStyle.titleFontSize,
                        fontWeight: CFGTextStyle.mediumFontWeight,
                        color: CFGTextStyle.lightGreyFontColor,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(CFGSize.tileRadius)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        query = value.toLowerCase();
                      });
                      debugPrint(value.toLowerCase());
                    },
                  ),
                ),
              ),

              //Search Icon
              Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: IconButton(
                    onPressed: () {
                      getNews(query);
                    },
                    icon: const Icon(
                      size: 36,
                      Icons.search_outlined,
                    ),
                  ),
                );
              })
            ],
          ),
          //

          isLoading
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : newsList == null
                  ? Expanded(
                      child: Center(
                        child: Text(
                          '',
                          style: TextStyle(
                            fontSize: CFGTextStyle.subTitleFontSize,
                            fontWeight: CFGTextStyle.regularFontWeight,
                            color: CFGTextStyle.defaultFontColor,
                          ),
                        ),
                      ),
                    )
                  : newsList!.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Text(
                              'No news found',
                              style: TextStyle(
                                fontSize: CFGTextStyle.subTitleFontSize,
                                fontWeight: CFGTextStyle.regularFontWeight,
                                color: CFGTextStyle.defaultFontColor,
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: newsList!.length,
                            itemBuilder: (context, index) {
                              return ArticleTile(
                                article: newsList![index],
                                isSaved: false,
                                onDelete: () {},
                              );
                            },
                          ),
                        ),
        ],
      ),
    );
  }
}
