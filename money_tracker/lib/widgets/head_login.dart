import 'package:flutter/material.dart';

import '../styles/colors.dart';

class HeadLogin extends StatelessWidget {
  const HeadLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        Column(
          children: [
            Image.asset('assets/images/folder.png'),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Учет расходов',
              style: TextStyle(
                color: customColorBlack,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Ваша история расходов\n всегда под рукой',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: customColorBlack,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ],
    );
  }
}
