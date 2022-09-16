import 'package:financas_pessoais/components/categoria_list_item.dart';
import 'package:financas_pessoais/components/list_credit_card.dart';
import 'package:financas_pessoais/models/credit_card.dart';
import 'package:financas_pessoais/pages/credit_card_page_cadastro.dart';
import 'package:financas_pessoais/repository/categoria_repository.dart';
import 'package:financas_pessoais/repository/credit_card_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/categorial.dart';

class ListaCartoes extends StatefulWidget {
  ListaCartoes({Key? key}) : super(key: key);

  @override
  State<ListaCartoes> createState() => _ListaCartoes();
}

class _ListaCartoes extends State<ListaCartoes> {
  final _futureCartoesRepository = CartoesRepository();
  late Future<List<CardCredit>> _futureCard;

  @override
  void initState() {
    carregarCartoes();
    super.initState();
  }

  void carregarCartoes() {
    _futureCard = _futureCartoesRepository.listarCartoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cartões de Crédito')),
      body: FutureBuilder<List<CardCredit>>(
          future: _futureCard,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              final cartoes = snapshot.data ?? [];
              return ListView.separated(
                itemCount: cartoes.length,
                itemBuilder: (context, index) {
                  final cartao = cartoes[index];
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            await _futureCartoesRepository
                                .removerCartao(cartao.id!);

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Cartão removido com sucesso')));

                            setState(() {
                              cartoes.removeAt(index);
                            });
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Remover',
                        ),
                        SlidableAction(
                          onPressed: (context) async {
                            var success = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => CartaoPage(
                                  cartaoCredito: cartao,
                                ),
                              ),
                            ) as bool?;

                            if (success != null && success) {
                              setState(() {
                                carregarCartoes();
                              });
                            }
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Editar',
                        ),
                      ],
                    ),
                    child: CartoesList(cardCredit: cartao),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              );
            }

            return Container();
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool? cartaoCadastrado = await Navigator.of(context)
                .pushNamed('/cartao-cadastro') as bool?;

            if (cartaoCadastrado != null && cartaoCadastrado) {
              setState(() {
                carregarCartoes();
              });
            }
          },
          child: const Icon(Icons.add_card)),
    );
  }
}
