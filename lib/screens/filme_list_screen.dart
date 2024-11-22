import 'package:flutter/material.dart';
import 'package:myapp/screens/filme_details_screen.dart';
import 'package:myapp/screens/filme_form_screen.dart';
import 'package:myapp/screens/filme_update_screen.dart';
import '../db/DatabaseHelper.dart';

class FilmeListScreen extends StatefulWidget {
  @override
  _FilmeListScreenState createState() => _FilmeListScreenState();
}

class _FilmeListScreenState extends State<FilmeListScreen> {
  List<Map<String, dynamic>> filmes = [];

  @override
  void initState() {
    super.initState();
    _loadFilmes();
  }

  Future<void> _loadFilmes() async {
    final data = await DatabaseHelper.instance.getFilmes();
    setState(() {
      filmes = data;
    });
  }

  void _deleteFilme(int id) async {
    await DatabaseHelper.instance.deleteFilme(id);
    _loadFilmes(); // Recarrega a lista após a exclusão
  }

  Widget _buildRatingStars(double rating) {
    int filledStars = rating.floor();
    bool halfStar = rating - filledStars >= 0.5;
    return Row(
      children: List.generate(5, (index) {
        if (index < filledStars) {
          return Icon(Icons.star, color: Colors.yellow);
        } else if (index == filledStars && halfStar) {
          return Icon(Icons.star_half, color: Colors.yellow);
        } else {
          return Icon(Icons.star_border, color: Colors.yellow);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Movies'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Criador:"),
                  content: Text("Guilherme Nóbrega Firmino"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Fechar"),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filmes.length,
        itemBuilder: (context, index) {
          final filme = filmes[index];
          return Dismissible(
            key: Key(filme['id'].toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: AlignmentDirectional.centerEnd,
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              _deleteFilme(filme['id']);
            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: Image.network(
                  filme['imagemUrl'],
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  filme['titulo'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      '${filme['genero']} - ${filme['duracao']} min',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    _buildRatingStars(filme['pontuacao']),
                  ],
                ),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text('O que você gostaria de fazer?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Fecha o diálogo
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FilmeDetailsScreen(filme: filme),
                                ),
                              );
                            },
                            child: Text('Exibir Dados'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop(); // Fecha o diálogo
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FilmeUpdateScreen(
                                    onSaved: () {},
                                    filme: filme,
                                  ),
                                ),
                              );
                              if (result == true) {
                                _loadFilmes(); // Recarrega a lista após a atualização
                              }
                            },
                            child: Text('Alterar'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FilmeFormScreen(onSaved: _loadFilmes),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
