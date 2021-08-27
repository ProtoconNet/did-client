class VPModel {
  VPModel(this.name, this.description, this.type, this.icon, this.schemaRequest, this.vc);

  String name;
  String description;
  String type;
  int icon;
  String schemaRequest;
  List<dynamic> vc;

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
      case 'schemaRequest':
        return schemaRequest;
      case 'vc':
        return vc;
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
      case 'schemaRequest':
        schemaRequest = value;
        break;
      case 'vc':
        vc = value;
        break;
    }
  }

  VPModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        type = json['type'],
        icon = json['icon'],
        schemaRequest = json['schemaRequest'],
        vc = json['vc'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'type': type,
        'icon': icon,
        'schemaRequest': schemaRequest,
        'vc': vc,
      };
}
