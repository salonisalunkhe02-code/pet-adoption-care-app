import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddPetScreen extends StatefulWidget {
  final String? petId;
  final Map<String, dynamic>? existingData;

  const AddPetScreen({Key? key, this.petId, this.existingData}) : super(key: key);

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _imageFile;
  String? _existingImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      _nameController.text = widget.existingData!['name'] ?? '';
      _breedController.text = widget.existingData!['breed'] ?? '';
      _ageController.text = widget.existingData!['age'] ?? '';
      _descriptionController.text = widget.existingData!['description'] ?? '';
      _priceController.text = widget.existingData!['price'] ?? '';
      _existingImageUrl = widget.existingData!['image'];
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _savePet() async {
    if (!_formKey.currentState!.validate() || (_imageFile == null && _existingImageUrl == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and pick an image")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String imageUrl = _existingImageUrl ?? '';
      if (_imageFile != null) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance.ref().child('pet_images').child(fileName);
        TaskSnapshot snapshot = await ref.putFile(_imageFile!);
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      final petData = {
        'name': _nameController.text.trim(),
        'breed': _breedController.text.trim(),
        'age': _ageController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': _priceController.text.trim(),
        'image': imageUrl,
        'created_at': FieldValue.serverTimestamp(),
      };

      if (widget.petId != null) {
        await FirebaseFirestore.instance.collection('pets').doc(widget.petId).update(petData);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pet updated successfully!")));
      } else {
        await FirebaseFirestore.instance.collection('pets').add(petData);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pet added successfully!")));
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
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
        title: Text(widget.petId != null ? "Edit Pet" : "Add Pet"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _imageFile != null
                    ? Image.file(_imageFile!, height: 150, fit: BoxFit.cover)
                    : (_existingImageUrl != null
                        ? Image.network(_existingImageUrl!, height: 150, fit: BoxFit.cover)
                        : Container(
                            height: 150,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(Icons.add_a_photo, size: 50),
                          )),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Pet Name"),
                validator: (value) => value!.isEmpty ? "Please enter pet name" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: "Breed"),
                validator: (value) => value!.isEmpty ? "Please enter breed" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: "Age"),
                validator: (value) => value!.isEmpty ? "Please enter age" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) => value!.isEmpty ? "Please enter description" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Please enter price" : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _savePet,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                      child: Text(widget.petId != null ? "Update Pet" : "Add Pet"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}