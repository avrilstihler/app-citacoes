import 'package:flutter/material.dart';
import 'package:citacoes_app/models/citacao_model.dart';

class CitacaoItem extends StatelessWidget {
  final Citacao citacao;
  final Function onTap;

  const CitacaoItem({super.key, required this.citacao, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                citacao.texto.length > 100
                    ? '${citacao.texto.substring(0, 100)}...'
                    : citacao.texto,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '- ${citacao.fonte}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
