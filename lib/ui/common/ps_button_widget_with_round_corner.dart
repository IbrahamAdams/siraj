import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

class PSButtonWidgetRoundCorner extends StatefulWidget {
  const PSButtonWidgetRoundCorner(
      {this.onPressed,
      this.titleText = '',
      this.titleTextAlign = TextAlign.center,
      this.colorData,
      this.width,
      this.gradient,
      this.hasShadow = false});

  final Function? onPressed;
  final String titleText;
  final Color? colorData;
  final double? width;
  final Gradient? gradient;
  final bool hasShadow;
  final TextAlign titleTextAlign;

  @override
  _PSButtonWidgetRoundCornerState createState() =>
      _PSButtonWidgetRoundCornerState();
}

class _PSButtonWidgetRoundCornerState extends State<PSButtonWidgetRoundCorner> {
  Gradient? _gradient;
  Color? _color;
  @override
  Widget build(BuildContext context) {
    _color = widget.colorData;
    _gradient = null;

    _color ??= PsColors.primary500;

    if (widget.gradient == null && _color == PsColors.primary500) {
      _gradient = LinearGradient(colors: <Color>[
        PsColors.primary500,
        PsColors.primary900,
      ]);
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: ShapeDecoration(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        color: _gradient == null ? _color : null,
        gradient: _gradient,
        shadows: <BoxShadow>[
          if (widget.hasShadow)
            BoxShadow(
                color: Utils.isLightMode(context)
                    ? _color!.withOpacity(0.6)
                    : PsColors.mainShadowColor,
                offset: const Offset(0, 4),
                blurRadius: 8.0,
                spreadRadius: 3.0),
        ],
      ),
      child: Material(
        color: PsColors.transparent,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(PsDimens.space8))),
        child: InkWell(
          onTap: widget.onPressed as void Function()?,
          highlightColor: PsColors.primary900,
          child: Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: PsDimens.space8, right: PsDimens.space8),
              child: Text(
                widget.titleText.toUpperCase(),
                textAlign: widget.titleTextAlign,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: PsColors.textColor4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PSButtonWithIconWidget extends StatefulWidget {
  const PSButtonWithIconWidget(
      {this.onPressed,
      this.titleText = '',
      this.colorData,
      this.width,
      this.gradient,
      this.icon,
      this.iconAlignment = MainAxisAlignment.center,
      this.hasShadow = false,
      this.iconColor});

  final Function? onPressed;
  final String titleText;
  final Color? colorData;
  final double? width;
  final IconData? icon;
  final Gradient? gradient;
  final MainAxisAlignment iconAlignment;
  final bool hasShadow;
  final Color? iconColor;

  @override
  _PSButtonWithIconWidgetState createState() => _PSButtonWithIconWidgetState();
}

class _PSButtonWithIconWidgetState extends State<PSButtonWithIconWidget> {
  Gradient? _gradient;
  Color? _color;
  Color? _iconColor;

  @override
  Widget build(BuildContext context) {
    _color = widget.colorData;
    _gradient = null;

    _iconColor = widget.iconColor;

    _iconColor ??= PsColors.white;

    _color ??= PsColors.primary500;

    if (widget.gradient == null && _color == PsColors.primary500) {
      _gradient = LinearGradient(colors: <Color>[
        PsColors.primary500,
        PsColors.primary900,
      ]);
    }

    return Container(
      width: widget.width, //MediaQuery.of(context).size.width,
      height: 40,
      decoration: ShapeDecoration(
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        color: _gradient == null ? _color : null,
        gradient: _gradient,
        shadows: <BoxShadow>[
          if (widget.hasShadow)
            BoxShadow(
                color: Utils.isLightMode(context)
                    ? _color!.withOpacity(0.6)
                    : PsColors.mainShadowColor,
                offset: const Offset(0, 4),
                blurRadius: 8.0,
                spreadRadius: 3.0),
        ],
      ),
      child: Material(
        color: PsColors.transparent,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(PsDimens.space8))),
        child: InkWell(
          onTap: widget.onPressed as void Function()?,
          highlightColor: PsColors.primary900,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: widget.iconAlignment,
            children: <Widget>[
              if (widget.icon != null) Icon(widget.icon, color: _iconColor),
              if (widget.icon != null && widget.titleText != '')
                const SizedBox(
                  width: PsDimens.space12,
                ),
              Text(
                widget.titleText.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: PsColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PSButtonWidgetWithIconRoundCorner extends StatefulWidget {
  const PSButtonWidgetWithIconRoundCorner(
      {this.onPressed,
      this.titleText = '',
      this.titleTextAlign = TextAlign.center,
      this.colorData,
      this.width,
      this.icon,
      this.gradient,
      this.iconColor,
      this.iconAlignment = MainAxisAlignment.center,
      this.hasShadow = false});

  final Function? onPressed;
  final String titleText;
  final Color? colorData;
  final double? width;
  final IconData? icon;
  final Gradient? gradient;
  final bool hasShadow;
  final TextAlign titleTextAlign;
  final MainAxisAlignment iconAlignment;
  final Color? iconColor;

  @override
  _PSButtonWidgetWithIconRoundCornerState createState() =>
      _PSButtonWidgetWithIconRoundCornerState();
}

class _PSButtonWidgetWithIconRoundCornerState
    extends State<PSButtonWidgetWithIconRoundCorner> {
  Gradient? _gradient;
  Color? _color;
  Color? _iconColor;

  @override
  Widget build(BuildContext context) {
    _color = widget.colorData;
    _gradient = null;

    _iconColor = widget.iconColor;

    _iconColor ??= PsColors.white;

    _color ??= PsColors.primary500;

    if (widget.gradient == null && _color == PsColors.primary500) {
      _gradient = LinearGradient(colors: <Color>[
        PsColors.primary500,
        PsColors.primary900,
      ]);
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: ShapeDecoration(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(13.0)),
        ),
        color: Color(0xFFFF9505),
        // shadows: <BoxShadow>[
        //   if (widget.hasShadow)
        //     BoxShadow(
        //         color: Utils.isLightMode(context)
        //             ? _color!.withOpacity(0.6)
        //             : PsColors.mainShadowColor,
        //         offset: const Offset(0, 4),
        //         blurRadius: 8.0,
        //         spreadRadius: 3.0),
        // ],
      ),
      child: Material(
        color: PsColors.transparent,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: PsColors.secondary50),
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space12))),
        child: InkWell(
          onTap: widget.onPressed as void Function()?,
          highlightColor: PsColors.primary900,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: widget.iconAlignment,
            children: <Widget>[
              if (widget.icon != null) Icon(widget.icon, color: _iconColor),
              if (widget.icon != null && widget.titleText != '')
                const SizedBox(
                  width: PsDimens.space4,
                ),
              Text(
                widget.titleText.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: widget.titleText ==
                                Utils.getString(
                                    context, 'edit_profile__title') ||
                            widget.titleText ==
                                Utils.getString(context, 'Reset') ||
                            widget.titleText ==
                                Utils.getString(context, 'map_filter__reset')
                        ? PsColors.activeColor //PsColors.primary500
                        : PsColors.textColor4 //PsColors.white
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
