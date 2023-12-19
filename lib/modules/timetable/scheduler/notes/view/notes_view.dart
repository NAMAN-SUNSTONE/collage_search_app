import 'dart:io';

import 'package:admin_hub_app/modules/timetable/scheduler/notes/view/notes_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/generated/assets.dart';
// import 'package:hub/routes/app_pages.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_appbar.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/ui/preview_pdf/preview_pdf_controller.dart';
// import 'package:hub/ui/profile/new_info/photo/photo_view.dart';
// import 'package:hub/ui/timetable/scheduler/notes/view/notes_controller.dart';
// import 'package:hub/ui/timetable/scheduler/view_image/view_image_screen.dart';
// import 'package:hub/utils/layout.dart';
// import 'package:hub/widgets/bottom_sheet_widgets/confirmation_sheet.dart';
// import 'package:hub/widgets/reusables.dart';

class NotesView extends GetView<NotesController> {
  const NotesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.onBack,
      child: Layout(
        child: Scaffold(
          appBar: SHAppBar(
            title: 'Notes',
            actions: [
              Obx(() => controller.savedOnce.value
                  ? InkWell(
                      onTap: () {
                        showMyBottomModalSheet(
                          context,
                          ConfirmationSheet(
                            title: "Are you sure you want to delete this note?",
                            message: "This action cannot be undone. ",
                            onYes: controller.onNotesDelete,
                            onNo: () {},
                          ),
                        );
                      },
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                          child: SvgPicture.asset(Assets.svgDelete, height: 20)),
                    )
                  : Container()),
              Obx(() => controller.savedOnce.value
                  ? InkWell(
                      onTap: controller.onNotesShare,
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                          child: SvgPicture.asset(AppSvgPath.share, height: 20)),
                    )
                  : Container()),
              SizedBox(
                width: 8,
              )
            ],
          ),
          floatingActionButton: Obx(() => Opacity(
              opacity: controller.showAttachmentButton.value ? 1 : 0.0,
              child: FloatingActionButton(
                elevation: 0,
                onPressed: controller.onUploadClick,
                backgroundColor: HubColor.iconColor,
                child: SvgPicture.asset(
                  Assets.svgAttachment,
                  color: HubColor.white,
                  height: 20,
                ),
              ))),
          body: SingleChildScrollView(
              controller: controller.scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SpaceLarge(height: 4),
                    Obx(() {
                      if (controller.lastSavedOn.value == '') return Container();
                      return Text(
                        "Last saved on ${controller.lastSavedOn.value}",
                        style: GoogleFonts.publicSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: HubColor.grey1.withOpacity(0.2)),
                      );
                    }),
                    TextField(
                      controller: controller.titleController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 16),
                        border: InputBorder.none,
                        hintText: "Add title",
                        hintStyle: GoogleFonts.publicSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: HubColor.grey1.withOpacity(0.4)),
                      ),
                      maxLines: 1,
                      minLines: 1,
                      style: GoogleFonts.publicSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: HubColor.grey1),
                    ),
                    TextField(
                      controller: controller.bodyController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 16),
                        border: InputBorder.none,
                        hintText: "Write your note",
                        hintStyle: context.textTheme.bodyText1!
                            .copyWith(color: HubColor.grey1.withOpacity(0.4)),
                      ),
                      maxLines: 30,
                      minLines: 1,
                      style: context.textTheme.bodyText1!
                          .copyWith(color: HubColor.grey1),
                    ),
                    Space(factor: 4),
                    Obx(() => GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.attachments.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 12,
                            crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          final int _id = controller.attachments[index].id;
                          final String _url = controller.attachments[index].url;
                          final String title = controller.attachments[index].name;
                          return ViewAttachment(
                            _url,
                            onDelete: () => controller.onAttachmentDelete(_id),
                            title: title,
                            isLoading: _id == -1,
                          );
                        })),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

class ViewAttachment extends StatelessWidget {
  const ViewAttachment(
    this.url, {
    this.onDelete,
    this.title,
    this.isLoading = false,
    this.disableDelete = false,
    this.onClick,
    Key? key,
  }) : super(key: key);

  final bool isLoading;
  final String url;
  final String? title;
  final void Function()? onDelete;
  final bool disableDelete;
  final Function(String fileName, String fileType)? onClick;

  @override
  Widget build(BuildContext context) {
    final double _height = 24;
    final bool _isPdf = (url.contains('.pdf'));

    if (isLoading) {
      return Container(
        decoration: BoxDecoration(
          color: HubColor.primaryTint,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
            child: CircularProgressIndicator(
          strokeWidth: 2,
          color: HubColor.primary.withOpacity(0.6),
        )),
      );
    }
    return GestureDetector(
      onTap: () {
       String fileName =  Uri.parse(url).pathSegments.last;
        if (_isPdf) {
          onClick?.call(fileName,'pdf');
          Get.toNamed(Paths.pdfPreview,
              arguments: PdfArguments(
                url: url,
                name: title ?? '',
                allowShare: false,
              ));
        } else {
          onClick?.call(fileName,'image');
          Get.toNamed(Paths.viewImage,
              arguments: ViewImageArgument(url: url, title: title));
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: _isPdf
                ? Container(
                    color: HubColor.primaryTint,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        Icon(
                          Icons.picture_as_pdf,
                          color: HubColor.redDark,
                          size: 50,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: 8, left: 8, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: Text(
                                title?.replaceAll(".pdf", "") ?? "",
                                overflow: TextOverflow.ellipsis,
                              )),
                              if (title != null) Text('.pdf'),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: url ?? '',
                    fit: BoxFit.cover,
                  ),
          ),
          if(!disableDelete)
          InkWell(
            child: Container(
                alignment: Alignment.topRight,
                height: _height,
                width: _height,
                child: InkWell(
                    onTap: onDelete,
                    child: SvgPicture.asset(Assets.svgRemove))),
          )
        ],
      ),
    );
  }
}
