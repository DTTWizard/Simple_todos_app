// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class todoModel {
  int id;
  String tenCv;
  bool  complated;
  todoModel({
    required this.id,
    required this.tenCv,
    required this.complated,
  });



  todoModel copyWith({
    int? id,
    String? tenCv,
    bool? complated,
  }) {
    return todoModel(
      id: id ?? this.id,
      tenCv: tenCv ?? this.tenCv,
      complated: complated ?? this.complated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'tenCv': tenCv,
      'complated': complated,
    };
  }

  factory todoModel.fromMap(Map<String, dynamic> map) {
    return todoModel(
      id: map['id'] as int,
      tenCv: map['tenCv'] as String,
      complated: map['complated'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory todoModel.fromJson(String source) => todoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'todoModel(id: $id, tenCv: $tenCv, complated: $complated)';

  @override
  bool operator ==(covariant todoModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.tenCv == tenCv &&
      other.complated == complated;
  }

  @override
  int get hashCode => id.hashCode ^ tenCv.hashCode ^ complated.hashCode;
}
