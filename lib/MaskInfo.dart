class MaskInfo {
  final String type;
  final List<Feature> features;

  MaskInfo({this.type, this.features});

  factory MaskInfo.fromJson(Map<String, dynamic> json) {
    List<Feature> _features;
    if (json['features'] != null) {
      var featuresJsonObject = json['features'] as List;
      _features = featuresJsonObject
          .map((feature) => Feature.fromJson(feature))
          .toList();
    }
    return MaskInfo(
      type: json['type'],
      features: _features,
    );
  }
}

class Feature {
  final String type;
  final Properties properties;

  Feature({this.type, this.properties});

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      type: json['type'],
      properties: Properties.fromJson(json['properties']),
    );
  }
}

class Properties {
  final String name;
  final String address;
  final String phone;
  final int maskAdult;
  final int maskChild;

  Properties(
      {this.name, this.address, this.phone, this.maskAdult, this.maskChild});

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      maskAdult: json['mask_adult'],
      maskChild: json['mask_child'],
    );
  }
}
