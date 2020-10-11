class Product {
  String itemId;
  String itemName;
  String hSN;
  String groupName;
  String groupId;
  String subGroupId;
  String imageName;
  List<Data> data;

  Product(
      {this.itemId,
      this.itemName,
      this.hSN,
      this.groupName,
      this.groupId,
      this.subGroupId,
      this.imageName,
      this.data});

  Product.fromJson(Map<String, dynamic> json) {
    itemId = json['ItemId'];
    itemName = json['ItemName'];
    hSN = json['HSN'];
    groupName = json['GroupName'];
    groupId = json['GroupId'];
    subGroupId = json['SubGroupId'];
    imageName = json['ImageName'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['ItemId'] = this.itemId;
  //   data['ItemName'] = this.itemName;
  //   data['HSN'] = this.hSN;
  //   data['GroupName'] = this.groupName;
  //   data['GroupId'] = this.groupId;
  //   data['SubGroupId'] = this.subGroupId;
  //   data['ImageName'] = this.imageName;
  //   if (this.data != null) {
  //     data['data'] = this.data.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Data {
  String packingQty;
  String uOM;
  String qtyLbl;
  String uOMId;
  String sellingRate;
  String costRate;
  String mRP;
  String code;

  Data(
      {this.packingQty,
      this.uOM,
      this.qtyLbl,
      this.uOMId,
      this.sellingRate,
      this.costRate,
      this.mRP,
      this.code});

  Data.fromJson(Map<String, dynamic> json) {
    packingQty = json['PackingQty'];
    uOM = json['UOM'];
    qtyLbl = json['QtyLbl'];
    uOMId = json['UOMId'];
    sellingRate = json['SellingRate'];
    costRate = json['CostRate'];
    mRP = json['MRP'];
    code = json['Code'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['PackingQty'] = this.packingQty;
  //   data['UOM'] = this.uOM;
  //   data['QtyLbl'] = this.qtyLbl;
  //   data['UOMId'] = this.uOMId;
  //   data['SellingRate'] = this.sellingRate;
  //   data['CostRate'] = this.costRate;
  //   data['MRP'] = this.mRP;
  //   data['Code'] = this.code;
  //   return data;
  // }
}
