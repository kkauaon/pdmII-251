import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cliente_model.dart';
import '../../providers/app_provider.dart';

class ClienteScreen extends StatefulWidget {
  @override
  _ClienteScreenState createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final PageController _pageController = PageController();

  void _addCliente() {
    if (_formKey.currentState!.validate()) {
      final novoCliente = Cliente(
        nome: _nomeController.text,
        email: _emailController.text,
      );
      Provider.of<AppProvider>(context, listen: false).addCliente(novoCliente);
      
      // Limpa os campos e exibe uma confirmação
      _nomeController.clear();
      _emailController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente adicionado com sucesso!')),
      );
      // Opcional: Mudar para a página de listagem
      _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Clientes'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          // 3.a Voltar para a tela Menu
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          // Página de Inserção de Dados
          _buildFormularioCliente(),
          // Página de Listagem de Dados
          _buildListaClientes(),
        ],
      ),
      // Botão para alternar entre as páginas
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              icon: Icon(Icons.add),
              label: Text("Cadastrar"),
              onPressed: () => _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn),
            ),
            TextButton.icon(
              icon: Icon(Icons.list),
              label: Text("Listar"),
              onPressed: () => _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn),
            ),
          ],
        ),
      ),
    );
  }

  // 3.b Inserir os dados
  Widget _buildFormularioCliente() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome do Cliente'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addCliente,
              child: Text('Salvar Cliente'),
            ),
          ],
        ),
      ),
    );
  }

  // 3.6 Listar os Dados
  Widget _buildListaClientes() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        if (appProvider.clientes.isEmpty) {
          return Center(
            child: Text('Nenhum cliente cadastrado.'),
          );
        }
        return ListView.builder(
          itemCount: appProvider.clientes.length,
          itemBuilder: (context, index) {
            final cliente = appProvider.clientes[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(cliente.nome),
                subtitle: Text(cliente.email),
                leading: CircleAvatar(child: Text(cliente.nome[0])),
              ),
            );
          },
        );
      },
    );
  }
}