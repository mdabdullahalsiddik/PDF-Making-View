import 'package:flutter/material.dart';

class LoadingButtonWidget extends StatelessWidget {
  const LoadingButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () {},
        child: const CircularProgressIndicator(),
      );
}
