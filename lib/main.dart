import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  double position = 0.0;

  Music music;

  List<Music> musics = [
    new Music("Bye bye", "P-square", "musics/photo_2020-07-20_18-53-12.jpg", "https://www.youtube.com/watch?v=-sF80KIqTW0"),
    new Music("Bakandja", "Fally Ipupa", "musics/photo_2020-06-14_16-34-35.jpg", "https://www.youtube.com/watch?v=Zi6V_xs-2i8")
  ];

  @override
  void initState() {
    super.initState();
    music = musics[0];
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
                    setButton(Icons.play_arrow, 45.0, ActionMusic.play),
                    setButton(Icons.fast_forward, 30.0, ActionMusic.forward),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget> [
                    styledText('0:0', 0.8),
                    styledText('03:45', 0.8)
                  ],
                ),
                new Slider(
                  activeColor: Colors.white,
                  inactiveColor: Colors.white24,
                  value: position,
                  min: 0.0,
                  max: 45.0,
                  onChanged: (double d){
                      setState(() {
                        position = d;
                      });
                  },
                )
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
              print('Play');
              break;
            case ActionMusic.pause:
              print('Pause');
              break;
            case ActionMusic.rewind:
              print('Rewind');
              break;
            case ActionMusic.forward:
              print('Forward');
              break;
          }
        }
    );
  }
}

enum ActionMusic{
  play,
  pause,
  rewind,
  forward
}