import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_this_food/blocs/payment/payment_bloc.dart';

class SuccessPaymentPage extends StatelessWidget {
  const SuccessPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("The payment is successful."),
        const SizedBox(
          height: 10,
          width: double.infinity,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<PaymentBloc>().add(PaymentStart());
            Navigator.pushNamed(context, '/home');
            style:
            ElevatedButton.styleFrom(
              primary: const Color(0xFF546B2F),
            );
          },
          child: const Text("Back to Home"),
        ),
      ],
    );
  }
}
