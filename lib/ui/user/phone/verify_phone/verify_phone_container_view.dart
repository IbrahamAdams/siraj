import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/user/phone/verify_phone/verify_phone_view.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:provider/provider.dart';

class VerifyPhoneContainerView extends StatefulWidget {
  const VerifyPhoneContainerView({
    Key? key,
    required this.userName,
    required this.phoneNumber,
    required this.phoneId,
  }) : super(key: key);
  final String userName;
  final String phoneNumber;
  final String? phoneId;
  @override
  _CityVerifyPhoneContainerViewState createState() =>
      _CityVerifyPhoneContainerViewState();
}

class _CityVerifyPhoneContainerViewState extends State<VerifyPhoneContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
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
  UserProvider? userProvider;
  UserRepository? userRepo;

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');
    userRepo = Provider.of<UserRepository>(context);

    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: PsColors.primary500,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
              ),
              iconTheme: Theme.of(context).iconTheme.copyWith(
                  color: Utils.isLightMode(context)
                      ? PsColors.primary500
                      : PsColors.primaryDarkWhite),
              title: Text(
                Utils.getString(context, 'home_verify_phone'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold, color: PsColors.white),
              ),
              elevation: 0,
            ),
            body: VerifyPhoneView(
              userName: widget.userName,
              phoneNumber: widget.phoneNumber,
              phoneId: widget.phoneId,
              animationController: animationController,
            )));
  }
}
