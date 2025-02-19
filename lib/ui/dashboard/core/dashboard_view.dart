import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/app_info/app_info_provider.dart';
import 'package:flutterbuyandsell/provider/chat/buyer_chat_history_list_provider.dart';
import 'package:flutterbuyandsell/provider/chat/seller_chat_history_list_provider.dart';
import 'package:flutterbuyandsell/provider/chat/user_unread_message_provider.dart';
import 'package:flutterbuyandsell/provider/common/notification_provider.dart';
import 'package:flutterbuyandsell/provider/delete_task/delete_task_provider.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/Common/notification_repository.dart';
import 'package:flutterbuyandsell/repository/app_info_repository.dart';
import 'package:flutterbuyandsell/repository/category_repository.dart';
import 'package:flutterbuyandsell/repository/chat_history_repository.dart';
import 'package:flutterbuyandsell/repository/delete_task_repository.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/repository/user_unread_message_repository.dart';
import 'package:flutterbuyandsell/ui/category/list/category_list_view.dart';
import 'package:flutterbuyandsell/ui/chat/list/chat_list_view.dart';
import 'package:flutterbuyandsell/ui/common/dialog/chat_noti_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/dialog/share_app_dialog.dart';
// import 'package:flutterbuyandsell/ui/common/dialog/chat_noti_dialog.dart';
import 'package:flutterbuyandsell/ui/contact/contact_us_view.dart';
// import 'package:flutterbuyandsell/ui/common/dialog/noti_dialog.dart';
import 'package:flutterbuyandsell/ui/dashboard/home/home_dashboard_view.dart';
import 'package:flutterbuyandsell/ui/faq/menu_faq_view.dart';
import 'package:flutterbuyandsell/ui/history/list/history_list_view.dart';
import 'package:flutterbuyandsell/ui/item/entry/item_entry_view.dart';
import 'package:flutterbuyandsell/ui/item/favourite/favourite_product_list_view.dart';
import 'package:flutterbuyandsell/ui/item/list_with_filter/product_list_with_filter_view.dart';
import 'package:flutterbuyandsell/ui/item/paid_ad/paid_ad_item_list_view.dart';
import 'package:flutterbuyandsell/ui/item/paid_ad_product/paid_ad_product_list_view.dart';
import 'package:flutterbuyandsell/ui/item/reported_item/reported_item_list_view.dart';
import 'package:flutterbuyandsell/ui/language/setting/language_setting_view.dart';
import 'package:flutterbuyandsell/ui/location/item_location_view.dart';
import 'package:flutterbuyandsell/ui/noti/list/noti_list_view.dart';
import 'package:flutterbuyandsell/ui/offer/list/offer_list_view.dart';
import 'package:flutterbuyandsell/ui/privacy_policy/menu_privacy_policy_view.dart';
import 'package:flutterbuyandsell/ui/setting/setting_view.dart';
import 'package:flutterbuyandsell/ui/terms_and_conditions/menu_terms_and_conditions_view.dart';
import 'package:flutterbuyandsell/ui/user/blocked_user/blocked_user_list_view.dart';
import 'package:flutterbuyandsell/ui/user/buy_adpost_transaction/buy_adpost_transaction_history.dart';
import 'package:flutterbuyandsell/ui/user/forgot_password/forgot_password_view.dart';
import 'package:flutterbuyandsell/ui/user/login/login_view.dart';
import 'package:flutterbuyandsell/ui/user/phone/sign_in/phone_sign_in_view.dart';
import 'package:flutterbuyandsell/ui/user/phone/verify_phone/verify_phone_view.dart';
import 'package:flutterbuyandsell/ui/user/profile/profile_view.dart';
import 'package:flutterbuyandsell/ui/user/register/register_view.dart';
import 'package:flutterbuyandsell/ui/user/verify/verify_email_view.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/chat_history_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/user_logout_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/user_unread_message_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:flutterbuyandsell/viewobject/user.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class DashboardView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<DashboardView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  late AnimationController animationController;
  late AnimationController animationControllerForFab;

  late Animation<double> animation;

  String? appBarTitle = 'Home';
  int? _currentIndex = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
  String? _itemId = '';
  String? _userId = '';
  bool isLogout = false;
  bool isFirstTime = true;
  bool isShowMessageDialog = false;
  String phoneUserName = '';
  String phoneNumber = '';
  String phoneId = '';
  UserProvider? provider;
  AppInfoProvider? appInfoProvider;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool isResumed = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      isResumed = true;
      initDynamicLinks(context);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (valueHolder!.loginUserId != null && valueHolder!.loginUserId != '') {
        userUnreadMessageHolder = UserUnreadMessageParameterHolder(
            userId: valueHolder!.loginUserId,
            deviceToken: valueHolder!.deviceToken);
        userUnreadMessageProvider!
            .userUnreadMessageCount(userUnreadMessageHolder);

        if (_currentIndex == PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT) {
          sellerHolder = ChatHistoryParameterHolder().getSellerHistoryList();
          sellerHolder!.getSellerHistoryList().userId =
              psValueHolder!.loginUserId;
          sellerListProvider!.resetShowProgress(false);
          sellerListProvider!.resetChatHistoryList(sellerHolder!);

          buyerHolder = ChatHistoryParameterHolder().getBuyerHistoryList();
          buyerHolder!.getBuyerHistoryList().userId =
              psValueHolder!.loginUserId;
          buyerListProvider!.resetShowProgress(false);
          buyerListProvider!.resetChatHistoryList(buyerHolder!);
        }
      }
    } else {
      //
    }
  }

  Future<dynamic> showMessageDialog(BuildContext context) async {
    if (!Utils.isShowNotiFromToolbar() && !isShowMessageDialog) {
      showDialog<dynamic>(
          context: context,
          builder: (_) {
            return ChatNotiDialog(
                description:
                    Utils.getString(context, 'noti_message__new_message'),
                leftButtonText: Utils.getString(context, 'chat_noti__cancel'),
                rightButtonText: Utils.getString(context, 'chat_noti__open'),
                onAgreeTap: () {
                  updateSelectedIndexWithAnimation(
                      Utils.getString(
                          context, 'dashboard__bottom_navigation_message'),
                      PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT);
                });
          });
      isShowMessageDialog = true;
    }
  }

  Future<void> updateSelectedIndexWithAnimation(
      String? title, int? index) async {
    await animationController.reverse().then<dynamic>((void data) {
      if (!mounted) {
        return;
      }

      setState(() {
        appBarTitleName = '';
        appBarTitle = title;
        _currentIndex = index;
      });
    });
  }

  Future<void> updateSelectedIndexWithAnimationUserId(
      String title, int index, String? userId) async {
    await animationController.reverse().then<dynamic>((void data) {
      if (!mounted) {
        return;
      }
      if (userId != null) {
        _userId = userId;
      }
      setState(() {
        appBarTitle = title;
        _currentIndex = index;
      });
    });
  }

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    animationControllerForFab = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this, value: 1);
    super.initState();
    initDynamicLinks(context);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    animationController.dispose();
    animationControllerForFab.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> initDynamicLinks(BuildContext context) async {
    Future<dynamic>.delayed(const Duration(seconds: 3)); //recomme
    String? itemId = '';
    if (!isResumed) {
      // ignore: prefer_final_locals
      // PendingDynamicLinkData? data =
      //     await FirebaseDynamicLinks.instance.getInitialLink();

      // if (data != null) {
      //   final Uri deepLink = data.link;
      //   // ignore: unnecessary_null_comparison
      //   if (deepLink != null) {
      //     final Map<String, String> queryParams = deepLink.queryParameters;
      //     if (queryParams.isNotEmpty) {
      //       itemId = queryParams['item_id'];
      //     }

      //     // final String path = deepLink.path;
      //     // final List<String> pathList = path.split('=');
      //     // itemId = pathList[1];
      //     final ProductDetailIntentHolder holder = ProductDetailIntentHolder(
      //         productId: itemId,
      //         // heroTagImage: '-1' + pathList[1] + PsConst.HERO_TAG__IMAGE,
      //         // heroTagTitle: '-1' + pathList[1] + PsConst.HERO_TAG__TITLE);
      //         heroTagImage: '-1' + itemId! + PsConst.HERO_TAG__IMAGE,
      //         heroTagTitle: '-1' + itemId + PsConst.HERO_TAG__TITLE);
      //     Navigator.pushNamed(context, RoutePaths.productDetail,
      //         arguments: holder);
      //   }
      // }
    }
    // FirebaseDynamicLinks.instance.onLink;
    // FirebaseDynamicLinks.instance.onLink(
    //     onSuccess: (PendingDynamicLinkData? dynamicLink) async {
    //   // ignore: prefer_final_locals
    //   Uri? deepLink = dynamicLink?.link;
    //   if (deepLink != null) {
    //     //  final String path = deepLink.path;
    //     //  final List<String> pathList = path.split('=');
    //     if (itemId == '') {
    //       final Map<String, String> queryParams = deepLink.queryParameters;
    //       if (queryParams.isNotEmpty) {
    //         itemId = queryParams['item_id'];
    //       }
    //       final ProductDetailIntentHolder holder = ProductDetailIntentHolder(
    //           productId: itemId,
    //           heroTagImage: '-1' + itemId! + PsConst.HERO_TAG__IMAGE,
    //           heroTagTitle: '-1' + itemId! + PsConst.HERO_TAG__TITLE);
    //       Navigator.pushNamed(context, RoutePaths.productDetail,
    //           arguments: holder);
    //     }
    //   }
    //   debugPrint('DynamicLinks onLink $deepLink');
    // }, onError: (OnLinkErrorException e) async {
    //   debugPrint('DynamicLinks onError $e');
    // });
  }

  int getBottonNavigationIndex(int? param) {
    int index = 0;
    switch (param) {
      case PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT:
        index = 0;
        break;
      // case PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT:
      case PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT:
        index = 1;
        break;
      // case PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT:
      case PsConst.REQUEST_CODE__DASHBOARD_ITEM_UPLOAD_FRAGMENT:
        index = 2;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT:
        if (valueHolder!.loginUserId != null &&
            valueHolder!.loginUserId != '') {
          index = 2;
        } else {
          index = 4;
        }
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT:
        if (valueHolder!.loginUserId != null &&
            valueHolder!.loginUserId != '') {
          index = 2;
        } else {
          index = 4;
        }
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT:
        if (valueHolder!.loginUserId != null &&
            valueHolder!.loginUserId != '') {
          index = 2;
        } else {
          index = 4;
        }
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT:
        index = 2;
        break;
      // case PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT:
      case PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT:
        index = 2;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT:
        index = 2;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT:
        index = 2;
        break;
      // case PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT:
      case PsConst.REQUEST_CODE__DASHBOARD_NOTI_FRAGMENT:
        index = 3;
        break;
      //case PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT:
      case PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT:
        index = 4;
        break;
      default:
        index = 0;
        break;
    }
    return index;
  }

  dynamic getIndexFromBottonNavigationIndex(int param) {
    int index = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
    String title;
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    switch (param) {
      case 0:
        index = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
        title = Utils.getString(
            context, 'app_name'); //Utils.getString(context, 'app_name');
        break;
      case 1:
        // index = PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT;
        index = PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT;
        title = (psValueHolder.loginUserId == null ||
                psValueHolder.loginUserId == '')
            ? Utils.getString(context, 'home_login')
            : Utils.getString(context, 'dashboard__bottom_navigation_message');
        break;
      case 2:
        // index = PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT;
        // title = (psValueHolder.userIdToVerify == null ||
        //         psValueHolder.userIdToVerify == '')
        //     ? Utils.getString(context, 'home__bottom_app_bar_login')
        //     : Utils.getString(context, 'home__bottom_app_bar_verify_email');
        index = PsConst.REQUEST_CODE__DASHBOARD_ITEM_UPLOAD_FRAGMENT;
        title = Utils.getString(context, 'item_entry__listing_entry');
        break;
      case 3:
        // index = PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT;
        index = PsConst.REQUEST_CODE__DASHBOARD_NOTI_FRAGMENT;
        title = Utils.getString(context, 'noti_list__toolbar_name');
        break;
      case 4:
        // index = PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT;
        // title = Utils.getString(context, 'home__bottom_app_bar_search');
        // if (valueHolder!.loginUserId != null &&
        //             valueHolder!.loginUserId != '')
        index = PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT;
        title = (psValueHolder.loginUserId == null ||
                psValueHolder.loginUserId == '')
            ? Utils.getString(context, 'home_login')
            : Utils.getString(context, 'home__bottom_app_bar_login');
        break;

      default:
        index = 0;
        title = ''; //Utils.getString(context, 'app_name');
        break;
    }
    return <dynamic>[title, index];
  }

  CategoryRepository? categoryRepository;
  UserRepository? userRepository;
  AppInfoRepository? appInfoRepository;
  ProductRepository? productRepository;
  PsValueHolder? valueHolder;
  DeleteTaskRepository? deleteTaskRepository;
  DeleteTaskProvider? deleteTaskProvider;
  UserUnreadMessageProvider? userUnreadMessageProvider;
  UserUnreadMessageRepository? userUnreadMessageRepository;
  NotificationRepository? notificationRepository;
  late UserUnreadMessageParameterHolder userUnreadMessageHolder;

  ChatHistoryRepository? chatHistoryRepository;
  BuyerChatHistoryListProvider? buyerListProvider;
  SellerChatHistoryListProvider? sellerListProvider;
  PsValueHolder? psValueHolder;
  ChatHistoryParameterHolder? buyerHolder;
  ChatHistoryParameterHolder? sellerHolder;
  int? sellerCount;
  int? buyerCount;

  String appBarTitleName = '';
  void changeAppBarTitle(String categoryName) {
    appBarTitleName = categoryName;
  }

  @override
  Widget build(BuildContext context) {
    categoryRepository = Provider.of<CategoryRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    appInfoRepository = Provider.of<AppInfoRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    productRepository = Provider.of<ProductRepository>(context);
    deleteTaskRepository = Provider.of<DeleteTaskRepository>(context);
    userUnreadMessageRepository =
        Provider.of<UserUnreadMessageRepository>(context);
    notificationRepository = Provider.of<NotificationRepository>(context);

    psValueHolder = Provider.of<PsValueHolder>(context);
    chatHistoryRepository = Provider.of<ChatHistoryRepository>(context);

    // final dynamic data = EasyLocalizationProvider.of(context).data;

    timeDilation = 1.0;

    if (isFirstTime) {
      appBarTitle = Utils.getString(context, 'app_name');

      Utils.subscribeToTopic(valueHolder!.notiSetting ?? true);
      Utils.fcmConfigure(context, _fcm, valueHolder!.loginUserId, () {
        if (valueHolder!.loginUserId != null &&
            valueHolder!.loginUserId != '') {
          userUnreadMessageHolder = UserUnreadMessageParameterHolder(
              userId: valueHolder!.loginUserId,
              deviceToken: valueHolder!.deviceToken);
          userUnreadMessageProvider!
              .userUnreadMessageCount(userUnreadMessageHolder);

          if (_currentIndex ==
              PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT) {
            sellerHolder = ChatHistoryParameterHolder().getSellerHistoryList();
            sellerHolder!.getSellerHistoryList().userId =
                psValueHolder!.loginUserId;
            sellerListProvider!.resetShowProgress(false);
            sellerListProvider!.resetChatHistoryList(sellerHolder!);

            buyerHolder = ChatHistoryParameterHolder().getBuyerHistoryList();
            buyerHolder!.getBuyerHistoryList().userId =
                psValueHolder!.loginUserId;
            buyerListProvider!.resetShowProgress(false);
            buyerListProvider!.resetChatHistoryList(buyerHolder!);
          }
        }
      });
      isFirstTime = false;
    }

    Future<void> updateSelectedIndex(int index) async {
      setState(() {
        _currentIndex = index;
      });
    }

    dynamic callLogout(UserProvider provider,
        DeleteTaskProvider deleteTaskProvider, int index) async {
      appBarTitle = Utils.getString(context, 'app_name');
      updateSelectedIndex(index);
      await provider.replaceLoginUserId('');
      await provider.replaceLoginUserName('');
      await deleteTaskProvider.deleteTask();
      await FacebookAuth.instance.logOut();
      await GoogleSignIn().signOut();
      await fb_auth.FirebaseAuth.instance.signOut();
    }

    Future<bool> _onWillPop() {
      if (_currentIndex == PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT) {
        return showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ConfirmDialogView(
                  description:
                      Utils.getString(context, 'home__quit_dialog_description'),
                  leftButtonText: Utils.getString(context, 'dialog__cancel'),
                  rightButtonText: Utils.getString(context, 'dialog__ok'),
                  onAgreeTap: () {
                    SystemNavigator.pop();
                  });
            }).then((dynamic value) => value as bool);
      } else {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.home,
        );
        return Future<bool>.value(false);
      }
    }

    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    final ProductParameterHolder latestParameterHolder =
        ProductParameterHolder().getLatestParameterHolder();
    latestParameterHolder.mile = psValueHolder!.mile;
    final ProductParameterHolder recentParameterHolder =
        ProductParameterHolder().getRecentParameterHolder();
    recentParameterHolder.mile = psValueHolder!.mile;
    final ProductParameterHolder popularParameterHolder =
        ProductParameterHolder().getPopularParameterHolder();
    popularParameterHolder.mile = psValueHolder!.mile;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
          child: MultiProvider(
            providers: <SingleChildWidget>[
              ChangeNotifierProvider<UserProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    return UserProvider(
                        repo: userRepository, psValueHolder: valueHolder);
                  }),
              ChangeNotifierProvider<DeleteTaskProvider?>(
                  lazy: false,
                  create: (BuildContext context) {
                    deleteTaskProvider = DeleteTaskProvider(
                        repo: deleteTaskRepository, psValueHolder: valueHolder);
                    return deleteTaskProvider;
                  }),
            ],
            child: Consumer<UserProvider>(
              builder:
                  (BuildContext context, UserProvider provider, Widget? child) {
                print(provider.psValueHolder!.loginUserId);
                return ListView(padding: EdgeInsets.zero, children: <Widget>[
                  _DrawerHeaderWidget(),
                  ListTile(
                    title: Text('Buy and Sell Everything'),
                  ),
                  _DrawerMenuWidget(
                      icon: Icons.store,
                      title: Utils.getString(context, 'home__drawer_menu_home'),
                      index: PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.category,
                      title: Utils.getString(
                          context, 'home__drawer_menu_category'),
                      index: PsConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.schedule,
                      title: Utils.getString(
                          context, 'home__drawer_menu_latest_product'),
                      index: PsConst.REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.trending_up,
                      title: Utils.getString(
                          context, 'home__drawer_menu_popular_item'),
                      index:
                          PsConst.REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: FontAwesome.diamond, //FontAwesome5.gem,
                      title: Utils.getString(
                          context, 'home__drawer_menu_feature_item'),
                      index:
                          PsConst.REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  const Divider(
                    height: PsDimens.space1,
                  ),
                  ListTile(
                    title: Text(Utils.getString(
                        context, 'home__menu_drawer_user_info')),
                  ),
                  _DrawerMenuWidget(
                      icon: Icons.person,
                      title:
                          Utils.getString(context, 'home__menu_drawer_profile'),
                      index:
                          PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        title = (valueHolder == null ||
                                valueHolder!.userIdToVerify == null ||
                                valueHolder!.userIdToVerify == '')
                            ? Utils.getString(
                                context, 'home__menu_drawer_profile')
                            : Utils.getString(
                                context, 'home__bottom_app_bar_verify_email');
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  if (provider.psValueHolder!.loginUserId != null &&
                      provider.psValueHolder!.loginUserId != '')
                    Visibility(
                      visible: true,
                      child: _DrawerMenuWidget(
                          icon: Icons.favorite_border,
                          title: Utils.getString(
                              context, 'home__menu_drawer_favourite'),
                          index: PsConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT,
                          onTap: (String title, int index) {
                            Navigator.pop(context);
                            updateSelectedIndexWithAnimation(title, index);
                          }),
                    ),
                  // if (provider.psValueHolder!.loginUserId != null &&
                  //     provider.psValueHolder!.loginUserId != '')
                  //   Visibility(
                  //     visible: true,
                  //     child: _DrawerMenuWidget(
                  //       icon: Icons.swap_horiz,
                  //       title: Utils.getString(
                  //           context, 'home__menu_drawer_paid_ad_transaction'),
                  //       index: PsConst.REQUEST_CODE__MENU_TRANSACTION_FRAGMENT,
                  //       onTap: (String title, int index) {
                  //         Navigator.pop(context);
                  //         updateSelectedIndexWithAnimation(title, index);
                  //       },
                  //     ),
                  //   ),
                  // if (valueHolder!.isPaidApp == PsConst.ONE &&
                  //     provider.psValueHolder!.loginUserId != null &&
                  //     provider.psValueHolder!.loginUserId != '')
                  //   Visibility(
                  //     visible: true,
                  //     child: _DrawerMenuWidget(
                  //       icon: Icons.view_column,
                  //       title: Utils.getString(
                  //           context, 'profile__package_transaction_history'),
                  //       index: PsConst
                  //           .REQUEST_CODE__MENU_BUY_AD_TRANSACTION_FRAGMENT,
                  //       onTap: (String title, int index) {
                  //         Navigator.pop(context);
                  //         updateSelectedIndexWithAnimation(title, index);
                  //       },
                  //     ),
                  //   ),
                  // if (provider.psValueHolder!.loginUserId != null &&
                  //     provider.psValueHolder!.loginUserId != '')
                  //   Visibility(
                  //     visible: true,
                  //     child: _DrawerMenuWidget(
                  //         icon: Icons.book,
                  //         title: Utils.getString(
                  //             context, 'home__menu_drawer_user_history'),
                  //         index: PsConst
                  //             .REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT, //14
                  //         onTap: (String title, int index) {
                  //           Navigator.pop(context);
                  //           updateSelectedIndexWithAnimation(title, index);
                  //         }),
                  //   ),
                  if (provider.psValueHolder!.loginUserId != null &&
                      provider.psValueHolder!.loginUserId != '')
                    Visibility(
                      visible: true,
                      child: _DrawerMenuWidget(
                          icon: Icons.chat_bubble,
                          title: Utils.getString(
                              context, 'home__menu_drawer_user_offers'),
                          index: PsConst.REQUEST_CODE__MENU_OFFER_FRAGMENT,
                          onTap: (String title, int index) {
                            Navigator.pop(context);
                            updateSelectedIndexWithAnimation(title, index);
                          }),
                    ),
                  if (Utils.showUI(
                          provider.psValueHolder!.blockedFeatureDisabled) &&
                      provider.psValueHolder!.loginUserId != null &&
                      provider.psValueHolder!.loginUserId != '')
                    Visibility(
                      visible: true,
                      child: _DrawerMenuWidget(
                          icon: FontAwesome
                              .user_times, //SimpleLineIcons.user_unfollow,
                          title: Utils.getString(
                              context, 'home__menu_drawer_user_blocked'),
                          index:
                              PsConst.REQUEST_CODE__MENU_BLOCKED_USER_FRAGMENT,
                          onTap: (String title, int index) {
                            Navigator.pop(context);
                            updateSelectedIndexWithAnimation(title, index);
                          }),
                    ),
                  if (provider.psValueHolder!.loginUserId != null &&
                      provider.psValueHolder!.loginUserId != '')
                    Visibility(
                      visible: true,
                      child: _DrawerMenuWidget(
                          icon: FontAwesome5
                              .times, //MaterialCommunityIcons.playlist_remove,
                          title: Utils.getString(
                              context, 'home__menu_drawer_reported_item'),
                          index:
                              PsConst.REQUEST_CODE__MENU_REPORTED_ITEM_FRAGMENT,
                          onTap: (String title, int index) {
                            Navigator.pop(context);
                            updateSelectedIndexWithAnimation(title, index);
                          }),
                    ),
                  if (provider.psValueHolder!.loginUserId != null &&
                      provider.psValueHolder!.loginUserId != '')
                    Visibility(
                      visible: true,
                      child: ListTile(
                        leading: Icon(
                          Icons.power_settings_new,
                          color:
                              PsColors.labelLargeColor, //PsColors.primary500,
                        ),
                        title: Text(
                          Utils.getString(context, 'home__menu_drawer_logout'),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmDialogView(
                                    description: Utils.getString(context,
                                        'home__logout_dialog_description'),
                                    leftButtonText: Utils.getString(context,
                                        'home__logout_dialog_cancel_button'),
                                    rightButtonText: Utils.getString(context,
                                        'home__logout_dialog_ok_button'),
                                    onAgreeTap: () async {
                                      //hide dialog
                                      Navigator.of(context).pop();

                                      await PsProgressDialog.showDialog(
                                          context);

                                      final UserLogoutHolder userlogoutHolder =
                                          UserLogoutHolder(
                                              userId: provider
                                                  .psValueHolder!.loginUserId);
                                      final PsResource<ApiStatus> apiStatus =
                                          await provider.userLogout(
                                              userlogoutHolder.toMap());

                                      await userUnreadMessageProvider!
                                          .userDeleteUnreadMessageCount();

                                      PsProgressDialog.dismissDialog();

                                      if (apiStatus.data != null) {
                                        callLogout(
                                            provider,
                                            deleteTaskProvider!,
                                            PsConst
                                                .REQUEST_CODE__MENU_HOME_FRAGMENT);
                                      } else {
                                        callLogout(
                                            provider,
                                            deleteTaskProvider!,
                                            PsConst
                                                .REQUEST_CODE__MENU_HOME_FRAGMENT);
                                      }
                                    });
                              });
                        },
                      ),
                    ),
                  const Divider(
                    height: PsDimens.space1,
                  ),
                  ListTile(
                    title:
                        Text(Utils.getString(context, 'home__menu_drawer_app')),
                  ),
                  _DrawerMenuWidget(
                      icon: Icons.g_translate,
                      title: Utils.getString(
                          context, 'home__menu_drawer_language'),
                      index: PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation('', index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.contacts,
                      title: Utils.getString(
                          context, 'home__menu_drawer_contact_us'),
                      index: PsConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.settings,
                      title:
                          Utils.getString(context, 'home__menu_drawer_setting'),
                      index: PsConst.REQUEST_CODE__MENU_SETTING_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  // _DrawerMenuWidget(
                  //     icon: Icons.info_outline,
                  //     title: Utils.getString(
                  //         context, 'privacy_policy__toolbar_name'),
                  //     index: PsConst.REQUEST_CODE__MENU_PRIVACY_POLICY_FRAGMENT,
                  //     onTap: (String title, int index) {
                  //       Navigator.pop(context);
                  //       updateSelectedIndexWithAnimation(title, index);
                  //     }),
                  _DrawerMenuWidget(
                      icon: Icons.assignment,
                      title: Utils.getString(
                          context, 'terms_and_condition__toolbar_name'),
                      index: PsConst
                          .REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: FontAwesome.question_circle_o,
                      title: Utils.getString(context, 'setting__faq'),
                      index: PsConst.REQUEST_CODE__MENU_FAQ_PAGES_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  ListTile(
                    leading: Icon(
                      Icons.share,
                      color: PsColors.labelLargeColor, //PsColors.primary500,
                    ),
                    title: Text(
                      Utils.getString(
                          context, 'home__menu_drawer_share_this_app'),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ShareAppDialog(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                            );
                          });
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.star_border,
                      color: PsColors.labelLargeColor, //PsColors.primary500,
                    ),
                    title: Text(
                      Utils.getString(
                          context, 'home__menu_drawer_rate_this_app'),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      if (Platform.isIOS) {
                        Utils.launchAppStoreURL(
                            iOSAppId: psValueHolder!.iosAppStoreId,
                            writeReview: true);
                      } else {
                        Utils.launchURL();
                      }
                    },
                  )
                ]);
              },
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: (appBarTitle ==
                      Utils.getString(context, 'home__verify_email') ||
                  appBarTitle == Utils.getString(context, 'home_verify_phone'))
              ? Color(0xFFFF9505)
              : Color(0xFFFF9505),
          title: Text(
            appBarTitleName == '' ? appBarTitle! : appBarTitleName,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold, color: Colors.white
                // color: (appBarTitle ==
                //             Utils.getString(context, 'home__verify_email') ||
                //         appBarTitle ==
                //             Utils.getString(context, 'home_verify_phone'))
                //     ? PsColors.white
                //     : PsColors.primaryDarkWhite,
                ),
          ),
          titleSpacing: 0,
          elevation: 0,
          iconTheme: IconThemeData(
              color: (appBarTitle ==
                          Utils.getString(context, 'home__verify_email') ||
                      appBarTitle ==
                          Utils.getString(context, 'home_verify_phone'))
                  ? PsColors.white
                  : PsColors.white),
          titleTextStyle: TextStyle(
              color: PsColors.white,
              fontFamily: PsConfig.ps_default_font_family,
              fontWeight: FontWeight.bold,
              fontSize: 18),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
          ),
          actions: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //if (appBarTitle == '')
                // Padding(
                //   padding: const EdgeInsets.only(right: PsDimens.space40),
                //   child: Text(
                //     Utils.getString(context, 'app_name'),
                //     maxLines: 1,
                //     overflow: TextOverflow.ellipsis,
                //     style: Theme.of(context).textTheme.titleLarge!.copyWith(
                //         fontWeight: FontWeight.bold,
                //         color: PsColors.textPrimaryDarkColor),
                //     // style: Theme.of(context)
                //     //     .textTheme
                //     //     .titleLarge!
                //     //     .copyWith(color: PsColors.textPrimaryDarkColor),
                //   ),
                // ),
                IconButton(
                  icon: Icon(Iconic.book_open, color: PsColors.white
                      // Utils.isLightMode(context)
                      //     ? PsColors.primary500
                      //     : PsColors.primary300,
                      ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RoutePaths.blogList,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Iconic.location_inv, color: PsColors.white
                      // Utils.isLightMode(context)
                      //     ? PsColors.primary500
                      //     : PsColors.primary300,
                      ),
                  onPressed: () {
                    searchCityNameController.text = '';
                    searchTownshipNameController.text = '';
                    Navigator.pushNamed(
                      context,
                      RoutePaths.itemLocationList,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: _currentIndex ==
                    PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT ||
                _currentIndex ==
                    PsConst
                        .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
                _currentIndex ==
                    PsConst
                        .REQUEST_CODE__DASHBOARD_ITEM_UPLOAD_FRAGMENT || //go to profile
                _currentIndex ==
                    PsConst
                        .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT || //go to forgot password
                _currentIndex ==
                    PsConst
                        .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT || //go to register
                _currentIndex ==
                    PsConst
                        .REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT || //go to email verify
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_NOTI_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT
            ? Visibility(
                visible: true,
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: getBottonNavigationIndex(_currentIndex),
                  showUnselectedLabels: true,
                  backgroundColor: PsColors.backgroundColor,
                  selectedItemColor: PsColors.bottomNavigationSelectedColor,
                  elevation: 10,
                  onTap: (int index) {
                    final dynamic _returnValue =
                        getIndexFromBottonNavigationIndex(index);

                    updateSelectedIndexWithAnimation(
                        _returnValue[0], _returnValue[1]);
                  },
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: const Icon(
                        //MfgLabs.home,
                        Icons.home_outlined,
                        //  size: 20,
                      ),
                      label: Utils.getString(context, ''),
                    ),
                    BottomNavigationBarItem(
                      icon: Stack(
                        children: <Widget>[
                          Container(
                            width: PsDimens.space40,
                            margin: const EdgeInsets.only(
                                left: PsDimens.space8, right: PsDimens.space8),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.message_outlined,
                              ),
                            ),
                          ),
                          Positioned(
                            right: PsDimens.space4,
                            top: PsDimens.space1,
                            child: ChangeNotifierProvider<
                                    UserUnreadMessageProvider?>(
                                create: (BuildContext context) {
                              userUnreadMessageProvider =
                                  UserUnreadMessageProvider(
                                      repo: userUnreadMessageRepository);

                              if (valueHolder!.loginUserId != null &&
                                  valueHolder!.loginUserId != '') {
                                userUnreadMessageHolder =
                                    UserUnreadMessageParameterHolder(
                                        userId: valueHolder!.loginUserId,
                                        deviceToken: valueHolder!.deviceToken);
                                userUnreadMessageProvider!
                                    .userUnreadMessageCount(
                                        userUnreadMessageHolder);
                              }
                              return userUnreadMessageProvider;
                            }, child: Consumer<UserUnreadMessageProvider>(
                                    builder: (BuildContext context,
                                        UserUnreadMessageProvider
                                            userUnreadMessageProvider,
                                        Widget? child) {
                              if (userUnreadMessageProvider
                                      .userUnreadMessage.data !=
                                  null) {
                                sellerCount = int.parse(
                                    userUnreadMessageProvider.userUnreadMessage
                                        .data!.sellerUnreadCount!);
                                buyerCount = int.parse(userUnreadMessageProvider
                                    .userUnreadMessage.data!.buyerUnreadCount!);
                                userUnreadMessageProvider.totalUnreadCount =
                                    sellerCount! + buyerCount!;
                                if (userUnreadMessageProvider
                                        .totalUnreadCount ==
                                    0) {
                                  return Container();
                                } else {
                                  if (userUnreadMessageProvider
                                          .totalUnreadCount >
                                      0) {
                                    Future<dynamic>.delayed(Duration.zero,
                                        () => showMessageDialog(context));
                                  }
                                  return Container(
                                    width: PsDimens.space20,
                                    height: PsDimens.space20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: PsColors
                                          .labelLargeColor, //PsColors.primary500,
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        userUnreadMessageProvider
                                                    .totalUnreadCount >
                                                9
                                            ? '9+'
                                            : userUnreadMessageProvider
                                                .totalUnreadCount
                                                .toString(),
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: PsColors.textColor4),
                                        maxLines: 1,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return Container();
                              }
                            })),
                          ),
                        ],
                      ),
                      label: Utils.getString(context, ''),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(
                        FontAwesome.plus_squared,
                      ),
                      label: Utils.getString(context, ''),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.notifications_outlined),
                      label: Utils.getString(context, ''),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.person_outline),
                      label: Utils.getString(context, ''),
                    ),
                  ],
                ),
                // ],
                // ),
              )
            : null,
        floatingActionButton: _currentIndex ==
                    PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT ||
                _currentIndex ==
                    PsConst
                        .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_ITEM_UPLOAD_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_NOTI_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT
            ? Container(
                height: 65.0,
                width: 65.0,
                child: FittedBox(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: PsColors.primary500.withOpacity(0.3),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Container()),
                ),
              )
            : null,
        body: ChangeNotifierProvider<NotificationProvider>(
          lazy: false,
          create: (BuildContext context) {
            final NotificationProvider provider = NotificationProvider(
                repo: notificationRepository, psValueHolder: valueHolder);
            if (provider.psValueHolder!.deviceToken == null ||
                provider.psValueHolder!.deviceToken == '') {
              final FirebaseMessaging _fcm = FirebaseMessaging.instance;
              Utils.saveDeviceToken(_fcm, provider);
            } else {
              print(
                  'Notification Token is already registered. Notification Setting : true.');
            }
            return provider;
          },
          child: Builder(
            builder: (BuildContext context) {
              // if (_currentIndex ==
              //     PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT) {
              //   return CategoryListView();
              if (_currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT) {
                if (valueHolder!.loginUserId != null &&
                    valueHolder!.loginUserId != '') {
                  return MultiProvider(
                    providers: <SingleChildWidget>[
                      // ChangeNotifierProvider<UserUnreadMessageProvider>(
                      //   create: (BuildContext context) {
                      //       userUnreadMessageCountProvider =
                      //             UserUnreadMessageProvider(
                      //                 repo: userUnreadMessageRepository);

                      //         if (psValueHolder!.loginUserId != null &&
                      //             psValueHolder!.loginUserId != '') {
                      //           userUnreadMessageHolder =
                      //               UserUnreadMessageParameterHolder(
                      //                   userId: psValueHolder!.loginUserId,
                      //                   deviceToken: psValueHolder!.deviceToken);
                      //           userUnreadMessageProvider!
                      //               .userUnreadMessageCount(
                      //                   userUnreadMessageHolder);
                      //         }
                      //         return userUnreadMessageCountProvider!;
                      //   },
                      // )
                      //,
                      ChangeNotifierProvider<BuyerChatHistoryListProvider>(
                        create: (BuildContext context) {
                          buyerListProvider = BuyerChatHistoryListProvider(
                              repo: chatHistoryRepository);
                          buyerHolder = ChatHistoryParameterHolder()
                              .getBuyerHistoryList();
                          buyerHolder!.getBuyerHistoryList().userId =
                              psValueHolder!.loginUserId;
                          buyerListProvider!.resetShowProgress(true);
                          buyerListProvider!.loadChatHistoryList(buyerHolder!);
                          return buyerListProvider!;
                        },
                      ),
                      ChangeNotifierProvider<SellerChatHistoryListProvider>(
                        create: (BuildContext context) {
                          sellerListProvider = SellerChatHistoryListProvider(
                              repo: chatHistoryRepository);
                          sellerHolder = ChatHistoryParameterHolder()
                              .getSellerHistoryList();
                          sellerHolder!.getSellerHistoryList().userId =
                              psValueHolder!.loginUserId;
                          sellerListProvider!.resetShowProgress(true);
                          sellerListProvider!
                              .loadChatHistoryList(sellerHolder!);
                          return sellerListProvider!;
                        },
                      ),
                    ],
                    child: Consumer2<BuyerChatHistoryListProvider,
                        SellerChatHistoryListProvider>(
                      builder: (BuildContext context,
                          BuyerChatHistoryListProvider buyer,
                          SellerChatHistoryListProvider seller,
                          Widget? child) {
                        return ChatListView(
                            animationController: animationController,
                            sellerChatHistoryListProvider: seller,
                            buyerChatHistoryListProvider: buyer,
                            unreadMessageProvider: userUnreadMessageProvider);
                      },
                    ),
                  );
                } else {
                  return _CallLoginWidget(
                      currentIndex: _currentIndex,
                      animationController: animationController,
                      animation: animation,
                      updateCurrentIndex: (String title, int index) {
                        updateSelectedIndexWithAnimation(title, index);
                      },
                      updateUserCurrentIndex:
                          (String title, int index, String userId) {
                        setState(() {
                          appBarTitle = title;
                          _currentIndex = index;
                        });
                        _userId = userId;
                      });
                }
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                return MultiProvider(
                    providers: <SingleChildWidget>[
                      ChangeNotifierProvider<UserProvider>(
                          lazy: false,
                          create: (BuildContext context) {
                            return UserProvider(
                                repo: userRepository,
                                psValueHolder: valueHolder);
                          }),
                      ChangeNotifierProvider<DeleteTaskProvider?>(
                          lazy: false,
                          create: (BuildContext context) {
                            deleteTaskProvider = DeleteTaskProvider(
                                repo: deleteTaskRepository,
                                psValueHolder: valueHolder);
                            return deleteTaskProvider;
                          }),
                    ],
                    child: Consumer<UserProvider>(builder:
                        (BuildContext context, UserProvider provider,
                            Widget? child) {
                      if (provider.psValueHolder!.userIdToVerify == null ||
                          provider.psValueHolder!.userIdToVerify == '') {
                        if (provider.psValueHolder == null ||
                            provider.psValueHolder!.loginUserId == null ||
                            provider.psValueHolder!.loginUserId == '') {
                          return _CallLoginWidget(
                              currentIndex: _currentIndex,
                              animationController: animationController,
                              animation: animation,
                              updateCurrentIndex: (String title, int index) {
                                updateSelectedIndexWithAnimation(title, index);
                              },
                              updateUserCurrentIndex:
                                  (String title, int index, String userId) {
                                updateSelectedIndexWithAnimation(title, index);
                                _userId = userId;
                                provider.psValueHolder!.loginUserId = userId;
                              });
                        } else {
                          return ProfileView(
                            scaffoldKey: scaffoldKey,
                            animationController: animationController,
                            flag: _currentIndex,
                            callLogoutCallBack: (String userId) {
                              callLogout(provider, deleteTaskProvider!,
                                  PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT);
                            },
                          );
                        }
                      } else {
                        return _CallVerifyEmailWidget(
                            animationController: animationController,
                            animation: animation,
                            currentIndex: _currentIndex,
                            userId: _userId,
                            updateCurrentIndex: (String title, int index) {
                              updateSelectedIndexWithAnimation(title, index);
                            },
                            updateUserCurrentIndex:
                                (String title, int index, String userId) async {
                              _userId = userId;
                              provider.psValueHolder!.loginUserId = userId;
                              setState(() {
                                appBarTitle = title;
                                _currentIndex = index;
                              });
                            });
                      }
                    }));
              }
              // if (_currentIndex ==
              //     PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT) {
              //   // 2nd Way
              //   final ProductParameterHolder searchProductParameterHolder =
              //       ProductParameterHolder().getLatestParameterHolder();
              //   searchProductParameterHolder.itemLocationId =
              //       valueHolder!.locationId;
              //   searchProductParameterHolder.itemLocationName =
              //       valueHolder!.locactionName;
              //   if (valueHolder!.isSubLocation == PsConst.ONE) {
              //     searchProductParameterHolder.itemLocationTownshipId =
              //         valueHolder!.locationTownshipId;
              //     searchProductParameterHolder.itemLocationTownshipName =
              //         valueHolder!.locationTownshipName;
              //   }

              //   return CustomScrollView(
              //     scrollDirection: Axis.vertical,
              //     slivers: <Widget>[
              //       HomeItemSearchView(
              //           animationController: animationController,
              //           animation: animation,
              //           productParameterHolder: searchProductParameterHolder)
              //     ],
              //   );
              if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                return Stack(children: <Widget>[
                  Container(
                    color: PsColors.primary50,
                    width: double.infinity,
                    height: double.maxFinite,
                  ),
                  CustomScrollView(
                      scrollDirection: Axis.vertical,
                      slivers: <Widget>[
                        PhoneSignInView(
                            animationController: animationController,
                            goToLoginSelected: () {
                              animationController
                                  .reverse()
                                  .then<dynamic>((void data) {
                                if (!mounted) {
                                  return;
                                }
                                if (_currentIndex ==
                                    PsConst
                                        .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                  updateSelectedIndexWithAnimation(
                                      Utils.getString(context, 'home_login'),
                                      PsConst
                                          .REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                                }
                                if (_currentIndex ==
                                    PsConst
                                        .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                  updateSelectedIndexWithAnimation(
                                      Utils.getString(context, 'home_login'),
                                      PsConst
                                          .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                                }
                              });
                            },
                            phoneSignInSelected:
                                (String name, String phoneNo, String verifyId) {
                              phoneUserName = name;
                              phoneNumber = phoneNo;
                              phoneId = verifyId;
                              if (_currentIndex ==
                                  PsConst
                                      .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                updateSelectedIndexWithAnimation(
                                    Utils.getString(
                                        context, 'home_verify_phone'),
                                    PsConst
                                        .REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT);
                              }
                              if (_currentIndex ==
                                  PsConst
                                      .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                updateSelectedIndexWithAnimation(
                                    Utils.getString(
                                        context, 'home_verify_phone'),
                                    PsConst
                                        .REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT);
                              }
                            })
                      ])
                ]);
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
                return _CallVerifyPhoneWidget(
                    userName: phoneUserName,
                    phoneNumber: phoneNumber,
                    phoneId: phoneId,
                    animationController: animationController,
                    animation: animation,
                    currentIndex: _currentIndex,
                    updateCurrentIndex: (String title, int index) {
                      updateSelectedIndexWithAnimation(title, index);
                    },
                    updateUserCurrentIndex:
                        (String title, int index, String userId) async {
                      _userId = userId;
                      setState(() {
                        appBarTitle = title;
                        _currentIndex = index;
                      });
                    });
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT) {
                return ProfileView(
                  scaffoldKey: scaffoldKey,
                  animationController: animationController,
                  flag: _currentIndex,
                  userId: _userId,
                  callLogoutCallBack: (String userId) {
                    callLogout(provider!, deleteTaskProvider!,
                        PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT);
                  },
                );

                // } else if (_currentIndex ==
                //       PsConst.REQUEST_CODE__DASHBOARD_ITEM_UPLOAD_FRAGMENT ) {
                //   return ItemEntryView(
                //     animationController: animationController,
                //     flag: PsConst.ADD_NEW_ITEM,
                //     item: Product(),
                //     onItemUploaded: (String itemId) {
                //       _itemId = itemId;

                //       if(_itemId != null){
                //         updateSelectedIndexWithAnimation(
                //           Utils.getString(context, ''),
                //           PsConst
                //               .REQUEST_CODE__MENU_HOME_FRAGMENT);
                //         }
                //       }
                //     );
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT) {
                return CategoryListView();
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT) {
                return ProductListWithFilterView(
                  key: const Key('1'),
                  changeAppBarTitle: appBarTitleName,
                  animationController: animationController,
                  productParameterHolder: latestParameterHolder,
                );
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_DISCOUNT_PRODUCT_FRAGMENT) {
                return ProductListWithFilterView(
                  key: const Key('2'),
                  changeAppBarTitle: appBarTitleName,
                  animationController: animationController,
                  productParameterHolder: recentParameterHolder,
                );
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT) {
                return ProductListWithFilterView(
                  key: const Key('3'),
                  changeAppBarTitle: appBarTitleName,
                  animationController: animationController,
                  productParameterHolder: popularParameterHolder,
                );
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT) {
                return PaidAdProductListView(
                  key: const Key('4'),
                  animationController: animationController,
                );
              } else if (_currentIndex ==
                      PsConst
                          .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
                return Stack(children: <Widget>[
                  Container(
                    color: PsColors.baseColor,
                    width: double.infinity,
                    height: double.maxFinite,
                  ),
                  CustomScrollView(
                      scrollDirection: Axis.vertical,
                      slivers: <Widget>[
                        ForgotPasswordView(
                          animationController: animationController,
                          goToLoginSelected: () {
                            animationController
                                .reverse()
                                .then<dynamic>((void data) {
                              if (!mounted) {
                                return;
                              }
                              if (_currentIndex ==
                                  PsConst
                                      .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
                                updateSelectedIndexWithAnimation(
                                    Utils.getString(context, 'home_login'),
                                    PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                              }
                              if (_currentIndex ==
                                  PsConst
                                      .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT) {
                                updateSelectedIndexWithAnimation(
                                    Utils.getString(context, 'home_login'),
                                    PsConst
                                        .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                              }
                            });
                          },
                        )
                      ])
                ]);
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                return Stack(children: <Widget>[
                  Container(
                    color: PsColors.baseColor,
                    width: double.infinity,
                    height: double.maxFinite,
                  ),
                  CustomScrollView(
                      scrollDirection: Axis.vertical,
                      slivers: <Widget>[
                        RegisterView(
                            animationController: animationController,
                            onRegisterSelected: (User user) {
                              _userId = user.userId;
                              // widget.provider.psValueHolder.loginUserId = userId;
                              if (user.status == PsConst.ONE) {
                                updateSelectedIndexWithAnimationUserId(
                                    Utils.getString(
                                        context, 'home__menu_drawer_profile'),
                                    PsConst
                                        .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                                    user.userId);
                              } else {
                                if (_currentIndex ==
                                    PsConst
                                        .REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                                  updateSelectedIndexWithAnimation(
                                      Utils.getString(
                                          context, 'home__verify_email'),
                                      PsConst
                                          .REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT);
                                } else if (_currentIndex ==
                                    PsConst
                                        .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                                  updateSelectedIndexWithAnimation(
                                      Utils.getString(
                                          context, 'home__verify_email'),
                                      PsConst
                                          .REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT);
                                } else {
                                  updateSelectedIndexWithAnimationUserId(
                                      Utils.getString(
                                          context, 'home__menu_drawer_profile'),
                                      PsConst
                                          .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                                      user.userId);
                                }
                              }
                            },
                            goToLoginSelected: () {
                              animationController
                                  .reverse()
                                  .then<dynamic>((void data) {
                                if (!mounted) {
                                  return;
                                }
                                if (_currentIndex ==
                                    PsConst
                                        .REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                                  updateSelectedIndexWithAnimation(
                                      Utils.getString(context, 'home_login'),
                                      PsConst
                                          .REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                                }
                                if (_currentIndex ==
                                    PsConst
                                        .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                                  updateSelectedIndexWithAnimation(
                                      Utils.getString(context, 'home_login'),
                                      PsConst
                                          .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                                }
                              });
                            })
                      ])
                ]);
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
                return _CallVerifyEmailWidget(
                    animationController: animationController,
                    animation: animation,
                    currentIndex: _currentIndex,
                    userId: _userId,
                    updateCurrentIndex: (String title, int index) {
                      updateSelectedIndexWithAnimation(title, index);
                    },
                    updateUserCurrentIndex:
                        (String title, int index, String userId) async {
                      _userId = userId;
                      setState(() {
                        appBarTitle = title;
                        _currentIndex = index;
                      });
                    });
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_ITEM_UPLOAD_FRAGMENT) {
                if (valueHolder!.loginUserId != null &&
                    valueHolder!.loginUserId != '') {
                  return ItemEntryView(
                      animationController: animationController,
                      flag: PsConst.ADD_NEW_ITEM,
                      item: Product(),
                      maxImageCount: valueHolder!.maxImageCount,
                      onItemUploaded: (String itemId) {
                        _itemId = itemId;

                        if (_itemId != null) {
                          updateSelectedIndexWithAnimation(
                              Utils.getString(context, ''),
                              PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT);
                        }
                      });
                } else {
                  return _CallLoginWidget(
                      currentIndex: _currentIndex,
                      animationController: animationController,
                      animation: animation,
                      updateCurrentIndex: (String title, int index) {
                        updateSelectedIndexWithAnimation(title, index);
                      },
                      updateUserCurrentIndex:
                          (String title, int index, String userId) {
                        setState(() {
                          // if (index != null) {
                          appBarTitle = title;
                          _currentIndex = index;
                          //}
                        });
                        //if (userId != null) {
                        _userId = userId;
                        // }
                      });
                }
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                  _currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                return _CallLoginWidget(
                    currentIndex: _currentIndex,
                    animationController: animationController,
                    animation: animation,
                    updateCurrentIndex: (String title, int index) {
                      updateSelectedIndexWithAnimation(title, index);
                    },
                    updateUserCurrentIndex:
                        (String title, int index, String userId) {
                      setState(() {
                        appBarTitle = title;
                        _currentIndex = index;
                      });
                      _userId = userId;
                    });
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                return ChangeNotifierProvider<UserProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      final UserProvider provider = UserProvider(
                          repo: userRepository, psValueHolder: valueHolder);

                      return provider;
                    },
                    child: Consumer<UserProvider>(builder:
                        (BuildContext context, UserProvider provider,
                            Widget? child) {
                      if (provider.psValueHolder!.userIdToVerify == null ||
                          provider.psValueHolder!.userIdToVerify == '') {
                        if (provider.psValueHolder == null ||
                            provider.psValueHolder!.loginUserId == null ||
                            provider.psValueHolder!.loginUserId == '') {
                          return Stack(
                            children: <Widget>[
                              Container(
                                color: PsColors.baseColor,
                                width: double.infinity,
                                height: double.maxFinite,
                              ),
                              CustomScrollView(
                                  scrollDirection: Axis.vertical,
                                  slivers: <Widget>[
                                    LoginView(
                                      animationController: animationController,
                                      animation: animation,
                                      onGoogleSignInSelected: (String userId) {
                                        setState(() {
                                          _currentIndex = PsConst
                                              .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                        });
                                        _userId = userId;
                                        provider.psValueHolder!.loginUserId =
                                            userId;
                                      },
                                      onFbSignInSelected: (String userId) {
                                        setState(() {
                                          _currentIndex = PsConst
                                              .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                        });
                                        _userId = userId;
                                        provider.psValueHolder!.loginUserId =
                                            userId;
                                      },
                                      onPhoneSignInSelected: () {
                                        if (_currentIndex ==
                                            PsConst
                                                .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_phone_signin'),
                                              PsConst
                                                  .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                        } else if (_currentIndex ==
                                            PsConst
                                                .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_phone_signin'),
                                              PsConst
                                                  .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                        } else if (_currentIndex ==
                                            PsConst
                                                .REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_phone_signin'),
                                              PsConst
                                                  .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                        } else if (_currentIndex ==
                                            PsConst
                                                .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_phone_signin'),
                                              PsConst
                                                  .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                        } else {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_phone_signin'),
                                              PsConst
                                                  .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                        }
                                      },
                                      onProfileSelected: (String userId) {
                                        setState(() {
                                          _currentIndex = PsConst
                                              .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                          _userId = userId;
                                          provider.psValueHolder!.loginUserId =
                                              userId;
                                        });
                                      },
                                      onForgotPasswordSelected: () {
                                        setState(() {
                                          _currentIndex = PsConst
                                              .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT;
                                          appBarTitle = Utils.getString(
                                              context, 'home__forgot_password');
                                        });
                                      },
                                      onSignInSelected: () {
                                        updateSelectedIndexWithAnimation(
                                            Utils.getString(
                                                context, 'home__register'),
                                            PsConst
                                                .REQUEST_CODE__MENU_REGISTER_FRAGMENT);
                                      },
                                    ),
                                  ])
                            ],
                          );
                        } else {
                          return ProfileView(
                            scaffoldKey: scaffoldKey,
                            animationController: animationController,
                            flag: _currentIndex,
                            callLogoutCallBack: (String userId) {
                              callLogout(provider, deleteTaskProvider!,
                                  PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT);
                            },
                          );
                        }
                      } else {
                        return _CallVerifyEmailWidget(
                            animationController: animationController,
                            animation: animation,
                            currentIndex: _currentIndex,
                            userId: _userId,
                            updateCurrentIndex: (String title, int index) {
                              updateSelectedIndexWithAnimation(title, index);
                            },
                            updateUserCurrentIndex:
                                (String title, int index, String userId) async {
                              _userId = userId;
                              provider.psValueHolder!.loginUserId = userId;
                              setState(() {
                                appBarTitle = title;
                                _currentIndex = index;
                              });
                            });
                      }
                    }));
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT) {
                return FavouriteProductListView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_TRANSACTION_FRAGMENT) {
                return PaidAdItemListView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_BUY_AD_TRANSACTION_FRAGMENT) {
                return BuyAdTransactionListView();
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT) {
                return HistoryListView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_OFFER_FRAGMENT) {
                return OfferListView(animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_BLOCKED_USER_FRAGMENT) {
                return BlockedUserListView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_REPORTED_ITEM_FRAGMENT) {
                return ReportedItemListView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT) {
                return LanguageSettingView(
                  animationController: animationController,
                );
                // animationController: animationController,
                // languageIsChanged: () {
                //   // _currentIndex = PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT;
                //   // appBarTitle = Utils.getString(
                //   //     context, 'home__menu_drawer_language');

                //   //updateSelectedIndexWithAnimation(
                //   //  '', PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT);
                //   // setState(() {});
                // });
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT) {
                return ContactUsView(animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_SETTING_FRAGMENT) {
                return Container(
                  color: PsColors.baseColor,
                  height: double.infinity,
                  child: SettingView(
                    animationController: animationController,
                  ),
                );
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_PRIVACY_POLICY_FRAGMENT) {
                return MenuPrivacyPolicyView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT) {
                return MenuTermsAndConditionView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_FAQ_PAGES_FRAGMENT) {
                return MenuFAQView(animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_NOTI_FRAGMENT) {
                return NotiListView();
                // } else if (_currentIndex ==
                //     PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT) {
                //   if (valueHolder!.loginUserId != null &&
                //       valueHolder!.loginUserId != '') {
                //     return ChatListView(
                //       animationController: animationController,
                //     );
                //   } else {
                //     return _CallLoginWidget(
                //         currentIndex: _currentIndex,
                //         animationController: animationController,
                //         animation: animation,
                //         updateCurrentIndex: (String title, int index) {
                //           updateSelectedIndexWithAnimation(title, index);
                //         },
                //         updateUserCurrentIndex:
                //             (String title, int index, String userId) {
                //           setState(() {
                //             appBarTitle = title;
                //             _currentIndex = index;
                //           });
                //           _userId = userId;
                //         });
                //   }
              } else {
                animationController.forward();
                return HomeDashboardViewWidget(
                  _scrollController,
                  animationController,
                  animationControllerForFab,
                  context,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _CallLoginWidget extends StatelessWidget {
  const _CallLoginWidget(
      {required this.animationController,
      required this.animation,
      required this.updateCurrentIndex,
      required this.updateUserCurrentIndex,
      required this.currentIndex});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final AnimationController? animationController;
  final Animation<double> animation;
  final int? currentIndex;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: PsColors.baseColor,
          width: double.infinity,
          height: double.maxFinite,
        ),
        CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
          LoginView(
            animationController: animationController,
            animation: animation,
            onGoogleSignInSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onFbSignInSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onPhoneSignInSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              } else if (currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              } else if (currentIndex ==
                  PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              } else if (currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              } else {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              }
            },
            onProfileSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onForgotPasswordSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home__forgot_password'),
                    PsConst.REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT);
              } else {
                updateCurrentIndex(
                    Utils.getString(context, 'home__forgot_password'),
                    PsConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT);
              }
            },
            onSignInSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(Utils.getString(context, 'home__register'),
                    PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
              } else {
                updateCurrentIndex(Utils.getString(context, 'home__register'),
                    PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
              }
            },
          ),
        ])
      ],
    );
  }
}

class _CallVerifyPhoneWidget extends StatelessWidget {
  const _CallVerifyPhoneWidget(
      {this.userName,
      this.phoneNumber,
      this.phoneId,
      required this.updateCurrentIndex,
      required this.updateUserCurrentIndex,
      required this.animationController,
      required this.animation,
      required this.currentIndex});

  final String? userName;
  final String? phoneNumber;
  final String? phoneId;
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final int? currentIndex;
  final AnimationController? animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyPhoneView(
          userName: userName,
          phoneNumber: phoneNumber,
          phoneId: phoneId,
          animationController: animationController,
          onProfileSelected: (String userId) {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else {
              //PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
            }
          },
          onSignInSelected: () {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            }
          },
        ));
  }
}

class _CallVerifyEmailWidget extends StatelessWidget {
  const _CallVerifyEmailWidget(
      {required this.updateCurrentIndex,
      required this.updateUserCurrentIndex,
      required this.animationController,
      required this.animation,
      required this.currentIndex,
      required this.userId});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final int? currentIndex;
  final AnimationController? animationController;
  final Animation<double> animation;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyEmailView(
          animationController: animationController,
          userId: userId,
          onProfileSelected: (String userId) {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else {
              //PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
            }
          },
          onSignInSelected: () {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            }
          },
        ));
  }
}

class _DrawerMenuWidget extends StatefulWidget {
  const _DrawerMenuWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function onTap;
  final int index;

  @override
  __DrawerMenuWidgetState createState() => __DrawerMenuWidgetState();
}

class __DrawerMenuWidgetState extends State<_DrawerMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(widget.icon,
            color: PsColors.labelLargeColor), //PsColors.primary500),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        onTap: () {
          widget.onTap(widget.title, widget.index);
        });
  }
}

class _DrawerHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/flutter_buy_and_sell_logo.png',
            width: 135,
            height: 135,
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Utils.isLightMode(context)
              ? PsColors.primary500
              : Colors.black12),
    );
  }
}
