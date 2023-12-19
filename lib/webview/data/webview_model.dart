class NativeWebViewOptions {
  final bool videoPlayerMode;
  bool isToShowBackButton;
  final bool isToShowCancelButton;
  bool isSingleChildView;
  final bool isToGoBackOrNot;
  final String? screenName;

  NativeWebViewOptions(
      {this.videoPlayerMode = false,
        this.isToShowBackButton = true,
        this.isToShowCancelButton = true,
        this.isSingleChildView = false,
        this.isToGoBackOrNot = true,
        this.screenName});

  Map<String, dynamic> toMap() {
    return {
      'video_player_mode': videoPlayerMode,
      'is_single_child_view': isSingleChildView,
      'is_to_show_back_button': isToShowBackButton,
      'is_to_show_cancel_button': isToShowCancelButton,
      'screen_name' : screenName
    };
  }

  NativeWebViewOptions copyWith({bool? videoPlayerMode, bool? isToShowBackButton,bool? isToShowCancelButton,bool? isToGoBackOrNot}) {
    return NativeWebViewOptions(
        videoPlayerMode: videoPlayerMode ?? this.videoPlayerMode,
        isToShowBackButton: isToShowBackButton ?? this.isToShowBackButton,
        isToShowCancelButton: isToShowCancelButton ?? this.isToShowCancelButton,
        isToGoBackOrNot: isToGoBackOrNot ?? this.isToGoBackOrNot,
        screenName: screenName ?? this.screenName);
  }

}

class NativeWebViewData {
  final String? url;
  final String? htmlData;

  NativeWebViewData({this.url, this.htmlData});

  Map<String, dynamic> toMap() => {"url": url, "html_data": htmlData};
}
