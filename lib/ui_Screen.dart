import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_album/bloc.dart';
import 'models.dart';
import 'database_helper.dart';
import 'api_service.dart';

class AlbumScreen extends StatelessWidget {
  final AlbumBloc albumBloc = AlbumBloc(ApiService(), DatabaseHelper.instance);
  final PhotoBloc photoBloc = PhotoBloc(ApiService(), DatabaseHelper.instance);

  @override
  Widget build(BuildContext context) {
    albumBloc.loadAlbums();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums & Photos'),
      ),
      body: BlocBuilder<AlbumBloc, List<Album>>(
        bloc: albumBloc,
        builder: (context, albums) {
          if (albums.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: albums.length * 10000, // For infinite vertical looping
            itemBuilder: (context, index) {
              final album = albums[index % albums.length];
              return AlbumWidget(
                album: album,
                photoBloc: photoBloc,
              );
            },
          );
        },
      ),
    );
  }
}

class AlbumWidget extends StatelessWidget {
  final Album album;
  final PhotoBloc photoBloc;

  const AlbumWidget({required this.album, required this.photoBloc});

  @override
  Widget build(BuildContext context) {
    photoBloc.loadPhotos(album.id);

    return BlocBuilder<PhotoBloc, Map<int, List<Photo>>>(
      bloc: photoBloc,
      builder: (context, photosMap) {
        final photos = photosMap[album.id] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(album.title, style: const TextStyle(fontSize: 18)),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length * 10000, // For infinite horizontal looping
                itemBuilder: (context, index) {
                  final photo = photos[index % photos.length];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CachedNetworkImage(
                      imageUrl: photo.url.isNotEmpty ? photo.url : 'https://via.placeholder.com/150',
                      placeholder: (context, url) => const Icon(Icons.front_loader),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                    )
                    ,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

