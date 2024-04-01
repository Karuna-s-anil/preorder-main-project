import 'package:flutter/material.dart';

class CartCard extends StatelessWidget {
  const CartCard({Key? key, required this.cart});

  final List<dynamic> cart;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              SizedBox(
                width: 88,
                child: AspectRatio(
                  aspectRatio: 0.88,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.network(cart[index]["imageUrl"]),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cart[index]["foodName"],
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    maxLines: 2,
                  ),
                  SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      text: "\₹${cart[index]["amount"]}",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.blue),
                      children: [
                        TextSpan(
                          text: " x${cart[index]["count"]}",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
