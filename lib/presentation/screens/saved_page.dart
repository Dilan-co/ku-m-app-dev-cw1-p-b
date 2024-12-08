import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_news_app/controllers/state_controller.dart';
import 'package:global_news_app/data/data_providers/news.dart';
import 'package:global_news_app/data/models/news_model.dart';
import 'package:global_news_app/presentation/widgets/article_tile.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final StateController stateController = Get.find();
  List<NewsModel> newsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateSavedNewsList();
  }

  Future<void> generateSavedNewsList() async {
    newsList.clear();
    debugPrint("List length -->> ${newsList.length}");
    List<NewsModel> list = await News().fetchAllRecords();
    setState(() {
      newsList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        return ArticleTile(
          key: UniqueKey(),
          article: newsList.reversed.toList()[index],
          isSaved: true,
          onDelete: generateSavedNewsList,
        );
      },
    );
  }
}
