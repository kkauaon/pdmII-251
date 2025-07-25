import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/fornecedor_model.dart';
import '../../providers/app_provider.dart';

class FornecedorScreen extends StatefulWidget {
  @override
  _FornecedorScreenState createState() => _FornecedorScreenState();
}

class _FornecedorScreenState extends State<FornecedorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cnpjController = TextEditingController();
  final PageController _pageController = PageController();

  // 3.b Inserir os dados dos Fornecedores
  void _addFornecedor() {
    if (_formKey.currentState!.validate()) {
      final novoFornecedor = Fornecedor(
        nome: _nomeController.text,
        cnpj: _cnpjController.text,
      );
      // Utiliza o AppProvider para adicionar o novo fornecedor à lista de estado
      Provider.of<AppProvider>(context, listen: false).addFornecedor(novoFornecedor);
      
      // Limpa os campos após o cadastro
      _nomeController.clear();
      _cnpjController.clear();

      // Exibe uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fornecedor adicionado com sucesso!')),
      );

      // Navega para a página de listagem para ver o item adicionado
      _pageController.animateToPage(
        1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Fornecedores'),
        // 3.a Voltar para a tela Menu
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // O PageView permite alternar entre o formulário e a lista
      body: PageView(
        controller: _pageController,
        children: [
          _buildFormularioFornecedor(), // Página 0: Formulário
          _buildListaFornecedores(),    // Página 1: Lista
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              icon: Icon(Icons.add_business),
              label: Text("Cadastrar"),
              onPressed: () => _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn),
            ),
            TextButton.icon(
              icon: Icon(Icons.list_alt),
              label: Text("Listar"),
              onPressed: () => _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o widget do formulário para inserir dados do fornecedor.
  Widget _buildFormularioFornecedor() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome do Fornecedor'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O nome é obrigatório';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _cnpjController,
              decoration: InputDecoration(labelText: 'CNPJ'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O CNPJ é obrigatório';
                }
                // Adicione aqui uma validação de CNPJ se necessário
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addFornecedor,
              child: Text('Salvar Fornecedor'),
            ),
          ],
        ),
      ),
    );
  }

  // 3.6 Listar os Dados dos Fornecedores
  /// Constrói o widget que exibe a lista de fornecedores cadastrados.
  Widget _buildListaFornecedores() {
    // Consumer ouve as mudanças no AppProvider e reconstrói a lista quando necessário
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        if (appProvider.fornecedores.isEmpty) {
          return Center(
            child: Text('Nenhum fornecedor cadastrado.'),
          );
        }
        // ListView.builder é eficiente para listas longas
        return ListView.builder(
          itemCount: appProvider.fornecedores.length,
          itemBuilder: (context, index) {
            final fornecedor = appProvider.fornecedores[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(fornecedor.nome),
                subtitle: Text('CNPJ: ${fornecedor.cnpj}'),
                leading: CircleAvatar(
                  child: Icon(Icons.local_shipping),
                ),
              ),
            );
          },
        );
      },
    );
  }
}