import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class UserDetailScreen extends StatefulWidget {
  static const routeName = 'user_detail';

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen>
    with AutomaticKeepAliveClientMixin<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors.primaryBlue,
        title: const Text("Dados Usuário"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.save,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: const Text("inside user detail"),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
