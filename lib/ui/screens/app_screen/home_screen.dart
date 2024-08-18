import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_store/ui/widgets/profile_app_bar.dart';
import '../book_screen_design/details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context), // Assuming this is a custom AppBar
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('books').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading books'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No books available'));
                }

                final books = snapshot.data!.docs.where((doc) {
                  final book = doc.data() as Map<String, dynamic>;
                  final title = book['title']?.toLowerCase() ?? '';
                  return title.contains(_searchQuery.toLowerCase());
                }).toList();

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    childAspectRatio: 0.65, // Adjust based on item size
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index].data() as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(book: book),
                          ),
                        );
                      },
                      child: _buildBookItem(book),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: TextField(
        onChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search books...',
          hintStyle: TextStyle(color: Colors.grey[600]), // Subtle hint text color
          filled: true,
          fillColor: Colors.grey[100], // Background color for the text field
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide.none, // Removes the default border
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.grey, // Consistent icon color with hint text
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
              setState(() {
                _searchQuery = '';
              });
            },
          )
              : null,
        ),
        textInputAction: TextInputAction.search,
      ),
    );
  }


  Widget _buildBookItem(Map<String, dynamic> book) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: book['image_url'] != null
                  ? Image.network(
                book['image_url'],
                fit: BoxFit.cover,
              )
                  : Container(
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.image_not_supported)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book['title'] ?? 'No Title',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  book['description'] ?? 'No Description',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Price: \$${book['price']?.toStringAsFixed(2) ?? '0.00'}',
                  style: const TextStyle(fontSize: 14, color: Colors.green),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Location: ${book['location'] ?? 'No Location'}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
