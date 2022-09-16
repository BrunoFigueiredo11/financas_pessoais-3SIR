import 'package:financas_pessoais/models/credit_card.dart';
import 'package:flutter/material.dart';

class CartoesList extends StatelessWidget {
  final CardCredit cardCredit;

  const CartoesList({Key? key, required this.cardCredit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.credit_card),
      ),
      title: Text(cardCredit.nome),
      trailing: Text("Limite: R\$ " + cardCredit.limite.toString()),
    );
  }
}
