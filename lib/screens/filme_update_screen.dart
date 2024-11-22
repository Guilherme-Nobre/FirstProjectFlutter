import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../db/DatabaseHelper.dart';

class FilmeUpdateScreen extends StatefulWidget {
  final VoidCallback onSaved;
  final Map<String, dynamic>? filme; // Parâmetro para editar filme

  FilmeUpdateScreen({required this.onSaved, this.filme});

  @override
  _FilmeUpdateScreenState createState() => _FilmeUpdateScreenState();
}

class _FilmeUpdateScreenState extends State<FilmeUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  String imagemUrl = '';
  String titulo = '';
  String genero = '';
  String faixaEtaria = 'Livre';
  double pontuacao = 0.0;
  int duracao = 0;
  String descricao = '';
  int ano = DateTime.now().year;
  int? filmeId;

  @override
  void initState() {
    super.initState();
    // Se houver filme para edição, preenche os campos com os dados
    if (widget.filme != null) {
      var filme = widget.filme!;
      imagemUrl = filme['imagemUrl'] ?? '';
      titulo = filme['titulo'] ?? '';
      genero = filme['genero'] ?? '';
      faixaEtaria = filme['faixaEtaria'] ?? 'Livre';
      pontuacao = filme['pontuacao'] ?? 0.0;
      duracao = filme['duracao'] ?? 0;
      descricao = filme['descricao'] ?? '';
      ano = filme['ano'] ?? DateTime.now().year;
      filmeId = filme['id']; // Armazena o ID para o update
    }
  }

  Future<void> _saveFilme() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, dynamic> filme = {
        'id': filmeId, // Inclui o ID para atualização
        'imagemUrl': imagemUrl,
        'titulo': titulo,
        'genero': genero,
        'faixaEtaria': faixaEtaria,
        'duracao': duracao,
        'pontuacao': pontuacao,
        'descricao': descricao,
        'ano': ano,
      };

      try {
        // Verifica a atualização de filme
        if (filmeId != null) {
          int result = await DatabaseHelper.instance.updateFilme(filme);
          if (result > 0) {
            print('Filme atualizado com sucesso!');
          } else {
            print(
                'Erro ao atualizar o filme. Verifique os dados e tente novamente.');
          }
        } else {
          int result = await DatabaseHelper.instance.insertFilme(filme);
          if (result > 0) {
            print('Filme inserido com sucesso!');
          } else {
            print(
                'Erro ao inserir o filme. Verifique os dados e tente novamente.');
          }
        }
      } catch (e) {
        print('Ocorreu um erro: $e');
      }

      widget.onSaved();
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(filmeId == null ? 'Cadastrar Filme' : 'Editar Filme')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: imagemUrl,
                decoration: InputDecoration(labelText: 'Url Imagem'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (value) => imagemUrl = value!,
              ),
              TextFormField(
                initialValue: titulo,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (value) => titulo = value!,
              ),
              TextFormField(
                initialValue: genero,
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
                initialValue: duracao.toString(),
                decoration: InputDecoration(labelText: 'Duração'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (value) => duracao = int.parse(value!),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Text('Nota:'),
                    SizedBox(width: 10),
                    SmoothStarRating(
                      allowHalfRating: true,
                      onRatingChanged: (value) =>
                          setState(() => pontuacao = value),
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
                initialValue: ano.toString(),
                decoration: InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
                onSaved: (value) => ano = int.parse(value!),
              ),
              TextFormField(
                initialValue: descricao,
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
