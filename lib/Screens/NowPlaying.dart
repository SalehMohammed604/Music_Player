import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key, required this.songModel,required this.audioPlayer}) : super(key: key);
  final SongModel songModel;
  final AudioPlayer audioPlayer;


  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {


  Duration _duration= Duration();
  Duration _position= Duration();
  bool _isPlaying =false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playSong();
    _isPlaying =true;
  }

  void playSong(){
    try{widget.audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(widget.songModel.uri!))
    );
    widget.audioPlayer.play();
    }on Expanded{
      log("Cannot Parse song");
    }
    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration=d!;
      });
    });

    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position=p;
      });
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(width:double.infinity,padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_ios)
            ),
            SizedBox(
              height: 30.0,
            ),
            Center(child: Column(children: [
              CircleAvatar(
                radius: 100.0,child: Icon(Icons.music_note,size: 80.0,),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text("${widget.songModel.displayNameWOExt}",overflow: TextOverflow.fade,maxLines: 1,style: TextStyle(
                fontWeight: FontWeight.bold,fontSize: 30.0
              ),
              ),
              SizedBox(
                height: 10.0
              ),
              Text(widget.songModel.artist.toString()== "<Unknown>" ? "Unknown Artist":widget.songModel.artist.toString(),overflow: TextOverflow.fade,maxLines: 1,style: TextStyle(
                  fontWeight: FontWeight.bold,fontSize: 10.0
              ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Text(_position.toString().split(".")[0]),
                  Expanded(child: Slider(
                      min:Duration(microseconds: 0).inSeconds.toDouble(),
                      value:_position.inSeconds.toDouble(),
                      max: _duration.inSeconds.toDouble(),
                      onChanged: (value){
                    setState(() {
                      changeToSeconds(value.toInt());
                      value=value;
                    });
                  })),
                  Text(_duration.toString().split(".")[0]),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(onPressed: (){
                    if(_duration.inSeconds == 0 || _duration.inSeconds <10){
                      seekTo(0);
                    }else if(_duration.inSeconds >10){
                      seekTo(_position.inSeconds -10 );
                    }
                  }, icon: Icon(Icons.skip_previous,size: 40.0,),),
                  IconButton(onPressed: (){

                    setState(() {
                      if(_isPlaying){
                        widget.audioPlayer.pause();

                      }else{
                        widget.audioPlayer.play();
                      }
                      _isPlaying =!_isPlaying;
                    });
                  }, icon: Icon(_isPlaying ? Icons.pause:Icons.play_arrow,size: 40.0,color: Colors.orangeAccent,),),
                  IconButton(onPressed: (){
                    if(_position<_duration -Duration(seconds: 10)){
                      seekTo(_position.inSeconds +10);
                    }else{
                      seekTo(_duration.inSeconds);
                      setState(() {
                        _isPlaying=false;
                      });
                      _isPlaying=false;
                    }
                  }, icon: Icon(Icons.skip_next,size: 40.0,),),

                ],
              ),
            ],
            ),
            )
          ],
        ),
        ),
      ),
    );
  }

  seekTo(int sec){
    widget.audioPlayer.seek(Duration(seconds: sec));

  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);

  }
}
