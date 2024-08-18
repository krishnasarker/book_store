import 'package:book_store/ui/screens/app_screen/update_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DeleteFile extends StatefulWidget {
  const DeleteFile({Key? key}) : super(key: key);

  @override
  State<DeleteFile> createState() => _DeleteFileState();
}

class _DeleteFileState extends State<DeleteFile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<DocumentSnapshot> _books = [];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    final snapshot = await _firestore.collection('books').get();
    setState(() {
      _books = snapshot.docs;
    });
  }

  Future<void> _deleteBook(String documentId, String imageUrl) async {
    try {
      // Delete image from Firebase Storage if it exists
      if (imageUrl.isNotEmpty) {
        final imageRef = _storage.refFromURL(imageUrl);
        await imageRef.delete();
      }

      // Delete document from Firestore
      await _firestore.collection('books').doc(documentId).delete();

      // Refresh the list after deletion
      _fetchBooks();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book deleted successfully!')),
      );
    } catch (e) {
      print('Error occurred while deleting: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete book: $e')),
      );
    }
  }

  void _confirmDelete(String documentId, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this book?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteBook(documentId, imageUrl);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditScreen(DocumentSnapshot book) {
    final data = book.data() as Map<String, dynamic>;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditBookScreen(
          documentId: book.id,
          initialTitle: data['title'] ?? '',
          initialDescription: data['description'] ?? '',
          initialPrice: (data['price'] ?? 0.0).toString(),
          initialMobile: data['mobile'] ?? '',
          initialLocation: data['location'] ?? '',
          initialImageUrl: data['image_url'] ?? '',
        ),
      ),
    ).then((_) => _fetchBooks()); // Refresh the list after returning from EditScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Books'),
      ),
      body: _books.isEmpty
          ? const Center(child: Text('No books available'))
          : ListView.builder(
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index].data() as Map<String, dynamic>;
          final documentId = _books[index].id;
          final imageUrl = book['image_url'] ?? '';

          return ListTile(
            leading: imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
                : const Placeholder(),
            title: Text(book['title'] ?? 'No Title'),
            subtitle: Text(book['description'] ?? 'No Description'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _navigateToEditScreen(_books[index]),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(documentId, imageUrl),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
