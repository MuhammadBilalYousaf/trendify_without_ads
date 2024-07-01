import 'dart:convert';

import '../models/slider_model.dart';
import 'package:http/http.dart' as http;

class Sliders {
  List<SliderModel> sliders = [];

  Future<void> getSlider(String selectedCountry, String selectedCategory) async {
    String url = "https://newsapi.org/v2/top-headlines?country=$selectedCountry&category=$selectedCategory&apiKey=6b2a40b1672a4c478e01f6df263e455f";

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      sliders.clear();
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element['description'] != null) {
          SliderModel sliderModel = SliderModel(
            title: element["title"],
            description: element["description"],
            urlToImage: element["urlToImage"],
            url: element["url"],
            content: element["content"],
            author: element["author"],
          );
          sliders.add(sliderModel);
        }
      });
    }
  }
}
