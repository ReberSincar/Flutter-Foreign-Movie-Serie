import 'package:cloud_firestore/cloud_firestore.dart';

class Episode {
  Episode({
    this.episodeName,
    this.episodeSeq,
    this.episodeLink,
    this.episodeFlags,
    this.episodeSubtitles,
    this.createdAt,
  });

  String episodeName;
  int episodeSeq;
  String episodeLink;
  List<String> episodeFlags;
  List<String> episodeSubtitles;
  Timestamp createdAt;

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        episodeName: json["episode_name"],
        episodeSeq: json["episode_seq"],
        episodeLink: json["episode_link"],
        episodeFlags: List<String>.from(json["episode_flags"].map((x) => x)),
        episodeSubtitles:
            List<String>.from(json["episode_subtitles"].map((x) => x)),
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "episode_name": episodeName,
        "episode_seq": episodeSeq,
        "episode_link": episodeLink,
        "episode_flags": List<dynamic>.from(episodeFlags.map((x) => x)),
        "episode_subtitles": List<dynamic>.from(episodeSubtitles.map((x) => x)),
        "created_at": createdAt,
      };
}
