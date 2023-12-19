import 'dart:io';

import 'package:admin_hub_app/constants/enums.dart';
import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/modules/image_uploader/controller.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/theme/size.dart';
import 'package:admin_hub_app/utils/ss_file.dart';
import 'package:admin_hub_app/widgets/reusables.dart';
import 'package:admin_hub_app/widgets/ss_appbar.dart';
import 'package:admin_hub_app/widgets/ss_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

class ImageUploaderView extends GetView<ImageUploaderController> {
  const ImageUploaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SHAppBar(
        title: controller.title,
      ),
      body: Obx(
        () => SSLoader.light(
          status: controller.status.value,
          child: Padding(
            padding:
                EdgeInsets.only(bottom: controller.onNext == null ? 0 : 80),
            child: GridView.count(
              padding: Sizes.margin,
              mainAxisSpacing: Sizes.spaceLarge,
              crossAxisSpacing: Sizes.spaceLarge,
              crossAxisCount: 2,
              children: [
                ...List.generate(
                    controller.images.length,
                    (index) => PhotoCard(
                        image: controller.images[index],
                        onTap: () =>
                            controller.onPhotoTap(controller.images[index]))),
                AddImageCard(
                  onTap: controller.onAddImage,
                )
              ],
            ),
          ),
        ),
      ),
      bottomSheet: controller.onNext == null
          ? null
          : Container(
              height: 48,
              width: double.infinity,
              margin: Sizes.margin,
              child: UIKitFilledButton(
                  text: "Take Attendance", onPressed: controller.onDone)),
    );
  }
}

class PhotoCard extends StatelessWidget {
  final Function() onTap;
  final SSFile image;
  const PhotoCard({Key? key, required this.image, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: image.location == SSFileLocation.network ? CachedNetworkImage(
            imageUrl: image.path!,
            fit: BoxFit.cover,
          ) : Image.file(File(image.path!), fit: BoxFit.cover)),
    );
  }
}

class AddImageCard extends StatelessWidget {
  final Function() onTap;
  const AddImageCard({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: DottedBorder(
        borderType: BorderType.RRect,
        color: HubColor.primary,
        strokeCap: StrokeCap.round,
        strokeWidth: 0.5,
        radius: Radius.circular(8),
        dashPattern: [4, 6],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.svgImagePlaceholder,
                height: 28,
              ),
              Space(
                factor: 2,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: HubColor.primary, width: 0.5)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      size: 20,
                    ),
                    Text('Add Image',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 12, fontWeight: FontWeight.w600))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
