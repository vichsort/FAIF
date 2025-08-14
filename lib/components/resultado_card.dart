// lib/components/resultado_card.dart
import 'package:flutter/material.dart';
import 'package:faif/model/resultado_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultadoCard extends StatelessWidget {
  final ResultadoBusca resultado;

  const ResultadoCard({super.key, required this.resultado});

  Future<void> _abrirLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Não foi possível abrir: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: ListTile(
        title: Text(
          resultado.titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(resultado.descricao),
        trailing: const Icon(Icons.open_in_new),
        onTap: () => _abrirLink(resultado.link),
      ),
    );
  }
}
