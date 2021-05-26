import 'package:flutter/material.dart';
import 'package:mb_assignment/models/arts_model.dart';

class Art extends StatefulWidget {
  final ArtsModel artData;

  Art(this.artData);
  @override
  _ArtState createState() => _ArtState();
}

class _ArtState extends State<Art> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.artData.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenIMG(
                      image: widget.artData.imageId,
                      title: widget.artData.title,
                    ),
                  ));
            },
            child: Stack(
              children: [
                Image.network(
                  widget.artData.imageId,
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(
                    Icons.fullscreen,
                    size: 50,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Text(
            "${widget.artData.artistDisplay}",
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}

class FullScreenIMG extends StatelessWidget {
  final String image;
  final String title;

  FullScreenIMG({required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: InteractiveViewer(
        maxScale: 5,
        child: Image.network(
          image,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
