abstract class EventType{
  static const String timetable = 'time_table';
  static const String content = 'content';
}

abstract class DeepLinkResources {
  static const yourAgreement = "your_agreement";
  static const zoomLink = "zoomLink";
  static const batchMates = "/batchMates";
  static const classMates = "/classMates";
  static const eligibleJobs = "/eligibleJobs";

  static const freshDesk = "fresh_desk";

  static const mySubjects = "/mySubjects";
  static const myLogs = "/myLogs";
  static const visualStories = "/visualStories";
  static const customWebViewNative = "/customWebView";
  static const login = "/login";
  static const magicLink = "/magicLink";
  static const wistiaVideo = "/wistiaVideo";
  static const contentEvent = "/contentEvent";
  static const appAction = "/appAction";
  static const scanQr = '/scanQr';
  static const studentOnboardingWelcome = '/studentOnboardingWelcome';
  static const groupChat = '/groupChat';
  static const loginWithUrl = '/loginWithURL';
  static const blank = '';
  static const queryAction = '/query-action';
}

abstract class DeepLinkResourcesQuerryParams {
  static const role = "role";
}

abstract class DeepLinkResourcesQuerryParamsValues {
  static const preLead = "prlead";
  static const preLeadHiphen = "pre-lead";
}

abstract class DeeplinkUrls {
  static const jobDetailDeeplink = "https://hub.sunstone.in/jobs/detail/";
  static const communityDeeplink = "community";
}

abstract class DeepLinkAppActions {
  static const download = "download";
  static const native = "native";
  static const browser = "browser";
  static const custom = "custom";
  static const viewPDF = "view";
  static const call = "call";
}


abstract class AlertDeeplinkIdentifiers {
  static const hubOk = "hub:ok";
  static const hubOptin = "hub:optin";
  static const hubContinue = "hub:continue";
  static const hubCopy = "hub:copy";
  static const hubShowDetailModal = "hub:showDetailModal";
  static const hubRegisterEvent = 'hub:registerEvent';
  static const hubTakeAttendance = 'hub:takeAttendance';
  static const hubMarkLecture = 'hub:markLecture';
  static const hubMarkLectureAndJoin = 'hub:markLectureAndJoin';
  static const hubEditAttendance = 'hub:editAttendance';
  static const hubShareFlyWhatsapp = "hub:share_fly_whatsapp";
}

abstract class NativeHandledActions {
  static const getUser = 'getUser';
}