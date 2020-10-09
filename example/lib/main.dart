import 'package:flutter/material.dart';
import './landscape_player/landscape_player.dart';
import 'animation_player/animation_player.dart';
import 'custom_orientation_player/custom_orientation_player.dart';
import 'default_player/default_player.dart';
import 'feed_player/feed_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flick player example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Color.fromRGBO(246, 245, 250, 1),
        body: SafeArea(child: Examples()),
      ),
    );
  }
}

class Examples extends StatefulWidget {
  const Examples({Key key}) : super(key: key);

  @override
  _ExamplesState createState() => _ExamplesState();
}

class _ExamplesState extends State<Examples> {
  final List<Map<String, dynamic>> samples = [
    {'name': 'Default player', 'widget': DefaultPlayer()},
    {'name': 'Animation player', 'widget': Expanded(child: AnimationPlayer())},
    {'name': 'Feed player', 'widget': Expanded(child: FeedPlayer())},
    {'name': 'Custom orientation player', 'widget': CustomOrientationPlayer()},
    {'name': 'Landscape player', 'widget': LandscapePlayer()},
  ];

  int selectedIndex = 0;

  changeSample(int index) {
    if (samples[index]['widget'] is LandscapePlayer) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LandscapePlayer(),
      ));
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: samples[selectedIndex]['widget'],
        ),
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: samples.asMap().keys.map((index) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      changeSample(index);
                    },
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          samples.asMap()[index]['name'],
                          style: TextStyle(
                            color: index == selectedIndex
                                ? Color.fromRGBO(100, 109, 236, 1)
                                : Color.fromRGBO(173, 176, 183, 1),
                            fontWeight:
                                index == selectedIndex ? FontWeight.bold : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList()),
        ),
      ],
    );
  }
}
