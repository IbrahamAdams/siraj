import 'package:flutterbuyandsell/viewobject/common/ps_object.dart';

class DefaultPhoto extends PsObject<DefaultPhoto> {
  DefaultPhoto(
      {this.imgId,
      this.imgParentId,
      this.imgType,
      this.imgPath,
      this.imgWidth,
      this.imgHeight,
      this.imgDesc});

  String? imgId;
  String? imgParentId;
  String? imgType;
  String? imgPath;
  String? imgWidth;
  String? imgHeight;
  String? imgDesc;

  @override
  String getPrimaryKey() {
    return imgId ?? '';
  }

  @override
  DefaultPhoto fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return DefaultPhoto(
          imgId: dynamicData['img_id'],
          imgParentId: dynamicData['img_parent_id'],
          imgType: dynamicData['img_type'],
          imgPath: dynamicData['img_path'],
          imgWidth: dynamicData['img_width'],
          imgHeight: dynamicData['img_height'],
          imgDesc: dynamicData['img_desc']);
    } else {
      return DefaultPhoto();
    }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object != null) {
      data['img_id'] = object.imgId;
      data['img_parent_id'] = object.imgParentId;
      data['img_type'] = object.imgType;
      data['img_path'] = object.imgPath;
      data['img_width'] = object.imgWidth;
      data['img_height'] = object.imgHeight;
      data['img_desc'] = object.imgDesc;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<DefaultPhoto> fromMapList(List<dynamic> dynamicDataList) {
    final List<DefaultPhoto> defaultPhotoList = <DefaultPhoto>[];

    // if (dynamicDataList != null) {
    for (dynamic dynamicData in dynamicDataList) {
      if (dynamicData != null) {
        defaultPhotoList.add(fromMap(dynamicData));
      }
    }
    // }
    return defaultPhotoList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<DefaultPhoto?> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];

    // if (objectList != null) {
    for (DefaultPhoto? data in objectList) {
      if (data != null) {
        mapList.add(toMap(data));
      }
    }
    // }

    return mapList;
  }
}
