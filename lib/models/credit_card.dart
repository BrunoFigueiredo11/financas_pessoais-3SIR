import 'package:financas_pessoais/models/tipo_lancamento.dart';

class CardCredit {
  int? id;
  String nome;
  double limite;

  CardCredit({
    this.id,
    required this.nome,
    required this.limite,
  });
}
