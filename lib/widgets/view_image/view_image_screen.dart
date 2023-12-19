import 'dart:io';

import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/utils/ss_file.dart';
import 'package:admin_hub_app/widgets/ss_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewImageArgument {
  late final SSFile image;
  late final String? title;

  ViewImageArgument({required this.image, this.title});
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
            child: _argument.image.location == SSFileLocation.network
                ? CachedNetworkImage(imageUrl: _argument.image.path!)
                : Image.file(File(_argument.image.path!))));
  }
}
