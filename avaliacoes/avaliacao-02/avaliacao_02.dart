// Agregação e Composição
import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  Map toJson() => {
    'nome': _nome
  };
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  Map toJson() => {
    'nome': _nome,
    'dependentes': _dependentes
  };
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map toJson() => {
    'nomeProjeto': _nomeProjeto,
    'funcionarios': _funcionarios
  };
}

void main() {
  // 1. Criar varios objetos Dependentes
  Dependente d1 = Dependente("Kauã");
  Dependente d2 = Dependente("João");
  Dependente d3 = Dependente("Benjamin");
  Dependente d4 = Dependente("Sousa");

  // 2. Criar varios objetos Funcionario
  // 3. Associar os Dependentes criados aos respectivos
  //    funcionarios
  Funcionario f1 = Funcionario("Róger", [d1,d2]);
  Funcionario f2 = Funcionario("Davis", [d3,d4]);
  
  // 4. Criar uma lista de Funcionarios
  List<Funcionario> listaFuncs = [f1,f2];

  // 5. criar um objeto Equipe Projeto chamando o metodo
  //    contrutor que da nome ao projeto e insere uma
  //    coleção de funcionario
  EquipeProjeto equipe = EquipeProjeto("Os Nobres", listaFuncs);

  // 6. Printar no formato JSON o objeto Equipe Projeto.
  print(jsonEncode(equipe));
}