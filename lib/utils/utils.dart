import 'dart:io';
import 'package:camera/camera.dart';
// import 'package:connectivity_plus/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
// import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/db/common/ps_shared_preferences.dart';
import 'package:flutterbuyandsell/provider/common/notification_provider.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/dialog/chat_noti_dialog.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/chat_history_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/noti_register_holder.dart';
import 'package:flutterbuyandsell/viewobject/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:launch_review/launch_review.dart';
// import 'package:launch_review/launch_review.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';
import '../ui/common/dialog/noti_dialog.dart';

mixin Utils {
  static bool isReachChatView = false;
  static bool isNotiFromToolbar = false;

  static List<CameraDescription> cameras = <CameraDescription>[];

  static String getString(BuildContext context, String? key) {
    if (key != '') {
      return tr(key!);
    } else {
      return '';
    }
  }

  static bool checkIsChatView() {
    return isReachChatView;
  }

  static bool isShowNotiFromToolbar() {
    return isNotiFromToolbar;
  }

  static bool? checkEmailFormat(String email) {
    bool? emailFormat;
    if (email != '') {
      emailFormat = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
    }
    return emailFormat;
  }

  static DateTime? previous;
  static void psPrint(String? msg) {
    final DateTime now = DateTime.now();
    int min = 0;
    if (previous == null) {
      previous = now;
    } else {
      min = now.difference(previous!).inMilliseconds;
      previous = now;
    }

    print('$now ($min)- $msg');
  }

  static String getPriceFormat(String price, String priceFormat) {
    return NumberFormat(priceFormat)
        .format(double.parse(price != '' ? price : '0'));
  }

  static String getChatPriceFormat(String message, String priceFormat) {
    String currencySymbol, price;
    try {
      currencySymbol = message.split(' ')[0];
      price = getPriceFormat(message.split(' ')[1], priceFormat);
      return '$currencySymbol  $price';
    } catch (e) {
      return message;
    }
  }

  static String splitMessage(String message) {
    try {
      return message.split(' ')[1];
    } catch (e) {
      return message;
    }
  }

  static String getPriceTwoDecimal(String price) {
    return PsConst.priceTwoDecimalFormat.format(double.parse(price));
  }

  static bool isLightMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }

  static Map<String, String> getTimeStamp() {
    // DateTime.now().microsecond;
    return ServerValue.timestamp;
  }

  // static dynamic getAdAppId() {
  //   if (Platform.isIOS) {
  //     return PsConfig.iosAdMobAdsIdKey;
  //   } else {
  //     return PsConfig.androidAdMobAdsIdKey;
  //   }
  // }

  static dynamic getBannerAdUnitId() {
    if (Platform.isIOS) {
      return PsConfig.iosAdMobBannerAdUnitId;
    } else {
      return PsConfig.androidAdMobBannerAdUnitId;
    }
  }

  static dynamic getNativeAdUnitId() {
    if (Platform.isIOS) {
      return PsConfig.iosAdMobNativeAdUnitId;
    } else {
      return PsConfig.androidAdMobNativeAdUnitId;
    }
  }

  static dynamic getInterstitialUnitId() {
    if (Platform.isIOS) {
      return PsConfig.iosAdMobInterstitialAdUnitId;
    } else {
      return PsConfig.androidAdMobInterstitialAdUnitId;
    }
  }

  static int getTimeStampDividedByOneThousand(DateTime dateTime) {
    final double dividedByOneThousand = dateTime.millisecondsSinceEpoch / 1000;
    final int doubleToInt = dividedByOneThousand.round();
    return doubleToInt;
  }

  static DateTime getDateOnlyFromTimeStamp(int timeStamp) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en_US');
    final DateTime datetimeMessage =
        DateTime.fromMillisecondsSinceEpoch(timeStamp, isUtc: true);
    final String s = formatter.format(datetimeMessage);
    return DateTime.parse(s);
  }

  static String convertTimeStampToDate(int? timeStamp) {
    if (timeStamp == null) {
      return '';
    }
    final DateTime dateTime2 =
        DateTime.fromMillisecondsSinceEpoch(timeStamp, isUtc: true);
    final DateTime dateTime = dateTime2.toLocal();
    final DateFormat format = DateFormat.yMMMMd(); //"6:00 AM"
    return format.format(dateTime);
  }

  static String convertTimeStampToTime(int? timeStamp) {
    if (timeStamp == null) {
      return '';
    }

    final DateTime dateTime2 =
        DateTime.fromMillisecondsSinceEpoch(timeStamp, isUtc: true);
    final DateTime dateTime = dateTime2.toLocal();
    final DateFormat format = DateFormat.jm(); //"6:00 AM"
    return format.format(dateTime);
  }

  static String getTimeString() {
    final DateTime dateTime = DateTime.now();
    final DateFormat format = DateFormat.Hms();
    return format.format(dateTime);
  }

  static String getDateFormat(String? dateTime, String dateFormat) {
    final DateTime date = DateTime.parse(dateTime!);
    return DateFormat(dateFormat).format(date);
  }

  static String changeTimeStampToStandardDateTimeFormat(String? timeStamp) {
    if (timeStamp == null || timeStamp == '') {
      return '';
    } else {
      final String standardDateTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp) * 1000)
              .toString();
      return changeDateTimeStandardFormat(standardDateTime);
    }
  }

  static String changeDateTimeStandardFormat(String selectedDateTime) {
    // if (selectedDateTime == null) {
    //   return '';
    // }
    final String standardDateTime =
        selectedDateTime.split(' ')[0].split('-')[2] +
            '-' +
            selectedDateTime.split(' ')[0].split('-')[1] +
            '-' +
            selectedDateTime.split(' ')[0].split('-')[0] +
            ' ' +
            selectedDateTime.split(' ')[1].split('.')[0];
    return standardDateTime;
  }

  static Brightness getBrightnessForAppBar(BuildContext context) {
    return Brightness.dark;
    // if (Platform.isAndroid) {
    //   return  isLightMode(context) ? Brightness.dark :Brightness.light;
    // } else {
    //   return Theme.of(context).brightness;
    // }
  }

  static Future<File?> getImageFileFromCameraImagePath(
      String? imagePath, int imageAize) async {
    final int imageWidth = imageAize;
    final bool status = await Utils.requestWritePermission();

    // bool status =await Utils.requestWritePermission().then((bool status) async {
    if (status) {
      // final ImageProperties properties =
      //     await FlutterNativeImage.getImageProperties(imagePath!);
      // final File compressedFile = await FlutterNativeImage.compressImage(
      //     imagePath,
      //     quality: 80,
      //     targetWidth: imageWidth,
      //     targetHeight:
      //         (properties.height! * imageWidth / properties.width!).round());
      // return compressedFile;
    } else {
      // Toast
      // We don't have permission to read/write images.
      Fluttertoast.showToast(
          msg: 'We don\'t have permission to read/write images.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white);
      return null;
    }

    // });
    // return null;
  }

  static String convertColorToString(Color? color) {
    String convertedColorString = '';

    String colorString = color.toString().toUpperCase();

    colorString = colorString.replaceAll(')', '');

    convertedColorString = colorString.substring(colorString.length - 6);

    return '#' + convertedColorString;
  }

  static Future<bool> requestWritePermission() async {
    // final Map<Permission, PermissionStatus> permissionss =
    //     await PermissionHandler()
    //         .requestPermissions(<Permission>[Permission.storage]);
    // if (permissionss != null &&
    //     permissionss.isNotEmpty &&
    //     permissionss[Permission.storage] == PermissionStatus.granted) {
    // ignore: prefer_const_declarations
    final Permission _storage = Permission.storage;
    final PermissionStatus permissionss = await _storage.request();

    if (permissionss == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> checkInternetConnectivity() async {
    // final ConnectivityResult connectivityResult =
    //     await Connectivity().checkConnectivity();
    // if (connectivityResult == ConnectivityResult.mobile) {
    //   // print('Mobile');
    //   return true;
    // } else if (connectivityResult == ConnectivityResult.wifi) {
    //   // print('Wifi');
    //   return true;
    // } else if (connectivityResult == ConnectivityResult.none) {
    //   print('No Connection');
    //   return false;
    // } else {
    //   return false;
    // }
    return false;
  }

  static dynamic launchURL() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo.packageName);
    final Uri url = Uri.parse(
        'https://play.google.com/store/apps/details?id=${packageInfo.packageName}');
    // 'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static dynamic launchAppStoreURL(
      {String? iOSAppId, bool writeReview = false}) async {
    //LaunchReview.launch(writeReview: writeReview, iOSAppId: iOSAppId);
  }

  static dynamic navigateOnUserVerificationView(
      dynamic provider, BuildContext context, Function onLoginSuccess) async {
    provider.psValueHolder = Provider.of<PsValueHolder>(context, listen: false);

    if (provider == null ||
        provider.psValueHolder.userIdToVerify == null ||
        provider.psValueHolder.userIdToVerify == '') {
      if (provider == null ||
          provider.psValueHolder == null ||
          provider.psValueHolder.loginUserId == null ||
          provider.psValueHolder.loginUserId == '') {
        final dynamic returnData = await Navigator.pushNamed(
          context,
          RoutePaths.login_container,
        );

        if (returnData != null && returnData is User) {
          final User user = returnData;
          provider.psValueHolder =
              Provider.of<PsValueHolder>(context, listen: false);
          provider.psValueHolder.loginUserId = user.userId;
        }
      } else {
        onLoginSuccess();
      }
    } else {
      Navigator.pushNamed(context, RoutePaths.user_verify_email_container,
          arguments: provider.psValueHolder.userIdToVerify);
    }
  }

  static Future<File?> getImageFileFromAssets(
      XFile asset, int imageSize) async {
    final int imageWidth = imageSize;

    // استخدام readAsBytes بدلاً من getByteData
    final Uint8List bytes = await asset.readAsBytes();

    final bool status = await requestWritePermission();

    if (status) {
      final Directory _appTempDir = await getTemporaryDirectory();
      final Directory _appTempDirFolder =
          Directory('${_appTempDir.path}/${PsConfig.tmpImageFolderName}');

      if (!_appTempDirFolder.existsSync()) {
        await _appTempDirFolder.create(recursive: true);
      }
      final File file = File('${_appTempDirFolder.path}/${asset.name}');
      await file.writeAsBytes(bytes);

      return file; // إرجاع الملف
    } else {
      Fluttertoast.showToast(
          msg: 'We don\'t have permission to read/write images.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white);
      return null;
    }
  }

  static String sortingUserId(String loginUserId, String itemAddedUserId) {
    if (loginUserId.compareTo(itemAddedUserId) == 1) {
      return '${itemAddedUserId}_$loginUserId';
    } else if (loginUserId.compareTo(itemAddedUserId) == -1) {
      return '${loginUserId}_$itemAddedUserId';
    } else {
      return '${loginUserId}_$itemAddedUserId';
    }
  }

  static String? checkUserLoginId(PsValueHolder psValueHolder) {
    if (psValueHolder.loginUserId == null || psValueHolder.loginUserId == '') {
      return 'nologinuser';
    } else {
      return psValueHolder.loginUserId;
    }
  }

  static Widget flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

  static int isAppleSignInAvailable = 0;
  static Future<void> checkAppleSignInAvailable() async {
    final bool _isAvailable = await TheAppleSignIn.isAvailable();

    isAppleSignInAvailable = _isAvailable ? 1 : 2;
  }

  static void subscribeToTopic(bool isEnable) {
    if (isEnable) {
      if (Platform.isIOS) {
        FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
      }

      FirebaseMessaging.instance.subscribeToTopic('broadcast');
    }
  }

  static Future<void> saveDeviceToken(
      FirebaseMessaging _fcm, NotificationProvider notificationProvider) async {
    // Get the token for this device
    final String? fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      await notificationProvider.replaceNotiToken(fcmToken);

      final NotiRegisterParameterHolder notiRegisterParameterHolder =
          NotiRegisterParameterHolder(
              platformName: PsConst.PLATFORM,
              deviceId: fcmToken,
              loginUserId:
                  checkUserLoginId(notificationProvider.psValueHolder!));
      print('Token Key $fcmToken');

      await notificationProvider
          .rawRegisterNotiToken(notiRegisterParameterHolder.toMap());
    }
    // return true;
  }

  static Future<void> _onSelectBroadCastNotification(
      BuildContext context, String? payload) async {
    showDialog<dynamic>(
        context: context,
        builder: (_) {
          return ChatNotiDialog(
              description: '$payload',
              leftButtonText: Utils.getString(context, 'chat_noti__cancel'),
              rightButtonText: Utils.getString(context, 'chat_noti__open'),
              onAgreeTap: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.notiList,
                );
              });
        });
  }

  //   static Future<void> _onSelectSubscribeBroadCastNotification(
  //     BuildContext context, String? payload, String? itemId) async {
  //   showDialog<dynamic>(
  //       context: context,
  //       builder: (_) {
  //         return ChatNotiDialog(
  //             description: '$payload',
  //             leftButtonText: Utils.getString(context, 'chat_noti__cancel'),
  //             rightButtonText: Utils.getString(context, 'chat_noti__open'),
  //             onAgreeTap: () {
  //               // Navigator.pushNamed(
  //               //   context,
  //               //   RoutePaths.notiList,
  //               // );
  //             });
  //       });
  // }

  static void subscribeToModelTopics(List<String?> subcatList) {
    if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true);
    }

    for (String? subCat in subcatList) {
      FirebaseMessaging.instance.subscribeToTopic(subCat ?? '');
    }
  }

  static void unSubsribeFromModelTopics(List<String?> subcatList) {
    for (String? subCat in subcatList) {
      FirebaseMessaging.instance.unsubscribeFromTopic(subCat ?? '');
    }
  }

  static Future<void> _onSelectReviewNotification(
      BuildContext context, String payload, String? userId) async {
    showDialog<dynamic>(
        context: context,
        builder: (_) {
          return ChatNotiDialog(
              description: '$payload',
              leftButtonText: Utils.getString(context, 'chat_noti__cancel'),
              rightButtonText: Utils.getString(context, 'chat_noti__open'),
              onAgreeTap: () {
                Navigator.pushNamed(context, RoutePaths.ratingList,
                    arguments: userId);
              });
        });
  }

  static Future<void> _onSelectApprovalNotification(
      BuildContext context, String? payload) async {
    showDialog<dynamic>(
        context: context,
        builder: (_) {
          return NotiDialog(message: '$payload');
        });
  }

  // static void subscribeToTopic(bool isEnable) {
  //   if (isEnable) {
  //     final FirebaseMessaging _fcm = FirebaseMessaging();
  //     if (Platform.isIOS) {
  //       _fcm.requestNotificationPermissions(const IosNotificationSettings());
  //     }
  //     _fcm.subscribeToTopic('broadcast');
  //   }
  // }

  static void fcmConfigure(BuildContext context, FirebaseMessaging _fcm,
      String? loginUserId, Function onMessageReceived) {
    // final FirebaseMessaging _fcm = FirebaseMessaging();
    if (Platform.isIOS) {
      // _fcm.requestNotificationPermissions(const IosNotificationSettings());
      _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
    // On Init
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? event) async {
      if (event != null) {
        final Map<String, dynamic> message = event.data;
        print('onMessage: $message');
        print(event);

        final String notiMessage = _parseNotiMessage(message)!;

        Utils.takeDataFromNoti(context, message, loginUserId);

        await PsSharedPreferences.instance.replaceNotiMessage(
          notiMessage,
        );
      }
      onMessageReceived();
    });
    // On Open
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      final Map<String, dynamic> message = event.data;
      print('onMessage: $message');
      print(event);

      final String notiMessage = _parseNotiMessage(message)!;

      Utils.takeDataFromNoti(context, message, loginUserId);

      await PsSharedPreferences.instance.replaceNotiMessage(
        notiMessage,
      );
      onMessageReceived();
    });
    // OnLaunch, OnResume
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) async {
      final Map<String, dynamic> message = event.data;
      print('onMessage: $message');
      print(event);

      final String notiMessage = _parseNotiMessage(message)!;

      Utils.takeDataFromNoti(context, message, loginUserId);

      await PsSharedPreferences.instance.replaceNotiMessage(
        notiMessage,
      );
      onMessageReceived();
    });
    // Background
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    //
    //   _fcm.configure(
    //     onMessage: (Map<String, dynamic> message) async {
    //       print('onMessage: $message');

    //       final String notiMessage = _parseNotiMessage(message);

    //       Utils.takeDataFromNoti(context, message, loginUserId);

    //       await PsSharedPreferences.instance.replaceNotiMessage(
    //         notiMessage,
    //       );
    //     },
    //     onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    //     onLaunch: (Map<String, dynamic> message) async {
    //       print('onLaunch: $message');

    //       final String notiMessage = _parseNotiMessage(message);

    //       Utils.takeDataFromNoti(context, message, loginUserId);

    //       await PsSharedPreferences.instance.replaceNotiMessage(
    //         notiMessage,
    //       );
    //     },
    //     onResume: (Map<String, dynamic> message) async {
    //       print('onResume: $message');

    //       final String notiMessage = _parseNotiMessage(message);

    //       Utils.takeDataFromNoti(context, message, loginUserId);

    //       await PsSharedPreferences.instance.replaceNotiMessage(
    //         notiMessage,
    //       );
    //     },
    //   );
  }

  static Future<dynamic> myBackgroundMessageHandler(RemoteMessage event) async {
    final Map<String, dynamic> message = event.data;
    await Firebase.initializeApp();

    print('onBackgroundMessage: $message');
    final String notiMessage = _parseNotiMessage(message)!;

    // Utils.takeDataFromNoti(context, message, loginUserId);

    await PsSharedPreferences.instance.replaceNotiMessage(
      notiMessage,
    );
  }

  static String? _parseNotiMessage(Map<String, dynamic> message) {
    final dynamic data = message['notification'] ?? message;
    String notiMessage = '';
    if (Platform.isAndroid) {
      notiMessage = data['message'];
    } else if (Platform.isIOS) {
      notiMessage = data['body'];
      notiMessage = data['message'];
    }
    return notiMessage;
  }

  // static Future<void> saveDeviceToken(
  //     FirebaseMessaging _fcm, NotificationProvider notificationProvider) async {
  //   // Get the token for this device
  //   final String fcmToken = await _fcm.getToken();
  //   await notificationProvider.replaceNotiToken(fcmToken);

  //   final NotiRegisterParameterHolder notiRegisterParameterHolder =
  //       NotiRegisterParameterHolder(
  //           platformName: PsConst.PLATFORM,
  //           deviceId: fcmToken,
  //           loginUserId:
  //               Utils.checkUserLoginId(notificationProvider.psValueHolder));
  //   print('Token Key $fcmToken');
  //   if (fcmToken != null) {
  //     await notificationProvider
  //         .rawRegisterNotiToken(notiRegisterParameterHolder.toMap());
  //   }
  //   return true;
  // }

  static dynamic takeDataFromNoti(
      BuildContext context, Map<String, dynamic> message, String? loginUserId) {
    final UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    final UserProvider userProvider =
        UserProvider(repo: userRepository, psValueHolder: psValueHolder);

    final dynamic data = message['notification'] ?? message;
    if (Platform.isAndroid) {
      // final String flag = message['data']['flag']; //backend flag
      // final String notiMessage = message['data']['message'];
      final String? flag = message['flag']; //backend flag
      final String? notiMessage = message['message'];

      if (flag == 'broadcast') {
        _onSelectBroadCastNotification(context, notiMessage);
      } else if (flag == 'sub_cat_id') {
        _onSelectBroadCastNotification(context, notiMessage);
      } else if (flag == 'approval') {
        _onSelectApprovalNotification(context, notiMessage);
      } else if (flag == 'chat') {
        isNotiFromToolbar = true;
        // final String sellerId = message['data']['seller_id'];
        // final String buyerId = message['data']['buyer_id'];
        // final String senderName = message['data']['sender_name'];
        // final String senderProflePhoto = message['data']['sender_profle_photo'];
        // final String itemId = message['data']['item_id'];
        // final String action = message['data']['action'];

        final String? sellerId = message['seller_id'];
        final String? buyerId = message['buyer_id'];
        final String? senderName = message['sender_name'];
        final String? senderProflePhoto = message['sender_profle_photo'];
        final String? itemId = message['item_id'];
        final String? action = message['action'];

        if (userProvider.psValueHolder!.loginUserId != null &&
            userProvider.psValueHolder!.loginUserId != '' &&
            !isReachChatView) {
          _showChatNotification(context, notiMessage, sellerId, buyerId,
              senderName, senderProflePhoto, itemId, action, loginUserId);
        }
      } else if (flag == 'review') {
        // final String rating = message['data']['rating'];
        final String rating = message['rating'];
        final String ratingMessage =
            Utils.getString(context, 'noti_message__text1') +
                rating.split('.')[0] +
                Utils.getString(context, 'noti_message__text2') +
                '\n"' +
                notiMessage! +
                '"';
        _onSelectReviewNotification(
            context, ratingMessage, userProvider.psValueHolder!.loginUserId);
      } else {
        _onSelectApprovalNotification(context, notiMessage);
      }
    } else if (Platform.isIOS) {
      final String? flag = data['flag'];
      String? notiMessage = data['body'];
      notiMessage ??= data['message'];
      notiMessage ??= '';

      if (flag == 'broadcast') {
        _onSelectBroadCastNotification(context, notiMessage);
      } else if (flag == 'approval') {
        _onSelectApprovalNotification(context, notiMessage);
      } else if (flag == 'chat') {
        isNotiFromToolbar = true;
        final String? sellerId = data['seller_id'];
        final String? buyerId = data['buyer_id'];
        final String? senderName = data['sender_name'];
        final String? senderProflePhoto = data['sender_profle_photo'];
        final String? itemId = data['item_id'];
        final String? action = data['action'];

        if (userProvider.psValueHolder!.loginUserId != null &&
            userProvider.psValueHolder!.loginUserId != '' &&
            !isReachChatView) {
          _showChatNotification(context, notiMessage, sellerId, buyerId,
              senderName, senderProflePhoto, itemId, action, loginUserId);
        }
      } else if (flag == 'review') {
        final String rating = data['rating'];
        final String ratingMessage =
            Utils.getString(context, 'noti_message__text1') +
                rating.split('.')[0] +
                Utils.getString(context, 'noti_message__text2') +
                '\n"' +
                notiMessage +
                '"';
        _onSelectReviewNotification(
            context, ratingMessage, userProvider.psValueHolder!.loginUserId);
      } else {
        _onSelectApprovalNotification(context, notiMessage);
      }
    }
  }

  static Future<void> _showChatNotification(
      BuildContext context,
      String? payload,
      String? sellerId,
      String? buyerId,
      String? senderName,
      String? senderProflePhoto,
      String? itemId,
      String? action,
      String? loginUserId) async {
    return showDialog<dynamic>(
      context: context,
      builder: (_) {
        return ChatNotiDialog(
            description: '$payload',
            leftButtonText: Utils.getString(context, 'dialog__cancel'),
            rightButtonText: Utils.getString(context, 'chat_noti__open'),
            onAgreeTap: () {
              _navigateToChat(context, sellerId, buyerId, senderName,
                  senderProflePhoto, itemId, action, loginUserId);
            });
      },
    );
  }

  static void _navigateToChat(
      BuildContext context,
      String? sellerId,
      String? buyerId,
      String? senderName,
      String? senderProflePhoto,
      String? itemId,
      String? action,
      String? loginUserId) {
    if (loginUserId == buyerId) {
      Navigator.pushNamed(context, RoutePaths.chatView,
          arguments: ChatHistoryIntentHolder(
            chatFlag: PsConst.CHAT_FROM_SELLER,
            itemId: itemId,
            buyerUserId: buyerId,
            sellerUserId: sellerId,
          ));
    } else {
      Navigator.pushNamed(context, RoutePaths.chatView,
          arguments: ChatHistoryIntentHolder(
              chatFlag: PsConst.CHAT_FROM_BUYER,
              itemId: itemId,
              buyerUserId: buyerId,
              sellerUserId: sellerId));
    }
  }

  static Future<void> linkifyLinkOpen(LinkableElement link) async {
    if (await canLaunchUrl(Uri.parse(link.url))) {
      await launchUrl(Uri.parse(link.url));
    } else {
      throw 'Could not launch $link';
    }
  }

  static bool showUI(String? valueHolderData) {
    return valueHolderData == PsConst.ONE;
  }

  // static Future<void> _showBroadCastNotification(
  //     BuildContext context, String payload) async {
  //   // if (context == null) {
  //   //   widget.onNotiClicked(payload);
  //   // } else {
  //   if (context != null) {
  //     return showDialog<dynamic>(
  //       context: context,
  //       builder: (_) {
  //         return NotiDialog(message: '$payload');
  //       },
  //     );
  //   }
  // }
}
