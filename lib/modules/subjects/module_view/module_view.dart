import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/module_view/content_list.dart';
// import 'package:hub/academic_content/module_view/lecture_list.dart';
// import 'package:hub/academic_content/module_view/module_controller.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_loader.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/utils/layout.dart';
// import 'package:hub/widgets/reusables.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

import '../../../generated/assets.dart';
import '../../../theme/colors.dart';
import '../../../widgets/reusables.dart';
import '../../../widgets/ss_loader.dart';
import 'content_list.dart';
import 'lecture_list.dart';
import 'module_controller.dart';


class ModuleView extends GetView<ModuleController> {
  const ModuleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SSLoader.light(
        hideChildWhileLoading: true,
        status: controller.status.value,
        child: Scaffold(
          body: CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              SliverAppBar(
                elevation: 0,
                pinned: true,
                floating: true,
                expandedHeight: controller.kExpandedHeight,
                leading: (ModalRoute.of(context)?.canPop ?? false)
                    ? IconButton(
                    onPressed: Navigator.of(context).maybePop,
                    splashRadius: 28,
                    icon: SvgPicture.asset(
                      Assets.svgNavbarBack,
                    ))
                    : null,
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1,
                  titlePadding: EdgeInsets.only(
                      bottom: 18.0,
                      right: 8,
                      left: controller.horizontalTitlePadding.value + 16),
                  centerTitle: false,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (controller.showSubTitle)
                        Text(controller.subTitle ?? '',
                            maxLines: 1,
                            style: UIKitDefaultTypography()
                                .subtitle2
                                .copyWith(color: HubColor.grey3)),
                      Space(
                        height: 4,
                      ),
                      Text(controller.title,
                          maxLines: controller.make1Liner ? 2 : 1,
                          style: UIKitDefaultTypography()
                              .headline6
                              .copyWith(color: HubColor.iconColorCircle)),
                    ],
                  ),
                ),
              ),
              const _Body()
            ],
          ),
        ),
      );
    });
  }
}
class _Body extends GetView<ModuleController> {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SliverToBoxAdapter(
        child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                if ((controller.module?.contents.isEmpty ?? true) &&
                    (controller.module?.lectures?.isEmpty ?? true))
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.svgEmptyContent,
                              height: 24,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "No Content uploaded yet!",
                              style: UIKitDefaultTypography()
                                  .bodyText2
                                  .copyWith(color: HubColor.grey3),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                LectureList(
                    moduleId: controller.moduleId,
                    courseId: controller.courseId,
                    allowedContentTypes: controller.allowedContentType,
                    lectures: controller.module?.lectures ?? []),
                ContentList(
                    moduleId: controller.moduleId,
                    courseId: controller.courseId,
                    allowedContentTypes: controller.allowedContentType,
                    contents: controller.module?.contents ?? []),
              ],
            )));
  }
}
