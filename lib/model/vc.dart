class VCModel {
  String name;
  String description;
  String type;
  int icon;
  String urls;
  String schemaID;
  String credentialDefinitionID;
  String schema;
  String jwt;
  Map<String, dynamic> vc;

  VCModel(this.name, this.description, this.type, this.icon, this.urls, this.schemaID, this.credentialDefinitionID,
      this.schema, this.jwt, this.vc);

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
      case 'urls':
        return urls;
      case 'schemaID':
        return schemaID;
      case 'credentialDefinitionID':
        return credentialDefinitionID;
      case 'schema':
        return schema;
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
      case 'urls':
        urls = value;
        break;
      case 'schemaID':
        schemaID = value;
        break;
      case 'credentialDefinitionID':
        credentialDefinitionID = value;
        break;
      case 'schema':
        schema = value;
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
        urls = json['urls'],
        schemaID = json['schemaID'],
        credentialDefinitionID = json['credentialDefinitionID'],
        schema = json['schema'],
        jwt = json['jwt'],
        vc = json['vc'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'type': type,
        'icon': icon,
        'urls': urls,
        'schemaID': schemaID,
        'credentialDefinitionID': credentialDefinitionID,
        'schema': schema,
        'jwt': jwt,
        'vc': vc,
      };
}
