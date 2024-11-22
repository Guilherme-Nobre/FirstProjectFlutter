import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../db/DatabaseHelper.dart';

class FilmeFormScreen extends StatefulWidget {
  final VoidCallback onSaved;

  FilmeFormScreen({required this.onSaved});

  @override
  _FilmeFormScreenState createState() => _FilmeFormScreenState();
}

class _FilmeFormScreenState extends State<FilmeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String imagemUrl = '';
  String titulo = '';
  String genero = '';
  String faixaEtaria = 'Livre';
  double pontuacao = 0.0;
  int duracao = 0;
  String descricao = '';
  int ano = DateTime.now().year;

  Future<void> _saveFilme() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, dynamic> filme = {
        'imagemUrl': imagemUrl,
        'titulo': titulo,
        'genero': genero,
        'faixaEtaria': faixaEtaria,
        'duracao': duracao,
        'pontuacao': pontuacao,
        'descricao': descricao,
        'ano': ano,
      };
      await DatabaseHelper.instance.insertFilme(filme);
      widget.onSaved();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Filme')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Url Imagem'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (value) => imagemUrl = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (value) => titulo = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Gênero'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (value) => genero = value!,
              ),
              DropdownButtonFormField<String>(
                value: faixaEtaria,
                items: ['Livre', '10', '12', '14', '16', '18']
                    .map((faixa) =>
                        DropdownMenuItem(value: faixa, child: Text(faixa)))
                    .toList(),
                onChanged: (value) => setState(() => faixaEtaria = value!),
                decoration: InputDecoration(labelText: 'Faixa Etária'),
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Duração'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    duracao = int.parse(value);
                  }
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Text('Nota:'),
                    SizedBox(width: 10),
                    SmoothStarRating(
                      allowHalfRating: true,
                      onRatingChanged: (value) {
                        setState(() => pontuacao = value);
                      },
                      starCount: 5,
                      rating: pontuacao,
                      size: 30.0,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half,
                      color: Colors.blue,
                      borderColor: Colors.blue,
                      spacing: 0.0,
                    ),
                  ],
                ),
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
                initialValue: ano.toString(),
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    ano = int.parse(value);
                  } else {
                    ano = DateTime.now().year;
                  }
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                onSaved: (value) => descricao = value!,
              ),
              SizedBox(height: 20),
              FloatingActionButton(
                onPressed: _saveFilme,
                child: Icon(Icons.save),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
