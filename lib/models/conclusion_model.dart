
class ConclusionModel {

  ConclusionModel({
    this.text,
    this.createdAt,
    this.updatedAt,
    this.isValidated,
    this.isApproved,
    this.headDoctorName,
  });

  factory ConclusionModel.fromJson(Map<dynamic, dynamic> json) {
    return ConclusionModel(
      text: json['text'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isValidated: json['isValidated'],
      isApproved: json['isApproved'],
      headDoctorName: json['headDoctorName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isValidated': isValidated,
      'isApproved': isApproved,
      'headDoctorName': headDoctorName,
    };
  }
  
  final String? text;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isValidated;
  final bool? isApproved;
  final String? headDoctorName;

  ConclusionModel copyWith({
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isValidated,
    bool? isApproved,
    String? headDoctorName,
  }) {
    return ConclusionModel(
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isValidated: isValidated ?? this.isValidated,
      isApproved: isApproved ?? this.isApproved,
      headDoctorName: headDoctorName ?? this.headDoctorName,
    );
  }
}
