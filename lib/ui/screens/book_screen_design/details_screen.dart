import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> book;

  const DetailsScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (book['image_url'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    book['image_url'],
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.grey[200],
                  ),
                  child: const Center(child: Icon(Icons.image_not_supported, size: 100)),
                ),
              const SizedBox(height: 16.0),
              Text(
                book['title'] ?? 'No Title',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Text(
                book['description'] ?? 'No Description',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Price: \$${book['price']?.toStringAsFixed(2) ?? '0.00'}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Location: ${book['location'] ?? 'No Location'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Mobile: ${book['mobile'] ?? 'No Mobile'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press here, such as navigating to another screen or opening a contact dialog
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Contact Seller', style: TextStyle(fontSize: 16.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
