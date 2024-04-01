import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String food;
  final String description;
  final String imageUrl;
  final String postId;
  final String price;
  final String count;
  final String time;

  const Item({
    required this.food,
    required this.description,
    required this.imageUrl,
    required this.postId,
    required this.time,
    required this.count,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'food': food,
        'description': description,
        'price': price,
        'postId': postId,
        'imageUrl': imageUrl,
        'time': time,
        'count': count,
      };
  static Item fromsnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);
    return Item(
        time: snap["time"],
        food: snap['food'],
        description: snap['description'],
        imageUrl: snap['imageUrl'],
        postId: snap['postId'],
        price: snap['price'],
        count: snap['count']);
  }
}
