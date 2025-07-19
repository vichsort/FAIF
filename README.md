# FAIF - Facilitador de Acesso à Informação Federal
FAIF ou Facilitador de Acesso à Informação Federal é um projeto desenvolvido pelos alunos do Instituto Federal Catarinense que serve como intermediário entre oito APIs governamentais diretamente proporcionadas pelo sistema federal e uma aplicação que serve como ferramenta para aumentar o intelecto e consciência política. 

## Como começar?
Primeiramente, acesse a pasta 'back-end' e no terminal digite
```bash
    pip install -r requirements.txt
    python app.py
```

## API
A API de código aberto do FAIF é desenvolvida e esquematizada para simplificar os processos, então, neste aspecto, este módulo documentará usagem por meio de exemplos.

## Sucesso
```json
{
  "ok": true,
  "data": { ... }  // ou lista, dependendo do endpoint
}
```

## Erro
```json
{
  "ok": false,
  "error": {
    "code": "CNPJ_NOT_FOUND", // exemplo para CNPJ
    "message": "CNPJ não encontrado.",
    "details": "texto opcional",
  }
}
```

### Endpoints
---
[ Deputados ] ----------------------------> /faif/deputados/`deputado`<br>
[ CEP ] ------------------------------------> /faif/cep/`cep`<br>
[ CNPJ ] -----------------------------------> /faif/cnpj/`cnpj`<br>
[ Serviços ] -------------------------------> /faif/servicos/`serv`<br>
[ Servidores (Portal) ] --------------------> /faif/servidores/`nome`<br>
[ Estruturas ] -----------------------------> /faif/estruturas/`info`<br>
[ COFIEX ] --------------------------------> /faif/cofiex/`info`<br>
[ CGU ] ------------------------------------> /faif/cgu/`cgu`<br>

#### Deputados
/faif/deputados/kim
```json
{
    "data": [
        {
            "email": "dep.kimkataguiri@camara.leg.br",
            "id": 204536,
            "idLegislatura": 57,
            "nome": "Kim Kataguiri",
            "siglaPartido": "UNIÃO",
            "siglaUf": "SP",
            "uri": "https://dadosabertos.camara.leg.br/api/v2/deputados/204536",
            "uriPartido": "https://dadosabertos.camara.leg.br/api/v2/partidos/38009",
            "urlFoto": "https://www.camara.leg.br/internet/deputado/bandep/204536.jpg"
        }
    ],
    "ok": true
}
```

#### CEP
/faif/cep/89801-000
```json
{
    "data": {
        "cep": "89801000",
        "city": "Chapecó",
        "location": {
            "coordinates": {
                "latitude": "-27.1038749",
                "longitude": "-52.6144686"
            },
            "type": "Point"
        },
        "neighborhood": "Centro",
        "service": "open-cep",
        "state": "SC",
        "street": "Avenida Getúlio Dorneles Vargas - N"
    },
    "ok": true
}
```

#### CNPJ
/faif/cnpj/82951229000176
```json
{
    "data": {
        "bairro": "SACO GRANDE II",
        "capital_social": 0,
        "cep": "88032000",
        "cnae_fiscal": 8411600,
        "cnae_fiscal_descricao": "Administração pública em geral",
        "cnaes_secundarios": [
            {
                "codigo": 0,
                "descricao": ""
            }
        ],
        "cnpj": "82951229000176",
        "codigo_municipio": 8105,
        "codigo_municipio_ibge": 4205407,
        "codigo_natureza_juridica": 1236,
        "codigo_pais": null,
        "codigo_porte": 5,
        "complemento": "KM 5",
        "data_exclusao_do_mei": null,
        "data_exclusao_do_simples": null,
        "data_inicio_atividade": "1974-12-13",
        "data_opcao_pelo_mei": null,
        "data_opcao_pelo_simples": null,
        "data_situacao_cadastral": "2005-11-03",
        "data_situacao_especial": null,
        "ddd_fax": "4836652120",
        "ddd_telefone_1": "4836652149",
        "ddd_telefone_2": "",
        "descricao_identificador_matriz_filial": "MATRIZ",
        "descricao_motivo_situacao_cadastral": "SEM MOTIVO",
        "descricao_situacao_cadastral": "ATIVA",
        "descricao_tipo_de_logradouro": "RODOVIA",
        "email": null,
        "ente_federativo_responsavel": "SANTA CATARINA",
        "identificador_matriz_filial": 1,
        "logradouro": "SC 401",
        "motivo_situacao_cadastral": 0,
        "municipio": "FLORIANOPOLIS",
        "natureza_juridica": "Estado ou Distrito Federal",
        "nome_cidade_no_exterior": "",
        "nome_fantasia": "ESTADO DE SANTA CATARINA",
        "numero": "4600",
        "opcao_pelo_mei": null,
        "opcao_pelo_simples": null,
        "pais": null,
        "porte": "DEMAIS",
        "qsa": null,
        "qualificacao_do_responsavel": 5,
        "razao_social": "ESTADO DE SANTA CATARINA",
        "regime_tributario": null,
        "situacao_cadastral": 2,
        "situacao_especial": "",
        "uf": "SC"
    },
    "ok": true
}
```


---

## Como funciona o middleware
1. **Exceções customizadas** (`FaifError` e subclasses) carregam metadados.
2. **`@app.errorhandler(err)`** converte exceções em respostas JSON padronizadas.
3. **`@app.errorhandler(Exception)`** *fallback* para erros inesperados.
4. **Função utilitária `fetch_json`** centraliza a chamada `requests.get`, trata
   timeouts, status codes e decodificação de JSON; ela lança exceções Faif.
5. Cada endpoint fica enxuto: constrói URL, chama `fetch_json`, aplica lógicas
   específicas (ex.: filtro de servidores) e retorna `ok: true`.

---

