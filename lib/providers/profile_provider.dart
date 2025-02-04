import 'package:flutter/material.dart';
import 'package:myorchard/models/profileModel.dart';

class ProfileProvider extends ChangeNotifier {
  final List<Profilemodel> list_profiles = [
    
  ];

  void addProfile(String image, String name,List profile) async {
    list_profiles.add(Profilemodel(image: image, name: name, profile: profile));
    notifyListeners();
  }

  void removeProfile(Profilemodel profile) {
    list_profiles.remove(profile);
    notifyListeners();
  }
}
