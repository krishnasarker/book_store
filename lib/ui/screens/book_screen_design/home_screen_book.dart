import 'package:book_store/ui/screens/book_screen_design/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:book_store/ui/utility/app_color.dart';
import 'package:book_store/ui/utility/asset_paths.dart';

class BookTask extends StatefulWidget {
  const BookTask({super.key});

  @override
  State<BookTask> createState() => _BookTaskState();
}

class _BookTaskState extends State<BookTask> {
  static const double _padding = 8.0;
  static const double _containerHeight = 210;
  static const double _imageHeight = 160; // Adjusted height
  static const double _imageWidth = 140;
  static const double _spacing = 4.0; // Adjusted spacing
  static const double _innerSpacing = 2.0; // Adjusted inner spacing

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_padding),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailsScreen(book: {},)),
          );
        },
        child: Container(
          height: _containerHeight,
          width: _imageWidth + _padding * 2,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: AppColors.themeColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(_padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: _imageHeight,
                  width: _imageWidth,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(AssetPaths.bookPng),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: _spacing),
                Text(
                  'Book Name',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: _innerSpacing),
                Text(
                  'Price: 10TK',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: _innerSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.location_on_outlined),
                    Text(
                      'Feni Town',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Icon(Icons.favorite_border),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
