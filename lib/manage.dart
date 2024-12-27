import 'package:flutter/material.dart';

class Manage extends StatefulWidget {
  const Manage({super.key});

  @override
  State<Manage> createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  late double width, height;
  int pageIndex = 0;
  TransformationController viewTranformationController = TransformationController(); 

@override
  void initState() {
    viewTranformationController = TransformationController(
      Matrix4.identity()..scale(0.3)
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: Visibility(
        visible: pageIndex == 0 || pageIndex == 1,
        child: pageIndex == 0? FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color.fromARGB(255, 2, 172, 135),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        ):
        FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color.fromARGB(255, 0, 62, 148),
          child: const Icon(
            Icons.gps_fixed,
            color: Colors.white,
            size: 32,)
        ),
      ),
      body: <Widget>[
        // ######################### Home Page ###########################
        Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 2, 172, 135),
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
                      child: Center(
                        child: Column(
                          children: [
                            NoteCard(
                                height: 150,
                                width: width * 0.9,
                                image: Image.asset('assets/images/map1.png',
                                    fit: BoxFit.cover),
                                title: const Text(
                                  'Title',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                description: const Text('Description')),
                            NoteCard(
                                height: 150,
                                width: width * 0.9,
                                image: Image.asset('assets/images/map4.png',
                                    fit: BoxFit.cover),
                                title: const Text(
                                  'Title',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                description: const Text('Description')),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              right: 10,
              top: 60,
              child: PopupMenuButton(
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 40,
                    color: Colors.white,
                  ),
                  itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(child: Text('Select All')),
                        const PopupMenuItem(child: Text('Upload to CSV')),
                        const PopupMenuItem(child: Text('Delete'))
                      ]))
        ],
      ),
      // ########################### Map Page ###########################
      Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 2, 172, 135),
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
                      size: 50,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Orchard Management',
                        style: TextStyle(
                            fontSize: 25,
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
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('Live Map',style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold),),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: SizedBox(
                                width: width*0.95,
                                child: InteractiveViewer(
                                  transformationController: viewTranformationController,
                                  minScale: 0.1,
                                  maxScale: 0.5,
                                  constrained: false,
                                  child: Image.asset('assets/images/map1.png')),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      // ##################### Log Page ########################
      Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 2, 172, 135),
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
                      size: 50,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Orchard Management',
                        style: TextStyle(
                            fontSize: 25,
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
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Log Page')
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      // ####################### Profile Page #############################
       Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 2, 172, 135),
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
                      size: 50,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Orchard Management',
                        style: TextStyle(
                            fontSize: 25,
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
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Profile Page')
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      ][pageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
             pageIndex = index;
          });
        },
        destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(
            icon: Icon(Icons.navigation_outlined), label: 'Map'),
        NavigationDestination(icon: Icon(Icons.chat_outlined), label: 'Log'),
        NavigationDestination(
            icon: Icon(Icons.person_2_outlined), label: 'Profile'),
      ],
      selectedIndex: pageIndex,),
    );
  }
}

// Card template
class NoteCard extends StatelessWidget {
  final double height;
  final double width;
  final Image image;
  final Text title;
  final Text description;
  final VoidCallback? onTap;
  const NoteCard(
      {super.key,
      required this.height,
      required this.width,
      required this.image,
      required this.title,
      required this.description,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        margin: const EdgeInsets.only(top: 20),
        elevation: 8,
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 150,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    child: image),
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
      ),
    );
  }
}
