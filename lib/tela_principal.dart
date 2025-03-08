import 'dart:io';

import 'package:flutter/material.dart';
import 'package:teste/agenda.dart';
import 'package:teste/cliente.dart';
import 'package:teste/tela_servico.dart';

class TelaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF64B5F6),
        centerTitle: true,
        title: Text(
          'Espaço Beleza',
          style: TextStyle(
            color: Colors.white, // Cor do texto
            fontSize: 24, // Tamanho da fonte
            fontWeight: FontWeight.bold, // Negrito
            fontFamily: 'Roboto', // Fonte personalizada (se disponível)
          ),
        ),
      ),
      body: Stack(
        children: [
          // Fundo com gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.lightBlue[200]!], // Degradê do branco para o azul
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Exibe a imagem
                Image.asset(
                  'assets/images/flower.jpg', // Caminho da imagem local
                  height: 250.0, // Ajuste o tamanho conforme necessário
                ),
                SizedBox(height: 40), // Espaço entre a imagem e os botões

                // Botão "Clientes"
                ElevatedButton(
                  onPressed: () {
                    // Navegação para a tela clientes
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClienteScreen()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Clientes pressionado')),
                    );
                  },
                  child: Text('Clientes'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50), // Tamanho do botão
                    textStyle: TextStyle(fontSize: 20),
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Cor do texto
                  ),
                ),
                SizedBox(height: 20),

                // Botão "Serviços"
                ElevatedButton(
                  onPressed: () {
                    // Navegação para a tela de serviços
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ServicosScreen()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Serviços pressionado')),
                    );
                  },
                  child: Text('Serviços'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50), // Tamanho do botão
                    textStyle: TextStyle(fontSize: 20),
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Cor do texto
                  ),
                ),
                SizedBox(height: 20),

                // Botão "Orçamento"
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Orçamento pressionado')),
                    );
                  },
                  child: Text('Orçamento'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Cor do texto
                    minimumSize: Size(double.infinity, 50),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 20),

                // Botão "Agenda"
                ElevatedButton(
                  onPressed: () {
                    // Navegação para a tela Agenda
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Agenda()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Agenda pressionado')),
                    );
                  },
                  child: Text('Agenda'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Cor do texto
                    minimumSize: Size(double.infinity, 50),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),

          // Botão "Sair" no canto inferior direito
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () => _sair(context), // Chama a função de saída
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: Size(80, 40), // Botão pequeno
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('Sair'),
            ),
          ),
        ],
      ),
    );
  }

  // Função para exibir o alerta e encerrar o app
  void _sair(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sair do aplicativo"),
          content: Text("Tem certeza que deseja sair?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Não"),
            ),
            TextButton(
              onPressed: () {
                exit(0); // Encerra completamente o aplicativo
              },
              child: Text("Sim"),
            ),
          ],
        );
      },
    );
  }
}


