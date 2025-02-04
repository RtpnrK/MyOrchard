class Profilemodel {
  String image;
  String name;
  List? profile = [];

  Profilemodel({
    required this.image,
    required this.name,
    this.profile = const [],
  });
}

