import 'package:financas_pessoais/database/database_manager.dart';
import 'package:financas_pessoais/models/categorial.dart';
import 'package:financas_pessoais/models/credit_card.dart';
import 'package:financas_pessoais/models/tipo_lancamento.dart';

class CartoesRepository {
  Future<List<CardCredit>> listarCartoes() async {
    final db = await DatabaseManager().getDatabase();

    // Listar Categorias do Banco de dados
    // Retorna uma Lista de Map (chave/valor)
    // onde a chave é o nome da coluna no banco de dados
    final List<Map<String, dynamic>> rows = await db.query('card');

    // Mapear a lista de <Map> para uma lista de <Categoria>
    return rows
        .map((row) => CardCredit(
              id: row['id'],
              nome: row['nome'],
              limite: row['limite'],
            ))
        .toList();
  }

  Future<void> cadastrarCartao(CardCredit cartao) async {
    final db = await DatabaseManager().getDatabase();

    await db.insert('card', {
      'nome': cartao.nome,
      'limite': cartao.limite,
    });
  }

  Future<void> removerCartao(int id) async {
    final db = await DatabaseManager().getDatabase();
    await db.delete('card', where: 'id = ?', whereArgs: [id]);
  }
}
