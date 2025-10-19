import '../../domain/entities/client.dart';

class ClientModel {
  final int id;
  final String name;
  final String? email;

  ClientModel({required this.id, required this.name, this.email});

  factory ClientModel.fromEntity(Client entity) {
    return ClientModel(id: entity.id, name: entity.name, email: entity.email);
  }

  Client toEntity() {
    return Client(id: id, name: name, email: email);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
