import './opcao.m.dart';
import './pergunta.m.dart';

class RespostaModel {
  int id;
  String resposta;
  String data;
  PerguntaModel pergunta;
  OpcaoModel opcao;

  RespostaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resposta = json['resposta'] ?? "";
    data = json['data'];
    pergunta = json['pergunta'] != null ? PerguntaModel.fromJson(json['pergunta']) : null;
    opcao = json['opcao'] != null ? OpcaoModel.fromJson(json['opcao']) : null;
  }
}
