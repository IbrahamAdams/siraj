import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

class SuccessDialog extends StatefulWidget {
  const SuccessDialog({this.message, this.onPressed});
  final String? message;
  final Function? onPressed;

  @override
  _SuccessDialogState createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog> {
  @override
  Widget build(BuildContext context) {
    return _NewDialog(widget: widget);
  }
}

class _NewDialog extends StatelessWidget {
  const _NewDialog({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final SuccessDialog widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                height: 60,
                width: double.infinity,
                padding: const EdgeInsets.all(PsDimens.space8),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    color: PsColors.activeColor),
                child: Row(
                  children: <Widget>[
                    const SizedBox(width: PsDimens.space4),
                    Icon(
                      Icons.check_circle,
                      color: PsColors.black,
                    ),
                    const SizedBox(width: PsDimens.space4),
                    Text(
                      Utils.getString(context, 'success_dialog__success'),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: PsColors.black,
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: PsDimens.space20),
            Container(
              padding: const EdgeInsets.only(
                  left: PsDimens.space16,
                  right: PsDimens.space16,
                  top: PsDimens.space8,
                  bottom: PsDimens.space8),
              child: Text(
                widget.message!,
                style: TextStyle(
                  color: PsColors.black,
                ),
              ),
            ),
            const SizedBox(height: PsDimens.space20),
            Divider(
              thickness: 0.5,
              height: 1,
              color: Theme.of(context).iconTheme.color,
            ),
            MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.of(context).pop();
                widget.onPressed!();
              },
              child: Text(
                Utils.getString(context, 'dialog__ok'),
                style: TextStyle(
                  color: PsColors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
