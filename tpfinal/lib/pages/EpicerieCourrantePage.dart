import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/articles.dart';
import '../providers/configdb.dart';
import '../providers/epicerie.dart';
import 'ArticlesPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';
import 'EpicerieListPage.dart';

class EpicerieCourrantePage extends StatefulWidget {
  @override
  _EpicerieCourrantePageState createState() => _EpicerieCourrantePageState();
}

class _EpicerieCourrantePageState extends State<EpicerieCourrantePage> {
  late ConfigDBProv dbProv;
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    dbProv = Provider.of<ConfigDBProv>(context, listen: false);
    loadArticles();
  }

  void loadArticles() async {
    articles = await dbProv.getAllArticles();
    setState(() {});
  }

  final User? user = Auth().currentUser;

  Future<void> _signOut() async {
    try {
      await Auth().signOut();
    } catch (e) {
      print(e);
    }
  }

  Widget _buildUser() {
    if (user != null) {
      return Text(user!.email!);
    } else {
      return Text('No user');
    }
  }

  Widget _buildSignOutButton() {
    return ElevatedButton(
      onPressed: _signOut,
      child: Text('Sign Out'),
    );
  }

  SaveEpicerie() async {
    String? name = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String? enteredName;

        return AlertDialog(
          title: Text('Enter Epicerie Name'),
          content: TextField(
            onChanged: (value) {
              enteredName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                if (enteredName != null && enteredName!.isNotEmpty) {
                  Navigator.of(context).pop(enteredName);
                } else {
                  // Handle invalid nom input, montre un message d'erreur
                }
              },
            ),
          ],
        );
      },
    );

    if (name != null) {
      Epicerie epicerie = Epicerie(
        nom: name,
        dateDeCreation: DateTime.now(),
        articles: articles,
      );

      FirebaseFirestore.instance.collection('Epicerie').add(epicerie.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Epicerie de ${user!.email ?? 'null'}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ListTile(
                  title: Text(article.nom),
                  subtitle: Text('Added by ${article.personneQuiAjoute} '),
                  tileColor: article.status == ArticleStatus.trouve
                      ? Colors.green
                      : article.status == ArticleStatus.pasTrouve
                          ? Colors.red
                          : Colors.orangeAccent,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          setState(() {
                            article.setStatus(context, ArticleStatus.trouve);
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            article.setStatus(context, ArticleStatus.pasTrouve);
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.hourglass_empty,
                            color: Colors.orangeAccent),
                        onPressed: () {
                          setState(() {
                            article.setStatus(context, ArticleStatus.enAttente);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArticlePage()),
                    );
                    loadArticles();
                  },
                  child: Text('Ajouter Article'),
                ),
                ElevatedButton(
                  onPressed: () {
                    SaveEpicerie();
                  },
                  child: Text('SAVE'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EpicerieListPage()),
                    );
                  },
                  child: Text('LOAD'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
