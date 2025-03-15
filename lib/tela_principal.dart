import 'dart:io'; // Apenas para Android/iOS

import 'package:beleza/tela_servico.dart';
import 'package:flutter/material.dart';
import 'package:beleza/agenda.dart';
import 'package:beleza/cliente.dart';
import 'package:beleza/tela_servico.dart';
import 'package:beleza/orcamento.dart';

import 'agenda.dart';
import 'cliente.dart';
import 'orcamento.dart';

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
                colors: [Colors.white, Colors.lightBlue[100]!], // Degradê do branco para o azul
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
                    // Exibe o SnackBar e após um pequeno delay, navega para a tela Clientes
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Clientes pressionado')),
                    );
                    Future.delayed(Duration(seconds: 1), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ClienteScreen()),
                      );
                    });
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
                    // Exibe o SnackBar e após um pequeno delay, navega para a tela de serviços
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Serviços pressionado')),
                    );
                    Future.delayed(Duration(seconds: 1), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ServicosScreen()),
                      );
                    });
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
                    // Exibe o SnackBar e após um pequeno delay, navega para a tela de orçamentos
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Orçamento pressionado')),
                    );
                    Future.delayed(Duration(seconds: 1), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Orcamento()),
                      );
                    });
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
                    // Exibe o SnackBar e após um pequeno delay, navega para a tela de agenda
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Agenda pressionado')),
                    );
                    Future.delayed(Duration(seconds: 1), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Agenda()),
                      );
                    });
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
