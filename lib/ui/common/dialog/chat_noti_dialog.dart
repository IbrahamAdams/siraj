import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

class ChatNotiDialog extends StatefulWidget {
  const ChatNotiDialog(
      {Key? key,
      this.description,
      this.leftButtonText,
      this.rightButtonText,
      this.onAgreeTap})
      : super(key: key);

  final String? description, leftButtonText, rightButtonText;
  final Function? onAgreeTap;

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<ChatNotiDialog> {
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

  final ChatNotiDialog widget;

  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      width: PsDimens.space4,
    );
    const Widget _largeSpacingWidget = SizedBox(
      height: PsDimens.space20,
    );
    final Widget _headerWidget = Row(
      children: <Widget>[
        _spacingWidget,
        const Icon(
          Icons.mail,
          color: Colors.black,
        ),
        _spacingWidget,
        Text(
          Utils.getString(context, 'chat_noti__new_message'),
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );

    final Widget _messageWidget = Text(
      widget.description!,
      style: Theme.of(context).textTheme.titleMedium,
    );
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              height: PsDimens.space60,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  //  border: Border.all(color: PsColors.activeColor, width: 5),
                  color: PsColors.activeColor),
              child: _headerWidget),
          _largeSpacingWidget,
          Container(
            padding: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
                top: PsDimens.space8,
                bottom: PsDimens.space8),
            child: _messageWidget,
          ),
          _largeSpacingWidget,
          Divider(
            color: Theme.of(context).iconTheme.color,
            height: 0.4,
          ),
          Row(children: <Widget>[
            Expanded(
                child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.of(context).pop();
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
                widget.onAgreeTap!();
              },
              child: Text(
                widget.rightButtonText!,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: PsColors.black),
              ),
            )),
          ])
        ],
      ),
    );
  }
}
