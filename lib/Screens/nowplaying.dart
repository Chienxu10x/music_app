import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key, required this.songModel, required this.audioPlayer }) : super(key: key);
  final SongModel songModel;
  final AudioPlayer audioPlayer;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  late AnimationController _rotationController;
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isPlaying = false;
  bool _isLooping = false;
  double _speed = 1;
  double _volume = 0.5;


  @override
  void initState() {
  // TODO: implement initState
  super.initState();

  playSong();

  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void playSong() {
    try {
      widget.audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(widget.songModel.uri!)));
      widget.audioPlayer.play();//stop and run
    } on Exception {
      log("message");
    }
    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  void playBackSong(){
    if(widget.audioPlayer.playing){
      widget.audioPlayer.stop();
    }

    widget.audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(widget.songModel.uri!)));
    widget.audioPlayer.play();
  }

  void playNextSong() {
    if(widget.audioPlayer.playing){
      widget.audioPlayer.stop();
    }
    widget.audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(widget.songModel.uri!)));
    widget.audioPlayer.play();

  }


  void setSpeed(double speed){
    widget.audioPlayer.setSpeed(speed);
  }
  

  void setLoopMode(bool isLooping) {
    setState(() {
      _isLooping = isLooping;
    });
    final loopMode = isLooping ? LoopMode.one : LoopMode.off;
    widget.audioPlayer.setLoopMode(loopMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(onPressed: (){
                Navigator.pop(context);

              }, icon: const Icon(Icons.arrow_back_ios)),
              const SizedBox(
                height: 30.0,
              ),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 100.0,
                      child: Icon(
                        Icons.music_note,
                        size: 80,),

                    ),
                    const SizedBox(
                        height: 30
                    ),
                    Text(widget.songModel.displayNameWOExt,
                        overflow:
                        TextOverflow.fade,
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                    )),
                    const SizedBox(
                        height: 10
                    ),
                    Text(widget.songModel.artist.toString() == "<unknown"
                        ? "Unknown Artist"
                        : widget.songModel.artist.toString(),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                      )
                    ),
                    Row(
                      children: [
                        Text(_position.toString().split(".")[0]),
                        Expanded(
                          child: Slider(
                            min: const Duration(microseconds: 0)
                                .inSeconds
                                .toDouble(),
                            value: _position.inSeconds.toDouble(),
                            max: _duration.inSeconds.toDouble(),
                            onChanged: (value){
                              setState(() {
                                changToSeconds(value.toInt());
                                value = value;
                              });
                          },
                          ),
                        ),
                        Text(_duration.toString().split(".")[0]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(onPressed: (){
                          setLoopMode(!_isLooping);
                        },
                            icon: Icon(_isLooping ? Icons.loop : Icons.lock_reset_outlined)),
                        IconButton(onPressed: (){
                          playBackSong();
                        }, icon: const Icon(Icons.skip_previous)),

                        IconButton(onPressed: (){
                          setState(() {
                            if(_isPlaying){
                              widget.audioPlayer.play();
                            } else {
                              widget.audioPlayer.pause();
                            }
                            _isPlaying = !_isPlaying;
                          });
                        }, icon: Icon(
                            _isPlaying ? Icons.play_arrow : Icons.pause,
                        )),
                        IconButton(onPressed: (){
                          playNextSong();
                        }, icon: const Icon(Icons.skip_next)),
                        
                        TextButton(onPressed: (){
                          _speed++;
                          if(_speed>3){
                            _speed=1;
                          }
                          setSpeed(_speed);
                        },
                            child: Text('$_speed'"X"))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _volume == 0 ? const Icon(Icons.volume_off) :
                        (_volume > 0 && _volume <= 0.3) ? const Icon(Icons.volume_mute) :
                        (_volume > 0.3 && _volume <= 0.7) ? const Icon(Icons.volume_down) : const Icon(Icons.volume_up_sharp),
                        Slider(
                          min: 0,
                          value: _volume,
                          max: 1,
                          onChanged: (value) {
                            setState(() {
                              _volume = value;
                              setVolume(value);
                            });
                          },
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void setVolume(double volume) {
    setState(() {
      _volume = volume;
    });
    widget.audioPlayer.setVolume(volume);
  }


  void changToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

}
