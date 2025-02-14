import 'package:flutter/material.dart';
import 'package:citacoes_app/models/citacao_model.dart';
import 'package:citacoes_app/database/database_helper.dart';

class CitacaoCompletaScreen extends StatefulWidget {
  final Citacao citacao;
  final Function onUpdate;

  const CitacaoCompletaScreen({
    super.key,
    required this.citacao,
    required this.onUpdate,
  });

  @override
  State<CitacaoCompletaScreen> createState() => _CitacaoCompletaScreenState();
}

class _CitacaoCompletaScreenState extends State<CitacaoCompletaScreen> {
  late Citacao _citacao;

  @override
  void initState() {
    super.initState();
    _citacao = widget.citacao;
  }

  void _toggleFavorito() async {
    setState(() {
      _citacao.isFavorito = !_citacao.isFavorito;
    });

    await DatabaseHelper().updateCitacao(_citacao);
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Citação Completa'),
        actions: [
          IconButton(
            icon: Icon(
              _citacao.isFavorito ? Icons.star : Icons.star_border,
              color: _citacao.isFavorito ? Colors.yellow : null,
            ),
            onPressed: _toggleFavorito,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _citacao.texto,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              '- ${_citacao.fonte}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}