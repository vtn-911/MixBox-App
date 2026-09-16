import 'package:flutter/material.dart';
import 'package:mixboxapp/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    if (user == null) {
      return const Material(
        child: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    final avatarUrl = user.avatarUrl;
    final imageUrl = avatarUrl != null
        ? 'http://10.0.2.2:3000$avatarUrl'
        : null;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                _avatarUser(imageUrl),
                const SizedBox(height: 24),
                Text(
                  user.fullName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 16, color: Color(0xff464555)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _avatarUser(String? imageUrl) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Color(0xffF8F9FA), width: 2, strokeAlign: -1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            spreadRadius: -2,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0xff4F46E5).withValues(alpha: 0.1),
            blurRadius: 15,
            spreadRadius: -3,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
        child: imageUrl == null
            ? const Icon(Icons.person, size: 60, color: Color(0xff464555))
            : null,
      ),
    );
  }
}
