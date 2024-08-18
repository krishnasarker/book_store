import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../utility/app_color.dart';

class EditBookScreen extends StatefulWidget {
  final String documentId;
  final String initialTitle;
  final String initialDescription;
  final String initialPrice;
  final String initialMobile;
  final String initialLocation;
  final String initialImageUrl;

  const EditBookScreen({
    Key? key,
    required this.documentId,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialPrice,
    required this.initialMobile,
    required this.initialLocation,
    required this.initialImageUrl,
  }) : super(key: key);

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialTitle;
    _descriptionController.text = widget.initialDescription;
    _priceController.text = widget.initialPrice;
    _mobileController.text = widget.initialMobile;
    _locationController.text = widget.initialLocation;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateBook() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String imageUrl = widget.initialImageUrl;

      if (_selectedImage != null) {
        // Upload new image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('book_images/${widget.documentId}.jpg');
        await storageRef.putFile(_selectedImage!);
        imageUrl = await storageRef.getDownloadURL();
        print('Image uploaded and URL retrieved: $imageUrl'); // Debug log
      }

      // Update Firestore document
      await FirebaseFirestore.instance
          .collection('books')
          .doc(widget.documentId)
          .update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'mobile': _mobileController.text,
        'location': _locationController.text,
        'image_url': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book updated successfully!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      print('Failed to update book: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update book: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Book',style: TextStyle(color:Colors.white),),
        backgroundColor: AppColors.themeColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPhotoPickerWidget(),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _titleController,
                label: 'Title',
                hintText: 'Enter Book Title',
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hintText: 'Enter Book Description',
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _priceController,
                label: 'Price',
                hintText: 'Enter Book Price',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _mobileController,
                label: 'Mobile',
                hintText: 'Enter Mobile Number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _locationController,
                label: 'Location',
                hintText: 'Enter Location',
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _updateBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.themeColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Update Book',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  Widget _buildPhotoPickerWidget() {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                color: Colors.grey[300],
              ),
              alignment: Alignment.center,
              child: Text(
                _selectedImage == null ? 'Select Photo' : 'Change Photo',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              )
            else if (widget.initialImageUrl.isNotEmpty)
              Image.network(
                widget.initialImageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}
