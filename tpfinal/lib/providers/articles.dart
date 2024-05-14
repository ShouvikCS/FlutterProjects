import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'configdb.dart';

enum ArticleStatus { enAttente, trouve, pasTrouve }

class Article extends ChangeNotifier {
  String id;
  final String nom;
  final String CUP;
  final String personneQuiAjoute;
  final DateTime dateAjout;
  ArticleStatus status;

  Article({
    required this.id,
    required this.nom,
    required this.CUP,
    required this.personneQuiAjoute,
    required this.dateAjout,
    this.status = ArticleStatus.enAttente,
  });

  void setStatus(BuildContext context, ArticleStatus newStatus) {
    status = newStatus;
    notifyListeners();
    Provider.of<ConfigDBProv>(context, listen: false).updateArticleStatus(
      id,
      status == ArticleStatus.enAttente
          ? 0
          : status == ArticleStatus.trouve
              ? 1
              : 2,
    );
  }

  Map<String, dynamic> toMap() => {
        'nom': nom,
        'CUP': CUP,
        'personneQuiAjoute': personneQuiAjoute,
        'dateAjout': dateAjout.toString(),
        'status': status == ArticleStatus.enAttente
            ? 0
            : status == ArticleStatus.trouve
                ? 1
                : 2,
      };

  Map<String, dynamic> toJSON() => {
        'id': id,
        'nom': nom,
        'CUP': CUP,
        'personneQuiAjoute': personneQuiAjoute,
        'dateAjout': dateAjout.toString(),
        'status': status == ArticleStatus.enAttente
            ? 0
            : status == ArticleStatus.trouve
                ? 1
                : 2,
      };

  static Article fromJson(Map<String, dynamic> json) => Article(
        id: json['id'],
        nom: json['nom'],
        CUP: json['CUP'],
        personneQuiAjoute: json['personneQuiAjoute'],
        dateAjout: (json['dateAjout'] as Timestamp).toDate(),
      );
}
