import 'package:flutter/material.dart';
import 'package:global_news_app/data/data_providers/news.dart';
import 'package:global_news_app/data/models/news_model.dart';
import 'package:global_news_app/utils/constants/size.dart';
import 'package:global_news_app/utils/constants/text_style.dart';
import 'package:global_news_app/utils/constants/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleTile extends StatefulWidget {
  final bool isSaved;
  final NewsModel article;
  final Function onDelete;

  const ArticleTile({
    super.key,
    required this.article,
    required this.isSaved,
    required this.onDelete,
  });

  @override
  State<ArticleTile> createState() => _ArticleTileState();
}

class _ArticleTileState extends State<ArticleTile> {
  IconData saveIcon = Icons.bookmark_add_outlined;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setIcon();
  }

  setIcon() {
    setState(() {
      if (widget.article.isBookmarked == true) {
        saveIcon = Icons.bookmark;
      } else {
        saveIcon = Icons.bookmark_add_outlined;
      }
    });
  }

  //Load Full Article in Browser.
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CFGTheme.bgColorScreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CFGSize.tileRadius),
      ),
      elevation: 4,
      // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(CFGSize.tileRadius),
        child: Column(
          children: [
            // Image with error handling
            if (widget.article.urlToImage?.isNotEmpty ?? false)
              Image.network(
                widget.article.urlToImage!,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),

            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.article.title ?? "",
                    style: TextStyle(
                      fontSize: CFGTextStyle.subTitleFontSize,
                      fontWeight: FontWeight.bold,
                      color: CFGTextStyle.defaultFontColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Author
                  if (widget.article.author?.isNotEmpty ?? false)
                    Text(
                      'Article By ${widget.article.author}',
                      style: TextStyle(
                        fontSize: CFGTextStyle.defaultFontSize,
                        fontStyle: FontStyle.italic,
                        color: CFGTextStyle.greyFontColor,
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    widget.article.description ?? "",
                    style: TextStyle(
                      fontSize: CFGTextStyle.smallTitleFontSize,
                      color: CFGTextStyle.greyFontColor,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                  const SizedBox(height: 8),
                  // Content preview
                  // Text(
                  //   article.content ?? "",
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: CFGTextStyle.greyFontColor,
                  //   ),
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  // const SizedBox(height: 8),
                  // Published date
                  Text(
                    'Published on : ${widget.article.publishedAt?.substring(0, 10) ?? ""}',
                    style: TextStyle(
                      fontSize: CFGTextStyle.smallFontSize,
                      color: CFGTextStyle.lightGreyFontColor,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Click to view full article
                      OutlinedButton(
                        onPressed: () {
                          if (widget.article.url?.isNotEmpty ?? false) {
                            _launchURL(widget.article.url!);
                          }
                        },
                        child: Text(
                          'Read full article',
                          style: TextStyle(color: CFGTextStyle.blueFontColor),
                        ),
                      ),

                      //Save or Delete
                      widget.isSaved
                          ? Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: IconButton(
                                iconSize: 30,
                                padding: const EdgeInsets.all(0),
                                onPressed: () async {
                                  await News()
                                      .deleteRecord(model: widget.article);
                                  //Reloading saved list
                                  widget.onDelete();
                                  setState(() {
                                    widget.article.isBookmarked = false;
                                  });
                                },
                                icon: Icon(Icons.delete_forever_outlined),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: IconButton(
                                  iconSize: 30,
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () async {
                                    if (widget.article.isBookmarked == null ||
                                        widget.article.isBookmarked == false) {
                                      // Save to SqfLite
                                      await News()
                                          .createRecord(model: widget.article);
                                      setState(() {
                                        // Change to filled bookmark
                                        saveIcon = Icons.bookmark;
                                        widget.article.isBookmarked = true;
                                      });
                                    }
                                  },
                                  icon: Icon(saveIcon)),
                            )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
