import 'dart:async';

import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/holder/mark_sold_out_item_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';

class MarkSoldOutItemProvider extends PsProvider {
  MarkSoldOutItemProvider({required ProductRepository? repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('MarkSoldOutItemProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    markSoldOutItemStream = StreamController<PsResource<Product>>.broadcast();

    subscription =
        markSoldOutItemStream!.stream.listen((PsResource<Product> resource) {
      _markSoldOutItem = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  ProductRepository? _repo;
  PsResource<Product> _markSoldOutItem =
      PsResource<Product>(PsStatus.NOACTION, '', null);

  PsResource<Product> get markSoldOutItem => _markSoldOutItem;
  late StreamSubscription<PsResource<Product>> subscription;
  StreamController<PsResource<Product>>? markSoldOutItemStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Mark Sold Out Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadmarkSoldOutItem(
      String? loginUserId, MarkSoldOutItemParameterHolder? holder) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo!.markSoldOutItem(markSoldOutItemStream, loginUserId,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING, holder);
  }

  Future<dynamic> nextmarkSoldOutItem(
      String loginUserId, MarkSoldOutItemParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.markSoldOutItem(markSoldOutItemStream, loginUserId,
          isConnectedToInternet, PsStatus.PROGRESS_LOADING, holder);
    }
  }
}
