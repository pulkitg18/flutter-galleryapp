import 'dart:async';
import 'package:mb_assignment/models/arts_model.dart';
import 'package:http/http.dart' as http;

enum ArtsAction { Fetch, Update }

class ArtsBloc {
  final _stateStreamController = StreamController<List<ArtsModel>>();

  StreamSink<List<ArtsModel>> get artsSink => _stateStreamController.sink;
  Stream<List<ArtsModel>> get artsStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<ArtsAction>.broadcast();

  StreamSink<ArtsAction> get eventSink => _eventStreamController.sink;
  Stream<ArtsAction> get eventStream => _eventStreamController.stream;

  final _searchStreamController = StreamController<String>.broadcast();
  StreamSink<String> get searchSink => _searchStreamController.sink;
  Stream<String> get searchStream => _searchStreamController.stream;

  ArtsBloc() {
    eventStream.listen((event) async {
      if (event == ArtsAction.Fetch) {
        try {
          var arts = await fetchArts("");
          print(arts[0].imageId);
          artsSink.add(arts);
        } on Exception catch (e) {
          print(e);
          print("req err");
        }
      }

      if (event == ArtsAction.Update) {
        searchStream.map((event) async {
          try {
            var arts = await fetchArts(event);
            artsSink.add(arts);
          } on Exception catch (e) {
            print(e);
            print("req err");
          }
        }).toList();
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
    _searchStreamController.close();
  }

  Future<List<ArtsModel>> fetchArts(String query) async {
    var client = http.Client();
    var url = Uri.https('api.artic.edu', '/api/v1/artworks/search', {
      "fields": "image_id,iiif_url,title,thumbnail,artist_display",
      "q": query
    });

    var response = await client.get(url);
    if (response.statusCode == 200) {
      var jsonString = response.body;

      var res = artsModelFromJson(jsonString);
      return res;
    } else {
      return [];
    }
  }
}
