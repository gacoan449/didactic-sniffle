import 'package:flutter/material.dart';

import '../services/order_service.dart';

class OrderScreen extends StatelessWidget{

const OrderScreen({super.key});

@override

Widget build(BuildContext context){

return Scaffold(

appBar:AppBar(

title:const Text("Pesanan Saya"),

),

body:ListView.builder(

itemCount:OrderService.orders.length,

itemBuilder:(context,index){

var order=OrderService.orders[index];

return Card(

margin:const EdgeInsets.all(10),

child:ListTile(

leading:const Icon(Icons.inventory),

title:Text(order.id),

subtitle:Column(

crossAxisAlignment:CrossAxisAlignment.start,

children:[

Text(order.status),

Text(order.kurir),

Text(order.pembayaran),

Text(order.tanggal),

],

),

trailing:Text(

"Rp ${order.total}",

style:const TextStyle(

color:Colors.red,

fontWeight:FontWeight.bold,

),

),

),

);

},

),

);

}

}
