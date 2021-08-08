class VC {
  final String name;
  final String description;
  final String type;
  final int icon;
  final String schemaRequest;
  final String jwt;
  final Map<String, dynamic> vc;

  VC(this.name, this.description, this.type, this.icon, this.schemaRequest, this.jwt, this.vc);

  VC.fromJson(Map<String, dynamic> json)
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
