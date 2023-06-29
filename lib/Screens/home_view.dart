import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/Screens/nowplaying.dart';
import 'package:music/data_color.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class AllSongs extends StatefulWidget {
  const AllSongs({Key? key}) : super(key: key);

  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {


  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();

  }

  void requestPermission(){
    Permission.storage.request();
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Music"),

      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (item.data!.isEmpty) {
            return const Center(child: Text("No Songs found"));
          }
          return ListView.builder(

              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  color: getRandomColor(),
                  child: ListTile(
                    title: Text(item.data![index].displayNameWOExt),
                    subtitle: Text("${item.data![index].artist}"),
                    trailing: const Icon(Icons.more_horiz),
                    leading: QueryArtworkWidget(
                      controller: _audioQuery,
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                    ),

                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NowPlaying(songModel:item.data![index], audioPlayer: _audioPlayer)
                          )
                      );
                    },
                  ),
                );

              }

          );
        },
      ),

    );
  }

}