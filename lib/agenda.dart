import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Para formatação de data

class Agenda extends StatefulWidget {
  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  TimeOfDay? _selectedTime;
  TextEditingController _pesquisaClienteController = TextEditingController(); // Campo de pesquisa cliente
  TextEditingController _telefoneClienteController = TextEditingController(); // Campo de telefone do cliente
  TextEditingController _pesquisaServicoController = TextEditingController(); // Campo de pesquisa serviço

  List<Map<String, dynamic>> _agendamentos = []; // Lista de agendamentos
  int? _editingIndex; // Para saber qual agendamento estamos editando
  List<Map<String, dynamic>> _agendamentosDoDia = []; // Lista de agendamentos para o dia selecionado

  // Dados carregados do banco
  List<String> _clientes = [];
  List<String> _servicos = [];
  Map<String, String> _clientesComTelefone = {}; // Mapa de clientes com seus telefones

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();

    // Inicializar os agendamentos com algum valor fictício
    _agendamentos.add({
      'data': DateTime.now(),
      'hora': TimeOfDay(hour: 14, minute: 30),
      'nome_cliente': 'Cliente Teste',
      'servico': 'Corte de cabelo',
      'telefone_cliente': '123456789',
    });

    // Carregar os clientes e serviços do banco de dados
    _carregarClientesEServicos();
  }

  // Função para carregar os clientes e serviços do banco
  Future<void> _carregarClientesEServicos() async {
    // Exemplo fictício de dados de clientes e serviços
    setState(() {
      _clientes = ['Cliente 1', 'Cliente 2', 'Cliente Teste'];
      _servicos = ['Corte de cabelo', 'Manicure', 'Pedicure'];
      _clientesComTelefone = {
        'Cliente Teste': '123456789',
        'Cliente 1': '987654321',
        'Cliente 2': '564738291',
      };
    });
  }

  // Função para salvar ou editar o agendamento
  void _salvarAgendamento(String nomeCliente, String nomeServico, String telefoneCliente) {
    if (_selectedTime == null || nomeCliente.isEmpty || nomeServico.isEmpty || telefoneCliente.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Preencha todos os campos!')));
      return;
    }

    if (_editingIndex == null) {
      // Salvar um novo agendamento
      setState(() {
        _agendamentos.add({
          'data': _selectedDay,
          'hora': _selectedTime!,
          'nome_cliente': nomeCliente,
          'servico': nomeServico,
          'telefone_cliente': telefoneCliente,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Agendamento salvo!')));
      });
    } else {
      // Editar um agendamento existente
      setState(() {
        _agendamentos[_editingIndex!] = {
          'data': _selectedDay,
          'hora': _selectedTime!,
          'nome_cliente': nomeCliente,
          'servico': nomeServico,
          'telefone_cliente': telefoneCliente,
        };
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Agendamento editado!')));
      });
    }

    // Limpa os campos após salvar ou editar
    setState(() {
      _selectedTime = null; // Limpa o tempo após salvar
      _editingIndex = null; // Reseta o índice de edição
      _pesquisaClienteController.clear();
      _telefoneClienteController.clear();
      _pesquisaServicoController.clear();
    });

    // Atualiza a lista de agendamentos do dia
    _atualizarAgendamentosDoDia();
  }

  // Função para editar um agendamento
  void _editarAgendamento(int index) {
    setState(() {
      _selectedDay = _agendamentos[index]['data'];
      _selectedTime = _agendamentos[index]['hora'];
      _editingIndex = index;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Agendamento selecionado para edição!')));
  }

  // Função para excluir um agendamento
  void _excluirAgendamento(int index) {
    setState(() {
      _agendamentos.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Agendamento excluído!')));

    // Atualiza a lista de agendamentos do dia após exclusão
    _atualizarAgendamentosDoDia();
  }

  // Função para escolher a hora
  Future<void> _selecionarHora() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Função para formatar a data no formato brasileiro
  String _formatarData(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Função para formatar o horário
  String _formatarHora(TimeOfDay time) {
    return time.format(context); // Formata para o formato de hora (HH:mm)
  }

  // Função para atualizar os agendamentos do dia selecionado
  void _atualizarAgendamentosDoDia() {
    setState(() {
      _agendamentosDoDia = _agendamentos.where((agendamento) {
        return isSameDay(agendamento['data'], _selectedDay);
      }).toList();
    });
  }

  // Função de pesquisa de cliente
  void _pesquisarCliente() {
    String query = _pesquisaClienteController.text.toLowerCase();
    setState(() {
      if (_clientesComTelefone.containsKey(query)) {
        _telefoneClienteController.text = _clientesComTelefone[query]!;
      } else {
        _telefoneClienteController.clear(); // Limpa o telefone caso não encontre
      }
    });
  }

  // Função de pesquisa de serviço
  void _pesquisarServico() {
    String query = _pesquisaServicoController.text.toLowerCase();
    setState(() {
      _agendamentosDoDia = _agendamentos.where((agendamento) {
        return agendamento['servico'].toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Agenda"),
        backgroundColor: Color(0xFF64B5F6),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.lightBlue[100]!],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Campo de pesquisa de cliente
                TextField(
                  controller: _pesquisaClienteController,
                  decoration: InputDecoration(
                    labelText: 'Pesquisar Cliente',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _pesquisarCliente,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Campo de telefone cliente
                TextField(
                  controller: _telefoneClienteController,
                  decoration: InputDecoration(
                    labelText: 'Telefone do Cliente',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20),
                // Campo de pesquisa de serviço
                TextField(
                  controller: _pesquisaServicoController,
                  decoration: InputDecoration(
                    labelText: 'Pesquisar Serviço',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _pesquisarServico,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Calendário
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2025, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _atualizarAgendamentosDoDia();
                  },
                ),
                SizedBox(height: 20),
                // Botão de hora
                ElevatedButton(
                  onPressed: _selecionarHora,
                  child: Text(_selectedTime == null ? 'Selecione a Hora' : 'Hora Selecionada: ${_formatarHora(_selectedTime!)}'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                SizedBox(height: 20),
                // Botão de salvar agendamento
                ElevatedButton(
                  onPressed: () {
                    String nomeCliente = _pesquisaClienteController.text.isEmpty ? 'Cliente não cadastrado' : _pesquisaClienteController.text;
                    String nomeServico = _pesquisaServicoController.text.isEmpty ? 'Serviço não selecionado' : _pesquisaServicoController.text;
                    String telefoneCliente = _telefoneClienteController.text.isEmpty ? 'Telefone não informado' : _telefoneClienteController.text;
                    _salvarAgendamento(nomeCliente, nomeServico, telefoneCliente);
                  },
                  child: Text('Salvar Agenda'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                SizedBox(height: 20),
                // Exibição dos agendamentos com a barra de rolagem
                _selectedDay == null || _agendamentosDoDia.isEmpty
                    ? Text('Nenhum agendamento para este dia.')
                    : Container(
                  height: 300, // Ajuste a altura conforme necessário
                  child: SingleChildScrollView(
                    child: Column(
                      children: _agendamentosDoDia.map((agendamento) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text('Cliente: ${agendamento['nome_cliente']}'),
                            subtitle: Text('Serviço: ${agendamento['servico']}\nDia: ${_formatarData(agendamento['data'])}\nHora: ${_formatarHora(agendamento['hora'])}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editarAgendamento(_agendamentos.indexOf(agendamento)),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _excluirAgendamento(_agendamentos.indexOf(agendamento)),
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
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Agenda(),
  ));
}
