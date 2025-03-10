class ActivitiesModel {
  bool isSelected;
  int? id;
  int profileId;
  String? tree, details, activity, plot, image, date, executor;

  ActivitiesModel(
      {this.id,
      this.tree,
      this.activity,
      this.details,
      this.plot,
      this.image,
      this.date,
      this.executor,
      this.isSelected = false,
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
      'executor': executor,
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
      date: map['date'],
      executor:map['executor']
    );
  }
}
