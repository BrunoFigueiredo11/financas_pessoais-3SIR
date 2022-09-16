import 'package:financas_pessoais/models/credit_card.dart';
import 'package:financas_pessoais/repository/credit_card_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';

class CartaoPage extends StatefulWidget {
  CardCredit? cartaoCredito;
  CartaoPage({Key? key, this.cartaoCredito}) : super(key: key);

  @override
  State<CartaoPage> createState() => _CartaoPageState();
}

class _CartaoPageState extends State<CartaoPage> {
  final _cartaoRepository = CartoesRepository();
  final _limiteController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');

  final _bandeiraController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Cartão'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildDescricao(),
                const SizedBox(height: 20),
                _buildLimite(),
                const SizedBox(height: 20),
                _buildButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Adicionar'),
        ),
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            final bandeira = _bandeiraController.text;
            final limite = NumberFormat.currency(locale: 'pt_BR')
                .parse(_limiteController.text.replaceAll('R\$', ''))
                .toDouble();

            final cartao = CardCredit(
              nome: bandeira,
              limite: limite,
            );

            try {
              await _cartaoRepository.cadastrarCartao(cartao);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Cartao cadastrado com sucesso'),
              ));

              Navigator.of(context).pop(true);
            } catch (e) {
              Navigator.of(context).pop(false);
            }
          }
        },
      ),
    );
  }

  TextFormField _buildDescricao() {
    return TextFormField(
      controller: _bandeiraController,
      decoration: const InputDecoration(
        hintText: 'Informe a Bandeira do Cartão',
        labelText: 'Bandeira do Cartão',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.credit_card_rounded),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma Bandeira';
        }
        if (value.length < 3 || value.length > 30) {
          return 'O Nome deve entre 3 e 30 caracteres';
        }
        return null;
      },
    );
  }

  TextFormField _buildLimite() {
    return TextFormField(
      controller: _limiteController,
      decoration: const InputDecoration(
        labelText: 'Limite do Cartão',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.monetization_on_outlined),
      ),
      validator: (value) {
        final valor = NumberFormat.currency(locale: 'pt_BR')
            .parse(_limiteController.text.replaceAll('R\$', ''));
        if (valor <= 0) {
          return 'Informe um valor';
        }
        return null;
      },
    );
  }
}
