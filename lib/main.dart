import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main(List<String> args) {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _cepController = TextEditingController();
  String _valorRetorno = "";

  void _buscarCep() async {
    String cep = _cepController.text;

    // Validar se o campo está vazio
    if (cep.isEmpty) {
      _mostrarErro("Por favor, insira um CEP.");
      return;
    }

    // Validar se o CEP contém apenas números
    if (!RegExp(r'^[0-9]*$').hasMatch(cep)) {
      _mostrarErro("O CEP deve conter apenas números.");
      return;
    }

    // Validar se o CEP possui 8 dígitos
    if (cep.length != 8) {
      _mostrarErro("O CEP deve ter 8 dígitos.");
      return;
    }

    var _urlApi = Uri.parse("https://viacep.com.br/ws/$cep/json/");
    http.Response resposta = await http.get(_urlApi);

    String endereco = "";

    if (resposta.statusCode == 200) {
      print('Código de Resposta: ${resposta.statusCode}');

      Map<String, dynamic> dadosCep = json.decode(resposta.body);

      endereco =
          "${dadosCep["logradouro"]}, ${dadosCep["bairro"]}, ${dadosCep["localidade"]} - ${dadosCep["uf"]} ";
    } else {
      endereco = 'Cep informado incorretamente ou não encontrado.';
    }

    setState(() {
      _valorRetorno = endereco;
    });
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consulta de CEP"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: _cepController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'CEP'),
              ),
            ),
            Text('$_valorRetorno')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buscarCep,
        child: Icon(Icons.search),
        backgroundColor: Colors.black,
      ),
    );
  }
}
