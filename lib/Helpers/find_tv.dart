import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tv_info/Modals/tv_show.dart';

class FindTv {
  final String mainUrl = "https://api.tvmaze.com/";

  Future<List<TvShow>> showSearch(String query) async {
    List<TvShow> TvShowList = [];
    var url = Uri.parse(mainUrl + 'search/shows?q=' + query);
    var response = await http.get(url);
    List data = jsonDecode(response.body);

    for (var shows in data) {
      TvShow tvShow = TvShow(
          shows['show']['name'],
          shows['show']['type'],
          shows['show']['name'],
          shows['show']['image'] != null
              ? shows['show']['image']['medium']
              : "");
      TvShowList.add(tvShow);
    }

    return TvShowList;
  }
}
