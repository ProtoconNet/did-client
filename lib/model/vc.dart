class VCModel {
  String name;
  String description;
  String type;
  int icon;
  String schemaRequest;
  String jwt;
  Map<String, dynamic> vc;

  VCModel(this.name, this.description, this.type, this.icon, this.schemaRequest, this.jwt, this.vc);

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
      case 'jwt':
        return jwt;
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
      case 'jwt':
        jwt = value;
        break;
      case 'vc':
        vc = value;
        break;
    }
  }

  VCModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        type = json['type'],
        icon = json['icon'],
        schemaRequest = json['schemaRequest'],
        jwt = json['jwt'],
        vc = json['vc'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'type': type,
        'icon': icon,
        'schemaRequest': schemaRequest,
        'jwt': jwt,
        'vc': vc,
      };
}
