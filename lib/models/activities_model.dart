class ActivitiesModel {
  int? id;
  int profileId;
  String? tree, details, activity, plot, image, date;

  ActivitiesModel(
      {this.id,
      this.tree,
      this.activity,
      this.details,
      this.plot,
      this.image,
      this.date,
      required this.profileId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileId': profileId,
      'tree': tree,
      'details': details,
      'activity': activity,
      'image': image,
      'date': date,
      'plot': plot,
    };
  }

  factory ActivitiesModel.fromMap(Map<String, dynamic> map) {
    return ActivitiesModel(
      id: map['id'],
      profileId: map['profileId'],
      tree: map['tree'],
      details: map['details'],
      activity: map['activity'],
      image: map['image'],
      plot: map['plot'],
      date: map['date']
    );
  }
}
