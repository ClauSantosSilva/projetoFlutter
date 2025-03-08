import 'package:flutter/material.dart';

class ServicosScreen extends StatefulWidget {
  @override
  _ServicosScreenState createState() => _ServicosScreenState();
}

class _ServicosScreenState extends State<ServicosScreen> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  List<Map<String, String>> _servicos = []; // Lista para armazenar os serviços
  int? _editarIndex; // Para saber qual serviço estamos editando

  // Função para adicionar ou editar um serviço na lista
  void _adicionarOuEditarServico() {
    String descricao = _descricaoController.text;
    String valor = _valorController.text;

    if (descricao.isNotEmpty && valor.isNotEmpty) {
      if (_editarIndex == null) {
        // Adiciona um novo serviço
        setState(() {
          _servicos.add({'descricao': descricao, 'valor': valor});
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Serviço cadastrado com sucesso!')),
        );
      } else {
        // Edita um serviço existente
        setState(() {
          _servicos[_editarIndex!] = {'descricao': descricao, 'valor': valor};
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Serviço editado com sucesso!')),
        );
      }

      // Limpa os campos e reseta o índice de edição
      _descricaoController.clear();
      _valorController.clear();
      setState(() {
        _editarIndex = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos!')),
      );
    }
  }

  // Função para excluir um serviço
  void _excluirServico(int index) {
    setState(() {
      _servicos.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Serviço excluído!')),
    );
  }

  // Função para editar um serviço
  void _editarServico(int index) {
    setState(() {
      _editarIndex = index;
    });
    _descricaoController.text = _servicos[index]['descricao']!;
    _valorController.text = _servicos[index]['valor']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF64B5F6),
        centerTitle: true,
        title: Text(
          'Serviços',
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
            colors: [Colors.white, Colors.lightBlue[200]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Campo para descrição do serviço
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição do Serviço',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              // Campo para valor do serviço
              TextField(
                controller: _valorController,
                decoration: InputDecoration(
                  labelText: 'Valor do Serviço',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              // Botão para adicionar ou editar o serviço
              ElevatedButton(
                onPressed: _adicionarOuEditarServico,
                child: Text(_editarIndex == null ? 'Cadastrar Serviço' : 'Salvar Alterações'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
              SizedBox(height: 20),

              // Barra de rolagem com a lista de serviços
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _servicos.map((servico) {
                      int index = _servicos.indexOf(servico);
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10.0),
                          title: Text(
                            servico['descricao']!,
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            'Valor: R\$ ${servico['valor']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Botão de editar
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editarServico(index),
                              ),
                              // Botão de excluir
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _excluirServico(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
