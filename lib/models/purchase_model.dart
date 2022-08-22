class Purchase {
  // final String orderID;
  final String email;
  final String sellerName;
  final DateTime purchaseDate;
  final Map<String, dynamic> records;
  final int totalPrice;

  Purchase(
      {
      // required this.orderID,
      required this.email,
      required this.sellerName,
      required this.purchaseDate,
      required this.records,
      required this.totalPrice});

  static Purchase fromJson(Map<String, dynamic> json) => Purchase(
      // orderID: json["quote"],
      email: json["email"],
      sellerName: json["name"],
      purchaseDate: json["purchaseDate"],
      records: json["purchases"],
      totalPrice: json["total"]);
}
