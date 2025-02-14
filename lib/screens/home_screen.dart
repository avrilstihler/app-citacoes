import 'package:flutter/material.dart';
import 'package:citacoes_app/models/citacao_model.dart';
import 'package:citacoes_app/database/database_helper.dart';
import 'package:citacoes_app/screens/citacao_detail_screen.dart';
import 'package:citacoes_app/screens/citacao_completa_screen.dart';
import 'package:citacoes_app/screens/favorites_screen.dart';
import 'package:citacoes_app/screens/add_citacao_screen.dart'; // Importe a tela de adicionar citação

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  void _alterarCitacao(BuildContext context, Citacao citacao) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CitacaoDetailScreen(
          isIncluir: false, // Indica que é uma edição
          citacao: citacao,
          onFinalizado: () {
            _atualizarCitacoes(); // Atualiza a lista após editar
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
        title: Text('Citações'),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(),
                ),
              );
            },
          ),
        ],
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
                  builder: (context) => CitacaoCompletaScreen(
                    citacao: citacao,
                    onUpdate: _atualizarCitacoes,
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
                          content: Text('Você deseja mesmo excluir esta citação?'),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCitacaoScreen(
                onCitacaoAdicionada: _atualizarCitacoes, // Passa o callback para atualizar a lista
              ),
            ),
          );
        },
        tooltip: 'Adicionar Citação',
        child: const Icon(Icons.add),
      ),
    );
  }
}