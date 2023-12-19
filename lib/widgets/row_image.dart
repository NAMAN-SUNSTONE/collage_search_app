import 'package:admin_hub_app/modules/timetable/data/image_row_card.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:hub/analytics/analytic_event.dart';
// import 'package:hub/analytics/events.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/data/home/model/image_row_card.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/utils/navigator/navigator.dart';

class RowImage extends StatelessWidget {
  final ImageRowCard story;
  final int length;
  final double? width;

  const RowImage(
      {Key? key, required this.story, required this.length, this.width})
      : super(key: key);

  String? _getImageFromStory(StoryImages storyImages, int length) {
    if (length == 1) return storyImages.large;
    if (length == 2) return storyImages.medium;
    return storyImages.small;
  }

  //returns the placeholder card in-case image is null
  String _getBackupImageFromStory(int length) {
    return '';
    //todo cht
    // if (length == 1) return AppSvgPath.visualStoryLarge;
    // if (length == 2) return AppSvgPath.visualStoryMedium;
    // return AppSvgPath.visualStorySmall;
  }

  onTap() {
    //todo cht
    // AnalyticEvents.visualStoriesCardClick(
    //     story.title, story.target.redirectUrl);
    // SHNavigationManager.navigate(story.target);
  }

  @override
  Widget build(BuildContext context) {
    final String title = story.title;
    final String? image = _getImageFromStory(story.image, length);
    final String? description = length == 1 ? story.description : null;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomLeft,
        fit: StackFit.loose,
        children: [
          image != null
              ? CachedNetworkImage(
              imageUrl: image, width: width, fit: BoxFit.fitWidth)
              : SvgPicture.asset(_getBackupImageFromStory(length),
              width: width),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, bottom: 16),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.w700, color: HubColor.white),
                ),
              ),
              if (description != null)
                Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 16, right: 16),
                  child: Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: HubColor.white.withOpacity(0.65)),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}