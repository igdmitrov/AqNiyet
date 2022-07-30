import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserLogo extends StatelessWidget {
  final String userId;
  const UserLogo({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      'https://avatars.dicebear.com/api/pixel-art/$userId.svg',
      width: 40,
      height: 40,
      placeholderBuilder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(30.0),
        child: const Text('...'),
      ),
    );
  }
}
