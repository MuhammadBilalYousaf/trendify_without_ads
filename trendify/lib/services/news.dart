import 'dart:convert';

import '../models/article_model.dart';
import 'package:http/http.dart' as http;

class News{
  List<ArticleModel> news = [];


Future <void> getNews() async {
  // String url = "https://newsapi.org/v2/everything?q=tesla&from=2024-04-25&sortBy=publishedAt&apiKey=6b2a40b1672a4c478e01f6df263e455f";
  // String url = "https://newsapi.org/v2/everything?from=2024-04-25&sortBy=publishedAt&apiKey=6b2a40b1672a4c478e01f6df263e455f&q=trending";
  // String url = "https://newsapi.org/v2/everything?from=2024-04-25&sortBy=publishedAt&apiKey=eaeca90b6c80420bbe53d9bc429cb761";


  String url = "https://newsapi.org/v2/everything?q=tesla&from=2024-04-28&sortBy=publishedAt&apiKey=eaeca90b6c80420bbe53d9bc429cb761"; //new mail api

  
  var responce = await http.get(Uri.parse(url));

  var jsonData = jsonDecode(responce.body);

  if(jsonData['status']=='ok')
  {
    jsonData["articles"].forEach((element){
      if(element["urlToImage"]!=null && element['description']!=null)
      {
        ArticleModel articleModel = ArticleModel(
          title: element["title"],
          description: element["description"],
          urlToImage: element["urlToImage"],
          url: element["url"],
          content: element["content"],
          author: element["author"],
        );
        news.add(articleModel);
      }
    });
  }
}

}