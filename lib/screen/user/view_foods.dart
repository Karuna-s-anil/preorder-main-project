// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:preorder/screen/user/food_details.dart';
import 'package:transparent_image/transparent_image.dart';

class Food {
  final String food;
  final String imageUrl;
  final String rating;
  final String ratingCount;
  final String postId;

  Food({
    required this.food,
    required this.imageUrl,
    required this.rating,
    required this.ratingCount,
    required this.postId,
  });
}

class FoodExplore extends StatefulWidget {
  const FoodExplore({super.key});

  @override
  State<FoodExplore> createState() => _FoodExploreState();
}

class _FoodExploreState extends State<FoodExplore> {
  final List<Food> _foods = [];
  String searchText = "";
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  late List<ItemModel> menuItems;

  Future<void> _fetchPosts() async {
    try {
      final postDocs =
          await FirebaseFirestore.instance.collection('foods').get();
      print("------------------");
      print(postDocs.docs.length);
      print("-------------------");
      for (var postDoc in postDocs.docs) {
        print("------------------");
        print(postDoc.data());
        print("-------------------");
        final rating = postDoc['rating'].toString();
        final ratingC = postDoc['ratingCount'].toString();

        final post = Food(
          food: postDoc['food'],
          imageUrl: postDoc['imageUrl'],
          postId: postDoc['postId'],
          rating: rating,
          ratingCount: ratingC,
        );
        print("------------------");
        print(post.food);
        print("-------------------");
        _foods.add(post);
      }

      setState(() {});
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  @override
  void initState() {
    menuItems = [
      ItemModel('Logout', Icons.group_add),
    ];
    super.initState();
    _fetchPosts();
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
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
                                }
                                _controller.hideMenu();
                              },
                              child: item.title == 'Messages'
                                  ? FirebaseAuth.instance.currentUser!.uid ==
                                          'ZKdxIXM5C0gDRim3qnQzxgRiqvI2'
                                      ? Container(
                                          height: 40,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                item.icon,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
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
                                        )
                                      : Container()
                                  : Container(
                                      height: 40,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
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
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
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
            controller: _controller,
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
                placeholder: 'Search foods',
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
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FoodDetails(
                                foodName: _foods[index].food,
                                imageUrl: _foods[index].imageUrl,
                                postId: _foods[index].postId,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                _foods[index].imageUrl,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              left: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.green[100]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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

class ItemModel {
  String title;
  IconData icon;

  ItemModel(this.title, this.icon);
}
