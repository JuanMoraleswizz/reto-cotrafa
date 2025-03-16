class Routes {
  Routes._();

  static const String home = "/home";
  static const String inventories = "/inventories";
  static const String addInventory = "/add-inventory";
  static const String editInventory = "/edit-inventory/:inventoryId";
  static const String products = "/products/:inventoryId";
  static const String addProduct = "/add-product/:inventoryId";
  static const String editProduct = "/edit-product/:productId";
}
