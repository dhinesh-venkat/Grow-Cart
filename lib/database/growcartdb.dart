import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class APIResponse<T> {
  T data;
  bool error;
  String errorMessage;

  APIResponse({this.data, this.errorMessage, this.error = false});
}

class GroupData {
  String id;
  String value;
  String imageUrl;

  GroupData({this.id, this.value, this.imageUrl});

  GroupData.fromJson(
    Map<String, dynamic> json,
  ) {
    id = json['ID'];
    value = json['VALUE'];
    imageUrl = json['ImageName'];
  }
}

class SubGroupData {
  String id;
  String value;

  SubGroupData({
    @required this.id,
    @required this.value,
  });

  SubGroupData.fromJson(
    Map<String, dynamic> json,
  ) {
    id = json['ID'];
    value = json['VALUE'];
  }
}

class ProductData {
  String itemId;
  String itemName;
  String hSN;
  String groupName;
  String groupId;
  String subGroupId;
  String imageName;
  List<PackageData> data;

  ProductData(
      {this.itemId,
      this.itemName,
      this.hSN,
      this.groupName,
      this.groupId,
      this.subGroupId,
      this.imageName,
      this.data});

  ProductData.fromJson(Map<String, dynamic> json) {
    itemId = json['ItemId'];
    itemName = json['ItemName'];
    hSN = json['HSN'];
    groupName = json['GroupName'];
    groupId = json['GroupId'];
    subGroupId = json['SubGroupId'];
    imageName = json['ImageName'];
    if (json['data'] != null) {
      data = new List<PackageData>();
      json['data'].forEach((v) {
        data.add(new PackageData.fromJson(v));
      });
    }
  }
}

class PackageData {
  String packingQty;
  String uOM;
  String uOMId;
  String sellingRate;
  String costRate;
  String mRP;
  String code;

  PackageData(
      {this.packingQty,
      this.uOM,
      this.uOMId,
      this.sellingRate,
      this.costRate,
      this.mRP,
      this.code});

  PackageData.fromJson(Map<String, dynamic> json) {
    packingQty = json['PackingQty'];
    uOM = json['UOM'];
    uOMId = json['UOMId'];
    sellingRate = json['SellingRate'];
    costRate = json['CostRate'];
    mRP = json['MRP'];
    code = json['Code'];
  }
}

class GrowCartDb {
  static const BASE_URL = "http://sksapi.suninfotechnologies.in/";

  static Future<APIResponse<List<GroupData>>> getGroupList() {
    return http.get(BASE_URL + 'api/group').then((data) {
      print('Status code : ${data.statusCode}');
      if (data.statusCode == 200) {
        final Iterable jsonData = json.decode(data.body);
        final List<GroupData> groups =
            jsonData.map((e) => GroupData.fromJson(e)).toList();

        return APIResponse<List<GroupData>>(data: groups);
      }
      return APIResponse<List<GroupData>>(
          error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<GroupData>>(
        error: true, errorMessage: 'An error occured'));
  }

  static Future<APIResponse<List<SubGroupData>>> getSubGroupList(
          String groupId) =>
      http
          .get(BASE_URL + '/api/subgroup?groupid=' + groupId)
          .then(
            (data) => (data.statusCode == 200)
                ? APIResponse<List<SubGroupData>>(
                    data: json
                        .decode(data.body)
                        .map((item) => SubGroupData.fromJson(item))
                        .toList()
                        .cast<SubGroupData>(),
                  )
                : APIResponse<List<SubGroupData>>(
                    error: true,
                    errorMessage: 'An error occured',
                  ),
          )
          .catchError(
            (_) => APIResponse<List<SubGroupData>>(
              error: true,
              errorMessage: 'An error occured',
            ),
          );

  static Future<APIResponse<List<ProductData>>> getProductList(
    String groupId,
    String subGroupId,
  ) {
    return http
        .get(BASE_URL +
            "/api/item?groupid=" +
            groupId +
            "&subgroupid=" +
            subGroupId)
        .then(
          (data) => (data.statusCode == 200)
              ? APIResponse<List<ProductData>>(
                  data: json
                      .decode(data.body)
                      .map((item) => ProductData.fromJson(item))
                      .toList()
                      .cast<SubGroupData>(),
                )
              : APIResponse<List<ProductData>>(
                  error: true,
                  errorMessage: 'An error occured',
                ),
        )
        .catchError(
          (_) => APIResponse<List<ProductData>>(
            error: true,
            errorMessage: 'An error occured',
          ),
        );
  }
}

class StoreFront {
  final List<Group> groups;

  StoreFront(this.groups);

  static build() async => StoreFront(
        await GrowCartDb.getGroupList()
            .then(
              (value) => (value.error) ? <Group>[] : value.data,
            )
            .then(
              (subgroupDataList) => subgroupDataList
                  .map<Group>((e) => Group.fromData(
                        e,
                      ))
                  .toList(),
            ),
      );
}

class Group {
  final String id;
  final String value;
  final String imageUrl;
  final List<SubGroup> subgroups;

  Group(
    this.id,
    this.value,
    this.imageUrl,
    this.subgroups,
  );

  static fromData(GroupData gd) async => Group(
        gd.id,
        gd.value,
        gd.imageUrl,
        await GrowCartDb.getSubGroupList(
          gd.id,
        )
            .then(
              (value) => (value.error) ? <SubGroupData>[] : value.data,
            )
            .then(
              (subgroupDataList) => subgroupDataList
                  .map<SubGroup>((e) => SubGroup.fromData(
                        e,
                        gd.id,
                      ))
                  .toList(),
            ),
      );
}

class SubGroup {
  final String id;
  final String value;
  final String groupId;
  final List<Package> packages;

  SubGroup(
    this.id,
    this.value,
    this.groupId,
    this.packages,
  );

  static fromData(SubGroupData sgd, String groupId) async {
    SubGroup retVal = SubGroup(
      sgd.id,
      sgd.value,
      groupId,
      await GrowCartDb.getProductList(
        groupId,
        sgd.id,
      )
          .then(
            (value) => (value.error) ? <ProductData>[] : value.data,
          )
          .then(
            (productDataList) => productDataList
                .expand<Package>(
                  (e) => Package.fromData(
                    e,
                  ),
                )
                .toList(),
          ),
    );
  }
}

class Package {
  String itemId;
  String itemName;
  String hSN;
  String groupName;
  String groupId;
  String subGroupId;
  String imageName;
  String packingQty;
  String uOM;
  String uOMId;
  String sellingRate;
  String costRate;
  String mRP;
  String code;
  Package({
    @required this.itemName,
    @required this.hSN,
    @required this.groupName,
    @required this.groupId,
    @required this.subGroupId,
    @required this.imageName,
    @required this.packingQty,
    @required this.uOM,
    @required this.uOMId,
    @required this.sellingRate,
    @required this.costRate,
    @required this.mRP,
    @required this.code,
    @required this.itemId,
  });

  static fromData(ProductData pd) {
    return pd.data.map((e) {
      return Package(
        itemName: pd.itemName,
        hSN: pd.hSN,
        groupName: pd.groupName,
        groupId: pd.groupId,
        subGroupId: pd.subGroupId,
        imageName: pd.imageName,
        packingQty: e.packingQty,
        uOM: e.uOM,
        uOMId: e.uOMId,
        sellingRate: e.sellingRate,
        costRate: e.costRate,
        mRP: e.mRP,
        code: e.code,
        itemId: pd.itemId,
      );
    }).toList();
  }
}
