import 'package:flutter/material.dart';
import 'package:mb_assignment/blocs/arts_bloc.dart';
import 'package:mb_assignment/models/arts_model.dart';
import 'package:mb_assignment/pages/art.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final artsBloc = ArtsBloc();

  Widget appBarTitle = new Text(
    "Images",
    style: new TextStyle(color: Colors.white),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    artsBloc.eventSink.add(ArtsAction.Fetch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
        new IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(
                  Icons.close,
                  color: Colors.white,
                );
                this.appBarTitle = new TextField(
                  onChanged: (val) {
                    setState(() {
                      artsBloc.searchSink.add(val);
                      artsBloc.eventSink.add(ArtsAction.Update);
                    });
                  },
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white),
                  ),
                );
              } else {
                _handleSearchEnd();
              }
            });
          },
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<ArtsModel>>(
          stream: artsBloc.artsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error occured");
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Art(snapshot.data![index])));
                    },
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              snapshot.data![index].imageId,
                              width: MediaQuery.of(context).size.width,
                              // height: MediaQuery.of(context).size.width,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                            // Text(snapshot.data![index].imageId),
                            Positioned(
                              bottom: 5,
                              left: 10,
                              child: Text(
                                snapshot.data![index].title,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                        offset: Offset(1.0, 1.0),
                                      ),
                                    ]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                        Divider(
                          height: 40,
                        )
                      ],
                    ),
                  );
                },
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Search Sample",
        style: new TextStyle(color: Colors.white),
      );
    });
  }
}
