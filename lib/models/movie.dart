import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foreign_movie_watch/constants/enums.dart';

class Movie {
  Movie({
    this.documentID,
    this.name,
    this.contentImage,
    this.coverImage,
    this.country,
    this.createdAt,
    this.updatedAt,
    this.desc,
    this.duration,
    this.genre,
    this.imdb,
    this.platform,
    this.searchKey,
    this.trailer,
    this.type,
    this.watchCount,
    this.videoLink,
    this.flags,
    this.subtitles,
    this.year,
  });

  String documentID;
  String name;
  String contentImage;
  String coverImage;
  List<String> country;
  Timestamp createdAt;
  Timestamp updatedAt;
  String desc;
  String duration;
  List<String> genre;
  String imdb;
  String platform;
  String searchKey;
  String trailer;
  ContentType type;
  int watchCount;
  String videoLink;
  List<String> flags;
  List<String> subtitles;
  String year;

  factory Movie.fromJson(String documentID, Map<String, dynamic> json) => Movie(
        documentID: documentID,
        name: json["name"],
        contentImage: json["content_image"],
        coverImage: json["cover_image"],
        country: List<String>.from(json["country"].map((x) => x)),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        desc: json["desc"],
        duration: json["duration"],
        genre: List<String>.from(json["genre"].map((x) => x)),
        imdb: json["imdb"],
        platform: json["platform"],
        searchKey: json["search_key"],
        trailer: json["trailer"],
        type: json["type"] == 0 ? ContentType.SERIE : ContentType.MOVIE,
        watchCount: json["watch_count"],
        videoLink: json["video_link"],
        flags: List<String>.from(json["flags"].map((x) => x)),
        subtitles: List<String>.from(json["subtitles"].map((x) => x)),
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "content_image": contentImage,
        "cover_image": coverImage,
        "country": List<dynamic>.from(country.map((x) => x)),
        "created_at": createdAt,
        "updated_at": updatedAt,
        "desc": desc,
        "duration": duration,
        "genre": List<dynamic>.from(genre.map((x) => x)),
        "imdb": imdb,
        "platform": platform,
        "search_key": searchKey,
        "trailer": trailer,
        "type": type == ContentType.SERIE ? 0 : 1,
        "watch_count": watchCount,
        "video_link": videoLink,
        "flags": List<dynamic>.from(flags.map((x) => x)),
        "subtitles": List<dynamic>.from(subtitles.map((x) => x)),
        "year": year,
      };
}
