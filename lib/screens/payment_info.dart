// ignore_for_file: use_build_context_synchronously

import 'package:checkout/Models/http_exception.dart';
import 'package:checkout/Models/payment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class PaymentInfoScreen extends StatefulWidget {
  static const routeName = '/Payment_Info';
  const PaymentInfoScreen({super.key});

  @override
  State<PaymentInfoScreen> createState() => _PaymentInfoScreenState();
}

class _PaymentInfoScreenState extends State<PaymentInfoScreen> {
  final _nameController = TextEditingController();
  final _cardnoController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isloading = false;
  final _formkey = GlobalKey<FormState>();

  void _submitData() async {
    final isValid = _formkey.currentState!.validate();
    setState(() {
      _isloading = true;
    });
    if (isValid) {
      CardInfo temp = CardInfo(
        name: _nameController.text,
        cardNo: _cardnoController.text,
        exmonth: _monthController.text,
        exyear: _yearController.text,
        cvv: _cvvController.text,
      );
      try {
        await Provider.of<Payment>(context, listen: false)
            .addPaymentMethod(temp);
        //  Navigator.of(context).pop();
      } on HttpException catch (error) {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('An Error Occur'),
            content: Text(error.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("okay"),
              ),
            ],
          ),
        );
      }
      setState(() {
        _isloading = false;
      });
    }

    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Back',
                      style: HeadStyle.copyWith(fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: Height * 1,
                  ),
                  Center(
                      child: Text(
                    'Payment Information',
                    style: HeadStyle,
                  )),
                  SizedBox(
                    height: Height * 10,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 15),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              'Payment Details',
                              style: HeadStyle.copyWith(fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: Height * 1,
                          ),
                          TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return '*required';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.5, horizontal: 10.0),
                              labelText: 'Name',
                              hintText: 'Enter name mention on the card',
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(20, 14, 37, 0.6),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Height * 1,
                          ),
                          TextFormField(
                            controller: _cardnoController,
                            keyboardType: TextInputType.number,
                            maxLength: 16,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return '*required';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.5, horizontal: 10.0),
                              labelText: 'Card Number',
                              hintText:
                                  'Enter 16-digits Debit/Credit card number',
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(20, 14, 37, 0.6),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Height * 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.025,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Expiry Date"),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: TextFormField(
                                            controller: _monthController,
                                            keyboardType: TextInputType.number,
                                            maxLength: 2,
                                            validator: (value) {
                                              if (value.toString().isEmpty) {
                                                return '*';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 12.5,
                                                      horizontal: 10.0),
                                              hintText: 'MM',
                                              hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    20, 14, 37, 0.6),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          '/',
                                          style: TextStyle(fontSize: 25),
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                            controller: _yearController,
                                            maxLength: 2,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value.toString().isEmpty) {
                                                return '*';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 12.5,
                                                      horizontal: 10.0),
                                              hintText: 'YY',
                                              hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    20, 14, 37, 0.6),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _cvvController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return '*required';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 12.5, horizontal: 10.0),
                                    labelText: 'CVV',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Height * 10,
                  ),
                  InkWell(
                    onTap: _isloading ? null : _submitData,
                    child: Container(
                      alignment: Alignment.center,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primaryColor,
                      ),
                      child: _isloading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              'Confirm',
                              style: HeadStyle.copyWith(fontSize: 16),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
