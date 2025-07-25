import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/produto_model.dart';
import '../../providers/app_provider.dart';

class ProdutoScreen extends StatefulWidget {
  @override
  _ProdutoScreenState createState() => _ProdutoScreenState();
}

class _ProdutoScreenState extends State<ProdutoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final PageController _pageController = PageController();

  // 3.b Inserir os dados dos Produtos
  void _addProduto() {
    if (_formKey.currentState!.validate()) {
      final String nome = _nomeController.text;
      // Converte o texto do preço para double, tratando a vírgula
      final double? preco = double.tryParse(_precoController.text.replaceAll(',', '.'));

      if (preco == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, insira um preço válido.')),
        );
        return;
      }

      final novoProduto = Produto(
        nome: nome,
        preco: preco,
      );

      // Usa o Provider para adicionar o produto à lista global
      Provider.of<AppProvider>(context, listen: false).addProduto(novoProduto);

      // Limpa os campos do formulário
      _nomeController.clear();
      _precoController.clear();
      
      // Mostra uma mensagem de confirmação
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto adicionado com sucesso!')),
      );

      // Navega para a página de listagem
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Produtos'),
        // 3.a Voltar para a tela Menu
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // PageView para alternar entre cadastro e listagem
      body: PageView(
        controller: _pageController,
        children: [
          _buildFormularioProduto(), // Página 0
          _buildListaProdutos(),      // Página 1
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.add_circle),
              label: const Text("Cadastrar"),
              onPressed: () => _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn),
            ),
            TextButton.icon(
              icon: const Icon(Icons.view_list),
              label: const Text("Listar"),
              onPressed: () => _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o widget de formulário para inserir os dados do produto.
  Widget _buildFormularioProduto() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Produto'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O nome do produto é obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _precoController,
              decoration: const InputDecoration(labelText: 'Preço', prefixText: 'R\$ '),
              // Teclado numérico com suporte a decimal
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O preço é obrigatório';
                }
                // Valida se o valor inserido é um número válido
                if (double.tryParse(value.replaceAll(',', '.')) == null) {
                  return 'Por favor, insira um número válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduto,
              child: const Text('Salvar Produto'),
            ),
          ],
        ),
      ),
    );
  }

  // 3.6 Listar os Dados dos Produtos
  /// Constrói o widget que exibe a lista de produtos.
  Widget _buildListaProdutos() {
    // Consumer garante que a lista seja reconstruída sempre que houver uma mudança no AppProvider
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        if (appProvider.produtos.isEmpty) {
          return const Center(
            child: Text('Nenhum produto cadastrado.'),
          );
        }
        return ListView.builder(
          itemCount: appProvider.produtos.length,
          itemBuilder: (context, index) {
            final produto = appProvider.produtos[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.shopping_basket),
                ),
                title: Text(produto.nome),
                // Formata o preço para duas casas decimais
                subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
              ),
            );
          },
        );
      },
    );
  }
}