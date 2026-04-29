 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'payment_screen.dart';

class AdoptionFormScreen extends StatefulWidget {
  final String petId;
  final String petName;
  final int petPrice;

  const AdoptionFormScreen({
    Key? key,
    required this.petId,
    required this.petName,
    required this.petPrice,
  }) : super(key: key);


  @override
  State<AdoptionFormScreen> createState() => _AdoptionFormScreenState();
}

class _AdoptionFormScreenState extends State<AdoptionFormScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  String _hasPets = "No";
  bool _agree = false;

  bool _isSubmitting = false;

  Future<void> _submitAdoptionRequest() async {

    if (!_formKey.currentState!.validate()) return;

    if(!_agree){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please agree to take proper care of the pet")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {

      await FirebaseFirestore.instance.collection('adoption_requests').add({
        'userName': _nameController.text.trim(),
        'userEmail': _emailController.text.trim(),
        'userPhone': _phoneController.text.trim(),
        'userAddress': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'pincode': _pincodeController.text.trim(),
        'hasPets': _hasPets,
        'reason': _reasonController.text.trim(),
        'petId': widget.petId,
        'petName': widget.petName,
        'status': 'Pending',
        'submittedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Adoption request submitted!")),
      );

      Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PaymentScreen(
      petName: widget.petName,
      petPrice: widget.petPrice,
    ),
  ),
);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting request: $e")),
      );

    } finally {

      setState(() {
        _isSubmitting = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Adopt ${widget.petName}"),
        backgroundColor: Colors.deepPurple,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (value) => value!.isEmpty ? "Enter your name" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? "Enter your email" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? "Enter phone number" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
                validator: (value) => value!.isEmpty ? "Enter address" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: "City"),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _pincodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Pincode"),
              ),

              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Do you already have pets?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              Row(
                children: [

                  Radio(
                    value: "Yes",
                    groupValue: _hasPets,
                    onChanged: (value){
                      setState(() {
                        _hasPets = value.toString();
                      });
                    },
                  ),
                  const Text("Yes"),

                  Radio(
                    value: "No",
                    groupValue: _hasPets,
                    onChanged: (value){
                      setState(() {
                        _hasPets = value.toString();
                      });
                    },
                  ),
                  const Text("No"),

                ],
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Reason for Adoption",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              CheckboxListTile(
                title: const Text("I agree to take proper care of the pet"),
                value: _agree,
                onChanged: (value){
                  setState(() {
                    _agree = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              _isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(

                      onPressed: _submitAdoptionRequest,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        minimumSize: const Size(double.infinity, 55),
                      ),

                      child: const Text(
                        "Submit Request",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),

            ],
          ),
        ),
      ),
    );
  }
}