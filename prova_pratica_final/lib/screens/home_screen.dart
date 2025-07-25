import 'package:flutter/material.dart';
import 'cadastro/cliente_screen.dart';
import 'cadastro/fornecedor_screen.dart';
import 'cadastro/produto_screen.dart';
import 'cadastro/pedido_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Principal'),
      ),
      body: Center(
        child: Text(
          'Selecione uma opção no menu para começar.',
          style: TextStyle(fontSize: 18),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Cadastros',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Clientes'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ClienteScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_basket),
              title: Text('Produtos'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProdutoScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.local_shipping),
              title: Text('Fornecedores'),
              onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => FornecedorScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Pedidos'),
              onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => PedidoScreen()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: () {
                // Ao sair, voltamos para a tela de login
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}