class Filme {
  int? id;
  String imagemUrl;
  String titulo;
  String genero;
  String faixaEtaria;
  int duracao;
  double pontuacao;
  String descricao;
  int ano;

  Filme({
    this.id,
    required this.imagemUrl,
    required this.titulo,
    required this.genero,
    required this.faixaEtaria,
    required this.duracao,
    required this.pontuacao,
    required this.descricao,
    required this.ano,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagemUrl': imagemUrl,
      'titulo': titulo,
      'genero': genero,
      'faixaEtaria': faixaEtaria,
      'duracao': duracao,
      'pontuacao': pontuacao,
      'descricao': descricao,
      'ano': ano,
    };
  }
}
