class AIChatModel {
  String name;
  List<String> stringList;
  String image;
  bool premium;
  String discription;
  String route;
  mainContainerType type;
  String? history;

  AIChatModel(this.name, this.stringList, this.image, this.premium,
      this.discription, this.route, this.type, this.history);
}

enum mainContainerType { normal, suggestions, avatar }
