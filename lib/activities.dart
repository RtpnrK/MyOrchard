import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myorchard/activityDetail.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  late double width, height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffA9C46C),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Stack(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Activities', style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold
                    ),),
                    SizedBox(width: 20,),
                    ImageIcon(
                      AssetImage('assets/icons/gardening.png'), 
                      color: Colors.white,
                      size: 40,),
                   
                  ],
                ),
                Positioned(
                  left: 20,
                  child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 35,)))
              ],
            ),
            const Divider(
              color: Colors.white,
              height: 30,
              thickness: 2,
              indent: 40,
              endIndent: 40,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: width*0.9,
              height: height*0.65,
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                     NoteCard(
                      onTap: (){
                        Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => const ActivityDetail()));
                      },
                      height: height*0.15, 
                      width: width*0.9, 
                      image: Image.asset('assets/images/map1.png', fit: BoxFit.cover,), 
                      title: 'Title', 
                      description: 'Description'),
                      NoteCard(
                      height: height*0.15, 
                      width: width*0.9, 
                      image: Image.asset('assets/images/map1.png', fit: BoxFit.cover,), 
                      title: 'Title', 
                      description: 'Description'),
                      NoteCard(
                      height: height*0.15, 
                      width: width*0.9, 
                      image: Image.asset('assets/images/map1.png', fit: BoxFit.cover,), 
                      title: 'Title', 
                      description: 'Description'),
                      NoteCard(
                      height: height*0.15, 
                      width: width*0.9, 
                      image: Image.asset('assets/images/map1.png', fit: BoxFit.cover,), 
                      title: 'Title', 
                      description: 'Description'),
                      NoteCard(
                      height: height*0.15, 
                      width: width*0.9, 
                      image: Image.asset('assets/images/map1.png', fit: BoxFit.cover,), 
                      title: 'Title', 
                      description: 'Description'),
                      NoteCard(
                      height: height*0.15, 
                      width: width*0.9, 
                      image: Image.asset('assets/images/map1.png', fit: BoxFit.cover,), 
                      title: 'Title', 
                      description: 'Description'),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))
              ),
              elevation: 8,
              child: SizedBox(
                width: width*0.9,
                height: height*0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: (){}, 
                      icon: const ImageIcon(AssetImage('assets/icons/csv.png'),
                       size: 50,
                       color: Color.fromARGB(255, 96, 126, 25))),
                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      icon: const Icon(Icons.home,
                       size: 50, 
                       color: Color.fromARGB(255, 96, 126, 25),)),
                    IconButton(
                      onPressed: () => _createNewCard(context), 
                      icon: const Icon(Icons.add_circle,
                       size: 50, 
                       color: Color.fromARGB(255, 96, 126, 25),))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _createNewCard(BuildContext context){
    return showDialog(
      barrierColor: Colors.black26,
      context: context, 
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: AlertDialog(
            insetPadding: const EdgeInsets.fromLTRB(10, 20, 10, 60),
            title: const Text('New Activity',
             textAlign: TextAlign.center,
             style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28),),
            content: Column(
              children: [
                const Divider(
                  thickness: 2,
                  color: Colors.black26,
                ),
                const SizedBox(height: 10,),
                Container(
                  width: width*0.5,
                  height: width*0.5,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    color: Colors.black12,
                    shape: BoxShape.circle
                  ),
                  child: const Center(
                    child: Icon(Icons.upload, size: 65, color: Colors.black26,),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width*0.4,
                      height: 50,
                      child: const TextField(
                        decoration: InputDecoration(
                          label: Text('Name'),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          )
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    SizedBox(
                      width: width*0.3,
                      height: 50,
                      child: const TextField(
                        decoration: InputDecoration(
                          label: Text('Date'),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          )
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          
          ),
        );
      });
  }
}

// Card template
class NoteCard extends StatelessWidget {
  final double height;
  final double width;
  final Image image;
  final String title;
  final String description;
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
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
        margin: const EdgeInsets.only(bottom: 15),
        elevation: 5,
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              Container(
                width: width*0.4,
                height: height*0.75,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    child: image),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(title, style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                    ),),
                    const Divider(
                      color: Colors.black26,
                      height: 5,
                      endIndent: 30,
                    ),
                    Text(description, style: const TextStyle(
                      fontSize: 18
                    ),),
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
