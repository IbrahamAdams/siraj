import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

class VersionUpdateDialog extends StatefulWidget {
  const VersionUpdateDialog(
      {Key? key,
      this.title,
      this.description,
      this.leftButtonText,
      this.rightButtonText,
      this.onCancelTap,
      this.onUpdateTap})
      : super(key: key);
  @override
  _VersionUpdateDialogState createState() => _VersionUpdateDialogState();
  final String? title, description, leftButtonText, rightButtonText;
  final Function? onCancelTap;
  final Function? onUpdateTap;
}

class _VersionUpdateDialogState extends State<VersionUpdateDialog> {
  @override
  Widget build(BuildContext context) {
    return NewDialog(widget: widget);
  }
}

class NewDialog extends StatelessWidget {
  const NewDialog({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final VersionUpdateDialog widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  height: PsDimens.space60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      //  border: Border.all(color: PsColors.activeColor, width: 5),
                      color: PsColors.activeColor),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: PsDimens.space8),
                      Icon(
                        Icons.alarm,
                        color: PsColors.black,
                      ),
                      const SizedBox(width: PsDimens.space8),
                      Text(
                        Utils.getString(
                            context, 'version_update_dialog__version_update'),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: PsColors.black,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: PsDimens.space8),
              Container(
                padding: const EdgeInsets.only(
                    left: PsDimens.space16,
                    right: PsDimens.space16,
                    top: PsDimens.space16,
                    bottom: PsDimens.space8),
                child: Row(
                  children: <Widget>[
                    Text(
                      widget.title!,
                      style: TextStyle(
                        color: PsColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: PsDimens.space16,
                    right: PsDimens.space16,
                    bottom: PsDimens.space8),
                child: Text(
                  widget.description!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: PsDimens.space8),
              Divider(
                color: Theme.of(context).iconTheme.color,
                height: 1,
              ),
              Row(children: <Widget>[
                Expanded(
                    child: MaterialButton(
                  height: 50,
                  minWidth: double.infinity,
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onCancelTap!();
                  },
                  child: Text(
                    widget.leftButtonText!,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                )),
                Container(
                    height: 50,
                    width: 0.4,
                    color: Theme.of(context).iconTheme.color),
                Expanded(
                    child: MaterialButton(
                  height: 50,
                  minWidth: double.infinity,
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onUpdateTap!();
                  },
                  child: Text(widget.rightButtonText!,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: PsColors.black)),
                )),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
