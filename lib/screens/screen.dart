import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/http_exception.dart';
import '../Models/payment.dart';
import '../constants.dart';
import 'payment_info.dart';

class ScreenW extends StatefulWidget {
  const ScreenW({super.key});

  @override
  State<ScreenW> createState() => _ScreenWState();
}

class _ScreenWState extends State<ScreenW> {
  int _index = 0;
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _noController = TextEditingController();
  bool _isloading = false;
  bool _isdone = false;
  String productkey = 'prod_Mmmt7h4FLlrrB5';
  final _formkey = GlobalKey<FormState>();

  Future<void> _submitData() async {
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
            content: Text('Add Payment Method First'),
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
          print('Complete');
          setState(() {
            _isdone = true;
          });
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
    final card = Provider.of<Payment>(context).tempCard;
    final Height = MediaQuery.of(context).size.height / 100;

    List<Step> steps = [
      Step(
          isActive: _index >= 0,
          title: const Text(''),
          content: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return '*required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.5, horizontal: 10.0),
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.5, horizontal: 10.0),
                    labelText: 'Phone Number',
                  ),
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
              ],
            ),
          )),
      Step(
        isActive: _index >= 1,
        title: Text(''),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Height * 1,
            ),
            Text(
              'Personal Info',
              style: HeadStyle.copyWith(fontSize: 16),
            ),
            SizedBox(
              height: Height * 1,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Name : ',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                        Text(_nameController.text)
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Phone Number : ',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                        Text(_noController.text)
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'City: ',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                        Text(_cityController.text)
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Country : ',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                        Text(_countryController.text)
                      ],
                    ),
                  ]),
            ),
            SizedBox(
              height: Height * 2,
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
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: card['id'].toString().isNotEmpty
                  ? Consumer<Payment>(
                      builder: (context, card, child) => Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'CardHolder Name : ',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(card.tempCard['name'])
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
                                Text('************${card.tempCard['last4']}')
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
                                Text(card.tempCard['brand'])
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
                                    '${card.tempCard['exmonth']}/${card.tempCard['exyear']}')
                              ],
                            ),
                          ]),
                    )
                  : Center(child: Text("Add Method to see Card Details")),
            ),
            SizedBox(
              height: Height * 2,
            ),
            _isdone
                ? Container(
                    height: Height * 10,
                  )
                : Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('*Click on Submit To upload your info',style: TextStyle(fontSize: 12),),
                        SizedBox(
              height: Height * 1,
            ),TextButton(
                            onPressed: _isloading ? null : _submitData,
                            child: _isloading
                                ? CircularProgressIndicator()
                                : Text('Submit')),
                      ],
                    ),
                )
          ],
        ),
      ),
      Step(
          isActive: _index >= 2,
          title: Text(''),
          content: Container(
            child: Text('Done'),
          )),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('app')),
      body: Center(
        child: Stepper(
            currentStep: _index,
            type: StepperType.horizontal,
            onStepContinue: () {
              final islastStep = (_index == steps.length - 1);
              if (islastStep) {
                print(islastStep);
              } else {
                if (_index == 0) {
                  var isValid = _formkey.currentState!.validate();
                  if (isValid) {
                    setState(() {
                      _index += 1;
                    });
                  }
                } else if (_index == 1) {
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
                    setState(() {});
                  } else {
                    setState(() {
                      _index += 1;
                    });
                  }
                }
              }
            },
            onStepCancel: _index == 0
                ? null
                : () {
                    if (_index > 0) {
                      setState(() {
                        _index -= 1;
                      });
                    }
                  },
           
            controlsBuilder: (context, details) {
              return Row(
                children: [
                  ElevatedButton(
                      onPressed: _index == 1 && !_isdone
                          ? null
                          : details.onStepContinue,
                      child: Text('Next')),
                  SizedBox(
                    width: 25,
                  ),
                  if (_index != 0)
                    ElevatedButton(
                        onPressed: details.onStepCancel, child: Text('Back')),
                ],
              );
            },
            steps: steps),
      ),
    );
  }
}
