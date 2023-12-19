import 'package:admin_hub_app/modules/timetable/scheduler/constants.dart';
import 'package:admin_hub_app/modules/timetable/widgets/single_lecture_widget.dart';
import 'package:admin_hub_app/routes/app_pages.dart';
import 'package:admin_hub_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SHPageNavigator {

  static go(
      {required String resource,
        dynamic arguments,
        dynamic extraData,
        Map<String, String>? parameters,
        Uri? deepLinkUri}) {

    debugPrint(
        'SHPageNavigator -> path : $resource, arguments: $arguments, extraData: $extraData');
    switch (resource) {
      // case Paths.dashboard:
      //   break;
      // case DeepLinkResources.classMates:
      //   toClassMates();
      //   break;
      // case DeepLinkResources.batchMates:
      //   toBatchMates();
      //   break;
      // case Paths.seniors:
      //   toSeniors();
      //   break;
      // case Paths.viewAllStudents:
      //   toViewAllStudents();
      //   break;
      // case DeepLinkResources.eligibleJobs:
      //   toJobs(JobType.eligible, arguments);
      //   break;
      // case Paths.jobs:
      //   toJobs(JobType.all, arguments);
      //   break;
      // case Paths.youtubePlayer:
      //   toYoutubePlayer(extraData);
      //   break;
      // case Paths.videoPlayer:
      //   toVideoPlayer(extraData);
      //   break;
      // case Paths.bonafideForm:
      //   toBonafide();
      //   break;
      // case DeepLinkResources.yourAgreement:
      //   toYourAgreement();
      //   break;
      // case Paths.timeTable:
      //   toTimeTable(dateString: arguments);
      //   break;
      //
      // case Paths.attendance:
      // case DeepLinkResources.myLogs:
      // case DeepLinkResources.mySubjects:
      //   toAttendance(arguments);
      //   break;
      // case DeepLinkResources.visualStories:
      //   toVisualStories();
      //   break;
      // case DeepLinkResources.customWebViewNative:
      //   SHNavigationManager.openNativeWebViewCustom(arguments);
      //   break;
      //
      // case DeepLinkResources.magicLink:
      //   toMagicLink(url: arguments);
      //   break;
      // case DeepLinkResources.login:
      // //Forwarding to Launch Screen
      //   HubAppManager.getInstance().goToLogin();
      //   // Get.toNamed(Paths.launchScreen);
      //   break;

      case Paths.lectureDetailView:
        toTimetableEvent(eventId: arguments);
        break;

      case DeepLinkResources.contentEvent:
        toContentEvent(eventId: arguments);
        break;

      // case DeepLinkResources.appAction:
      //   debugPrint('DeepLinkResources.appAction : $arguments');
      //   handleAppAction(appAction: arguments, url: deepLinkUri.toString());
      //   break;
      //
      // case DeepLinkResources.zoomLink:
      //   handleZoomLink(arguments);
      //   break;
      //
      // case DeepLinkResources.freshDesk:
      //   openFreshDesk(deepLinkUri.toString());
      //   break;
      //
      // case Paths.refferalFly:
      //   FlyyHelper().openFlyOfferPage();
      //   break;
      //
      // case Paths.certifications:
      //   toCertifications(arguments);
      //   break;
      //
      // case Paths.community:
      //   _goToCommunityTab();
      //   break;
      //
      // case Paths.referShareWhatsApp:
      //   referFlyToWhatsapp();
      //   break;
      //
      // case CommunityPaths.communityFeed:
      //   toCommunityFeed(arguments);
      //   break;
      // case DeepLinkResources.scanQr:
      //   debugPrint('DeepLinkResources.scanQr : ${deepLinkUri.toString()}');
      //   if (deepLinkUri != null) {
      //     _handleQr(deepLinkUri);
      //   }
      //   break;
      //
      // case DeepLinkResources.studentOnboardingWelcome:
      //   _toStudentOnboardingWelcome();
      //   break;
      //
      // case Paths.contentLibrary:
      //   toContentLibrary(
      //       query: arguments?['query'],
      //       contentCategory: arguments?['contentCategory']);
      //   break;
      //
      // case DeepLinkResources.groupChat:
      //   String guid = arguments;
      //   String? groupName = extraData['group_name'];
      //   int? memberCount = int.tryParse(extraData['member_count']);
      //   GroupChatManager.tryInitialiseAndLogin(onSuccess: () {
      //     GroupChatManager.startGroupChatFlow(
      //         groupData: GroupChatData(
      //             id: guid, name: groupName, membersCount: memberCount));
      //   });
      //   break;
      //
      // case DeepLinkResources.loginWithUrl:
      //   return _handleLoginLink(deepLinkUri!);
      //
      // case DeepLinkResources.queryAction:
      //   if (deepLinkUri != null) handleQueryAction(deepLinkUri);
      //   break;
      default:
        {
          _go(resource: resource, arguments: arguments, parameters: {
            if (extraData is Map) ...stringifyMapAndRemoveIterables(extraData),
            ...?parameters,
          });
        }
    }
  }

  static void toTimetableEvent({required int eventId}) {
    _go(
        resource: Paths.lectureDetailView,
        parameters: LectureDataToPass(
          eventId: eventId,
          type: EventType.timetable,
        ).toJson());
  }

  static void toContentEvent({required int eventId}) {
    _go(
        resource: Paths.lectureDetailView,
        parameters: LectureDataToPass(
          eventId: eventId,
          type: EventType.content,
        ).toJson());
  }

  static openWebView(String url, {String? title}) {
    Get.toNamed(Paths.webView, parameters: {'url': url, 'title': title ?? ''});
  }

  static void _go(
      {required String resource,
        dynamic arguments,

        /// If true, will combine the arguments with the parameters.
        /// Todo: Remove once deeplink supported page's arguments ported to parameters
        bool combineArgumentWithParams = false,
        Map<String, String>? parameters}) {
    debugPrint("App path name : $resource");
    debugPrint("App path arguments : $arguments");
    Get.toNamed(
      resource,
      arguments: arguments == "" ? null : arguments,
      //May contain utm parameters
      parameters: {
        ...?parameters,

      },
      preventDuplicates: false,
    );
  }

}