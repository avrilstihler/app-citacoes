import 'package:flutter/material.dart';
import 'package:citacoes_app/models/citacao_model.dart';
import 'package:citacoes_app/database/database_helper.dart';
import 'package:citacoes_app/screens/citacao_completa_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
      ),
      body: FutureBuilder<List<Citacao>>(
        future: DatabaseHelper().getCitacoes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar citações'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma citação favoritada'));
          } else {
            final favoritos = snapshot.data!.where((citacao) => citacao.isFavorito).toList();
            return ListView.builder(
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                final citacao = favoritos[index];
                return ListTile(
                  title: Text(citacao.texto),
                  subtitle: Text('- ${citacao.fonte}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CitacaoCompletaScreen(
                          citacao: citacao,
                          onUpdate: () {
                            // Atualiza a lista de favoritos
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}