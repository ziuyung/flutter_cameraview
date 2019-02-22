import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_cameraview/flutter_cameraview.dart';

import 'settings_page.dart';

Future<Null> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "flutter_cameraview example",
        theme: new ThemeData(
            primarySwatch: Colors.blue,
        ),
        home: MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget  {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraViewController _cameraViewController; 
  Icon _flashButtonIcon = Icon(Icons.flash_off);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flutter_cameraview example'),
        ),
        body: Stack(
          children: <Widget>[
            CameraView(
              onCreated: _onCameraViewCreated
            ),
            
            //Flash button
            Positioned(
              top: 8.0,
              right: 8.0,
              width: 40.0,
              height: 40.0,
              child: new Builder (builder: (BuildContext _context) {return new IconButton(
                  color: Colors.white,
                  iconSize: 25.0,
                  icon: _flashButtonIcon,
                  onPressed:  () => _onFlashButtonPressed (_context),
              );}) 
            ),

            //Picture capture button
            Positioned(
              bottom: 20.0,
              width: 60.0,
              height: 60.0,
              left: (MediaQuery.of(context).size.width/2 - 30),
              child: new RaisedButton(
                padding: EdgeInsets.all(10.0),
                shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                ),
                child: new Icon(Icons.camera_alt, size: 30.0, color: Colors.blue),
                onPressed: () => _onTakePictureButtonPressed,
              ),
            ),


            //Camera facing button
            Positioned(
              bottom: 120,
              width: 40.0,
              height: 40.0,
              right: 15.0,
              child: new IconButton(
                color: Colors.white,
                icon: new Icon(Icons.switch_camera, size: 25.0),
                onPressed: () => _onCameraFacingButtonPressed,
              ),
            ),

            //Settings button
            Positioned(
              bottom: 20.0,
              width: 40.0,
              height: 40.0,
              right: 15.0,
              child: new IconButton(
                color: Colors.white,
                icon: new Icon(Icons.settings, size: 25.0),
                onPressed: () => _onSettingsButtonPressed (context),
              ),
            )
          ],
        ),
      ),
    );
  }
 
  void _onCameraViewCreated(CameraViewController controller){
      _cameraViewController = controller;
  }

  void _onFlashButtonPressed(BuildContext context) async {
      Flash flash = await _cameraViewController.getFlash();
      Icon icon;
      String _msg;
      switch(flash) {
        case Flash.Off:
          flash = Flash.On;
          _msg = "Flash On";
          icon = Icon(Icons.flash_on);
          break;

        case Flash.On:
          flash = Flash.Auto;
          _msg = "Flash Auto";
          icon = Icon(Icons.flash_auto);
          break;

        case Flash.Auto:
          flash = Flash.Torch;
          _msg = "Torch Mode";
          icon = Icon(Icons.highlight);
          break;

        case Flash.Torch:
          flash = Flash.Off;
          _msg = "Flash Off";
          icon = Icon(Icons.flash_off);
          break;
      }
      
      await _cameraViewController.setFlash(flash);

      setState(() {
        _flashButtonIcon = icon;
      });

      ScaffoldState scaffoldState = Scaffold.of(context);
      scaffoldState.removeCurrentSnackBar();
      scaffoldState.showSnackBar(new SnackBar(content: new Text(_msg) , duration: Duration( seconds: 2)));
  }

  void _onTakePictureButtonPressed() async {
    //_cameraViewController.takePicture(filepath);
  }

  void _onCameraFacingButtonPressed() async {

  }

  void _onSettingsButtonPressed(BuildContext context) async {
     Navigator.push(context, new MaterialPageRoute(builder: (context) => new SettingsPage()));
  }
}
