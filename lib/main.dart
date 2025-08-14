import 'package:flutter/material.dart';
import 'db/db_helper.dart';
import 'model/nota_model.dart';
import 'screen/nota_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteLux - Tu Bloc de Lujo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ListaNotas(),
    );
  }
}

class ListaNotas extends StatefulWidget {
  const ListaNotas({super.key});

  @override
  State<ListaNotas> createState() => _ListaNotasState();
}

class _ListaNotasState extends State<ListaNotas> {
  List<Nota> _notas = [];

  @override
  void initState() {
    super.initState();
    _cargarNotas();
  }

  void _cargarNotas() async {
    final datos = await DBHelper().getNotas();
    setState(() {
      _notas = datos
          .map(
            (e) => Nota(
              id: e['id'],
              titulo: e['titulo'],
              contenido: e['contenido'],
              fecha: e['fecha'],
            ),
          )
          .toList();
    });
  }

  void _eliminarNota(int id) async {
    await DBHelper().deleteNota(id);
    _cargarNotas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF0000), Color(0xFF000000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Encabezado de lujo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  '📝 NoteLux',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Colors.white.withOpacity(0.95),
                    shadows: [
                      Shadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 8,
                          offset: const Offset(2, 2))
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _notas.isEmpty
                    ? const Center(
                        child: Text(
                          '📄 No tienes notas aún\n¡Agrega la primera!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, color: Colors.white70, height: 1.5),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _notas.length,
                        itemBuilder: (context, index) {
                          final nota = _notas[index];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            child: Card(
                              color: Colors.white.withOpacity(0.15),
                              elevation: 6,
                              shadowColor: Colors.redAccent.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(
                                  nota.titulo,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                                subtitle: Text(
                                  '${nota.fecha}\n${nota.contenido}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      const TextStyle(color: Colors.white70),
                                ),
                                isThreeLine: true,
                                trailing: Wrap(
                                  spacing: 4,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orangeAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => NotaForm(
                                                nota: nota,
                                                refresh: _cargarNotas),
                                          ),
                                        );
                                      },
                                      child: const Icon(Icons.edit,
                                          size: 18, color: Colors.white),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                      ),
                                      onPressed: () =>
                                          _eliminarNota(nota.id!),
                                      child: const Icon(Icons.delete,
                                          size: 18, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nueva Nota',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NotaForm(refresh: _cargarNotas)),
          );
        },
      ),
    );
  }
}
