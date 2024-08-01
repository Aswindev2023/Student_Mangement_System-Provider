class User {
  int? id;
  String? address;
  String? name;
  String? batch;
  String? contact;
  String? imagePath;

  Map<String, dynamic> userMap() {
    return {
      'id': id,
      'name': name!,
      'batch': batch!,
      'contact': contact!,
      'address': address!,
      'imagePath': imagePath ?? '',
    };
  }
}
