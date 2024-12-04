class Album {
  final int id;
  final String title;

  Album({required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(id: json['id'], title: json['title']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }
}

class Photo {
  final int id;
  final String url;
  final int albumId;

  Photo({required this.id, required this.url, required this.albumId});

  factory Photo.fromJson(Map<String, dynamic> json) {
    // Ensure `url` is not null
    final url = json['url'] ?? '';  // Default to empty string if null
    return Photo(id: json['id'], url: url, albumId: json['albumId']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'url': url, 'albumId': albumId};
  }
}


