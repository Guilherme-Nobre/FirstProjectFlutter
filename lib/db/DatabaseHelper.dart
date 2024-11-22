import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('filmes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const String sql = '''
    CREATE TABLE filmes (
      id INTEGER PRIMARY KEY,
      imagemUrl TEXT,
      titulo TEXT,
      genero TEXT,
      faixaEtaria TEXT,
      duracao INTEGER,
      pontuacao REAL,
      descricao TEXT,
      ano INTEGER
    )
    ''';
    await db.execute(sql);
  }

  // Método de inserção com validação completa
  Future<int> insertFilme(Map<String, dynamic> filme) async {
    final db = await instance.database;

    // Validação e conversão de dados
    filme['duracao'] = _parseInteger(filme['duracao']);
    filme['pontuacao'] = _parseDouble(filme['pontuacao']);
    filme['ano'] = _parseInteger(filme['ano']);

    // Checa se os valores são nulos após a conversão
    if (filme['duracao'] == null || filme['ano'] == null) {
      throw Exception("Os campos 'duracao' e 'ano' devem ser números válidos.");
    }

    return await db.insert('filmes', filme);
  }

  Future<List<Map<String, dynamic>>> getFilmes() async {
    final db = await instance.database;
    return await db.query('filmes');
  }

  Future<int> updateFilme(Map<String, dynamic> filme) async {
    final db = await instance.database;
    int id = filme['id'];

    // Validação e conversão de dados no update
    filme['duracao'] = _parseInteger(filme['duracao']);
    filme['pontuacao'] = _parseDouble(filme['pontuacao']);
    filme['ano'] = _parseInteger(filme['ano']);

    if (filme['duracao'] == null || filme['ano'] == null) {
      throw Exception("Os campos 'duracao' e 'ano' devem ser números válidos.");
    }

    return await db.update(
      'filmes',
      filme,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteFilme(int id) async {
    final db = await instance.database;
    return await db.delete(
      'filmes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // Funções auxiliares para validação e conversão de dados
  int? _parseInteger(dynamic value) {
    if (value == null || value.toString().isEmpty) return null;
    return int.tryParse(value.toString());
  }

  double? _parseDouble(dynamic value) {
    if (value == null || value.toString().isEmpty) return null;
    return double.tryParse(value.toString());
  }
}

// https://i.imgur.com/4AiXzf8.jpg
// https://i.imgur.com/Nh9eZP5.jpg
// https://i.imgur.com/Ml6v14u.jpg
// https://i.imgur.com/vn0mKXs.jpg
// https://i.imgur.com/5qNYvKS.jpg
// https://i.imgur.com/QHndkBz.jpg
// https://i.imgur.com/R9x6jqz.jpg
// https://i.imgur.com/zMk5nEZ.jpg
// https://i.imgur.com/eBz1CVX.jpg