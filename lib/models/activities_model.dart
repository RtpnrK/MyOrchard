class ActivitiesModel {
  int? id;
  int profileId;
  String? tree;
  String? details;
  String? activity;
  List? plot;
  
  ActivitiesModel(
      {this.id,
      this.tree,
      this.activity,
      this.details,
      this.plot,
      required this.profileId});
}
