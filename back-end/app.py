import os
import logging
from typing import Any, Dict, Optional

import requests
from flask import Flask, jsonify, request
from flask_cors import CORS

# ---------------------------------------------------------------------------
# Configuração básica
# ---------------------------------------------------------------------------

app = Flask(__name__)
CORS(app)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Tokens vindos do ambiente (.env / variáveis de ambiente)
token_cofiex = os.getenv("TOKEN_COFIEX")
token_cgu = os.getenv("TOKEN_CGU")  # carregado logo no início

TOKEN_PORTAL = os.getenv("TOKEN_PORTAL", "d1b5fac8951a331b63047753f1eaa2fb")

# Timeout padrão para chamadas externas (segundos)
DEFAULT_TIMEOUT = int(os.getenv("FAIF_HTTP_TIMEOUT", "10"))

# ---------------------------------------------------------------------------
# Exceções customizadas
# ---------------------------------------------------------------------------

class err(Exception):
# aqui fica o tratamento total dos erros
    def __init__(
        self,
        message: str, # mensagem de erro
        *,
        status_code: int = 500, # código de erro
        error_code: str = "INTERNAL_ERROR",
        details: Optional[str] = None, # detalhes (texto curto)
    ) -> None:
        super().__init__(message)
        self.message = message
        self.status_code = status_code
        self.error_code = error_code
        self.details = details

    def to_dict(self) -> Dict[str, Any]:
        return {
            "ok": False,
            "error": {
                "code": self.error_code,
                "message": self.message,
                "details": self.details,
            },
        }


class ErrorNotFound(err):
    def __init__(self, message: str, *, error_code: str = "NOT_FOUND", details: Optional[str] = None, upstream_status: Optional[int] = 404) -> None:
        super().__init__(message, status_code=404, error_code=error_code, details=details, upstream_status=upstream_status)


class ConnectionErrorUpstream(err):
    def __init__(self, message: str, *, details: Optional[str] = None) -> None:
        super().__init__(message, status_code=502, error_code="UPSTREAM_CONNECTION_ERROR", details=details)


class ErrorUpstream(err):
    def __init__(self, message: str, *, upstream_status: int, details: Optional[str] = None, error_code: str = "UPSTREAM_ERROR") -> None:
        super().__init__(message, status_code=502, error_code=error_code, details=details, upstream_status=upstream_status)


class InvalidJSON(err):
    def __init__(self, message: str = "Resposta JSON inválida do serviço externo.", *, upstream_status: Optional[int] = None, details: Optional[str] = None) -> None:
        super().__init__(message, status_code=502, error_code="INVALID_JSON", details=details, upstream_status=upstream_status)


# ---------------------------------------------------------------------------
# Respostas
# ---------------------------------------------------------------------------

def success_response(data: Any, status_code: int = 200):
    """Resposta padronizada de sucesso."""
    return jsonify({"ok": True, "data": data}), status_code


def error_response_from_exception(exc: err):
    return jsonify(exc.to_dict()), exc.status_code


# ---------------------------------------------------------------------------
# Centro das requisições
# ---------------------------------------------------------------------------

def fetch_json(
    url: str,
    *,
    headers: Optional[Dict[str, str]] = None,
    timeout: Optional[int] = None,
    not_found_message: str = "Recurso não encontrado.",
    not_found_error_code: str = "NOT_FOUND",
) -> Any:
    #Faz GET em uma URL e retorna JSON e chama exceção no caso de erro
    headers = headers or {}
    timeout = timeout or DEFAULT_TIMEOUT

    logger.info("[FAIF] GET %s", url)
    try:
        resp = requests.get(url, headers=headers, timeout=timeout)
    except requests.RequestException as e:  # tipo Timeout, ConnectionError
        logger.exception("[FAIF] Erro de conexão com %s", url)
        raise ConnectionErrorUpstream("Erro de conexão com serviço externo.", details=str(e)) from e

    # para 404:
    if resp.status_code == 404:
        raise ErrorNotFound(not_found_message, error_code=not_found_error_code, upstream_status=resp.status_code, details=resp.text[:500])

    # para outros erros:
    if not resp.ok:
        raise ErrorUpstream(
            "Erro ao consultar serviço externo.",
            upstream_status=resp.status_code,
            details=resp.text[:500],
        )

    # Decodifica JSON
    try:
        return resp.json()
    except ValueError as e:  # JSON inválido
        logger.exception("[FAIF] JSON inválido de %s", url)
        raise InvalidJSON(upstream_status=resp.status_code, details=str(e)) from e


# ---------------------------------------------------------------------------
# Rotas / Endpoints
# ---------------------------------------------------------------------------
#   [ Serviços ]               /faif/servicos/<serv>
#   [ Servidores (Portal) ]    /faif/servidores/<nome>
#   (Futuros) Estruturas, COFIEX, CGU, etc.
# ---------------------------------------------------------------------------

# DEPUTADOS -----------------------------------------------------------------
@app.route("/faif/deputados/<deputado>")
def buscar_deputados(deputado: str):
    url = f"https://dadosabertos.camara.leg.br/api/v2/deputados?nome={deputado}"
    dados = fetch_json(
        url,
        headers={"Accept": "application/json"},
        not_found_message="Deputado(s) não encontrado(s).",  # o endpoint retorna 200 mesmo qdo vazio, mas deixo aqui pra ter consistência
        not_found_error_code="DEPUTADO_NOT_FOUND",
    )

    # API da Câmara retorna {"dados": [...], "links": [...]}
    lista = dados.get("dados", []) if isinstance(dados, dict) else dados
    return success_response(lista)


# CEP -----------------------------------------------------------------------
@app.route("/faif/cep/<cep>")
def consultar_cep(cep: str):
    # tira o que nao é digito
    digits = ''.join(filter(str.isdigit, cep))
    url = f"https://brasilapi.com.br/api/cep/v2/{digits}"
    dados = fetch_json(
        url,
        not_found_message="CEP não encontrado.",
        not_found_error_code="CEP_NOT_FOUND",
    )
    return success_response(dados)


# CNPJ ----------------------------------------------------------------------
@app.route("/faif/cnpj/<cnpj>")
def consultar_cnpj(cnpj: str):
    digits = ''.join(filter(str.isdigit, cnpj))
    url = f"https://brasilapi.com.br/api/cnpj/v1/{digits}"
    dados = fetch_json(
        url,
        not_found_message="CNPJ não encontrado.",
        not_found_error_code="CNPJ_NOT_FOUND",
    )
    return success_response(dados)


# SERVIÇOS (gov.br) ---------------------------------------------------------
@app.route("/faif/servicos/<serv>")
def consultar_servico(serv: str):
    url = f"https://www.servicos.gov.br/api/v1/orgao/serv/{serv}"
    dados = fetch_json(
        url,
        not_found_message="Código SIORG não encontrado.",
        not_found_error_code="SIORG_NOT_FOUND",
    )
    return success_response(dados)


# SERVIDORES (Portal da Transparência) --------------------------------------
@app.route("/faif/servidores/<nome>")
def buscar_servidores(nome):
    url = f"https://api.portaldatransparencia.gov.br/api-de-dados/pessoas-fisicas?nome={nome}&pagina=1"
    headers = {
        "Accept": "application/json",
        "chave-api-dados": TOKEN_PORTAL,
    }

    dados = fetch_json(
        url,
        headers=headers,
        not_found_message="Nenhum servidor encontrado para este nome.",
        not_found_error_code="SERVIDOR_NOT_FOUND",
    )

    # O Portal pode retornar lista de pessoas físicas com vários tipos de vínculo.
    if isinstance(dados, list):
        servidores = [p for p in dados if 'Servidor' in ((p.get('vinculo') or '').title())]
    else:
        servidores = []

    return success_response(servidores)


# ---------------------------------------------------------------------------
# Handlers
# ---------------------------------------------------------------------------

@app.errorhandler(err)
def handle_faif_error(exc: err):  # type: ignore[override]
    logger.warning("[FAIF] %s", exc)
    return error_response_from_exception(exc)


@app.errorhandler(Exception)
def handle_unexpected_error(exc: Exception):  # type: ignore[override]
    logger.exception("[FAIF] Erro inesperado: %s", exc)
    fallback = err("Erro interno do servidor.")
    return error_response_from_exception(fallback)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
