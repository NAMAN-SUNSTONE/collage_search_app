import 'package:admin_hub_app/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:sunstone_ui_kit/typo/ui_kit_default_typo.dart';

enum TitleSize { large, medium }

enum TitleColorScheme { light, dark }

class SHAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final double bottomPreferredSizeWidgetHeight;
  final String? title;
  final bool? centerTitle;
  final bool automaticallyImplyLeading;

  /// Override default back click behavior
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final TitleSize titleSize;
  final double? titleSpacing;
  final TextStyle? titleTextStyle;
  final TitleColorScheme colorScheme;

  /// Triggers on back button click
  final VoidCallback? onBackPressedCallback;
  final Widget? svg;

  const SHAppBar(
      {Key? key,
      this.leading,
      this.bottom,
      this.bottomPreferredSizeWidgetHeight = 40,
      this.title,
      this.centerTitle,
      this.automaticallyImplyLeading = true,
      this.onBackPressed,
      this.actions,
      this.titleTextStyle,
      this.backgroundColor,
      this.titleSize = TitleSize.medium,
      this.titleSpacing,
      this.colorScheme = TitleColorScheme.dark,
      this.onBackPressedCallback,
      this.svg})
      : super(key: key);

  bool get _isLargeTitle => titleSize == TitleSize.large;

  Color get _colorScheme =>
      colorScheme == TitleColorScheme.dark ? HubColor.black : HubColor.white;

  Color get _backgroundColor => ((backgroundColor == null &&
          (titleSize == TitleSize.large || title == null)))
      ? Colors.transparent
      : backgroundColor ?? Colors.white;

  @override
  Widget build(BuildContext context) {
    /// This part is copied from AppBar class
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    Widget? leadingIcon = leading;

    if (leadingIcon == null && automaticallyImplyLeading) {
      if (canPop) {
        leadingIcon = Container(
          width: 24,
          child: IconButton(
              onPressed: () {
                onBackPressedCallback?.call();
                onBackPressed == null
                    ? Navigator.of(context).maybePop()
                    : onBackPressed?.call();
              },
              splashRadius: 28,
              icon: SvgPicture.asset(
                Assets.svgNavbarBack,
                height: 15,
                width: 24,
                color: _colorScheme,
              )),
        );
      }
    }

    return AppBar(
      leading: leadingIcon,
      actionsIconTheme: IconThemeData(color: _colorScheme, size: 24),
      toolbarHeight: 52,
      toolbarTextStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
            color: HubColor.grey1,
          ),
      title: Row(
        children: [
          if (title != null)
            Flexible(
              child: Text(title!,
                  style: (_isLargeTitle && !canPop)
                      ? Theme.of(context).textTheme.headline5?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: _colorScheme)
                      : Theme.of(context).textTheme.headline4?.copyWith(
                            fontSize: 16,
                            color: _colorScheme,
                          )),
            ),
          if (svg != null) ...[const SizedBox(width: 4), svg!]
        ],
      ),
      centerTitle: centerTitle ?? false,
      titleSpacing: titleSpacing ??
          ((titleSize == TitleSize.medium || canPop) ? 0 : null),
      backgroundColor: _backgroundColor,
      elevation: 0,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(bottom == null
      ? kToolbarHeight
      : bottomPreferredSizeWidgetHeight + kToolbarHeight);
}

class SHSliverAppBar extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final bool? centerTitle;
  final bool automaticallyImplyLeading;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color backgroundColor;
  final TitleSize titleSize;
  final double? titleSpacing;
  final TitleColorScheme titleColorScheme;
  final PreferredSizeWidget? bottom;

  const SHSliverAppBar(
      {Key? key,
      this.leading,
      this.title,
      this.centerTitle,
      this.automaticallyImplyLeading = true,
      this.onBackPressed,
      this.actions,
      this.backgroundColor = HubColor.white,
      this.titleSize = TitleSize.medium,
      this.titleSpacing,
      this.titleColorScheme = TitleColorScheme.dark,
      this.bottom})
      : super(key: key);

  Color get _titleColor => titleColorScheme == TitleColorScheme.dark
      ? HubColor.grey1
      : HubColor.greyDC;

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    Widget? leadingIcon = leading;

    if (leadingIcon == null && automaticallyImplyLeading) {
      if (canPop) {
        leadingIcon = Container(
          width: 24,
          child: IconButton(
              onPressed: () {
                onBackPressed?.call();
                Navigator.of(context).maybePop();
              },
              splashRadius: 28,
              icon: SvgPicture.asset(
                Assets.svgNavbarBack,
                height: 15,
                width: 24,
              )),
        );
      }
    }

    return SliverAppBar(
        leading: leadingIcon,
        actionsIconTheme:
            const IconThemeData(color: HubColor.primaryLight, size: 24),
        toolbarHeight: 52,
        title: Text(
          title ?? "",
          style: (titleSize == TitleSize.large && !canPop)
              ? Theme.of(context).textTheme.headline5?.copyWith(
                  fontSize: 24, fontWeight: FontWeight.w600, color: _titleColor)
              : Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(fontSize: 16, color: _titleColor, height: 1.2),
          maxLines: 2,
        ),
        centerTitle: centerTitle ?? false,
        titleSpacing: titleSpacing ??
            ((titleSize == TitleSize.medium || canPop) ? 0 : null),
        backgroundColor: backgroundColor,
        elevation: 0,
        actions: actions,
        snap: true,
        pinned: true,
        floating: true,
        bottom: bottom);
  }
}

class BottomSheetAppBar extends StatelessWidget {
  final String? title;
  final Function? onClose;
  final TextStyle? titleTextStyle;
  final bool centerTitle;

  const BottomSheetAppBar(
      {Key? key,
      this.title,
      this.onClose,
      this.titleTextStyle,
      this.centerTitle = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            height: 3,
            width: 30,
            decoration: BoxDecoration(
                color: HubColor.dividerColor,
                borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: centerTitle
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              if (title != null)
                Flexible(
                  child: Text(
                    title!,
                    style: titleTextStyle ??
                        context.textTheme.bodyText2?.copyWith(
                            color: HubColor.grey1.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class SHGradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final double bottomPreferredSizeWidgetHeight;
  final String? title;
  final String? subtitle;
  final bool? centerTitle;
  final bool automaticallyImplyLeading;
  final double height;

  /// Override default back click behavior
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final TitleSize titleSize;
  final double? titleSpacing;
  final TextStyle? titleTextStyle;
  final TitleColorScheme colorScheme;

  /// Triggers on back button click
  final VoidCallback? onBackPressedCallback;
  final Widget? svg;
  final VoidCallback? onTapTitle;
  final int maxLines;
  final List<Color>? gradient;
  final Widget? bottom;

  const SHGradientAppBar(
      {Key? key,
        this.leading,
        this.height = 150,
        this.bottomPreferredSizeWidgetHeight = 40,
        this.title,
        this.subtitle,
        this.centerTitle,
        this.automaticallyImplyLeading = true,
        this.onBackPressed,
        this.actions,
        this.titleTextStyle,
        this.backgroundColor,
        this.titleSize = TitleSize.medium,
        this.titleSpacing,
        this.colorScheme = TitleColorScheme.light,
        this.onBackPressedCallback,
        this.svg,
        this.maxLines = 2,
        this.onTapTitle,
        this.gradient,
        this.bottom})
      : super(key: key);

  Color get _colorScheme =>
      colorScheme == TitleColorScheme.dark ? HubColor.black : HubColor.white;

  @override
  Widget build(BuildContext context) {
    /// This part is copied from AppBar class
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    Widget? leadingIcon = leading;

    if (leadingIcon == null && automaticallyImplyLeading) {
      if (canPop) {
        leadingIcon = Container(
          width: 24,
          child: IconButton(
              onPressed: () {
                onBackPressedCallback?.call();
                onBackPressed == null
                    ? Navigator.of(context).maybePop()
                    : onBackPressed?.call();
              },
              splashRadius: 28,
              icon: SvgPicture.asset(
                Assets.svgNavbarBack,
                height: 15,
                width: 24,
                color: _colorScheme,
              )),
        );
      }
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient ??
              [
                Color(0xffb5adcb),
                Color(0xff736798),
              ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: AppBar(
        leading: SizedBox(
          height: 24,
          width: 24,
          child: leadingIcon,
        ),
        actionsIconTheme: IconThemeData(color: _colorScheme, size: 24),
        toolbarTextStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
          color: HubColor.grey1,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(height - 56),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onTapTitle,
                  child: Row(
                    children: [
                      if (title != null)
                        Flexible(
                            child: Text(
                              title!.capitalizeFirst ?? '',
                              maxLines: maxLines,
                              style: TextStyle(
                                  fontSize: 20,
                                  height: 1.4,
                                  fontWeight: FontWeight.w900,
                                  color: HubColor.white),
                            )),
                      if (svg != null) ...[SizedBox(width: 4), svg!],
                      SizedBox(
                        height: 4,
                      )
                    ],
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(
                    height: 8,
                  ),
                  Text(subtitle!.trim(),
                      style: UIKitDefaultTypography().bodyText2.copyWith(
                        fontSize: 14,
                        color: HubColor.white.withOpacity(.6),
                      )),
                ],
                if (bottom != null) bottom!
              ],
            ),
          ),
        ),
        centerTitle: centerTitle ?? false,
        titleSpacing: titleSpacing ??
            ((titleSize == TitleSize.medium || canPop) ? 0 : null),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: actions,
        automaticallyImplyLeading: automaticallyImplyLeading,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
