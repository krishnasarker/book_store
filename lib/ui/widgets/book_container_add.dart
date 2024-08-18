import 'package:flutter/material.dart';

Widget _buildPhotoPickerWidget() {
  return Container(
    width: double.maxFinite,
    height: 48,
    decoration: BoxDecoration(
      image: const DecorationImage(
          image: NetworkImage(
            'https://imgeng.jagran.com/images/2024/04/08/template/image/1-1712590418689.jpg',
          ),
          fit: BoxFit.cover),
      borderRadius: BorderRadius.circular(10),
    ),
    alignment: Alignment.centerLeft,
    child: Container(
      width: 100,
      height: 48,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
        color: Colors.grey,
      ),
      alignment: Alignment.center,
      child: const Text(
        'Photo',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    ),
  );
}
