import 'package:dio/dio.dart';
import 'models.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Album>> fetchAlbums() async {
    final response =
    await _dio.get('https://jsonplaceholder.typicode.com/albums');
    return (response.data as List)
        .map((json) => Album.fromJson(json))
        .toList();
  }

  Future<List<Photo>> fetchPhotos(int albumId) async {
    try {
      final response = await _dio.get(
        'https://jsonplaceholder.typicode.com/photos',
        queryParameters: {'albumId': albumId},
      );
      if (response.statusCode == 200) {
        // Safely parse the response and handle missing values
        return (response.data as List)
            .map((json) => Photo.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (e) {
      print('Error fetching photos: $e');
      return [];
    }
  }

}
