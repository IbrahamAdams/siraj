import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

class PsHeaderWidget extends StatelessWidget {
  const PsHeaderWidget({
    Key? key,
    required this.headerName,
    required this.viewAllClicked,
    this.showViewAll = true,
  }) : super(key: key);

  final String headerName;
  final Function viewAllClicked;
  final bool showViewAll;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: viewAllClicked as void Function()?,
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(headerName,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleMedium),
            Visibility(
              visible: showViewAll,
              child: InkWell(
                child: Text(
                  Utils.getString(context, 'profile__view_all'),
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: PsColors.activeColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
