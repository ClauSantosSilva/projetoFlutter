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
  TextEditingController _nomeController = TextEditingController(); // Controlador para o nome da cliente

  List<Map<String, dynamic>> _agendamentos = []; // Lista de agendamentos
  int? _editingIndex; // Para saber qual agendamento estamos editando
  List<Map<String, dynamic>> _agendamentosDoDia = []; // Lista de agendamentos para o dia selecionado

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  // Função para salvar ou editar o agendamento
  void _salvarAgendamento() {
    String nomeCliente = _nomeController.text;

    if (_selectedTime == null || nomeCliente.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Preencha todos os campos!')));
      return;
    }

    if (_editingIndex == null) {
      // Salvar um novo agendamento
      setState(() {
        _agendamentos.add({
          'data': _selectedDay,
          'hora': _selectedTime!,
          'nome': nomeCliente,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Agendamento salvo!')));
      });
    } else {
      // Editar um agendamento existente
      setState(() {
        _agendamentos[_editingIndex!] = {
          'data': _selectedDay,
          'hora': _selectedTime!,
          'nome': nomeCliente,
        };
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Agendamento editado!')));
      });
    }

    // Limpa o campo de nome após salvar ou editar
    _nomeController.clear();
    setState(() {
      _editingIndex = null; // Reseta o índice de edição
      _selectedTime = null; // Limpa o tempo após salvar
    });

    // Atualiza a lista de agendamentos do dia
    _atualizarAgendamentosDoDia();
  }

  // Função para editar um agendamento
  void _editarAgendamento(int index) {
    setState(() {
      _selectedDay = _agendamentos[index]['data'];
      _selectedTime = _agendamentos[index]['hora'];
      _nomeController.text = _agendamentos[index]['nome'];
      _editingIndex = index; // Define o índice do agendamento que está sendo editado
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
    return DateFormat('dd/MM/yyyy').format(date); // Formata a data como dd/MM/yyyy
  }

  // Função para atualizar os agendamentos do dia selecionado
  void _atualizarAgendamentosDoDia() {
    setState(() {
      _agendamentosDoDia = _agendamentos.where((agendamento) {
        return isSameDay(agendamento['data'], _selectedDay); // Verifica se a data do agendamento é a mesma do dia selecionado
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Agenda",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: Colors.blue, // Título com fundo azul
      ),
      body: SingleChildScrollView( // Permite a rolagem na tela inteira
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.lightBlue[200]!],// Degradê azul
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Campo para o nome da cliente
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome da Cliente',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2025, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });

                    // Atualiza a lista de agendamentos para o dia selecionado
                    _atualizarAgendamentosDoDia();
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue, // Cor de fundo para o dia selecionado
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.transparent, // Retira a cor amarela do dia atual
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle: TextStyle(color: Colors.red), // Cor para os fins de semana
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Título da legenda em branco
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue, // Fundo azul para a legenda
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Exibe a data selecionada no formato brasileiro
                Text(
                  'Data Selecionada: ${_formatarData(_selectedDay)}', // Exibe a data formatada
                  style: TextStyle(fontSize: 16, color: Colors.white), // Texto em branco
                ),
                SizedBox(height: 20),
                // Botão para selecionar o horário
                ElevatedButton(
                  onPressed: _selecionarHora,
                  child: Text(_selectedTime == null
                      ? 'Selecione a Hora'
                      : 'Hora Selecionada: ${_selectedTime!.format(context)}'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                ),
                SizedBox(height: 20),
                // Botão para salvar o agendamento
                ElevatedButton(
                  onPressed: _salvarAgendamento,
                  child: Text(_editingIndex == null ? 'Salvar Agendamento' : 'Salvar Alterações'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                ),
                SizedBox(height: 20),
                // Exibe os agendamentos do dia selecionado
                _agendamentosDoDia.isEmpty
                    ? Text(
                  'Nenhum agendamento para este dia.',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )
                    : ListView.builder(
                  shrinkWrap: true, // Permite rolar apenas a lista de agendamentos
                  itemCount: _agendamentosDoDia.length,
                  itemBuilder: (context, index) {
                    final agendamento = _agendamentosDoDia[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10.0),
                        title: Text(
                          'Cliente: ${agendamento['nome']}',
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          'Hora: ${agendamento['hora'].format(context)}',
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Botão de editar
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editarAgendamento(index), // Passa o índice
                            ),
                            // Botão de excluir
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _excluirAgendamento(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
