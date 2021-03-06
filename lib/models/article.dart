import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/services/app_service.dart';

class Article {
  String? category;
  String? contentType;
  String? title;
  String? description;
  String? youtubeVideoUrl;
  String? videoID;
  int? loves;
  String? sourceUrl;
  String? date;
  String? imageurl;
  String? timestamp;
  int? views;
  bool? isLecture;

  Article(
      {this.category,
      this.contentType,
      this.title,
      this.description,
      this.youtubeVideoUrl,
      this.videoID,
      this.loves,
      this.sourceUrl,
      this.imageurl,
      this.date,
      this.timestamp,
      this.views,
      this.isLecture});

  factory Article.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return Article(
        category: d['category'],
        contentType: d['content type'],
        title: d['title'],
        imageurl: d['image url'],
        description: d['description'],
        youtubeVideoUrl: d['youtube url'],
        videoID: d['content type'] == 'video'
            ? AppService.getYoutubeVideoIdFromUrl(d['youtube url'])
            : '',
        loves: d['loves'],
        sourceUrl: d['source'],
        date: d['date'],
        timestamp: d['timestamp'],
        views: d['views'] ?? null,
        isLecture: d['isLecture']);
  }
}
