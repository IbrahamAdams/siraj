import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/about_us/about_us_provider.dart';
import 'package:flutterbuyandsell/ui/common/ps_expansion_tile.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:provider/provider.dart';

class TermsAndConditionTileView extends StatelessWidget {
  const TermsAndConditionTileView({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  final AnimationController? animationController;
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'setting__terms_and_condition'),
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: PsColors.textColor2));

    final Widget _expansionTileLeadingIconWidget = Icon(
      Icons.assignment, //FontAwesome.shield,
      color: PsColors.textColor2,
    );

    final Widget _expanionTitleWithLeadingIconWidget = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _expansionTileLeadingIconWidget,
        const SizedBox(
          width: PsDimens.space12,
        ),
        _expansionTileTitleWidget
      ],
    );

    return Consumer<AboutUsProvider>(builder: (BuildContext context,
        AboutUsProvider aboutUsProvider, Widget? gchild) {
      if (aboutUsProvider.aboutUsList.data!.isNotEmpty) {
        return Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12,
              right: PsDimens.space12,
              bottom: PsDimens.space12),
          decoration: BoxDecoration(
            color: PsColors.cardBackgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          child: PsExpansionTile(
            initiallyExpanded: true,
            //  leading: _expansionTileLeadingIconWidget,
            title: _expanionTitleWithLeadingIconWidget,
            children: <Widget>[
              Column(
                children: <Widget>[
                  // const Divider(
                  //   height: PsDimens.space1,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: PsDimens.space18),
                    child: Html(
                      data: aboutUsProvider
                          .aboutUsList.data![0].termsAndConditions!,
                      // ignore: always_specify_types
                      // style: {
                      //   '#': Style(
                      //       margin: const EdgeInsets.only(top: -7.0),
                      //       maxLines: 2,
                      //       height: 40,
                      //       fontWeight: FontWeight.normal,
                      //       //  textOverflow: TextOverflow.ellipsis,
                      //       color: PsColors.textColor2),
                      // },
                    ),
                    // child: Text(
                    //     aboutUsProvider.aboutUsList.data![0].safetyTips!,
                    //     maxLines: 3,
                    //     overflow: TextOverflow.ellipsis,
                    //     textAlign: TextAlign.justify,
                    //     style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    //       color: PsColors.textColor2
                    // )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(PsDimens.space12),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutePaths.termsAndCondition);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            Utils.getString(
                                context, 'safety_tips_tile__read_more_button'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: PsColors.textColor1, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
