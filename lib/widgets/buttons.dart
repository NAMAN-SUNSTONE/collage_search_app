import 'package:admin_hub_app/theme/app_colors.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  const CustomButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.height,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(0, height ?? 50)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        )));
    return ElevatedButton(
        onPressed: onPressed, style: buttonStyle, child: child);
  }
}

class GeneralButton extends StatelessWidget {
  const GeneralButton(
      {Key? key,
        required this.buttonTextKey,
        this.onPressed,
        this.iconData,
        this.iconSize,
        this.btnTextColor,
        this.btnbackColor,
        this.btnTextpadding,
        this.btnTextFontWeight,
        this.svgIcon,
        this.isDense = false,
        this.textStyle,
        this.borderColor,
        this.borderWidth,
        this.borderRadius,
        this.iconColor,
        this.isBorder = false,
        this.isTakeCompleteWidth = false,
        this.isEnabled = true,
        this.height,
        this.paddingBtnStyle,
        this.elevation = 2})
      : super(key: key);

  const GeneralButton.icon(
      {Key? key,
        required this.buttonTextKey,
        required this.iconData,
        this.iconSize,
        this.btnTextColor,
        this.btnbackColor,
        this.isDense = false,
        this.btnTextFontWeight,
        this.svgIcon,
        this.btnTextpadding,
        this.textStyle,
        this.borderRadius,
        this.iconColor,
        this.borderColor,
        this.borderWidth,
        this.isBorder = false,
        this.isEnabled = true,
        this.isTakeCompleteWidth = false,
        this.onPressed,
        this.height,
        this.paddingBtnStyle,
        this.elevation = 2})
      : super(key: key);

  const GeneralButton.svg(
      {Key? key,
        required this.buttonTextKey,
        required this.svgIcon,
        this.btnTextColor,
        this.btnbackColor,
        this.isDense = false,
        this.btnTextFontWeight,
        this.btnTextpadding,
        this.iconData,
        this.iconSize,
        this.textStyle,
        this.borderRadius,
        this.borderColor,
        this.borderWidth,
        this.iconColor,
        this.isBorder = false,
        this.isEnabled = true,
        this.isTakeCompleteWidth = false,
        this.onPressed,
        this.height,
        this.paddingBtnStyle,
        this.elevation = 2})
      : super(key: key);

  final bool isDense;
  final String buttonTextKey;
  final VoidCallback? onPressed;
  final Color? btnTextColor;
  final Color? btnbackColor;
  final Widget? svgIcon;
  final IconData? iconData;
  final Color? iconColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? iconSize;
  final EdgeInsets? btnTextpadding;
  final FontWeight? btnTextFontWeight;
  final TextStyle? textStyle;
  final double? borderRadius;
  final bool isEnabled;
  final bool isTakeCompleteWidth;
  final double? height;
  final bool isBorder;
  final MaterialStateProperty<EdgeInsetsGeometry?>? paddingBtnStyle;
  final double elevation;

  Color get getButtonColor {
    if (!isEnabled) {
      return HubColor.lightPurpleGrey;
    }

    return btnbackColor != null ? btnbackColor! : BaseAppColor.primary;
  }

  @override
  Widget build(BuildContext context) {

    final buttonStyle = ButtonStyle(
      padding: paddingBtnStyle,
      elevation: MaterialStateProperty.all(elevation),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: borderRadius != null
                  ? BorderRadius.circular(borderRadius!)
                  : BorderRadius.circular(4),
              side: isBorder
                  ? BorderSide(
                  color: borderColor ?? BaseAppColor.primary,
                  width: borderWidth ?? 1)
                  : BorderSide.none)),
      backgroundColor: MaterialStateProperty.all(getButtonColor),
      textStyle: btnTextColor != null
          ? MaterialStateProperty.all(TextStyle(color: btnTextColor))
          : MaterialStateProperty.all(
          const TextStyle(color: BaseAppColor.white)),
    );



    return iconData != null
        ? SizedBox(
      width: isTakeCompleteWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton.icon(
          onPressed: isEnabled ? onPressed : null,
          icon: Icon(iconData, size: iconSize, color: iconColor),
          label: Padding(
            padding: btnTextpadding ?? const EdgeInsets.all(0),
            child: Text(
              buttonTextKey.tr,
              textAlign: TextAlign.center,
              style: textStyle != null
                  ? textStyle!.copyWith(letterSpacing: 0)
                  : btnTextColor != null
                  ? TextStyle(
                  color: btnTextColor,
                  letterSpacing: 0,
                  fontWeight:
                  btnTextFontWeight ?? FontWeight.normal)
                  : TextStyle(
                  color: BaseAppColor.white,
                  letterSpacing: 0,
                  fontWeight:
                  btnTextFontWeight ?? FontWeight.normal),
            ),
          ),
          style: buttonStyle),
    )
        : svgIcon != null
        ? SizedBox(
      width: isTakeCompleteWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton.icon(
        onPressed: isEnabled ? onPressed : null,
        icon: svgIcon ?? const Icon(Icons.error),
        label: Padding(
          padding: btnTextpadding ?? const EdgeInsets.all(0),
          child: Text(
            buttonTextKey.tr,
            textAlign: TextAlign.center,
            style: textStyle != null
                ? textStyle!.copyWith(letterSpacing: 0)
                : btnTextColor != null
                ? TextStyle(
                color: btnTextColor,
                fontWeight:
                btnTextFontWeight ?? FontWeight.normal)
                : TextStyle(
                color: BaseAppColor.white,
                fontWeight:
                btnTextFontWeight ?? FontWeight.normal),
          ),
        ),
        style: buttonStyle,
      ),
    )
        : SizedBox(
      width: isTakeCompleteWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: buttonStyle,
        child: Padding(
          padding: btnTextpadding ?? const EdgeInsets.all(0),
          child: Text(
            buttonTextKey.tr,
            textAlign: TextAlign.center,
            style: textStyle != null
                ? textStyle!.copyWith(letterSpacing: 0)
                : btnTextColor != null
                ? TextStyle(
                color: btnTextColor,
                letterSpacing: 0,
                fontWeight:
                btnTextFontWeight ?? FontWeight.normal)
                : TextStyle(
                color: BaseAppColor.white,
                letterSpacing: 0,
                fontWeight:
                btnTextFontWeight ?? FontWeight.normal),
          ),
        ),
      ),
    );
  }
}


class OutlineButtonCustom extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color borderColor;

  OutlineButtonCustom({
    required this.child,
    required this.onPressed,
    this.borderColor = HubColor.primary,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      side: MaterialStateBorderSide.resolveWith((states) {
        return BorderSide(color: borderColor, width: 1);
      }),
      shape: MaterialStateProperty.all(const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)))),
    );

    return OutlinedButton(
      child: child,
      onPressed: onPressed,
      style: buttonStyle,
    );
  }
}
