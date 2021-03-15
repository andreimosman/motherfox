import 'dart:io';

import 'package:flutter/material.dart';

import 'picwithinsult.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';

void main() {
  runApp(PicsWithInsultsApp());
}

class Insult {
  final String number;
  final String language;
  final String insult;
  final String created;
  final String shown;
  final String createdby;
  final String active;
  final String comment;

  Insult({
    this.number,
    this.language,
    this.insult,
    this.created,
    this.shown,
    this.createdby,
    this.active,
    this.comment,
  });

  factory Insult.fromJson(Map<String, dynamic> json) {
    return Insult(
      number: json['number'],
      language: json['language'],
      insult: json['insult'],
      created: json['created'],
      shown: json['shown'],
      active: json['active'],
      comment: json['comment'],
    );
  }
}

class FoxImage {
  final String image;
  final String link;
  FoxImage({this.image, this.link});

  factory FoxImage.fromJson(Map<String, dynamic> json) {
    return FoxImage(
      image: json['image'],
      link: json['link'],
    );
  }
}

class PicsWithInsultsApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pics and Insults',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PicsWithInsultsHome(title: 'Pics and Insults'),
    );
  }
}

class PicsWithInsultsHome extends StatefulWidget {
  PicsWithInsultsHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PicsWithInsultsHomeState createState() => _PicsWithInsultsHomeState();
}

class _PicsWithInsultsHomeState extends State<PicsWithInsultsHome> {
  String imageUrl = '';
  String insultText = '';
  Image preloadedImage;

  String nextImageUrl = '';
  String nextInsultText = '';

  Image nextPreloadedImage;

  Future<FoxImage> fetchFoxImage() async {
    //
    final response = await http.get(Uri.https('randomfox.ca', '/floof/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return FoxImage.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Insult> fetchInsult() async {
    var queryParameters = {'lang': 'en', 'type': 'json'};
    final response = await http.get(
        Uri.https('evilinsult.com', '/generate_insult.php', queryParameters));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Insult.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<void> loadNextInsult() async {
    FoxImage fox = await fetchFoxImage();
    Insult insult = await fetchInsult();

    nextImageUrl = fox.image;
    var unescape = HtmlUnescape();
    nextInsultText = unescape.convert(insult.insult);

    nextPreloadedImage = Image.network(
      nextImageUrl,
      height: double.infinity,
      fit: BoxFit.fitHeight,
    );

    precacheImage(NetworkImage(nextImageUrl), context);
  }

  void _updateInsult() async {
    if (imageUrl.isEmpty) {
      // print("Image is empty!");
      await loadNextInsult();
    }

    setState(() {
      imageUrl = nextImageUrl;
      insultText = nextInsultText;
      preloadedImage = nextPreloadedImage;
    });

    loadNextInsult();

    /**
    FoxImage fox = await fetchFoxImage();
    Insult insult = await fetchInsult();

    setState(() {
      imageUrl = fox.image;
      var unescape = HtmlUnescape();
      insultText = unescape.convert(insult.insult);
    });
    // print(fox.image);
     */
  }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    _updateInsult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: PicWithInsult(preloadedImage, insultText),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateInsult,
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
