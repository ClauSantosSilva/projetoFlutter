import 'package:flutter/material.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  void _cadastrar() {
    String nome = _nomeController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;

    if (nome.isNotEmpty && email.isNotEmpty && senha.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
      // Após o cadastro, podemos redirecionar para a tela de login ou outra tela
      Navigator.pop(context); // Volta para a tela de login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF64B5F6),
        centerTitle: true,
        title: Text(
          "Cadastro",
          style: TextStyle(
            color: Colors.white, // Cor do texto
            fontSize: 24, // Tamanho da fonte
            fontWeight: FontWeight.bold, // Negrito
            fontFamily: 'Roboto', // Fonte personalizada (se disponível)
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.lightBlue[200]!], // Degradê do branco para o azul
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Exibe a imagem
              Image.asset(
                'assets/images/flower.jpg', // Caminho da imagem local
                height: 250.0, // Ajuste o tamanho conforme necessário
              ),
              SizedBox(height: 40), // Espaço entre a imagem e os botões
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  hintText: 'Nome',
                  labelText: 'Nome',
                  //filled: true,
                  fillColor: Colors.white.withOpacity(0.8), // Fundo dos campos
                  border: OutlineInputBorder(), // Adicionando borda para melhor aparência
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'E-mail',
                  labelText: 'E-mail',
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Senha',
                  labelText: 'Senha',
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _cadastrar,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Cor do botão
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Cadastrar',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
