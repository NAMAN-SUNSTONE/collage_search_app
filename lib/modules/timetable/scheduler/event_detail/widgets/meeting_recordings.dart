import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:hub/app_assets/app_image_path.dart';
// import 'package:hub/data/student/student.dart';
// import 'package:hub/generated/assets.dart';

// import 'package:hub/theme/colors.dart';

class ClassRecordingsListView extends StatelessWidget {
  final List<ClassRecordingModel> classRecordings;
  final String? eventType;
  final Function(ClassRecordingModel recording) onPlayVideo;

  ClassRecordingsListView(
      {Key? key,
      required this.classRecordings,
      required this.onPlayVideo,
      this.eventType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) => Container(
              padding: EdgeInsets.only(
                left: index == 0 ? 16 : 0,
                right: index == classRecordings.length - 1 ? 16 : 0,
              ),
              width: context.width * (classRecordings.length == 1 ? 1 : 0.85),
              child: ClassRecordingListItem(
                data: classRecordings[index].copyWith(
                    title:
                        "Recording${classRecordings.length == 1 ? "" : (" ${index + 1}")}"),
                onPressed: onPlayVideo,
                eventType: eventType ?? "class",
              ),
            ),
            separatorBuilder: (_, index) => const SizedBox(width: 16),
            itemCount: classRecordings.length,
          ),
        ),
      ],
    );
  }
}

class ClassRecordingListItem extends StatelessWidget {
  const ClassRecordingListItem({
    Key? key,
    required this.data,
    this.onPressed,
    this.eventType = "class",
  }) : super(key: key);

  final ClassRecordingModel data;
  final void Function(ClassRecordingModel classRecording)? onPressed;
  final String eventType;

  static const String _bootCamp = "bootcamp";
  static const String _lecture = "class";

  @override
  Widget build(BuildContext context) {
    Widget _buildRecordingThumbnail() {
      Widget _buildLocalThumbnail() {
        String localThumbPath = eventType == _lecture
            ? Assets.svgClassThumb
            : Assets.svgBootcampThumb;
        return SvgPicture.asset(
          localThumbPath,
          fit: BoxFit.cover,
        );
      }

      if (data.thumbnail != null && data.thumbnail != "") {
        return CachedNetworkImage(
          imageUrl: data.thumbnail!,
          fit: BoxFit.cover,
          placeholder: (context, string) => _buildLocalThumbnail(),
        );
      } else {
        return _buildLocalThumbnail();
      }
    }

    return GestureDetector(
      onTap: () => onPressed?.call(data),
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        child: AspectRatio(
          aspectRatio: 1.78,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              _buildRecordingThumbnail(),
              Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: HubColor.black.withOpacity(0.4)),
              Icon(
                Icons.play_arrow_rounded,
                color: context.theme.colorScheme.background,
                size: 48,
              ),
              if (data.title != null)
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, bottom: 12),
                      child: Text(
                        data.title!,
                        style: context.textTheme.headline5
                            ?.copyWith(color: HubColor.greyLight, fontSize: 16),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
