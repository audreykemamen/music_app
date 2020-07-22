import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';

import 'Music.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mziki',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Mziki'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Duration position = new Duration(seconds: 0);
  Duration musicDuration = new Duration(seconds: 10);
  StreamSubscription streamSubscription, stateSubscription;
  PlayerState playerState  = PlayerState.stopped;

  int index = 0;

  AudioPlayer audioPlayer;

  Music music;

  List<Music> musics = [
    new Music("Bye bye", "P-square", "musics/photo_2020-07-20_18-53-12.jpg", "https://codabee.com/wp-content/uploads/2018/06/un.mp3"),
    new Music("Bakandja", "Fally Ipupa", "musics/photo_2020-06-14_16-34-35.jpg", "https://codabee.com/wp-content/uploads/2018/06/deux.mp3")
  ];

  @override
  void initState() {
    super.initState();
    music = musics[index];
    configureAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: new SafeArea(
        child:
        new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
                new Card(
                  elevation: 10.0,
                  margin: EdgeInsets.only(top: 50.0),
                  child: new Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: new Image.asset(music.imagePath),
                  ),
                ),
                styledText(music.title, 1.5),
                styledText(music.artist, 1.0),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    setButton(Icons.fast_rewind, 30.0, ActionMusic.rewind),
                    setButton((playerState == PlayerState.playing) ? Icons.pause : Icons.play_arrow, 45.0, (playerState == PlayerState.playing) ? ActionMusic.pause : ActionMusic.play),
                    setButton(Icons.fast_forward, 30.0, ActionMusic.forward),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget> [
                    styledText((position.inMinutes < 10 ? "0" + position.inMinutes.toString() + ":" : position.inMinutes.toString() + ":") + (position.inMinutes < 10 ? "0" + position.inSeconds.toString() : position.inSeconds.toString()), 0.8),
                    styledText((audioPlayer.duration.inMinutes < 10 ? "0" + audioPlayer.duration.inMinutes.toString() + ":" : audioPlayer.duration.inMinutes.toString() + ":") + (audioPlayer.duration.inSeconds < 10 ? "0" + audioPlayer.duration.inSeconds.toString() : audioPlayer.duration.inSeconds.toString()), 0.8)
                  ],
                ),
                setSlider(audioPlayer.duration.inSeconds.toDouble())
              ],
            )
        ),
    )
    );
  }

  Text styledText(String text, double scale){
    return new Text(
      text,
      textScaleFactor: scale,
      style: new TextStyle(
        color: Colors.white70,
        fontSize: 20.0,
        fontStyle: FontStyle.italic
      ),
    );
  }


  IconButton setButton(IconData icon, double size, ActionMusic action){
    return new IconButton(
        icon: new Icon(icon),
        iconSize: size,
        color: Colors.white,
        onPressed: (){
          switch (action){
            case ActionMusic.play:
              play();
              break;
            case ActionMusic.pause:
              pause();
              break;
            case ActionMusic.rewind:
              rewind();
              break;
            case ActionMusic.forward:
              forward();
              break;
          }
        }
    );
  }

  Slider setSlider(double duration){
    return new Slider(
      activeColor: Colors.white,
      inactiveColor: Colors.white24,
      value: position.inSeconds.toDouble(),
      min: 0.0,
      max: duration,
      onChanged: (double d){
        setState(() {
          audioPlayer.seek(d);
        });
      },
    );
  }

  void configureAudioPlayer(){
    audioPlayer = new AudioPlayer();
    streamSubscription = audioPlayer.onAudioPositionChanged.listen(
        (pos) => setState(() => position = pos)
    );
    stateSubscription = audioPlayer.onPlayerStateChanged.listen((state){
        if(state == AudioPlayerState.PLAYING){
          setState(() {
            musicDuration = audioPlayer.duration;
          });
        }
        else if(state == AudioPlayerState.STOPPED) {
          setState(() {
            playerState = PlayerState.stopped;
          });
        }
      }, onError: (message){
      print('erreur: $message');
      setState(() {
        playerState = PlayerState.stopped;
        musicDuration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    }
    );
  }

  Future play() async{
    await audioPlayer.play(music.url);
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() {
      playerState = PlayerState.paused;
    });
  }

  void forward(){
    audioPlayer.stop();
    if(index == musics.length - 1) {
      index = 0;
    }
    else {
      index++;
    }
    music = musics[index];
    configureAudioPlayer();
    play();
  }

  void rewind(){
    if(position > Duration(seconds: 5)) {
      audioPlayer.seek(0.0);
    }
    else{
      audioPlayer.stop();
      if(index == 0) {
        index = musics.length - 1;
      }
      else {
        index--;
      }
      music = musics[index];
      configureAudioPlayer();
      play();
    }
  }


}

enum ActionMusic{
  play,
  pause,
  rewind,
  forward
}

enum PlayerState{
  playing,
  paused,
  stopped
}