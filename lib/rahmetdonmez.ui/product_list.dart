import 'package:flutter/material.dart';
import 'package:ikinci_el_arac_mobil/rahmetdonmez.partial/drawer.dart';
import 'package:ikinci_el_arac_mobil/rahmetdonmez.service/api_service.dart';
import 'package:ikinci_el_arac_mobil/rahmetdonmez.ui/product_details.dart';

class ProductsViewPage extends StatefulWidget {
  final String type;
  final String title;
  final int category;
  const ProductsViewPage(
      {super.key,
      required this.type,
      required this.title,
      required this.category});

  @override
  State<ProductsViewPage> createState() => ProductsPage();
}

class ProductsPage extends State<ProductsViewPage> {
  ApiService api = new ApiService();

  List ilan_liste = [];
  Future refresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      ilan_listesi(context);
    });
  }

  Widget ilan_listesi(BuildContext context) {
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
            if (snapshot.data!['status'] == false) {
              return Column(children: <Widget>[
                const SizedBox(
                  height: 150,
                ),
                Container(
                    height: 40,
                    width: 200,
                    margin: const EdgeInsets.all(10), //elemanlar arası boşluk
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 3),
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                        child: Text("İlan bulunamadı.",
                            style: TextStyle(color: Colors.white))))
              ]);
            } else {
              ilan_liste = snapshot.data!['products'];
              return ilan_listele(context);
            }
          }
        },
        future: api.product(widget.type, widget.category));
  }

  Widget ilan_listele(
    BuildContext context,
  ) {
    return Expanded(
      child: SizedBox(
          height: 200.0,
          child: RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                  itemCount: ilan_liste.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        child: Center(
                      child: Column(children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                            //containerın tıklanabilir olmasını sağlar
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetailsViewPage(
                                          id: ilan_liste[index][
                                              'productId']))); //id:ilan_liste[index]['productId']
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.9,

                               // width: 300,
                               // height: 350,
                                alignment: Alignment.center,
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
                                    /* gradient: LinearGradient(begin:Alignment.centerLeft,end: Alignment.centerRight,//soldan sağa belirtilen rrenkler arası geçişle renklendirir
                    colors: [Color.fromARGB(255, 191, 158, 248), Color.fromARGB(255, 94, 56, 161)]),*/
                                    // border: Border.all(color: Colors.deepPurple,style:BorderStyle.solid,width: 3),//kenar kalınlığı ve çizgi rengini belirler
                                    color: Colors.white),
                                child: Column(children: <Widget>[
                                  Text(ilan_liste[index]['date']),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //Text(ilan_liste[index]['productImg']),
                                  Image.asset(
                                    'assets/products/' +
                                        ilan_liste[index]['productImg'],
                                    height:  MediaQuery.of(context).size.height*0.7,
                                    width: MediaQuery.of(context).size.width*0.9,
                                  ),
                                  
                                Text(ilan_liste[index]['productDistrict']+"-"+ilan_liste[index]['productCity']),
                                 SizedBox(
                                    height: 12,
                                  ),
                                  Container(
                                    width: 200,
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
                                                Color.fromARGB(
                                                    255, 191, 158, 248),
                                                Color.fromARGB(255, 94, 56, 161)
                                              ]),
                                          // border: Border.all(color: Colors.deepPurple,style:BorderStyle.solid,width: 3),//kenar kalınlığı ve çizgi rengini belirler
                                          color: Colors.white),
                                      child: Column(
                                        children: [
                                          Text(
                                              ilan_liste[index]['productPrice']
                                                      .toString() +
                                                  " TL",
                                              style: TextStyle(
                                               // backgroundColor: Colors.green,
                                                  fontSize: 20,
                                                  color: Color.fromARGB(255, 8, 77, 14),
                                                  fontWeight: FontWeight.w500)),
                                          Text(
                                              ilan_liste[index]['productName']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white))
                                        ],
                                      ))
                                ])))
                      ]),
                    ));
                  }))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 219, 215, 215),
        drawer: const DrawerViewPage(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: Container(
            child: Column(children: <Widget>[ilan_listesi(context)])));
  }
}
