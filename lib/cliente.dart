import 'package:flutter/material.dart';

void main() {
  runApp(ClienteApp());  // Mudou de MyApp para ClienteApp
}

class Cliente {
  String nome;
  String telefone;
  String cpf;

  Cliente({required this.nome, required this.telefone, required this.cpf});
}

class ClienteApp extends StatelessWidget {  // Renomeado de MyApp para ClienteApp
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Clientes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClienteScreen(),
    );
  }
}

class ClienteScreen extends StatefulWidget {
  @override
  _ClienteScreenState createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final List<Cliente> _clientes = [];
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _pesquisaController = TextEditingController();
  int? _editarIndex; // Variável para saber se estamos editando um cliente

  // Função para adicionar ou editar cliente
  void _salvarCliente() {
    String nome = _nomeController.text;
    String telefone = _telefoneController.text;
    String cpf = _cpfController.text;

    if (nome.isEmpty || telefone.isEmpty || cpf.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Preencha todos os campos!')));
      return;
    }

    setState(() {
      if (_editarIndex == null) {
        // Adicionar novo cliente
        _clientes.add(Cliente(nome: nome, telefone: telefone, cpf: cpf));
      } else {
        // Editar cliente existente
        _clientes[_editarIndex!] = Cliente(nome: nome, telefone: telefone, cpf: cpf);
      }
    });

    _limparCampos();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_editarIndex == null ? 'Cliente salvo!' : 'Cliente editado!')));
    setState(() {
      _editarIndex = null; // Limpar o índice de edição
    });
  }

  // Função para excluir cliente
  void _excluirCliente(String cpf) {
    setState(() {
      _clientes.removeWhere((cliente) => cliente.cpf == cpf);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cliente excluído!')));
  }

  // Função para limpar os campos de entrada
  void _limparCampos() {
    _nomeController.clear();
    _telefoneController.clear();
    _cpfController.clear();
  }

  // Função para pesquisar cliente por telefone
  Cliente? _pesquisarClientePorTelefone() {
    String telefone = _pesquisaController.text;
    try {
      // Tentar encontrar o cliente pelo telefone
      Cliente cliente = _clientes.firstWhere((cliente) => cliente.telefone == telefone);
      return cliente; // Retorna o cliente encontrado
    } catch (e) {
      // Caso não seja encontrado, retorna null
      return null;
    }
  }

  // Função para editar cliente
  void _editarCliente(int index) {
    Cliente cliente = _clientes[index];
    _nomeController.text = cliente.nome;
    _telefoneController.text = cliente.telefone;
    _cpfController.text = cliente.cpf;
    setState(() {
      _editarIndex = index; // Armazenar o índice do cliente a ser editado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF64B5F6),
        centerTitle: true,
        title: Text(
          'Cadastro de Clientes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.lightBlue[100]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Campo de pesquisa
              TextField(
                controller: _pesquisaController,
                decoration: InputDecoration(
                  labelText: 'Pesquisar por Telefone',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Cliente? cliente = _pesquisarClientePorTelefone();
                  if (cliente != null) {
                    _nomeController.text = cliente.nome;
                    _telefoneController.text = cliente.telefone;
                    _cpfController.text = cliente.cpf;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cliente encontrado!')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cliente não encontrado!')));
                  }
                },
                child: Text('Pesquisar'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              // Campos de cadastro
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _telefoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _cpfController,
                decoration: InputDecoration(
                  labelText: 'CPF',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Botão para salvar ou editar cliente
              ElevatedButton(
                onPressed: _salvarCliente,
                child: Text(_editarIndex == null ? 'Salvar' : 'Salvar Alterações'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  minimumSize: Size(100, 50),
                ),
              ),
              SizedBox(height: 20),
              // Lista de clientes cadastrados
              Expanded(
                child: ListView.builder(
                  itemCount: _clientes.length,
                  itemBuilder: (context, index) {
                    Cliente cliente = _clientes[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10.0),
                        title: Text(cliente.nome, style: TextStyle(fontSize: 18)),
                        subtitle: Text(
                          'Telefone: ${cliente.telefone}\nCPF: ${cliente.cpf}',
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Botão de editar
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editarCliente(index),
                            ),
                            // Botão de excluir
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _excluirCliente(cliente.cpf),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
