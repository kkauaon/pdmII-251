import 'package:flutter/material.dart';
import '../models/cliente_model.dart';
import '../models/produto_model.dart';
import '../models/fornecedor_model.dart';
import '../models/pedido_model.dart';

class AppProvider with ChangeNotifier {
  // Listas para armazenar os dados
  final List<Cliente> _clientes = [];
  final List<Produto> _produtos = [];
  final List<Fornecedor> _fornecedores = [];
  final List<Pedido> _pedidos = [];

  // Getters para acessar as listas de fora da classe
  List<Cliente> get clientes => _clientes;
  List<Produto> get produtos => _produtos;
  List<Fornecedor> get fornecedores => _fornecedores;
  List<Pedido> get pedidos => _pedidos;

  // Métodos para adicionar novos itens às listas
  void addCliente(Cliente cliente) {
    _clientes.add(cliente);
    notifyListeners(); // Notifica os widgets que estão ouvindo sobre a mudança
  }

  void addProduto(Produto produto) {
    _produtos.add(produto);
    notifyListeners();
  }

  void addFornecedor(Fornecedor fornecedor) {
    _fornecedores.add(fornecedor);
    notifyListeners();
  }

  void addPedido(Pedido pedido) {
    _pedidos.add(pedido);
    notifyListeners();
  }
}