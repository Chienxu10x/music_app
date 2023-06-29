import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NextPlaying extends StatefulWidget {
  const NextPlaying({super.key, required this.songModel, required this.audioPlayer });
  final SongModel songModel;
  final AudioPlayer audioPlayer;

  @override
  State<NextPlaying> createState() => _NextPlayingState();
}

class _NextPlayingState extends State<NextPlaying> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
