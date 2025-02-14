import 'package:flutter/material.dart';
import 'package:citacoes_app/database/database_helper.dart';
import 'package:citacoes_app/models/citacao_model.dart';

class AddCitacaoScreen extends StatefulWidget {
  final Function onCitacaoAdicionada; // Callback para atualizar a lista

  const AddCitacaoScreen({super.key, required this.onCitacaoAdicionada});

  @override
  State<AddCitacaoScreen> createState() => _AddCitacaoScreenState();
}

class _AddCitacaoScreenState extends State<AddCitacaoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textoController = TextEditingController();
  final _fonteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Citação')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _textoController,
                decoration: const InputDecoration(
                  hintText: 'Escreva aqui algo que te inspira...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma citação';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fonteController,
                decoration: const InputDecoration(
                  labelText: 'Fonte',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ), 
                ),
                style: const TextStyle(color: Colors.grey),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a fonte';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // Cor do fundo
                      foregroundColor: Colors.white, // Cor do texto
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // Cor do fundo
                      foregroundColor: Colors.white, // Cor do texto
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Salvar'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Citacao novaCitacao = Citacao(
                          texto: _textoController.text,
                          fonte: _fonteController.text,
                        );
                        DatabaseHelper().insertCitacao(novaCitacao);
                        widget.onCitacaoAdicionada(); // Atualiza a lista na tela inicial
                        Navigator.pop(context); // Volta para a tela inicial
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}