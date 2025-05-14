class IpModel {
  final int id;
  final String address;
  final String ptr;

  IpModel({required this.id, required this.address, required this.ptr});

  factory IpModel.fromJson(Map<String, dynamic> json) {
    return IpModel(
      id: json['id'] ?? 0,
      address: json['address'] ?? '',
      ptr: json['ptr'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'address': address, 'ptr': ptr};
  }
}
