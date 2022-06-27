import 'dart:developer';

import 'package:aduio_player/Screens/NowPlaying.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:aduio_player/LoadingScreen.dart';



void main(){
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: LoadingScreen(),
    );
  }
}
class AllSongs extends StatefulWidget {
  const AllSongs({Key? key}) : super(key: key);

  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  final OnAudioQuery _audioQuery=OnAudioQuery(); // i deleted the new _audioQuery because of this
  final AudioPlayer _audioPlayer = AudioPlayer();

  PlaySong(String? uri){
  try{
    _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
        _audioPlayer.play();

  } on Exception {
    log("Error parsing song");
  }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
  }

  void requestPermission(){
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF440346),
      appBar: AppBar(backgroundColor: const Color(0xFF804E85),
        title:  const Text("Music Player demo"),
      actions: [IconButton(onPressed: (){
      }, icon: const Icon(Icons.search),),
      ],
      ),
      body:
      FutureBuilder<List<SongModel>>(

        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true
        ),
        builder: (context,item) {
          if(item.data == null){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
            if(item.data!.isEmpty){
              return const Center(child: Text("No Songs found"));
            }
            return ListView.builder(itemCount: item.data!.length,
              itemBuilder: (context,index)=>ListTile(
              leading: const Icon(Icons.music_note),
              title:Text(item.data![index].displayName),
              subtitle: Text("${item.data![index].artist}"),
              trailing: const Icon(Icons.more_horiz),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>NowPlaying(songModel: item.data![index],audioPlayer: _audioPlayer,)));
              },
            ),);
        } ,
      ),
    );
  }
}



// class MySearchDelegate extends SearchDelegate {
//   List<AudioPlayer> SearchResults =[AudioPlayer()];
//   @override
//   Widget? buildLeading(BuildContext context) =>
//       IconButton(
//         icon: const Icon(Icons.arrow_back),
//         onPressed: () {},
//       );
//
//   @override
//   List<Widget>? buildActions(BuildContext context) =>[
//   IconButton(
//   icon: const Icon(Icons.clear),
//   onPressed: () {
//     if (query.isEmpty){
//       close(context,null);
//     }else{query='';}
//   },
//   ),
//   ];
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<SongModel> suggestions = [];
//     return ListView.builder(
//       itemCount: suggestions.length,
//       itemBuilder: (context, index) {
//         final suggestion = suggestions[index];
//         return ListTile(
//           title:Text(""),onTap: (){
//           query = '';
//           showResults(context);
//         },
//
//         );
//       },
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context){
//     List<SongModel> suggestions = [];
//     return ListView.builder(
//       itemCount: suggestions.length,
//       itemBuilder: (context, index) {
//         final suggestion = suggestions[index];
//         return ListTile(
//           title:Text(""),onTap: (){
//           query = '';
//           showResults(context);
//         },
//
//         );
//       },
//     );
//   }
//
//
//
// }

