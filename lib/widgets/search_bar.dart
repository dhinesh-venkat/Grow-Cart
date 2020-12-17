import '../models/product.dart';

Future<List<Product>> search(String search) async {
  await Future.delayed(Duration(seconds: 2));
  return List.generate(search.length, (int index) {
    return Product(
      
    );
  });
}
