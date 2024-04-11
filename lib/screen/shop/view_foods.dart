// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:preorder/screen/shop/qr_scanner.dart';
import 'package:preorder/screen/user/view_foods.dart';
import 'package:transparent_image/transparent_image.dart';

class Food {
  final String food;
  final String imageUrl;
  final String rating;
  final String ratingCount;
  final String postId;
  final int price;

  Food({
    required this.food,
    required this.imageUrl,
    required this.rating,
    required this.ratingCount,
    required this.postId,
    required this.price,
  });
}

class ViewFoodsShopOwner extends StatefulWidget {
  const ViewFoodsShopOwner({super.key});

  @override
  State<ViewFoodsShopOwner> createState() => _ViewFoodsShopOwnerState();
}

class _ViewFoodsShopOwnerState extends State<ViewFoodsShopOwner> {
  final List<Food> _foods = [];
  String searchText = "";

  Future<void> _fetchPosts() async {
    try {
      final postDocs =
          await FirebaseFirestore.instance.collection('foods').get();
      for (var postDoc in postDocs.docs) {
        final rating = postDoc['rating'].toString();
        final ratingC = postDoc['ratingCount'].toString();

        final post = Food(
            food: postDoc['food'],
            imageUrl: postDoc['imageUrl'],
            postId: postDoc['postId'],
            rating: rating,
            ratingCount: ratingC,
            price: postDoc['price']);
        _foods.add(post);
      }

      setState(() {});
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  late List<ItemModel> menuItems;

  @override
  void initState() {
    super.initState();
    menuItems = [
      ItemModel('Logout', Icons.group_add),
      ItemModel('QR scan', Icons.qr_code_scanner),
    ];
    _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    CustomPopupMenuController controller = CustomPopupMenuController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Foods',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CustomPopupMenu(
            menuBuilder: () => ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: const Color(0xFF4C4C4C),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: menuItems
                        .map(
                          (item) => GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                print("onTap");
                                if (item.title == 'Logout') {
                                  FirebaseAuth.instance.signOut();
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => QRScanner()));
                                }
                                controller.hideMenu();
                              },
                              child: Container(
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      item.icon,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Text(
                                          item.title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            pressType: PressType.singleClick,
            verticalMargin: -10,
            controller: controller,
            child: Container(
              child: CircleAvatar(
                radius: 20,
                child: ClipOval(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image:
                        'https://imgs.search.brave.com/gLciFO7xykeQKiunWQ1S9-s1fq1snzvKAxAEzg1YGac/rs:fit:500:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAwLzY1LzEwLzQ3/LzM2MF9GXzY1MTA0/NzE4X3gxN2E3Nnd6/V0tJbTNCbGhBNnV5/WVZrRHM5OTgyYzZx/LmpwZw',
                    fit: BoxFit.cover,
                    width: 36,
                    height: 36,
                  ),
                ),
              ),
              // padding: EdgeInsets.all(20),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: CupertinoSearchTextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                borderRadius: BorderRadius.circular(10.0),
                placeholder: 'Search items',
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: MasonryGridView.builder(
                itemCount: _foods.length,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  if (searchText == '') {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              Image.network(
                                _foods[index].imageUrl,
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  color:
                                      const Color.fromARGB(255, 210, 210, 210),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(_foods[index].food),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  color:
                                      const Color.fromARGB(255, 210, 210, 210),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        '₹ ${_foods[index].price.toString()}'),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
