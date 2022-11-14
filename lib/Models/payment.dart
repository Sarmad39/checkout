import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'http_exception.dart';

const baseUrl = 'https://api.stripe.com/v1/';
const skApi = 'sk_test_TqX0Y9mcG2no0LKyG7lpuhmd00gcglhtbc';

class CardInfo {
  final String name;
  final String cardNo;
  final String exmonth;
  final String exyear;
  final String cvv;

  CardInfo(
      {required this.name,
      required this.cardNo,
      required this.exmonth,
      required this.exyear,
      required this.cvv});
}

class Customer {
  final String id;
  final String name;
  final String city;
  final String coutry;
  final String phone;
  final String? paymentmthd;

  Customer(
      {required this.id,
      required this.name,
      required this.city,
      required this.coutry,
      required this.phone,
      this.paymentmthd});
}

class Payment with ChangeNotifier {
  Map tempCard = {
    'id': '',
    "type": '',
    'fngrprnt': '',
    'last4': '',
    'brand': '',
  };
  Future<void> addPaymentMethod(CardInfo card) async {
    var url = Uri.parse('${baseUrl}payment_methods');
    try {
      final response = await http.post(url, headers: {
        'Authorization': 'Bearer $skApi'
      }, body: {
        'type': 'card',
        'card[exp_month]': card.exmonth,
        'card[exp_year]': card.exyear,
        'card[number]': card.cardNo,
        'card[cvc]': card.cvv
      });
      // print(response.body);
      final extractedData = json.decode(response.body) as Map<String,dynamic>;

      if (extractedData.containsKey('error')) {
        print(extractedData['error']['message']); 
        throw HttpException(extractedData['error']['message']);
      } else {
        tempCard = {
          'id': extractedData['id'],
          'name': card.name,
          'type': extractedData['type'],
          'fngrprnt': extractedData["card"]['fingerprint'],
          'last4': extractedData["card"]['last4'],
          'brand': extractedData["card"]['brand'],
          'exmonth': card.exmonth,
          'exyear': card.exyear,
        };
      }
    } catch (error) {
      rethrow;
    }
   // print(tempCard);
  }

  var tempCustomer =
      Customer(id: '', name: '', city: '', coutry: '', phone: '');
  Future<void> addCustomer(Customer customer) async {
    var url = Uri.parse('${baseUrl}customers');
    try {
      final response = await http.post(url, headers: {
        'Authorization': 'Bearer $skApi'
      }, body: {
        'name': customer.name,
        'phone': customer.phone,
        'payment_method': tempCard['id'],
        'invoice_settings[default_payment_method': tempCard['id'],
        'address[city]': customer.city,
        'address[country]': customer.coutry
      });
      // print(response.body);
      var newCust = Customer(
        id: json.decode(response.body)['id'],
        name: customer.name,
        city: customer.city,
        coutry: customer.coutry,
        phone: customer.phone,
        paymentmthd: tempCard['id'],
      );
      tempCustomer = newCust;
    } catch (error) {
      rethrow;
    }
  }

  Map tempSubs = {};
  Future<void> addSubscription({required String prodkey}) async {
    var url = Uri.parse('${baseUrl}subscriptions');
    try {
      final response = await http.post(url, headers: {
        'Authorization': 'Bearer $skApi'
      }, body: {
        'items[0][price_data][currency]': 'usd',
        'items[0][price_data][product]': 'prod_Mmmt7h4FLlrrB5',
        'items[0][price_data][recurring][interval]': 'day',
        'items[0][price_data][recurring][interval_count]': '1',
        'items[0][price_data][unit_amount_decimal]': '100000',
        'customer': tempCustomer.id,
        'default_payment_method': tempCustomer.paymentmthd,
      });
      tempSubs = {
        'id': json.decode(response.body)['id'],
        'curreny': 'usd',
        'product': 'prod_Mmmt7h4FLlrrB5',
        'recurringinterval': 'day',
        'interval_count': '1',
        'unit_amount_decimal': '100000',
        'customer': tempCustomer.id,
        'default_payment_method': tempCustomer.paymentmthd,
      };
    } catch (error) {
      rethrow;
    }
    //print(response.body);
    print(tempSubs);
  }

  Future<void> uploaddata() async {
    await FirebaseFirestore.instance.collection('customers').add({
      'id': tempCustomer.id,
      'name': tempCustomer.name,
      'city': tempCustomer.city,
      'coutry': tempCustomer.coutry,
      'phone': tempCustomer.phone,
      'paymentmthd': tempCustomer.paymentmthd,
    });
    await FirebaseFirestore.instance.collection('PaymentMethods').add({
      'id': tempCard['id'],
      'name': tempCard['name'],
      'type': tempCard['type'],
      'fingrePrint': tempCard['fngrprnt'],
      'last4': tempCard['last4'],
      'brand': tempCard['brand'],
      'expiryMonth': tempCard['exmonth'],
      'expiryYear': tempCard['exyear'],
    });
    await FirebaseFirestore.instance.collection('Subscriptions').add({
      'id': tempSubs['id'],
      'curreny': tempSubs['curreny'],
      'product': tempSubs['product'],
      'eecurringInterval': tempSubs['recurringinterval'],
      'intervalCount': tempSubs['interval_count'],
      'unitAmountDecimal': tempSubs['unit_amount_decimal'],
      'customer': tempSubs['customer'],
      'defaultPaymentMethod': tempSubs['default_payment_method'],
    });
  }
}
