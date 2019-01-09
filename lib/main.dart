import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:painter/painter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';


String selectedAccident;
String eventType = "évenement";
bool selectedCritic = false;
bool showRadio = false;
int _radioValue = 0;
MaterialColor colorApp = Colors.blue;
File image;


void main() {

  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
    
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}


class SecondScreen extends StatefulWidget {
  @override
  _MyAppStateSecond createState() => _MyAppStateSecond();
}

class ImgScreen extends StatefulWidget {
  @override
  _MyAppStateImg createState() => _MyAppStateImg();
}

class MapsScreen extends StatefulWidget {
  @override
  _MyAppStateMaps createState() => _MyAppStateMaps();
}


class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  void changeAppColor(){
    if (selectedAccident == "Accident") {
      selectedCritic ? colorApp = Colors.red : colorApp = Colors.orange;
      showRadio = true;
    } else {
      selectedCritic ? colorApp = Colors.lime : colorApp = Colors.green;
      showRadio = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'VP TEST Valentin',
      theme: ThemeData(
        primarySwatch: colorApp,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Déclarer un '+eventType),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(12.0),
              // Selection du type
              child: Row(
                //ROW 1
                children: [
                  Padding(
                    padding: EdgeInsets.only(right:15.0),
                    child: Text(
                      'Type : ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      textAlign: TextAlign.center,
                    )
                  ),
                  Container(
                    child: new DropdownButton(
                      value: selectedAccident,
                      hint: new Text("Selectionnez une valeur"),
                      items: ['Accident', 'Presque accident'].map((String value) {
                        return new DropdownMenuItem(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedAccident = value;
                        setState(() {
                          eventType = value;
                          changeAppColor();
                        });
                      },
                    ),
                  ),
                ]
              ),
            ),

            //Affichage de la classification seulement si "Accident" est selectionné
            showRadio ? new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new Text(
                  'Classification : ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  textAlign: TextAlign.right,
                ),  
                Row(
                  //ROW 2.1
                  children: <Widget>[
                    new Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    new Text(
                      'Materiel',
                    ),
                  ]
                ),
                Row(
                  //ROW 2.2
                  children: <Widget>[
                    new Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    new Text(
                      'Humain',
                    ),
                  ]
                ),
                Row(
                  //ROW 2.3
                  children: <Widget>[
                    new Radio(
                      value: 2,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    new Text(
                      'Environnement',
                    ),
                  ]
                ),
              ]
            ) : new Container(),

            // Checkbox si critique
            Row(
              //ROW 3
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: new Text(
                    'Critique ?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
                new Checkbox(
                  value: selectedCritic,
                  onChanged: (value) {
                    setState(() {selectedCritic = value;
                      changeAppColor();
                    });
                  }
                ),
              ]
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: new Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            Column(
              children: <Widget>[ 
                new TextField(
                  decoration: InputDecoration(
                    hintText: 'Entrez une description',
                    border: new OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: RaisedButton(
                    child: Text('Annuler'),
                    onPressed: () {
                      // Annule tout
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: RaisedButton(
                    child: Text('Page suivante'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecondScreen()),
                      );
                    },
                  ),
                ),
              ],
            )
          ])
        )
      ),
    );
  }
}


class _MyAppStateMaps extends State<MapsScreen>{

  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: Column(
          children: <Widget>[
            Container(
              height:MediaQuery.of(context).size.height-80,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {},
                options: GoogleMapOptions(
                  cameraPosition: CameraPosition(
                    target: LatLng(0,0),
                  ),
                  myLocationEnabled: true,
                ),
              ),      
            ),
          ],
        ),
      ),
    );
  }
}



class _MyAppStateSecond extends State<SecondScreen> {
  // This widget is the root of your application.

  askPerm() async{
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.location]);
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    print(permissions);
    setState(() {});
  }

  picker() async {
    print('Picker is called');
    File img = await ImagePicker.pickImage(
      source: ImageSource.camera
    );
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primarySwatch: colorApp,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Déclarer un '+eventType+ ' - Page 2'),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Photo : ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
            ),
            Container(
              child: new Center(
                child: image == null
                  ? new Text('No Image to Show ')
                  : new Image.file(          
                      image, 
                      fit:BoxFit.cover,
                      height: 300,
                      width: 250,
                      alignment: Alignment.center,
                    ),
              ),
            ),
            FloatingActionButton(
              onPressed: picker,
              child: new Icon(Icons.camera_alt),
            ),
          
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                child: Text('Modifier'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImgScreen()),
                  );
                },
              ),
            ),

            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Géolocalisation : ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                ),
                Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onDoubleTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapsScreen()),
                    );
                    },
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        askPerm();
                        // print(location.getLocation());
                      },
                      options: GoogleMapOptions(
                        cameraPosition: CameraPosition(
                          target: LatLng(0, 0),
                        ),
                        rotateGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        zoomGesturesEnabled: false,
                        myLocationEnabled: true,
                      )
                    ),
                  ),
                ),
              ],
            ),


            //Boutons navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: RaisedButton(
                    child: Text('Annuler'),
                    onPressed: () {
                      // Annule tout
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: RaisedButton(
                    child: Text('Page précédente'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            )
          ])
        )
      ),
    );
  }
}


class _MyAppStateImg extends State<ImgScreen> {
bool _finished;
PainterController _controller;

  @override
  void initState() {
    super.initState();
    _finished=false;
    _controller=_newController();
  }


PainterController _newController(){
  PainterController controller=new PainterController();
  controller.thickness=5.0;
  controller.backgroundColor=Color.fromARGB(0, 200, 200, 200);
  return controller;
}

@override
Widget build(BuildContext context) {
    List<Widget> actions;
    if(_finished){
      actions = <Widget>[
        new IconButton(
          icon: new Icon(Icons.content_copy),
          tooltip: 'New Painting',
          onPressed: ()=>setState((){
            _finished=false;
            _controller=_newController();
          }),
        ),
      ];
    } else {
      actions = <Widget>[
        new IconButton(
            icon: new Icon(Icons.undo),
            tooltip: 'Undo',
            onPressed:  _controller.undo
        ),
        new IconButton(
            icon: new Icon(Icons.delete),
            tooltip: 'Clear',
            onPressed:  _controller.clear
        ),
        new IconButton(
            icon: new Icon(Icons.check),
            onPressed: ()=>_show( _controller.finish(),context)
        ),
      ];
    }
    return new Scaffold(
      appBar: new AppBar(
          title: const Text('Modifier la photo'),
          actions:actions,
          bottom: new PreferredSize(
            child: new DrawBar(_controller),
            preferredSize: new Size(MediaQuery.of(context).size.width,30.0),
          )
      ),
      body: new Center(
        
          child:new AspectRatio(
              aspectRatio: 1.0,
              child: new Painter( _controller)
          )
      ),
    );
  }

  void _show(PictureDetails picture,BuildContext context){
    setState(() {
      _finished=true;
    });
    Navigator.of(context).push(
        new MaterialPageRoute(builder: (BuildContext context){
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('View your image'),
            ),
            body: new Container(
                alignment: Alignment.center,
                child:new FutureBuilder<Uint8List>(
                  future:picture.toPNG(),
                  builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot){
                    switch (snapshot.connectionState)
                    {
                      case ConnectionState.done:
                        if (snapshot.hasError){
                          return new Text('Error: ${snapshot.error}');
                        }else{
                          return Image.memory(snapshot.data);
                        }
                        break;
                      default:
                        return new Container(
                            child:new FractionallySizedBox(
                              widthFactor: 0.1,
                              child: new AspectRatio(
                                  aspectRatio: 1.0,
                                  child: new CircularProgressIndicator()
                              ),
                              alignment: Alignment.center,
                            )
                        );
                    }
                  },
                )
            ),
          );
        })
    );
  }



// @override
//   Widget build(BuildContext context) {
//         return new MaterialApp(
//       theme: ThemeData(
//         primarySwatch: colorApp,
//       ),
//       home: new Scaffold(
//         appBar: new AppBar(
//           title: new Text('Déclarer un '+eventType+ ' - Page 3'),
//         ),
//         body: Column(children: <Widget>[

//         Container(
//           child: new Center(
//             child: image == null
//                 ? new Text('No Image to Show ')
//                 : new Image.file(image,
//                           fit:BoxFit.cover,
//           height: 400,
//           width: 325,
//           alignment: Alignment.center,
//                 ),
//           ),
          
//         ),


//           //Boutons navigation
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: RaisedButton(
//                   child: Text('Retour'),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: RaisedButton(
//                   child: Text('Sauvegarder'),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//             ],
//           )
//         ])
//       ),
// );
// }
}


class DrawBar extends StatelessWidget {

  final PainterController _controller;

  DrawBar(this._controller);

  @override
  Widget build(BuildContext context) {
    return  new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Flexible(
            child: new StatefulBuilder(
                builder: (BuildContext context,StateSetter setState){
                  return new Container(
                      child: new Slider(
                        value:  _controller.thickness,
                        onChanged: (double value)=>setState((){
                          _controller.thickness=value;
                        }),
                        min: 1.0,
                        max: 20.0,
                        activeColor: Colors.white,
                      )
                  );
                }
            )
        ),
        new ColorPickerButton( _controller, false),
      ],
    );
  }
}


class ColorPickerButton extends StatefulWidget {

  final PainterController _controller;
  final bool _background;

  ColorPickerButton(this._controller,this._background);

  @override
  _ColorPickerButtonState createState() => new _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: new Icon(_iconData,color: _color),
        tooltip: widget._background?'Change background color':'Change draw color',
        onPressed: _pickColor
    );
  }

  void _pickColor(){
    Color pickerColor=_color;
    Navigator.of(context).push(
        new MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context){
              return new Scaffold(
                  appBar: new AppBar(
                    title: const Text('Pick color'),
                  ),
                  body: new Container(
                      alignment: Alignment.center,
                      child: new ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: (Color c)=>pickerColor=c,
                      )
                  )
              );
            }
        )
    ).then((_){
      setState((){
        _color=pickerColor;
      });
    });
  }

  Color get _color=>widget._background?widget._controller.backgroundColor:widget._controller.drawColor;

  IconData get _iconData=>widget._background?Icons.format_color_fill:Icons.brush;

  set _color(Color color){
    if(widget._background){
      widget._controller.backgroundColor=color;
    } else {
      widget._controller.drawColor=color;
    }
  }
}