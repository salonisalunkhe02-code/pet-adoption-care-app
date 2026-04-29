import 'package:flutter/material.dart';
import 'home_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String petName;
  final int petPrice;

  const PaymentScreen({
    super.key,
    required this.petName,
    required this.petPrice,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  String paymentMethod = "UPI";

  final TextEditingController _priceController = TextEditingController();

  void completePayment() {

    int price = int.tryParse(_priceController.text) ?? 0;
    int total = price + 1000;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Payment Successful 🎉"),
        content: Text(
            "You have successfully adopted ${widget.petName}.\nPaid ₹$total"),
        actions: [

          TextButton(
            onPressed: () {

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen()),
                (route) => false,
              );

            },
            child: const Text("Go to Home"),
          )

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    int price = int.tryParse(_priceController.text) ?? 0;
    int total = price + 1000;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.deepPurple,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// PET SUMMARY

            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.pets, size: 40),
                title: Text(widget.petName),
                subtitle: const Text("Pet Adoption"),
              ),
            ),

            const SizedBox(height: 20),

            /// ENTER PRICE

            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Pet Price",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),

            const SizedBox(height: 20),

            /// ORDER SUMMARY

            const Text(
              "Order Summary",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Pet Price"),
                Text("₹$price"),
              ],
            ),

            const SizedBox(height: 5),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Adoption Charge"),
                Text("₹1000"),
              ],
            ),

            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "₹$total",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// PAYMENT METHOD

            const Text(
              "Payment Method",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            RadioListTile(
              title: const Text("UPI / Scan (GPay, PhonePe, Paytm)"),
              value: "UPI",
              groupValue: paymentMethod,
              onChanged: (value) {
                setState(() {
                  paymentMethod = value.toString();
                });
              },
            ),

            RadioListTile(
              title: const Text("Debit / Credit Card"),
              value: "CARD",
              groupValue: paymentMethod,
              onChanged: (value) {
                setState(() {
                  paymentMethod = value.toString();
                });
              },
            ),

            RadioListTile(
              title: const Text("Cash on Adoption"),
              value: "COD",
              groupValue: paymentMethod,
              onChanged: (value) {
                setState(() {
                  paymentMethod = value.toString();
                });
              },
            ),

            const Spacer(),

            /// PAY BUTTON

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(

                onPressed: completePayment,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.all(15),
                ),

                child: Text(
                  "Pay ₹$total",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}