import 'dart:async';

import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';
import 'package:flutterbuyandsell/repository/delete_task_repository.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/user_login.dart';

class DeleteTaskProvider extends PsProvider {
  DeleteTaskProvider(
      {required DeleteTaskRepository? repo, this.psValueHolder, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Delete Task Provider: $hashCode');
    deleteTaskListStream =
        StreamController<PsResource<List<UserLogin>>>.broadcast();
    subscription = deleteTaskListStream.stream
        .listen((PsResource<List<UserLogin>> resource) {
      updateOffset(resource.data!.length);

      _deleteTaskList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  late StreamController<PsResource<List<UserLogin>>> deleteTaskListStream;
  DeleteTaskRepository? _repo;
  PsValueHolder? psValueHolder;

  PsResource<List<UserLogin>> _deleteTaskList =
      PsResource<List<UserLogin>>(PsStatus.NOACTION, '', <UserLogin>[]);

  PsResource<List<UserLogin>> get basketList => _deleteTaskList;
  late StreamSubscription<PsResource<List<UserLogin>>> subscription;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Delete Task Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> deleteTask() async {
    isLoading = true;
    _repo!.deleteTask(deleteTaskListStream);
  }
}
