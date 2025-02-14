class Citacao {
  int? id;
  String texto;
  String fonte;
  bool isFavorito;

  Citacao({
    this.id,
    required this.texto,
    required this.fonte,
    this.isFavorito = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'texto': texto,
      'fonte': fonte,
      'isFavorito': isFavorito ? 1 : 0,
    };
  }

  factory Citacao.fromMap(Map<String, dynamic> map) {
    return Citacao(
      id: map['id'],
      texto: map['texto'],
      fonte: map['fonte'],
      isFavorito: map['isFavorito'] == 1,
    );
  }
}