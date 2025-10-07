import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> touristPlaces = [
    {
      "name": "Gir National Park",
      "description": "Home to the majestic Asiatic lions, offering wildlife safaris and nature exploration.",
      "price": 500
    },
    {
      "name": "Somnath Temple",
      "description": "One of the twelve Jyotirlinga shrines of Lord Shiva, located on the Arabian Sea coast.",
      "price": 200
    },
    {
      "name": "Rann of Kutch",
      "description": "A white salt desert famous for the Rann Utsav, culture, and breathtaking sunsets.",
      "price": 300
    },
    {
      "name": "Diu Island",
      "description": "A serene coastal getaway known for Portuguese architecture and beautiful beaches.",
      "price": 350
    },
    {
      "name": "Saputara Hill Station",
      "description": "A scenic hill station in the Western Ghats with lush greenery and boating facilities.",
      "price": 400
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gujarat Tourist Guide"),
        backgroundColor: Colors.amberAccent,
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: touristPlaces.length,
          itemBuilder: (context, index) {
            final place = touristPlaces[index];
            return Card(
              elevation: 5,
              shadowColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.place, color: Colors.amber, size: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            place['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      place['description'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ticket: ₹${place['price']}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Booked ticket for ${place['name']}",
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart_checkout),
                          label: const Text("Book Ticket"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
