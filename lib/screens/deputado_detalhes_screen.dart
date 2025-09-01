import 'package:faif/model/deputado_detalhes_model.dart';
import 'package:faif/services/api_service.dart';
import 'package:flutter/material.dart';

class DeputadoDetalhesPage extends StatefulWidget {
  final int deputadoId;
  final String deputadoNome; // Para mostrar o nome no AppBar enquanto carrega

  const DeputadoDetalhesPage({
    super.key,
    required this.deputadoId,
    required this.deputadoNome,
  });

  @override
  State<DeputadoDetalhesPage> createState() => _DeputadoDetalhesPageState();
}

class _DeputadoDetalhesPageState extends State<DeputadoDetalhesPage> {
  final ApiService _apiService = ApiService();
  
  // Estado para controlar o carregamento e os dados
  late Future<DeputadoDetalhes> _deputadoFuture;

  @override
  void initState() {
    super.initState();
    // Inicia a busca pelos dados assim que a tela é construída
    _deputadoFuture = _apiService.fetchDeputadoDetails(widget.deputadoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deputadoNome),
      ),
      body: FutureBuilder<DeputadoDetalhes>(
        future: _deputadoFuture,
        builder: (context, snapshot) {
          // Enquanto está carregando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Se deu erro
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar detalhes: ${snapshot.error}'));
          }
          // Se carregou com sucesso
          if (snapshot.hasData) {
            final deputado = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildHeader(deputado),
                SizedBox(height: 24),
                _buildInfoCard(deputado),
              ],
            );
          }
          // Caso padrão
          return Center(child: Text('Nenhum dado encontrado.'));
        },
      ),
    );
  }

  Widget _buildHeader(DeputadoDetalhes deputado) {
    return Row(
      children: [
        if (deputado.urlFoto != null)
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(deputado.urlFoto!),
          ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deputado.nomeEleitoral ?? 'Nome não disponível',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                '${deputado.siglaPartido ?? ''} - ${deputado.situacao ?? ''}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(DeputadoDetalhes deputado) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Informações Pessoais', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            _buildInfoTile('Nome Civil', deputado.nomeCivil),
            _buildInfoTile('CPF', deputado.cpf),
            _buildInfoTile('Nascimento', deputado.dataNascimento),
            _buildInfoTile('Escolaridade', deputado.escolaridade),
            SizedBox(height: 16),
            if (deputado.gabinete != null) ...[
              Text('Gabinete', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Divider(),
              _buildInfoTile('Email', deputado.gabinete!.email),
              _buildInfoTile('Telefone', deputado.gabinete!.telefone),
              _buildInfoTile('Andar', deputado.gabinete!.andar),
              _buildInfoTile('Sala', deputado.gabinete!.sala),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String? value) {
    if (value == null || value.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title:', style: TextStyle(color: Colors.grey[700])),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}