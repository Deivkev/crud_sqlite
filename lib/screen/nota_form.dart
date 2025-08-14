import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../model/nota_model.dart';

class NotaForm extends StatefulWidget {
  final Nota? nota;
  final Function refresh;

  const NotaForm({super.key, this.nota, required this.refresh});

  @override
  State<NotaForm> createState() => _NotaFormState();
}

class _NotaFormState extends State<NotaForm> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.nota != null) {
      _tituloController.text = widget.nota!.titulo;
      _contenidoController.text = widget.nota!.contenido;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    super.dispose();
  }

  void _guardarNota() async {
    if (_formKey.currentState!.validate()) {
      final nota = Nota(
        id: widget.nota?.id,
        titulo: _tituloController.text,
        contenido: _contenidoController.text,
        fecha: DateTime.now().toString().substring(0, 16),
      );

      if (widget.nota == null) {
        await DBHelper().insertNota(nota.toMap());
      } else {
        await DBHelper().updateNota(nota.toMap());
      }

      widget.refresh();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.nota != null;

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
              // Encabezado elegante
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  esEdicion ? '✏️ Editar Nota' : '📝 Nueva Nota',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Campo título
                        TextFormField(
                          controller: _tituloController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('Título'),
                          validator: (value) =>
                              value!.isEmpty ? 'Ingrese un título' : null,
                        ),
                        const SizedBox(height: 16),
                        // Campo contenido
                        TextFormField(
                          controller: _contenidoController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('Contenido'),
                          maxLines: 6,
                          validator: (value) =>
                              value!.isEmpty ? 'Ingrese contenido' : null,
                        ),
                        const SizedBox(height: 30),
                        // Botón guardar de lujo
                        ElevatedButton.icon(
                          onPressed: _guardarNota,
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: Text(
                            esEdicion ? 'Guardar Cambios' : 'Guardar Nota',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                            shadowColor: Colors.black.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Estilo de campos de texto
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white54, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
    );
  }
}
