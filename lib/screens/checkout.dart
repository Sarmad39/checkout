import 'package:checkout/screens/payment_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/payment.dart';
import '../constants.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _noController = TextEditingController();
  bool _isloading = false;
  String productkey = 'prod_Mmmt7h4FLlrrB5';
  final _formkey = GlobalKey<FormState>();

  void _submitData() async {
    final isValid = _formkey.currentState!.validate();
    setState(() {
      _isloading = true;
    });
    if (isValid) {
      var cardid = Provider.of<Payment>(context, listen: false)
          .tempCard['id']
          .toString();
      if (cardid.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added Payment Method First'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      } else {
        Customer temp = Customer(
          id: "",
          name: _nameController.text,
          city: _cityController.text,
          coutry: _countryController.text,
          phone: _noController.text,
        );
        var payment = Provider.of<Payment>(context, listen: false);
        try {
          await payment.addCustomer(temp);
          await payment.addSubscription(prodkey: productkey);
          await payment.uploaddata();
        } catch (error) {
          await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('An Error Occur'),
              content: const Text('Something Went wrong!'),
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
      }
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = Provider.of<Payment>(context, listen: false).tempCard;
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
                children: [
                  InkWell(
                      onTap: () {},
                      child: Text(
                        'Back',
                        style: HeadStyle.copyWith(fontSize: 12),
                      )),
                  SizedBox(
                    height: Height * 1,
                  ),
                  Center(
                      child: Text(
                    'Checkout',
                    style: HeadStyle,
                  )),
                  SizedBox(
                    height: Height * 3,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              'Personal Info',
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
                              labelText: "Name",
                            ),
                          ),
                          SizedBox(
                            height: Height * 1,
                          ),
                          TextFormField(
                            controller: _noController,
                            maxLength: 11,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return '*required';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.5, horizontal: 10.0),
                              labelText: 'Phone Number',
                            ),
                          ),
                          SizedBox(
                            height: Height * 1,
                          ),
                          TextFormField(
                            controller: _cityController,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return '*required';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.5, horizontal: 10.0),
                                labelText: 'City'),
                          ),
                          SizedBox(
                            height: Height * 1,
                          ),
                          SizedBox(
                            height: Height * 1,
                          ),
                          TextFormField(
                            controller: _countryController,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return '*required';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.5, horizontal: 10.0),
                                labelText: 'Country'),
                          ),
                          SizedBox(
                            height: Height * 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Payment Info',
                                style: HeadStyle.copyWith(fontSize: 16),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(PaymentInfoScreen.routeName);
                                  },
                                  child: Text('Add Payment Method'))
                            ],
                          ),
                          SizedBox(
                            height: Height * 1,
                          ),
                          if (card['id'].toString().isNotEmpty)
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(217, 217, 217, 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'CardHolder Name : ',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(card['name'])
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Card Number : ',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text('************${card['last4']}')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Card Brand : ',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(card['brand'])
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Epiry Date : ',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                            '${card['exmonth']}/${card['exyear']}')
                                      ],
                                    ),
                                  ]),
                            )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Height * 3,
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
