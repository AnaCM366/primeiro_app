import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TarefaFormPage extends StatefulWidget {
  const TarefaFormPage({super.key});

  @override
  State<TarefaFormPage> createState() => _TarefaFormPageState();
}

class _TarefaFormPageState extends State<TarefaFormPage> {
  late TextEditingController controllerDescricao;
  late TextEditingController controllerTitulo;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controllerDescricao = TextEditingController();
    controllerTitulo = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controllerTitulo.dispose();
    controllerDescricao.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      //puxa a configuração do tema(da página)
      appBar: AppBar(title: Text("Cadastrar Tarefa")),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerTitulo,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Digite um Titulo',
                ),
                validator: (value) => _validaCamposTitulo(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerDescricao,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Digite uma Descrição',
                ),
                validator: (value) => _validaCampoDescricao(),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _salvarTarefa,
              label: Text("Salvar Tarefa"),
              icon: Icon(Icons.save_alt_outlined),
            ),
          ],
        ),
      ),
    );
  }

  String? _validaCampoDescricao() {
    var descricaoTarefa = controllerDescricao.text;

    if (descricaoTarefa.trim().isEmpty) {
      return 'Você deve digitar uma descrição!';
    }
    return null;
  }

  String? _validaCamposTitulo() {
    var titulo = controllerTitulo.text;

    if (titulo.trim().isEmpty) {
      return 'Você preicsa deigitar um título!';
    }
    return null;
  }

  Future<void> _salvarTarefa() async {
    // Lógica para adicionar uma nova tarefa
    var tituloTarefa = controllerTitulo.text;
    var descricaoTarefa = controllerDescricao.text;

    if (formKey.currentState?.validate() == true) {
      var dio = Dio(
        BaseOptions(
          connectTimeout: Duration(seconds: 30),
          baseUrl: 'https://6912666052a60f10c8218ac5.mockapi.io/api/v1',
        ),
      );
      var response = await dio.post(
        '/tarefa',
        data: {'titulo': tituloTarefa, 'descricao': descricaoTarefa},
      );

      if (!context.mounted) return;
      Navigator.pop(context);
    }
  }
}
