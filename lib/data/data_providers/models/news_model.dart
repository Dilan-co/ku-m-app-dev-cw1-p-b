class NewsModel {
  final int? newsId;
  final String? sourceId;
  final String? sourceName;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;
  bool? isBookmarked;

  NewsModel({
    this.newsId,
    required this.sourceId,
    required this.sourceName,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    this.isBookmarked,
  });

  factory NewsModel.fromSqfliteDatabase(Map<String, dynamic> map) {
    return NewsModel(
      newsId: map["newsId"],
      sourceId: map["sourceId"],
      sourceName: map["sourceName"],
      author: map["author"],
      title: map["title"],
      description: map["description"],
      url: map["url"],
      urlToImage: map["urlToImage"],
      publishedAt: map["publishedAt"],
      content: map["content"],
    );
  }

  factory NewsModel.fromApiResponse(Map<String, dynamic> map) {
    final source = map["source"] ?? {};
    //Removing character length at the end of content
    String? content = map["content"];
    final regex = RegExp(r'\[\+\d+ chars\]$');
    String? cleanedContent = content?.replaceAll(regex, '').trim();
    return NewsModel(
      sourceId: source["id"],
      sourceName: source["name"],
      author: map["author"],
      title: map["title"],
      description: map["description"],
      url: map["url"],
      urlToImage: map["urlToImage"],
      publishedAt: map["publishedAt"],
      content: cleanedContent,
    );
  }
}
