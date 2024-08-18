import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/profile_app_bar.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _locationTEController = TextEditingController();
  File? _selectedImage;

  static const double _spacing = 12.0;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProduct() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    try {
      // Upload image to Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('book_images/${DateTime.now()}.jpg');
      await ref.putFile(_selectedImage!);
      String imageUrl = await ref.getDownloadURL();

      // Save product details to Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('books').add({
        'title': _titleTEController.text,
        'description': _descriptionTEController.text,
        'price': double.tryParse(_priceTEController.text) ?? 0.0,
        'mobile': _mobileTEController.text,
        'location': _locationTEController.text,
        'image_url': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear fields
      _titleTEController.clear();
      _descriptionTEController.clear();
      _priceTEController.clear();
      _mobileTEController.clear();
      _locationTEController.clear();
      setState(() {
        _selectedImage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book added successfully!')),
      );
    } catch (e) {
      print('Error occurred while uploading: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload book: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _titleTEController,
                label: 'Title',
                hintText: 'Enter Book Title...',
              ),
              const SizedBox(height: _spacing),
              _buildTextField(
                controller: _descriptionTEController,
                label: 'Description',
                hintText: 'Enter Book Description...',
                maxLines: 12,
              ),
              const SizedBox(height: _spacing),
              _buildTextField(
                controller: _priceTEController,
                label: 'Price',
                hintText: 'Enter Book Price',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: _spacing),
              _buildTextField(
                controller: _mobileTEController,
                label: 'Mobile',
                hintText: 'Enter Mobile Number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: _spacing),
              _buildTextField(
                controller: _locationTEController,
                label: 'Location',
                hintText: 'Enter Right Location...',
              ),
              const SizedBox(height: _spacing),
              _buildPhotoPickerWidget(),
              const SizedBox(height: _spacing),
              ElevatedButton(
                onPressed: _uploadProduct,
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.amber.shade50,
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
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  Widget _buildPhotoPickerWidget() {
    return InkWell(
      onTap: () {
        _pickImage();
      },
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(color: Colors.grey),
        ),
        alignment: Alignment.centerLeft,
        child: _selectedImage == null
            ? Container(
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
              )
            : Row(
                children: [
                  Container(
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
                      'Change Photo',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.file(
                    _selectedImage!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    _priceTEController.dispose();
    _mobileTEController.dispose();
    _locationTEController.dispose();
    super.dispose();
  }
}
