import 'package:flutter/material.dart';
import 'package:ikinci_el_arac_mobil/rahmetdonmez.partial/drawer.dart';
import 'package:ikinci_el_arac_mobil/rahmetdonmez.ui/product_details.dart';
import 'package:ikinci_el_arac_mobil/rahmetdonmez.ui/product_list.dart';

import '../rahmetdonmez.service/api_service.dart';

class HomePage extends StatelessWidget {
  ApiService api = ApiService();

  Widget kategoriler() {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Column(children: <Widget>[
              const SizedBox(
                height: 150,
              ),
              Container(
                alignment: Alignment.center,
                height: 40,
                child: const CircularProgressIndicator(),
              )
            ]);
          } else {
            return Container(
                child: ListView.builder(
                    shrinkWrap:
                        true, //listview bulunduğu alanı doldurmaya çalışır. renderbox hatası
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(

                          /*  decoration: BoxDecoration(
                                  
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment
                                          .centerRight, //soldan sağa belirtilen rrenkler arası geçişle renklendirir
                                      colors: [
                                        Color.fromARGB(255, 209, 199, 226),
                                        Color.fromARGB(255, 148, 129, 180)
                                      ]),
                                  // border: Border.all(color: Colors.deepPurple,style:BorderStyle.solid,width: 3),//kenar kalınlığı ve çizgi rengini belirler
                                  color: Colors.white),*/
                          child: Column(
                        children: [
                          ListTile(
                            tileColor: Color.fromARGB(255, 186, 166, 221),
                            title: Text(snapshot.data![index]['categoryName']),
                            leading: Icon(Icons.category),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductsViewPage(
                                        title: snapshot.data![index]
                                            ['categoryName'],
                                        category: snapshot.data![index]
                                            ['categoryId'],
                                        type: "filter_products"),
                                  ));
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ));
                    }));
          }
        },
        future: api.categories());
  }

  Widget son_ilanlar() {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Column(children: <Widget>[
              const SizedBox(
                height: 150,
              ),
              Container(
                alignment: Alignment.center,
                height: 40,
                child: const CircularProgressIndicator(),
              )
            ]);
          } else {
            return Container(
                child: ListView.builder(
                    shrinkWrap:
                        true, //listview bulunduğu alanı doldurmaya çalışır. renderbox hatası
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(children: <Widget>[
                        GestureDetector(
                            //containerın tıklanabilir olmasını sağlar
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetailsViewPage(
                                          id: snapshot.data!['products'][index][
                                              'productId']))); //id:ilan_liste[index]['productId']
                            },
                            child: Container(
                                child: Column(children: <Widget>[
                              Text(snapshot.data!['products'][index]['date']),
                              SizedBox(
                                height: 10,
                              ),
                              Image.asset(
                                'assets/products/' +
                                    snapshot.data!['products'][index]
                                        ['productImg'],
                                height: 15,
                                width: 10,
                              ),
                              Text(snapshot.data!['products'][index]
                                      ['productDistrict'] +
                                  "-" +
                                  snapshot.data!['products'][index]
                                      ['productCity']),
                              SizedBox(
                                height: 12,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          10), //kenarların şeklini belirler. burada oval yapıldı
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.deepPurple,
                                            blurRadius: 5,
                                            spreadRadius: 0.5,
                                            offset: Offset(5, 5))
                                      ], //gölgelendirme yapar
                                      gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment
                                              .centerRight, //soldan sağa belirtilen rrenkler arası geçişle renklendirir
                                          colors: [
                                            Color.fromARGB(255, 191, 158, 248),
                                            Color.fromARGB(255, 94, 56, 161)
                                          ]),
                                      // border: Border.all(color: Colors.deepPurple,style:BorderStyle.solid,width: 3),//kenar kalınlığı ve çizgi rengini belirler
                                      color: Colors.white),
                                  child: Column(
                                    children: [
                                      Text(
                                          snapshot.data!['products'][index]
                                                      ['productPrice']
                                                  .toString() +
                                              " TL",
                                          style: TextStyle(
                                              // backgroundColor: Colors.green,
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 8, 77, 14),
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                          snapshot.data!['products'][index]
                                                  ['productName']
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white))
                                    ],
                                  ))
                            ])))
                      ]);
                    }));
          }
        },
        future: api.son_products());
  }

  Widget ilanlar() {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          } else {
            return SingleChildScrollView(
              child:Row(children: [
Container(
                  color: Colors.pink,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Container(color: Colors.amber, height: 10, width: 10),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      );
                    },
                    shrinkWrap:
                        true, //listview bulunduğu alanı doldurmaya çalışır. renderbox hatası
                    itemCount: 1,
                  )),
            

              ]));
               

            
          }
        },
        future: api.son_products());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerViewPage(),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Ana Sayfa'),
        ),
        body: SingleChildScrollView(child: ilanlar()
            /*Column(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: Image(
                  image: AssetImage("assets/images/background.jpg"),
                )),
            Text("Kategoriler",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
            SizedBox(
              height: 12,
            ),
            kategoriler(),
            SizedBox(
              height: 12,
            ),
            Text("Son Eklenen İlanlar",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
            ilanlar(),
          ],
        )
        */
            ));
  }
}
