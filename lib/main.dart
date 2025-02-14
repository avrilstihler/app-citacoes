import 'package:citacoes_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:citacoes_app/models/citacao_model.dart';
import 'package:citacoes_app/database/database_helper.dart';
import 'package:citacoes_app/screens/citacao_detail_screen.dart';
import 'package:citacoes_app/screens/citacao_completa_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Citações App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple[800],
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E28),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Cor dos ícones
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple, // Cor do botão flutuante
          foregroundColor: Colors.white, // Cor do ícone
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Citacao> _citacoes = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _atualizarCitacoes();
  }

  Future<void> _atualizarCitacoes() async {
    final resultado = await _databaseHelper.getCitacoes();
    setState(() {
      _citacoes = resultado;
    });
  }

  void _incluirCitacao(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CitacaoDetailScreen(
              isIncluir: true,
              citacao: Citacao(texto: '', fonte: ''),
              onFinalizado: () {
                _atualizarCitacoes();
              },
            ),
      ),
    );
  }

  void _alterarCitacao(BuildContext context, Citacao citacao) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CitacaoDetailScreen(
              isIncluir: false,
              citacao: citacao,
              onFinalizado: () {
                _atualizarCitacoes();
              },
            ),
      ),
    );
  }

  void _excluirCitacao(int id) async {
    await _databaseHelper.deleteCitacao(id);
    _atualizarCitacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _citacoes.length,
        itemBuilder: (context, index) {
          final citacao = _citacoes[index];
          return ListTile(
            title: Text(citacao.texto),
            subtitle: Text('- ${citacao.fonte}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CitacaoCompletaScreen(
                        citacao: citacao,
                        onUpdate: () {},
                      ),
                ),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _alterarCitacao(context, citacao),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Excluir Citação'),
                          content: Text(
                            'Você deseja mesmo excluir esta citação?',
                          ),
                          actions: [
                            TextButton(
                              child: Text('Cancelar'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text('Excluir'),
                              onPressed: () {
                                _excluirCitacao(citacao.id!);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incluirCitacao(context),
        tooltip: 'Adicionar Citação',
        child: const Icon(Icons.add),
      ),
    );
  }
}
