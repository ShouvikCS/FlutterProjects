import 'articles.dart';

class Epicerie {
  final String nom;
  final DateTime dateDeCreation;
  final List<Article> articles;

  Epicerie(
      {required this.nom,
      required this.dateDeCreation,
      required this.articles});

  static Epicerie fromJson(Map<String, dynamic> json) => Epicerie(
        nom: json['nom'],
        dateDeCreation: DateTime.parse(json['dateDeCreation']),
        articles: (json['articles'] as List<dynamic>)
            .map((article) => Article.fromJson(article))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'nom': nom,
        'dateDeCreation': dateDeCreation.toIso8601String(),
        'articles': articles.map((article) => article.toJSON()).toList(),
      };
}
