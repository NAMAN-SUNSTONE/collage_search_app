import 'package:admin_hub_app/constants/enums.dart';
import 'package:admin_hub_app/modules/content_view/content_view_controller.dart';
import 'package:admin_hub_app/modules/subjects/lms/lms_controller.dart';
import 'package:admin_hub_app/modules/subjects/module_view/module_controller.dart';
import 'package:admin_hub_app/modules/timetable/scheduler/constants.dart';
import 'package:admin_hub_app/routes/app_pages.dart';
import 'package:admin_hub_app/utils/flavour_variables.dart';
import 'package:ss_deeplink/models/pattern_mapper.dart';

class URLPatterns {
  static const String _noHost = '';
  static const String _anyHost = r'https://[_\w.-]+';

  static const String _sunstoneHub = 'https://hub.sunstone.in';
  static const String _sunstoneHubDev = 'https://dev-hub.sunstone.in';
  static const String _sunstoneClass = 'https://class.sunstone.in';
  static const String _sunstoneIn = 'https://sunstone.in';

  //Internal deep link hosts
  static const String _wistia = 'https://typeform-product.wistia.com';

  static const String _slashOrQuerySeparatorRegex = r'(?:/|\?)';
  static const String _optionalQueriesRegex = r'(?:(?!/).*)';

  static String _getFullPattern({
    String? host,
    String? pattern,
    bool exactMatch = true,
  }) {
    if (host == null) {
      host = FlavourVariables.flavorName == AppFlavors.dev
          ? _sunstoneHubDev
          : _sunstoneHub;
    }
    if (pattern != null) {
      final String separatorRegex =
      host == _noHost ? '' : _slashOrQuerySeparatorRegex;

      if (exactMatch) {
        final String exactMatchPattern = r"^" +
            host +
            separatorRegex +
            pattern +
            _optionalQueriesRegex +
            r'$';
        return exactMatchPattern;
      } else {
        final String notExactMatchPattern = host + separatorRegex + pattern;
        return notExactMatchPattern;
      }
    }
    return '';
  }

  static final List<Map<String, dynamic>> _patterns = [

    {
      "resource": Paths.lectureDetailView,
      "pattern": _getFullPattern(pattern: 'time-table/event/([a-zA-Z0-9]+)')
    }, //type -> time_table

    {
      "resource": DeepLinkResources.contentEvent,
      "pattern": _getFullPattern(pattern: 'event/([a-zA-Z0-9]+)')
    },
    //type -> content

    {
      "resource": Paths.contentView,
      "pattern": 'subjects/([0-9]+)/modules/([0-9]+)/contents/([0-9]+)',
      'matchedValueKeys': [
        ContentViewParams.subjectIdKey,
        ContentViewParams.moduleIdKey,
        ContentViewParams.contentIdKey
      ]
    },

    {
      "resource": Paths.contentView,
      "pattern": 'subjects/([0-9]+)/modules/([0-9]+)',
      'matchedValueKeys': [
        ContentViewParams.subjectIdKey,
        ContentViewParams.moduleIdKey,
        ContentViewParams.contentIdKey
      ]
    },

    {
      "resource": Paths.lmsModule,
      "pattern": 'subjects/([0-9]+)/module-detail/([0-9]+)/([0-9]+)',
      "matchedValueKeys": [
        ModuleViewParams.subjectIdKey,
        ModuleViewParams.moduleIdKey,
        ModuleViewParams.lectureIdKey
      ]
    },

    {
      "resource": Paths.lms,
      "pattern": 'subjects/([0-9]+)/(info)',
      "matchedValueKeys": [
        LmsParameters.subjectIdKey,
        LmsParameters.tabIdentifierKey
      ]
    },

    {
      "resource": Paths.lms,
      "pattern": 'subjects/([0-9]+)/(modules)',
      "matchedValueKeys": [
        LmsParameters.subjectIdKey,
        LmsParameters.tabIdentifierKey
      ]
    },

    {
      "resource": Paths.lms,
      "pattern": 'subjects/([0-9]+)/(assignments)',
      "matchedValueKeys": [
        LmsParameters.subjectIdKey,
        LmsParameters.tabIdentifierKey
      ]
    },

    {
      "resource": Paths.lms,
      "pattern": 'subjects/([0-9]+)/(notes)',
      "matchedValueKeys": [
        LmsParameters.subjectIdKey,
        LmsParameters.tabIdentifierKey
      ]
    }

  ];

  static final List<SSDPatternMapperModel> _mappedPatterns = _patterns
      .map((pattern) => SSDPatternMapperModel(
      resource: pattern["resource"],
      pattern: pattern["pattern"],
      additionalArgs: pattern["additionalArgs"],
      matchedValueKeys: pattern["matchedValueKeys"] ?? []))
      .toList();

  static List<SSDPatternMapperModel> patterns = _mappedPatterns;

}