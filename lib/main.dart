import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class ImageContainer extends StatelessWidget {
  final Widget child;
  final bool isBlackBorder;

  const ImageContainer({Key key, this.child, this.isBlackBorder = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: isBlackBorder ? Colors.black : Colors.grey, width: 4.0),
      ),
      child: child,
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Draggable Playground'),
    );
  }
}

class _HomePageState extends State<HomePage> {
  final choices = {
    "Love": "assets/images/love.png",
    "Sad": "assets/images/sad.png",
    "Haha": "assets/images/haha.png",
    "Cry": "assets/images/cry.png"
  };
  final Map<String, bool> scores = {};

  int seed = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.restore),
        onPressed: () {
          setState(() {
            scores.clear();
            seed++;
          });
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0.0,
      ),
      // extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            color: Colors.transparent,
            child: Column(
              children: [
                Container(
                  // color: Colors.pink,
                  height: 64,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Quiz",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
                Container(
                  // color: Colors.green,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 24),
                  child: Text(
                    "What are those?",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                Container(
                  // color: Colors.green,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 24),
                  child: Text(
                    "Drag and drop Emojies to match the description.",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                SizedBox(
                  height: 48,
                ),
                Row(
                  children: choices.keys
                      .map((e) => Expanded(
                            child: _buildDragTargetColumn(e),
                          ))
                      .toList()
                        ..shuffle(Random(seed)),
                ),
                SizedBox(
                  height: 64,
                ),
                Row(
                  children: choices.keys
                      .map((e) => Expanded(
                            child: _buildDraggableWidget(e),
                          ))
                      .toList(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableWidget(String label) {
    return Draggable<String>(
      feedback: ImageContainer(
        child: Image.asset(choices[label]),
      ),
      child: scores[label] == true
          ? ImageContainer(
              isBlackBorder: false,
            )
          : ImageContainer(
              child: Image.asset(choices[label]),
            ),
      data: label,
      childWhenDragging: ImageContainer(
        isBlackBorder: false,
      ),
    );
  }

  // Widget _buildImageContainer(String label) {
  //   return Container(
  //     height: 48,
  //     decoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //       border: Border.all(color: Colors.black, width: 4.0),
  //     ),
  //     child: Image.asset(choices[label]),
  //   );
  // }

  // Widget _buildFeedbackWidget(String)

  Widget _buildDragTargetColumn(String label) {
    return Column(
      children: [
        Text(label),
        SizedBox(height: 24),
        DragTarget<String>(
          builder: (context, candidateData, rejectedData) {
            if (scores[label] == true) {
              return ImageContainer(
                child: Image.asset(choices[label]),
              );
            } else {
              return ImageContainer(
                isBlackBorder: false,
              );
            }
          },
          onWillAccept: (data) => data == label,
          onAccept: (data) {
            setState(() {
              scores[label] = true;
            });
          },
          onLeave: (data) {},
        ),
      ],
    );
  }
}
