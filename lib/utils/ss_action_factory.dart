import 'package:admin_hub_app/deep_links/deep_links.dart';
import 'package:admin_hub_app/modules/content_view/ss_navigation.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/data/student/models/target_model.dart';
// import 'package:hub/routes/universal_links/deep_links.dart';
// import 'package:hub/sunstone_base/data/ss_navigation.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/utils/navigator/navigator.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

class SSActionFactory {

  static List<Widget> generateButtonList(List<SSNavigation> actions, Function(SSNavigation action) onClickCallback) {
    List<Widget> list = [];

    for (int index = 0; index < actions.length; index++) {
      list.add(Expanded(child: SizedBox(height: 32, width: double.infinity, child: getActionButton(actions[index], onClickCallback))));
      if (index < actions.length - 1) {
        list.add(const SizedBox(
          width: 12,
        ));
      }
    }

    return list;
  }

  static Widget getActionButton(SSNavigation action, Function(SSNavigation action)? onClickCallback,
      {double? padding = null, double? size = null}) {
    switch (action.type) {
      case SSNavigationType.primary:
        return _getPrimaryButton(action, onClickCallback);
      case SSNavigationType.secondary:
        return _getSecondaryButton(action, onClickCallback);
      case SSNavigationType.primaryDisabled:
        return _getPrimaryDisabledButton(action);
      case SSNavigationType.secondaryDisabled:
        return _getSecondaryDisabledButton(action);
      case SSNavigationType.text:
        return _getTextButton(action, onClickCallback);
      case SSNavigationType.link:
        return _getLinkButton(action, onClickCallback);
      case SSNavigationType.icon:
        return _getIconButton(action, onClickCallback, padding, size);

      default:
        return _getSecondaryButton(action, onClickCallback);
    }
  }

  static Widget _getPrimaryButton(SSNavigation action, Function(SSNavigation action)? onClickCallback) =>
      UIKitFilledButton(
          // leftIcon: action.iconIdentifier == null
          //     ? null
          //     : SvgPicture.asset(
          //         AppSvgPath.getSVGIconFromIdentifier(action.iconIdentifier!),
          //         color: UIKitColor.primary3), //todo cht
          text: action.title,
          onPressed: onClickCallback == null ? () => DeepLinks.getInstance().register(action.deeplink) : _getButtonIntent(action, onClickCallback),
        buttonSize: UIKitButtonSize.small,
      );

  static Widget _getSecondaryButton(SSNavigation action, Function(SSNavigation action)? onClickCallback) =>
      UIKitOutlineButton(
          // leftIcon: action.iconIdentifier == null
          //     ? null
          //     : SvgPicture.asset(
          //         AppSvgPath.getSVGIconFromIdentifier(action.iconIdentifier!),
          //         color: UIKitColor.primary1),
          text: action.title,
          onPressed:
          onClickCallback == null ? () => DeepLinks.getInstance().register(action.deeplink) : _getButtonIntent(action, onClickCallback),
        buttonSize: UIKitButtonSize.small,
          );

  static Widget _getTextButton(SSNavigation action, Function(SSNavigation action)? onClickCallback) =>
      UIKitTextButton(
          // leftIcon: action.iconIdentifier == null
          //     ? null
          //     : SvgPicture.asset(
          //     AppSvgPath.getSVGIconFromIdentifier(action.iconIdentifier!),
          //     color: UIKitColor.primary1),
          text: action.title,
          onPressed:
          onClickCallback == null ? () => DeepLinks.getInstance().register(action.deeplink) : _getButtonIntent(action, onClickCallback),
        buttonSize: UIKitButtonSize.small,
      );


  static Widget _getLinkButton(SSNavigation action, Function(SSNavigation action)? onClickCallback) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onClickCallback == null
            ? () => DeepLinks.getInstance().register(action.deeplink)
            : _getButtonIntent(action, onClickCallback),
        child: Text(action.title, style: UIKitDefaultTypography().subtitle2.copyWith(
            color: HubColor.blueBright)),
      );


  static Widget _getIconButton(SSNavigation action,
          Function(SSNavigation action)? onClickCallback, double? padding, double? size) {

    padding ??= 10;
    size ??= 24;

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onClickCallback == null
            ? () => DeepLinks.getInstance().register(action.deeplink)
            : _getButtonIntent(action, onClickCallback),
        child: Container(
          width: size + padding,
          height: size + padding,
          padding: EdgeInsets.all(padding),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          child: SvgPicture.asset(
              /*AppSvgPath.getSVGIconFromIdentifier(action.iconIdentifier!)*/ '' //todo cht
              ,color: HubColor.iconColor,
              height: size,
              width: size,
              fit: BoxFit.scaleDown),
        ),
      );
  }

  static Widget _getPrimaryDisabledButton(
          SSNavigation action) =>
      UIKitFilledButton(
          leftIcon: action.iconIdentifier == null
              ? null
              : SvgPicture.asset(
                  /*AppSvgPath.getSVGIconFromIdentifier(action.iconIdentifier!)*/ '' //todo cht
                  ,color: UIKitColor.primary3),
          isEnabled: false,
          onPressed: null,
          text: action.title,
        buttonSize: UIKitButtonSize.small);

  static Widget _getSecondaryDisabledButton(SSNavigation action) =>
      UIKitOutlineButton(
          leftIcon: action.iconIdentifier == null
              ? null
              : SvgPicture.asset(
                  /*AppSvgPath.getSVGIconFromIdentifier(action.iconIdentifier!)*/ '' //todo cht
               ,
                  color: UIKitColor.primary2),
          isEnabled: false,
          text: action.title,
          onPressed: null,
        buttonSize: UIKitButtonSize.small);

  static Function() _getButtonIntent(SSNavigation action, Function(SSNavigation action) onClickCallback) => action.onTap ?? onClickCallback.call(action);
}
