/*
    Aluno : Kauã Sousa de Oliveira
*/

import 'dart:convert';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class Aluno {
  int id;
  String nome;
  String matricula;

  Aluno(this.id, this.nome, this.matricula);

  Map toJson() => {
    "id": id,
    "nome": nome,
    "matricula": matricula
  };
}

class Disciplina {
  int id;
  String descricao;
  int qtdAulas;

  Disciplina(this.id, this.descricao, this.qtdAulas);

  Map toJson() => {
    "id": id,
    "descricao": descricao,
    "qtdAulas": qtdAulas
  };
}

class Professor {
  int id;
  String codigo;
  String nome;

  List<Disciplina> disciplinas = [];

  Professor(this.id, this.codigo, this.nome);

  void adicionarDisciplina(Disciplina disc) {
    disciplinas.add(disc);
  }

  Map toJson() => {
    "id": id,
    "codigo": codigo,
    "nome": nome,
    "disciplinas": disciplinas
  };
}

class Curso {
  int id;
  String descricao;

  List<Professor> professores = [];
  List<Disciplina> disciplinas = [];
  List<Aluno> alunos = [];

  Curso(this.id, this.descricao);

  void adicionarProfessor(Professor prof) {
    professores.add(prof);
  }

  void adicionarDisciplina(Disciplina disc) {
    disciplinas.add(disc);
  }

  void adicionarAluno(Aluno aluno) {
    alunos.add(aluno);
  }

  Map toJson() => {
    "id": id,
    "descricao": descricao,
    "professores": professores,
    "disciplinas": disciplinas,
    "alunos": alunos
  };
}

main() async {
  // Parte 1 : Criação dos Objetos.
  Aluno aluno1 = Aluno(0, "Kauã Sousa", "20231011060001");
  Aluno aluno2 = Aluno(1, "João Senna", "20231011060002");
  Aluno aluno3 = Aluno(2, "Mônica Nunes", "20231011060003");

  Disciplina disc1 = Disciplina(0, "BD", 80);
  Disciplina disc2 = Disciplina(1, "PDM II", 80);
  Disciplina disc3 = Disciplina(2, "PWEB I", 80);

  Professor prof1 = Professor(0, "RICDT", "Ricardo Duarte Taveira");
  prof1.adicionarDisciplina(disc1);
  prof1.adicionarDisciplina(disc2);

  Professor prof2 = Professor(1, "JBROB", "José Roberto Bezerra");
  prof2.adicionarDisciplina(disc3);

  Curso curso = Curso(0, "Informática");
  curso.adicionarProfessor(prof1);
  curso.adicionarProfessor(prof2);

  curso.adicionarDisciplina(disc1);
  curso.adicionarDisciplina(disc2);
  curso.adicionarDisciplina(disc3);

  curso.adicionarAluno(aluno1);
  curso.adicionarAluno(aluno2);
  curso.adicionarAluno(aluno3);

  final json = jsonEncode(curso);
  print("JSON a ser enviado por e-mail: $json");

  // Parte 2 : Envio do e-mail.
  final email = "kaua.sousa63@aluno.ifce.edu.br";
  final pass = "xzhb josz kmhq zanj";
  final name = "Kauã Sousa de Oliveira";

  final smtpServer = gmail(email, pass);

  final message = Message()
    ..from = Address(email, name)
    ..recipients.add("taveira@ifce.edu.br")
    ..subject = 'Prova-Prática-2 | JSON enviado'
    ..text = json;

  try {
    final sendReport = await send(message, smtpServer);

    print('E-mail enviado: $sendReport');
  } on MailerException catch (e) {
    print('Erro ao enviar e-mail: ${e.toString()}');
  }
}