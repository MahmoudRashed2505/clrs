import 'package:clrs/screens/ResultScreen.dart';
import 'package:clrs/widgets/RoundedButton.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  void _goNext(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ResultScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(
          0xFF3c3c3c,
        ),
        centerTitle: true,
        title: Text(
          "Colorize",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFF3c3c3c),
              Color(0xff000000)
            ], // red to yellow
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Image.asset('assets/main.png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 50,
                    left: 10,
                  ),
                  child: Text(
                    "Welcome on photo colorization app",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30, left: 10),
                  child: Text(
                    "please select photo from your gallery to colorize",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                )
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(top: 150),
                child: RoundedButton(
                  child: Center(
                    child: Text(
                      "Select Photo",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  btnWidth: 0.5,
                  action: _goNext,
                ))
          ],
        ),
      ),
    );
  }
}
