import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Bookticket(),
    );
  }
}

class Bookticket extends StatefulWidget {
  const Bookticket({super.key});

  @override
  State<Bookticket> createState() => _BookticketState();
}

class _BookticketState extends State<Bookticket> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ticketCountController = TextEditingController();

  // List of places with price
  final List<Map<String, dynamic>> places = [
    {"name": "Gir National Park", "price": 500},
    {"name": "Somnath Temple", "price": 200},
    {"name": "Rann of Kutch", "price": 300},
    {"name": "Diu Island", "price": 350},
    {"name": "Saputara Hill Station", "price": 400},
  ];

  String? selectedPlace;
  int ticketPrice = 0;

  // Generate and save PDF
  Future<void> _generateAndDownloadPDF(String name, String place, int tickets, int totalPrice) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.amber),
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text(
                      "🎟 Gujarat Tourist Ticket",
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.amber,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 15),
                  pw.Text("Name: $name", style: const pw.TextStyle(fontSize: 18)),
                  pw.Text("Place: $place", style: const pw.TextStyle(fontSize: 18)),
                  pw.Text("Tickets Booked: $tickets", style: const pw.TextStyle(fontSize: 18)),
                  pw.Text("Total Price: ₹$totalPrice", style: const pw.TextStyle(fontSize: 18)),
                  pw.SizedBox(height: 10),
                  pw.Text("Booking ID: ${DateTime.now().millisecondsSinceEpoch}",
                      style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey)),
                  pw.SizedBox(height: 20),
                  pw.Center(
                    child: pw.Text(
                      "✅ Ticket Booked Successfully!",
                      style: pw.TextStyle(
                        fontSize: 18,
                        color: PdfColors.green,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    try {
      final output = await getTemporaryDirectory(); // Use temp directory
      final file = File("${output.path}/Ticket_${name.replaceAll(" ", "_")}.pdf");
      await file.writeAsBytes(await pdf.save());

      // Open PDF
      await OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving/opening PDF: $e")),
      );
    }
  }

  void _bookTicket() {
    final name = nameController.text.trim();
    final ticketsText = ticketCountController.text.trim();

    if (name.isEmpty || ticketsText.isEmpty || selectedPlace == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and select a place!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final tickets = int.tryParse(ticketsText);
    if (tickets == null || tickets <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter valid ticket count"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final totalPrice = ticketPrice * tickets;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Ticket Booked Successfully! Total Price: ₹$totalPrice"),
        backgroundColor: Colors.green,
      ),
    );

    _generateAndDownloadPDF(name, selectedPlace!, tickets, totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Ticket"),
        backgroundColor: Colors.amberAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter Name:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Enter your name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Select Tourist Place:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedPlace,
              items: places.map((place) {
                return DropdownMenuItem<String>(
                  value: place['name'],
                  child: Text("${place['name']} (₹${place['price']})"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPlace = value;
                  ticketPrice = places.firstWhere((p) => p['name'] == value)['price'];
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.place),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Enter Number of Tickets:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: ticketCountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter ticket count",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.confirmation_number),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: _bookTicket,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Book & Download Ticket"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
