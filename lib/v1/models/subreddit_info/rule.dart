import 'dart:convert';

class Rule {
  final String? kind;
  final String? description;
  final String? shortName;
  final String? violationReason;
  final int? createdUtc;
  final int? priority;
  final String? descriptionHtml;

  Rule({
    this.kind,
    this.description,
    this.shortName,
    this.violationReason,
    this.createdUtc,
    this.priority,
    this.descriptionHtml,
  });

  factory Rule.fromJson(Map<String, dynamic> json) => Rule(
        kind: json["kind"],
        description: json["description"],
        shortName: json["short_name"],
        violationReason: json["violation_reason"],
        createdUtc: (json["created_utc"] as double).toInt(),
        priority: json["priority"],
        descriptionHtml: json["description_html"],
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "description": description,
        "short_name": shortName,
        "violation_reason": violationReason,
        "created_utc": createdUtc,
        "priority": priority,
        "description_html": descriptionHtml,
      };
  static List<Rule> listFromJson(Map<String, dynamic> json) =>
      List<Rule>.from(json["rules"].map((x) => Rule.fromJson(x)));
}
