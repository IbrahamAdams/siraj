import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/success_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/forgot_password_parameter_holder.dart';
import 'package:provider/provider.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({
    Key? key,
    this.animationController,
    this.goToLoginSelected,
  }) : super(key: key);
  final AnimationController? animationController;
  final Function? goToLoginSelected;
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView>
    with SingleTickerProviderStateMixin {
  final TextEditingController userEmailController = TextEditingController();
  UserRepository? repo1;
  PsValueHolder? psValueHolder;
  late AnimationController animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    animationController.forward();
    repo1 = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(
        lazy: false,
        create: (BuildContext context) {
          final UserProvider provider =
              UserProvider(repo: repo1, psValueHolder: psValueHolder);
          // provider.postUserRegister(userRegisterParameterHolder.toMap());
          return provider;
        },
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider provider, Widget? child) {
          return Stack(
            children: <Widget>[
              SingleChildScrollView(
                  child: AnimatedBuilder(
                      animation: animationController,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          _HeaderIconAndTextWidget(),
                          _CardWidget(
                            userEmailController: userEmailController,
                          ),
                          const SizedBox(
                            height: PsDimens.space8,
                          ),
                          _SendButtonWidget(
                            provider: provider,
                            userEmailController: userEmailController,
                          ),
                          const SizedBox(
                            height: PsDimens.space16,
                          ),
                          _TextWidget(
                              goToLoginSelected: widget.goToLoginSelected),
                        ],
                      ),
                      builder: (BuildContext context, Widget? child) {
                        return FadeTransition(
                          opacity: animation,
                          child: Transform(
                              transform: Matrix4.translationValues(
                                  0.0, 100 * (1.0 - animation.value), 0.0),
                              child: child),
                        );
                      }))
            ],
          );
        }),
      ),
    );
  }
}

class _TextWidget extends StatefulWidget {
  const _TextWidget({this.goToLoginSelected});
  final Function? goToLoginSelected;
  @override
  __TextWidgetState createState() => __TextWidgetState();
}

class __TextWidgetState extends State<_TextWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Ink(
          color: PsColors.backgroundColor,
          child: Text(
            Utils.getString(context, 'forgot_psw__login'),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: PsColors.textColor1),
          ),
        ),
      ),
      onTap: () {
        if (widget.goToLoginSelected != null) {
          widget.goToLoginSelected!();
        } else {
          Navigator.pushReplacementNamed(
            context,
            RoutePaths.login_container,
          );
        }
      },
    );
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(
      Utils.getString(context, 'app_name'),
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: PsColors.activeColor,
          ),
    );

    final Widget _imageWidget = Container(
      width: 90,
      height: 90,
      child: Image.asset(
        'assets/images/flutter_buy_and_sell_logo.png',
      ),
    );
    return Column(
      children: <Widget>[
        const SizedBox(
          height: PsDimens.space32,
        ),
        _imageWidget,
        const SizedBox(
          height: PsDimens.space8,
        ),
        _textWidget,
        const SizedBox(
          height: PsDimens.space52,
        ),
      ],
    );
  }
}

class _CardWidget extends StatelessWidget {
  const _CardWidget({
    required this.userEmailController,
  });

  final TextEditingController userEmailController;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.3,
      margin: const EdgeInsets.only(
          left: PsDimens.space32, right: PsDimens.space32),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
                top: PsDimens.space4,
                bottom: PsDimens.space4),
            child: TextField(
              controller: userEmailController,
              keyboardType: TextInputType.emailAddress,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'forgot_psw__email'),
                  hintStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Utils.isLightMode(context)
                          ? PsColors.textPrimaryLightColor
                          : PsColors.primaryDarkGrey),
                  icon: Icon(Icons.email,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SendButtonWidget extends StatefulWidget {
  const _SendButtonWidget({
    required this.provider,
    required this.userEmailController,
  });
  final UserProvider provider;
  final TextEditingController userEmailController;

  @override
  __SendButtonWidgetState createState() => __SendButtonWidgetState();
}

dynamic callWarningDialog(BuildContext context, String text) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          message: Utils.getString(context, text),
          onPressed: () {},
        );
      });
}

class __SendButtonWidgetState extends State<_SendButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space32, right: PsDimens.space32),
      child: PSButtonWidget(
          colorData: PsColors.labelLargeColor,
          hasShadow: true,
          width: double.infinity,
          titleText: Utils.getString(context, 'forgot_psw__send'),
          onPressed: () async {
            if (widget.userEmailController.text.isEmpty) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_email'));
            } else {
              if (Utils.checkEmailFormat(
                  widget.userEmailController.text.trim())!) {
                if (await Utils.checkInternetConnectivity()) {
                  final ForgotPasswordParameterHolder
                      forgotPasswordParameterHolder =
                      ForgotPasswordParameterHolder(
                    userEmail: widget.userEmailController.text.trim(),
                  );

                  await PsProgressDialog.showDialog(context);
                  final PsResource<ApiStatus> _apiStatus = await widget.provider
                      .postForgotPassword(
                          forgotPasswordParameterHolder.toMap());
                  PsProgressDialog.dismissDialog();

                  if (_apiStatus.data != null) {
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return SuccessDialog(
                            message: _apiStatus.data!.message,
                            onPressed: () {},
                          );
                        });
                  } else {
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorDialog(
                            message: _apiStatus.message,
                          );
                        });
                  }
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: Utils.getString(
                              context, 'error_dialog__no_internet'),
                        );
                      });
                }
              } else {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__email_format'));
              }
            }
          }),
    );
  }
}
