import 'package:flutter/material.dart';

class PicWithInsult extends StatelessWidget {
  final Image preloadedImage;
  // final String imageUrl;
  final String insult;

  // PicWithInsult(this.imageUrl, this.insult);
  PicWithInsult(this.preloadedImage, this.insult);

  @override
  Widget build(BuildContext context) {
    return insult.length > 0
        ? Container(
            child: (Stack(
              children: [
                preloadedImage,
                Container(
                  width: double.infinity,
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      insult,
                      style: TextStyle(
                        // backgroundColor: Colors.red,
                        color: Colors.white,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            )),
          )
        : Container();

    /**
    return Container(
      height: 500,
      width: 500,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Text("teste"),
        ],
      ),
    );
    */
  }
}
