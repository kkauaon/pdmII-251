import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() {
  // Abrir conexão com banco SQLite na memória (pode salvar em arquivo se preferir)
  final db = sqlite3.open('aluno.db');

  // Criar tabela TB_ALUNO
  db.execute('''
    CREATE TABLE IF NOT EXISTS TB_ALUNO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL CHECK(length(nome) <= 50)
    );
  ''');

  print('Tabela TB_ALUNO criada ou já existente.');

  bool running = true;

  while (running) {
    print('\nEscolha uma opção:');
    print('1 - Inserir novo aluno');
    print('2 - Listar todos os alunos');
    print('0 - Sair');
    stdout.write('Opção: ');
    String? option = stdin.readLineSync();

    switch (option) {
      case '1':
        inserirAluno(db);
        break;
      case '2':
        listarAlunos(db);
        break;
      case '0':
        running = false;
        break;
      default:
        print('Opção inválida, tente novamente.');
        break;
    }
  }

  db.dispose();
  print('Programa finalizado.');
}

void inserirAluno(Database db) {
  stdout.write('Digite o nome do aluno (máx 50 caracteres): ');
  String? nome = stdin.readLineSync();

  if (nome == null || nome.trim().isEmpty) {
    print('Nome não pode ser vazio.');
    return;
  }
  if (nome.length > 50) {
    print('Nome deve ter no máximo 50 caracteres.');
    return;
  }

  final stmt = db.prepare('INSERT INTO TB_ALUNO (nome) VALUES (?)');
  stmt.execute([nome.trim()]);
  stmt.dispose();

  print('Aluno "$nome" inserido com sucesso.');
}

void listarAlunos(Database db) {
  final ResultSet result = db.select('SELECT id, nome FROM TB_ALUNO ORDER BY id;');

  if (result.isEmpty) {
    print('Nenhum aluno cadastrado.');
    return;
  }

  print('\nLista de alunos:');
  for (final row in result) {
    print('ID: ${row['id']}, Nome: ${row['nome']}');
  }
}
