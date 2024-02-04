import 'package:preorder/shop_owner_page.dart';
import 'package:preorder/security_page.dart';
import 'package:preorder/user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import 'auth/user_provider.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userModel = userProvider.userModel;
    if (userModel!.type == "admin") {
      return ShopOwnerIndexPage();
    } else {
      if (userModel.type == "security") {
        return SecurityIndexPage();
      } else {
        return UserIndexPage();
      }
    }
  }
}
