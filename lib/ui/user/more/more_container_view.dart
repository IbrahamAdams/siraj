import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

import 'more_view.dart';

class MoreContainerView extends StatefulWidget {
  const MoreContainerView({required this.userName});

  final String userName;

  @override
  _MoreContainerViewState createState() => _MoreContainerViewState();
}

class _MoreContainerViewState extends State<MoreContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Function? callLogoutCallBack;

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    dynamic closeMoreContainerView() {
      Navigator.of(context).pop(true);
    }

    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
          ),
          iconTheme: Theme.of(context).iconTheme.copyWith(
              color: PsColors
                  .activeColor), //Utils.isLightMode(context)? PsColors.primary500 : PsColors.primaryDarkWhite),
          title: Text(
            widget.userName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: PsColors.activeColor, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: Container(
          color: PsColors.baseColor,
          height: double.infinity,
          child: MoreView(
              animationController: animationController,
              closeMoreContainerView: closeMoreContainerView),
        ),
      ),
    );
  }
}
