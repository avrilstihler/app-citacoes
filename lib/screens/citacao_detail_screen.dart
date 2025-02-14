import 'package:flutter/material.dart';
import 'package:citacoes_app/models/citacao_model.dart';
import 'package:citacoes_app/database/database_helper.dart';

class CitacaoDetailScreen extends StatefulWidget {
  final bool isIncluir;
  final Citacao citacao;
  final Function onFinalizado;

  const CitacaoDetailScreen({
    super.key,
    required this.isIncluir,
    required this.citacao,
    required this.onFinalizado,
  });

  @override
  State<CitacaoDetailScreen> createState() => _CitacaoDetailScreenState();
}

class _CitacaoDetailScreenState extends State<CitacaoDetailScreen> {
  late TextEditingController _textoController;
  late TextEditingController _fonteController;

  @override
  void initState() {
    super.initState();
    _textoController = TextEditingController(text: widget.citacao.texto);
    _fonteController = TextEditingController(text: widget.citacao.fonte);
  }

  void _salvarCitacao() async {
    final citacao = Citacao(
      id: widget.citacao.id,
      texto: _textoController.text,
      fonte: _fonteController.text,
      isFavorito: widget.citacao.isFavorito,
    );

    if (widget.isIncluir) {
      await DatabaseHelper().insertCitacao(citacao);
    } else {
      await DatabaseHelper().updateCitacao(citacao);
    }

    widget.onFinalizado();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isIncluir ? 'Adicionar Citação' : 'Editar Citação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _textoController,
              decoration: InputDecoration(labelText: 'Citação'),
              maxLines: null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _fonteController,
              decoration: InputDecoration(labelText: 'Fonte'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Cor do fundo
                    foregroundColor: Colors.white, // Cor do texto
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  label: Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Cor do fundo
                    foregroundColor: Colors.white, // Cor do texto
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  label: Text('Salvar'),
                  onPressed: _salvarCitacao,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
