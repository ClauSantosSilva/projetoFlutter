import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:teste/tela_principal.dart';
import 'cadastro.dart';

void main() {
  // Adicione a linha abaixo para remover o debug banner
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled = false; // Desabilita a pintura de depuração
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a imagem de debug
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    String nome = _usernameController.text;
    String senha = _passwordController.text;

    AuthService().login(nome, senha).then((isAuthenticated) {
      if (isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TelaPrincipal()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Bem-sucedido')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Credenciais Inválidas')),
        );
      }
    });
  }

  void _goToCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastroScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF64B5F6),
        centerTitle: true,
        title: Text(
          "Espaço Beleza",
          style: TextStyle(
            color: Colors.white, // Cor do texto
            fontSize: 24, // Tamanho da fonte
            fontWeight: FontWeight.bold, // Negrito
            fontFamily: 'Roboto', // Fonte personalizada (se disponível)
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset('assets/images/lotus1.png'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,       // Cor no topo
              Colors.lightBlue[200]!, // Azul claro
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'assets/images/flower.jpg',
                height: 250.0,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8), // Fundo dos campos
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
                child: Text('Login'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _goToCadastro,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthService {
  Future<bool> login(String username, String password) async {
    if (username == 'user' && password == '1234') {
      return Future.value(true);
    }
    return Future.value(false);
  }
}
