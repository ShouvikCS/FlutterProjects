import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tpfinal/providers/configdb.dart';
import '../providers/articles.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final _formKey = GlobalKey<FormState>();
  String _articleName = '';
  String _articleCUP = '';
  final User? user = Auth().currentUser;

  late ConfigDBProv dbProv;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dbProv = Provider.of<ConfigDBProv>(context, listen: false);
  }

  void addArticleToLocalDB(Article article) async {
    final db = await dbProv.database;
    await db.insert(
      'article',
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Stream<List<Article>> readArticles() => FirebaseFirestore.instance
      .collection('Articles')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Article.fromJson(doc.data())).toList());

  Widget buildArticle(Article article) => ListTile(
        leading: CircleAvatar(
          child: Text(article.nom[0] + article.nom[1] + article.nom[2]),
        ),
        title: Text(article.nom),
        subtitle: Text(
            'Added by ${article.personneQuiAjoute}  \non ${DateFormat('yyyy/MM/dd HH:mm a').format(article.dateAjout)} \nCUP: ${article.CUP}'),
        trailing: IconButton(
          icon: Icon(Icons.add, color: Colors.green),
          onPressed: () {
            addArticleToLocalDB(article);
            Navigator.of(context).pop();
          },
        ),
      );

  void _createArticle() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      DocumentReference ref =
          FirebaseFirestore.instance.collection('Articles').doc();

      await ref.set({
        'id': ref.id,
        'nom': _articleName,
        'CUP': _articleCUP,
        'personneQuiAjoute': user!.email,
        'dateAjout': DateTime.now(),
      });

      Navigator.of(context).pop();
    }
  }

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nouvel Article'),
          content: Container(
            height: 300.0,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Nom de l\'Article'),
                    validator: (value) => (value!.isEmpty || value.length < 3)
                        ? 'Entrez au moins 3 characteres'
                        : null,
                    onSaved: (value) => _articleName = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'CUP'),
                    validator: (value) =>
                        value!.isEmpty ? 'Entrez un CUP' : null,
                    onSaved: (value) => _articleCUP = value!,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Ajouter'),
              onPressed: _createArticle,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Articles'),
      ),
      body: StreamBuilder<List<Article>>(
        stream: readArticles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.hasData) {
            final articles = snapshot.data!;
            return ListView(
              children: articles.map(buildArticle).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showFormDialog(context),
      ),
    );
  }
}
