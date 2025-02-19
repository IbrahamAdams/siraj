import 'dart:async';

import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/follower_uer_item_list_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';

class ItemListFromFollowersProvider extends PsProvider {
  ItemListFromFollowersProvider(
      {required ProductRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }
    _repo = repo;

    print('ItemListFromFollowersProvider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    itemListFromFollowersStream =
        StreamController<PsResource<List<Product>>>.broadcast();
    subscription = itemListFromFollowersStream!.stream
        .listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data!.length);

      print('**** ItemListFromFollowersProvider ${resource.data!.length}');
      _itemListFromFollowersList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  FollowUserItemParameterHolder followUserItemParameterHolder =
      FollowUserItemParameterHolder().getLatestParameterHolder();

  ProductRepository? _repo;
  PsValueHolder? psValueHolder;
  PsResource<List<Product>> _itemListFromFollowersList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get itemListFromFollowersList =>
      _itemListFromFollowersList;
  StreamSubscription<PsResource<List<Product>>>? subscription;
  StreamController<PsResource<List<Product>>>? itemListFromFollowersStream;

  dynamic daoSubscription;

  @override
  void dispose() {
    subscription?.cancel();

    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemListFromFollowersList(
      Map<dynamic, dynamic> jsonMap, String? loginUserId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    daoSubscription = await _repo!.getAllItemListFromFollower(
      itemListFromFollowersStream,
      jsonMap,
      isConnectedToInternet,
      loginUserId,
      limit,
      offset,
      PsStatus.PROGRESS_LOADING,
    );
  }

  Future<dynamic> nextItemListFromFollowersList(
      Map<dynamic, dynamic> jsonMap, String loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo!.getNextPageItemListFromFollower(
          itemListFromFollowersStream,
          jsonMap,
          isConnectedToInternet,
          loginUserId,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemListFromFollowersList(
      Map<dynamic, dynamic> jsonMap, String? loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    daoSubscription = await _repo!.getAllItemListFromFollower(
      itemListFromFollowersStream,
      jsonMap,
      isConnectedToInternet,
      loginUserId,
      limit,
      offset,
      PsStatus.PROGRESS_LOADING,
    );

    isLoading = false;
  }
}
