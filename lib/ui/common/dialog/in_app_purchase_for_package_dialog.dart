import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget_with_round_corner.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';

class InAppPurchaseBuyPackageDialog extends StatefulWidget {
  const InAppPurchaseBuyPackageDialog(
      {Key? key, required this.onInAppPurchaseTap})
      : super(key: key);

  final Function onInAppPurchaseTap;

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<InAppPurchaseBuyPackageDialog> {
  UserRepository? repo1;
  PsValueHolder? psValueHolder;

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

  final InAppPurchaseBuyPackageDialog widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        width: 400.0,
        // height: 300.0,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(height: PsDimens.space16),
            Text(Utils.getString(context, 'item_entry__buy_package_title'),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: PsColors.labelLargeColor,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: PsDimens.space28),
            PSButtonWidgetRoundCorner(
              colorData: PsColors.labelLargeColor,
              hasShadow: true,
              width: double.infinity,
              titleText:
                  Utils.getString(context, 'item_entry__package_go_to_shop'),
              onPressed: () async {
                //  Navigator.pop(context);
                widget.onInAppPurchaseTap();
              },
            ),
            const SizedBox(height: PsDimens.space16),
          ],
        ),
      ),
    );
  }
}
