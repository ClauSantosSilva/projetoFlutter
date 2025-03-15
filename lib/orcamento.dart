import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Para enviar via WhatsApp

class Orcamento extends StatefulWidget {
  @override
  _OrcamentoState createState() => _OrcamentoState();
}

class _OrcamentoState extends State<Orcamento> {
  DateTime _selectedDay = DateTime.now();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _descontoController = TextEditingController();

  List<Map<String, dynamic>> _servicos = [];
  List<Map<String, dynamic>> _orcamentos = [];
  double _total = 0;

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _descontoController.dispose();
    super.dispose();
  }

  void _adicionarServico() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _servicoController = TextEditingController();
        TextEditingController _valorUnitarioController = TextEditingController();

        return AlertDialog(
          title: Text('Adicionar Serviço'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _servicoController,
                decoration: InputDecoration(labelText: 'Nome do Serviço'),
              ),
              TextField(
                controller: _valorUnitarioController,
                decoration: InputDecoration(labelText: 'Valor Unitário'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_servicoController.text.isNotEmpty && _valorUnitarioController.text.isNotEmpty) {
                  setState(() {
                    _servicos.add({
                      'servico': _servicoController.text,
                      'valorUnitario': double.parse(_valorUnitarioController.text),
                    });
                    _atualizarTotal();
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Preencha todos os campos!')));
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _atualizarTotal() {
    double total = 0;
    for (var servico in _servicos) {
      total += servico['valorUnitario'];
    }
    if (_descontoController.text.isNotEmpty) {
      double desconto = double.tryParse(_descontoController.text) ?? 0;
      total -= (total * (desconto / 100));
    }
    setState(() {
      _total = total;
    });
  }

  void _salvarOrcamento() {
    String nomeCliente = _nomeController.text;
    String telefoneCliente = _telefoneController.text;

    if (nomeCliente.isEmpty || telefoneCliente.isEmpty || _servicos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Preencha todos os campos!')));
      return;
    }

    setState(() {
      _orcamentos.add({
        'data': _selectedDay,
        'nome': nomeCliente,
        'telefone': telefoneCliente,
        'servicos': List.from(_servicos),
        'total': _total,
        'desconto': _descontoController.text.isEmpty ? 0 : double.parse(_descontoController.text),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Orçamento salvo!')));
    });
    limparCampos();
  }

  void limparCampos() {
    _nomeController.clear();
    _telefoneController.clear();
    _descontoController.clear();
    setState(() {
      _servicos.clear();
      _total = 0;
    });
  }

  void _enviarWhatsApp(String telefone) async {
    final url = 'https://wa.me/$telefone?text=Orçamento%20disponível.';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Não foi possível abrir o WhatsApp')));
    }
  }

  // Função para editar um orçamento
  void _editarOrcamento(int index) {
    var orcamento = _orcamentos[index];
    _nomeController.text = orcamento['nome'];
    _telefoneController.text = orcamento['telefone'];
    _descontoController.text = orcamento['desconto'].toString();

    // Limpa os serviços atuais para preenchê-los novamente
    _servicos.clear();
    _servicos.addAll(orcamento['servicos']);
    _atualizarTotal();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Orçamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome do Cliente'),
              ),
              TextField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
              ),
              TextField(
                controller: _descontoController,
                decoration: InputDecoration(labelText: 'Desconto (%)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _adicionarServico,
                child: Text('Adicionar Serviço'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _orcamentos[index] = {
                    'data': orcamento['data'],
                    'nome': _nomeController.text,
                    'telefone': _telefoneController.text,
                    'servicos': List.from(_servicos),
                    'total': _total,
                    'desconto': _descontoController.text.isEmpty ? 0 : double.parse(_descontoController.text),
                  };
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Orçamento atualizado!')));
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Debugging: Verificar o estado de _orcamentos
    print('Orçamentos: $_orcamentos');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Orçamento",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.lightBlue[100]!],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Adicionando um campo de entrada para nome e telefone
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome do Cliente'),
            ),
            TextField(
              controller: _telefoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
            ),
            TextField(
              controller: _descontoController,
              decoration: InputDecoration(labelText: 'Desconto (%)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            // Botão para adicionar serviço
            ElevatedButton(
              onPressed: _adicionarServico,
              child: Text('Adicionar Serviço'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _salvarOrcamento,
              child: Text('Salvar Orçamento'),
            ),
            SizedBox(height: 10),
            // Se houver orçamentos, mostrar a lista
            if (_orcamentos.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _orcamentos.length,
                  itemBuilder: (context, index) {
                    var orcamento = _orcamentos[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cliente: ${orcamento['nome']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('Telefone: ${orcamento['telefone']}'),
                            ...orcamento['servicos'].map<Widget>((servico) {
                              return Text('${servico['servico']}: R\$ ${servico['valorUnitario']}');
                            }).toList(),
                            Text('Desconto: ${orcamento['desconto']}%'),
                            Text('Total: R\$ ${orcamento['total']}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(icon: Icon(Icons.edit), onPressed: () => _editarOrcamento(index)),
                                IconButton(icon: Icon(Icons.delete), onPressed: () {
                                  setState(() {
                                    _orcamentos.removeAt(index);
                                  });
                                }),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward),
                                  onPressed: () {
                                    _enviarWhatsApp(orcamento['telefone']);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            // Se não houver orçamentos, mostrar mensagem
            if (_orcamentos.isEmpty) Text('Nenhum orçamento salvo.'),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // Remover faixa de depuração
    home: Orcamento(),
  ));
}
