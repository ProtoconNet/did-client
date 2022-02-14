class VPModel {
  VPModel(this.name, this.description, this.type, this.icon, this.endPoint);

  String name;
  String description;
  String type;
  int icon;
  String endPoint;

  getField(field) {
    switch (field) {
      case 'name':
        return name;
      case 'description':
        return description;
      case 'type':
        return type;
      case 'icon':
        return icon;
      case 'endPoint':
        return endPoint;
    }
  }

  setField(field, value) {
    switch (field) {
      case 'name':
        name = value;
        break;
      case 'description':
        description = value;
        break;
      case 'type':
        type = value;
        break;
      case 'icon':
        icon = value;
        break;
      case 'endPoint':
        endPoint = value;
        break;
    }
  }

  VPModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        type = json['type'],
        icon = json['icon'],
        endPoint = json['endPoint'];

  Map<String, dynamic> toJson() =>
      {'name': name, 'description': description, 'type': type, 'icon': icon, 'endPoint': endPoint};
}
