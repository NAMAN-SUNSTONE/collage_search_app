import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hub/sunstone_base/ui/widgets/ss_appbar.dart';
import 'package:get/get.dart';
import 'package:hub/theme/colors.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewImageArgument {
  late final String url;
  late final String? title;
  late final bool isPinchView;
  ViewImageArgument({required this.url, this.title, this.isPinchView = false});
}

class ViewImage extends GetView {
  const ViewImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ViewImageArgument _argument = Get.arguments;

    return Scaffold(
        backgroundColor: HubColor.black,
        appBar: SHAppBar(
          colorScheme: TitleColorScheme.light,
          title: _argument.title,
          backgroundColor: HubColor.black,
        ),
        body: Center(
            child: _argument.isPinchView
                ? Container(
                    height: double.maxFinite,
                    child: PhotoViewGallery.builder(
                      scrollPhysics: const BouncingScrollPhysics(),
                      builder: (BuildContext context, int index) {
                        return PhotoViewGalleryPageOptions(
                          imageProvider: CachedNetworkImageProvider(
                            _argument.url,
                          ),
                        );
                      },
                      itemCount: 1,
                    ))
                : CachedNetworkImage(imageUrl: _argument.url)));
  }
}
