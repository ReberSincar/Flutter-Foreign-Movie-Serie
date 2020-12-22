import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({Key key, this.imageUrl}) : super(key: key);
  final imageUrl;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) {
          return Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: RefreshProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
          );
        },
        fit: BoxFit.cover);
  }
}
