import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/provider/about_us/about_us_provider.dart';
import 'package:flutterbuyandsell/repository/about_us_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';

class SettingPrivacyPolicyView extends StatefulWidget {
  const SettingPrivacyPolicyView({required this.checkPolicyType});
  final int checkPolicyType;
  @override
  _SettingPrivacyPolicyViewState createState() {
    return _SettingPrivacyPolicyViewState();
  }
}

class _SettingPrivacyPolicyViewState extends State<SettingPrivacyPolicyView>
    with SingleTickerProviderStateMixin {
  // final ScrollController _scrollController = ScrollController();

  // late AboutUsProvider _aboutUsProvider;

  // late AnimationController animationController;
  // Animation<double>? animation;

  @override
  void dispose() {
    // animationController.dispose();
    // animation = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     _aboutUsProvider.nextAboutUsList();
    //   }
    // });

    // animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 3),
    // )..addListener(() => setState(() {}));

    // animation = Tween<double>(
    //   begin: 0.0,
    //   end: 10.0,
    // ).animate(animationController);
  }

  AboutUsRepository? repo1;
  PsValueHolder? valueHolder;
  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<AboutUsRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    return PsWidgetWithAppBar<AboutUsProvider>(
        appBarTitle: "Terms of use",
        initProvider: () {
          return AboutUsProvider(
            repo: repo1,
            psValueHolder: valueHolder,
          );
        },
        onProviderReady: (AboutUsProvider provider) {
          provider.loadAboutUsList();
          // _aboutUsProvider = provider;
        },
        builder:
            (BuildContext context, AboutUsProvider provider, Widget? child) {
          if (provider.aboutUsList.data != null &&
              provider.aboutUsList.data!.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(PsDimens.space10),
              child: SingleChildScrollView(
                child: Html(data: provider.aboutUsList.data![0].privacypolicy!),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
