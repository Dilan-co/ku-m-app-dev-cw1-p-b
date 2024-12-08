import 'package:flutter/material.dart';
import 'package:global_news_app/data/models/news_model.dart';
import 'package:global_news_app/data/services/api_data_service.dart';
import 'package:global_news_app/presentation/widgets/article_tile.dart';

class FeaturedPage extends StatefulWidget {
  const FeaturedPage({super.key});

  @override
  State<FeaturedPage> createState() => _FeaturedPageState();
}

class _FeaturedPageState extends State<FeaturedPage>
    with AutomaticKeepAliveClientMixin<FeaturedPage> {
  List<NewsModel> newsList = [];
  String? country;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews(country);
  }

  Future<void> getNews(String? country) async {
    List<NewsModel> list = await ApiDataService().getFeaturedNews(country);
    if (mounted) {
      setState(() {
        newsList = list;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          return ArticleTile(
            article: newsList[index],
            isSaved: false,
            onDelete: () {},
          );
        },
      ),
    );
  }
}
