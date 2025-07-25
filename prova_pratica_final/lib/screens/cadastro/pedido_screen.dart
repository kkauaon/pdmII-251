import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cliente_model.dart';
import '../../models/produto_model.dart';
import '../../models/pedido_model.dart';
import '../../providers/app_provider.dart';

class PedidoScreen extends StatefulWidget {
  @override
  _PedidoScreenState createState() => _PedidoScreenState();
}

class _PedidoScreenState extends State<PedidoScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  // Variáveis de estado para o formulário do pedido
  Cliente? _selectedCliente;
  final List<Produto> _selectedProdutos = [];

  // 3.b Inserir os dados dos Pedidos
  void _addPedido() {
    // Validação dos dados antes de salvar
    if (_formKey.currentState!.validate()) {
      if (_selectedCliente == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione um cliente.')),
        );
        return;
      }
      if (_selectedProdutos.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, adicione pelo menos um produto.')),
        );
        return;
      }

      final novoPedido = Pedido(
        cliente: _selectedCliente!,
        produtos: List.from(_selectedProdutos), // Cria uma cópia da lista
        data: DateTime.now(),
      );

      Provider.of<AppProvider>(context, listen: false).addPedido(novoPedido);

      // Limpa o formulário e o estado local
      setState(() {
        _selectedCliente = null;
        _selectedProdutos.clear();
        _formKey.currentState!.reset();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido cadastrado com sucesso!')),
      );

      _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void _adicionarProdutoAoPedido(Produto produto) {
    setState(() {
      _selectedProdutos.add(produto);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Pedidos'),
        // 3.a Voltar para a tela Menu
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          _buildFormularioPedido(),
          _buildListaPedidos(),
        ],
      ),
       bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text("Novo Pedido"),
              onPressed: () => _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn),
            ),
            TextButton.icon(
              icon: const Icon(Icons.receipt_long),
              label: const Text("Listar Pedidos"),
              onPressed: () => _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o formulário de cadastro de pedido.
  Widget _buildFormularioPedido() {
    // O Consumer é usado aqui para obter as listas de clientes e produtos
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Dropdown para selecionar o cliente
                DropdownButtonFormField<Cliente>(
                  value: _selectedCliente,
                  hint: const Text('Selecione um Cliente'),
                  isExpanded: true,
                  items: appProvider.clientes.map((Cliente cliente) {
                    return DropdownMenuItem<Cliente>(
                      value: cliente,
                      child: Text(cliente.nome),
                    );
                  }).toList(),
                  onChanged: (Cliente? newValue) {
                    setState(() {
                      _selectedCliente = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 20),
                // Seção para adicionar produtos
                const Text('Adicionar Produtos ao Pedido:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                if (_selectedProdutos.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: _selectedProdutos.map((produto) => Chip(
                        label: Text(produto.nome),
                        onDeleted: () {
                          setState(() {
                            _selectedProdutos.remove(produto);
                          });
                        },
                      )).toList(),
                    ),
                  ),

                // Lista de produtos disponíveis para seleção
                Expanded(
                  child: appProvider.produtos.isEmpty
                  ? const Center(child: Text('Nenhum produto cadastrado.\nCadastre um produto antes de criar um pedido.'))
                  : ListView.builder(
                      itemCount: appProvider.produtos.length,
                      itemBuilder: (context, index) {
                        final produto = appProvider.produtos[index];
                        return Card(
                          child: ListTile(
                            title: Text(produto.nome),
                            subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                              onPressed: () => _adicionarProdutoAoPedido(produto),
                            ),
                          ),
                        );
                      },
                    ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addPedido,
                  child: const Text('Salvar Pedido'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 3.6 Listar os Dados dos Pedidos
  /// Constrói a lista de pedidos já cadastrados.
  Widget _buildListaPedidos() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        if (appProvider.pedidos.isEmpty) {
          return const Center(
            child: Text('Nenhum pedido cadastrado.'),
          );
        }
        return ListView.builder(
          itemCount: appProvider.pedidos.length,
          itemBuilder: (context, index) {
            final pedido = appProvider.pedidos[index];
            final totalProdutos = pedido.produtos.length;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text('Cliente: ${pedido.cliente.nome}'),
                subtitle: Text('Itens: $totalProdutos - Data: ${pedido.data.day}/${pedido.data.month}/${pedido.data.year}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Opcional: Mostrar detalhes do pedido em um Dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Detalhes do Pedido'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cliente: ${pedido.cliente.nome}', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('Produtos:'),
                          ...pedido.produtos.map((p) => Text('- ${p.nome}')),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Fechar'),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}