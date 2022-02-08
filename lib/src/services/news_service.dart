import 'package:flutter/material.dart';
import 'package:newsapp/src/models/category_model.dart';
import 'package:newsapp/src/models/news_models.dart';
import 'package:http/http.dart' as http;

final _URL_NEWS = "https://newsapi.org/v2";
final _APIKEY = "82fbfec89d824372af32c71c931c540b";

class NewsService with ChangeNotifier {
  List<Article> headlines = [];
  List<Category> categories = [
    Category(icon: Icons.business, name: 'business'),
    Category(icon: Icons.star_border_outlined, name: 'entertainment'),
    Category(icon: Icons.games_outlined, name: 'general'),
    Category(icon: Icons.health_and_safety_rounded, name: 'health'),
    Category(icon: Icons.local_convenience_store, name: 'science'),
    Category(icon: Icons.sports, name: 'sports'),
    Category(icon: Icons.military_tech_outlined, name: 'technology'),
  ];
  String _selectedCategory = 'business';
  //lista de articulos por categoria
  Map<String, List<Article>>? categoryArticles = {};
  NewsService() {
    getTopHeadlines();
    //inicializar valores
    categories.forEach((item) {
      categoryArticles![item.name!] = [];
    });
  }
  getTopHeadlines() async {
    final url = "$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=us";
    //PETICION HTTP
    final resp = await http.get(Uri.parse(url));
    final newsResponse = newsResponseFromJson(resp.body);
    //añadir todas los headers a la lista
    headlines.addAll(newsResponse.articles!);
    print(headlines);
    //propagar los cambios
    notifyListeners();
  }

  //metodo para la categoria
  String get selectedCategory => _selectedCategory;
  set selectedCategory(String valor) {
    _selectedCategory = valor;
    getArticlesByCategory(valor);
    notifyListeners();
  }

  //metodo para cargar la informacion en base a la categoria
  getArticlesByCategory(String category) async {
    //para devolver la info en caso de que ya este cargada
    if (categoryArticles![category]!.length > 0) {
      return categoryArticles![category];
    }

    final url =
        "$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=us&category=${category}";
    //PETICION HTTP
    final resp = await http.get(Uri.parse(url));
    final newsResponse = newsResponseFromJson(resp.body);
    //almacenar los datos
    categoryArticles![category]!.addAll(newsResponse.articles!);
    //propagar los cambios
    notifyListeners();
  }

  List<Article> get getArticulosCategoriaSeleccionada =>
      categoryArticles![selectedCategory]!;
}
