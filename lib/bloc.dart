import 'package:flutter_bloc/flutter_bloc.dart';
import 'models.dart';
import 'api_service.dart';
import 'database_helper.dart';

class AlbumBloc extends Cubit<List<Album>> {
  final ApiService apiService;
  final DatabaseHelper databaseHelper;

  AlbumBloc(this.apiService, this.databaseHelper) : super([]);

  Future<void> loadAlbums() async {
    try {
      final cachedAlbums = await databaseHelper.fetchAlbums();
      if (cachedAlbums.isNotEmpty) {
        emit(cachedAlbums);
      }
      final apiAlbums = await apiService.fetchAlbums();
      await databaseHelper.insertAlbums(apiAlbums);
      emit(apiAlbums);
    } catch (e) {
      print('Error loading albums: $e');
    }
  }
}

class PhotoBloc extends Cubit<Map<int, List<Photo>>> {
  final ApiService apiService;
  final DatabaseHelper databaseHelper;

  PhotoBloc(this.apiService, this.databaseHelper) : super({});

  Future<void> loadPhotos(int albumId) async {
    try {
      final cachedPhotos = await databaseHelper.fetchPhotos(albumId);
      if (cachedPhotos.isNotEmpty) {
        emit({...state, albumId: cachedPhotos});
      }
      final apiPhotos = await apiService.fetchPhotos(albumId);
      await databaseHelper.insertPhotos(apiPhotos);
      emit({...state, albumId: apiPhotos});
    } catch (e) {
      print('Error loading photos: $e');
    }
  }
}

