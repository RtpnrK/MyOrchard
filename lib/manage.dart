import 'package:flutter/material.dart';

class Manage extends StatefulWidget {
  const Manage({super.key});

  @override
  State<Manage> createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  late double width, height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      endDrawer: const Drawer(
        child: Column(),
      ),
      body: Container(
        color: const Color.fromARGB(255, 2, 172, 135),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.forest_outlined,
                    color: Colors.white,
                    size: 60,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Orchard \nManagement',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        NoteCard(
                            height: 150,
                            width: width * 0.9,
                            image: Image.asset('assets/images/map1.png'),
                            title: const Text(
                              'Title',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            description: const Text('Description')),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(
            icon: Icon(Icons.navigation_outlined), label: 'Map'),
        NavigationDestination(icon: Icon(Icons.chat_outlined), label: 'Log'),
        NavigationDestination(
            icon: Icon(Icons.person_2_outlined), label: 'Profile'),
      ]),
    );
  }
}

class NoteCard extends StatelessWidget {
  final double height;
  final double width;
  final Image image;
  final Text title;
  final Text description;
  const NoteCard(
      {super.key,
      required this.height,
      required this.width,
      required this.image,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        margin: const EdgeInsets.only(top: 20),
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: image,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  title,
                  description,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
