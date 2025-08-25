import 'package:flutter/material.dart';
import '../model/deputado_model.dart';

class DeputadoCard extends StatelessWidget {
  final Deputado deputado;
  final bool isDark;

  const DeputadoCard({
    super.key,
    required this.deputado,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final fundo = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final fundoInput = isDark ? const Color(0xFF2A2A2A) : Colors.grey[200]!;
    final texto = isDark ? Colors.white : Colors.black;
    final laranja = const Color(0xFFFF6B35);

    return Container(
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto ou placeholder
          Container(
            height: 90,
            width: 70,
            decoration: BoxDecoration(
              color: laranja,
              borderRadius: BorderRadius.circular(8),
            ),
            child: deputado.urlFoto.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      deputado.urlFoto,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Text(
                      "(Foto do deputado)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),

          const SizedBox(width: 12),

          // Informações
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deputado.nome,
                  style: TextStyle(
                    color: texto,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  deputado.siglaPartido.isNotEmpty
                      ? deputado.siglaPartido
                      : "Nome do deputado",
                  style: TextStyle(color: texto, fontSize: 14),
                ),
                const SizedBox(height: 8),

                // Botão acessar
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: laranja,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  onPressed: () {
                    // TODO: ação acessar deputado
                  },
                  child: const Text("Acessar"),
                ),

                const SizedBox(height: 8),

                // Referência
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "Referência | Ver fonte",
                    style: TextStyle(
                      color: texto,
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
