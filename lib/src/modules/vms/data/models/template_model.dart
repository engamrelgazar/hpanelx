class TemplateModel {
  final int id;
  final String name;
  final String description;
  final String? documentation;

  TemplateModel({
    required this.id,
    required this.name,
    required this.description,
    this.documentation,
  });

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      documentation: json['documentation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'documentation': documentation,
    };
  }
}
