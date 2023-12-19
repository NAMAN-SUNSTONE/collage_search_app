import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';

class SSImageViewerWidget extends StatelessWidget {
  final String imageUrl;
  const SSImageViewerWidget({Key? key,required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: CachedNetworkImageProvider(
          imageUrl
      ) ,
    );
  }
}
