class Nota {
  int? id;
  String titulo;
  String contenido;
  String fecha;

  Nota({
    this.id,
    required this.titulo,
    required this.contenido,
    required this.fecha,
  });

  // Convertir objeto a Map para SQLite
  Map<String, dynamic> toMap() {
    final map = {
      'titulo': titulo,
      'contenido': contenido,
      'fecha': fecha,
    };
    if (id != null) {
      map['id'] = id as String;
    }
    return map;
  }

  // Convertir Map de SQLite a objeto Nota
  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map['id'],
      titulo: map['titulo'],
      contenido: map['contenido'],
      fecha: map['fecha'],
    );
  }
}
