import 'package:prova_pratica_final/models/cliente_model.dart';
import 'package:prova_pratica_final/models/produto_model.dart';

class Pedido {
  Cliente cliente;
  List<Produto> produtos;
  DateTime data;

  Pedido({required this.cliente, required this.produtos, required this.data});
}