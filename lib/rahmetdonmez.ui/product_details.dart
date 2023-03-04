import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ikinci_el_arac_mobil/rahmetdonmez.partial/drawer.dart';
import 'package:ikinci_el_arac_mobil/rahmetdonmez.service/api_service.dart';
import 'package:ikinci_el_arac_mobil/rahmetdonmez.ui/product_update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsViewPage extends StatefulWidget {
  int id;
  ProductDetailsViewPage({required this.id});

  @override
  State<ProductDetailsViewPage> createState() => ProductDetailsPage();
}

class ProductDetailsPage extends State<ProductDetailsViewPage> {
  ApiService api = ApiService();
  Uri launchUri = Uri();
  String phone = "";
String id="";
user_id()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id=prefs.get("userId").toString();
    });
     

}

@override
  void initState() {
    user_id();
    super.initState();
  }
  Widget ilan_sahibi(Map data) {
   
              return Column(children: [
Text("İlan Sahibi",style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 12,
                    ),
              
               Container(width: MediaQuery.of(context).size.width*0.9,
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

                    border: Border.all(
                        color: Colors.deepPurple,
                        style: BorderStyle.solid,
                        width: 3), //kenar kalınlığı ve çizgi rengini belirler
                    color: Colors.white),
                child: Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Text(data['user']['userFirstName'].toString()+" "+data['user']['userLastName'].toString()),
                 
                    SizedBox(
                      height: 12,
                    ),
                    Text(data['user']['userEmail'].toString()),
                    SizedBox(
                      height: 12,
                    ),
                    Text(data['user']['userPhone'].toString()),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            child: ElevatedButton.icon(
                                onPressed: () async {
                                  launchUri = Uri(scheme: 'tel', path: phone);
                                  await launchUrl(launchUri);
                                },
                                icon: Icon(Icons.call),
                                label: Text("Ara"))),
                        SizedBox(
                          width: 12,
                        ),
                        SizedBox(
                            child: ElevatedButton.icon(
                                onPressed: () async {
                                  launchUri = Uri(scheme: 'sms', path: phone);
                                  await launchUrl(launchUri);
                                },
                                icon: Icon(Icons.message),
                                label: Text("Mesaj Gönder")))
                      ],
                    )
                  ],
                ),
              )
           ],);
  }
   Widget ilan_islemleri(Map data) {
   
              return
                   
                    Row(
                      children: [
                        SizedBox(
                            child: ElevatedButton.icon(
                                onPressed: () {
                                 showDialog<String>(
        context: context,
        builder: (BuildContext context) =>  AlertDialog(
          icon: Icon(FontAwesomeIcons.exclamationCircle),
          title: Text('Uyarı'),
          content: Text('İlanı silmek istediğinize emin misiniz?'),
          actions: 
            <Widget>[
            TextButton(
              onPressed: () {
                //Navigator.pop(context);
                api.product_delete(data['product']['productId'].toString(),context);
                },
              child: Text('Evet'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
            
              },
              child: Text('Hayır'),
            ),
          

          ],
        ),
      );
                                },
                                icon: Icon(Icons.delete),
                                label: Text("Sil"))),
                        SizedBox(
                          width: 12,
                        ),
                        SizedBox(
                            child: ElevatedButton.icon(
                                onPressed: ()  {
                                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductUpdateViewPage(aciklama_controller: data['product']['productExplanation'].toString(), 
                      semt_controller: data['product']['productDistrict'].toString(), 
                      yil_controller: data['product']['productYear'].toString(),
                       renk_controller: data['product']['productColor'].toString(), 
                      ad_controller: data['product']['productName'].toString(), 
                      durum_controller: data['product']['productStatus'].toString(),
                       fiyat_controller: data['product']['productPrice'].toString(), 
                       km_controller: data['product']['productKm'].toString(), 
                       marka_controller: data['product']['productBrand'].toString(),
                        model_controller: data['product']['productModel'].toString(), 
                        motor_gucu_controller: data['product']['productMotorPower'].toString(), 
                        sehir_controller: data['product']['productCity'].toString(), product_id: data['product']['productId'].toString(),),
                    ));
                                  
                                },
                                icon: Icon(Icons.message),
                                label: Text("Düzenle")))
                      ],
                    );
                
           
  }


Widget ilan_yetkisi(Map data){

  if(data['user']['userId'].toString()==id){

return ilan_islemleri(data);
      }
      else{
        return ilan_sahibi(data);
      }

      

   
}


  Widget ilan_detay(BuildContext context) {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Column(children: <Widget>[
              const SizedBox(
                height: 150,
              ),
              Container(alignment: Alignment.center,
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
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                        child: Text("İlan bulunamadı.",
                            style: TextStyle(color: Colors.white))))
              ]);
            } else {
      
                  phone = snapshot.data!['user']['userPhone'].toString();
           
              return Column(
                children: [
                  Text(
                    snapshot.data!['product']['productName'].toString(),
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Center(
                      child: Container(
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

                        border: Border.all(
                            color: Colors.deepPurple,
                            style: BorderStyle.solid,
                            width:
                                3), //kenar kalınlığı ve çizgi rengini belirler
                        color: Colors.white),
                    child: Image.asset(
                      'assets/images/light-2.png',
                      height: 90,
                      width: 90,
                    ),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      snapshot.data!['product']['productPrice'].toString() +
                          " TL",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.green)),
                  SizedBox(
                    height: 32,
                  ),
                 
                 
                  Container(
                    width: MediaQuery.of(context).size.width*0.9,
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

                        border: Border.all(
                            color: Colors.deepPurple,
                            style: BorderStyle.solid,
                            width:
                                3), //kenar kalınlığı ve çizgi rengini belirler
                        color: Colors.white),
                    child: Column(children: [
                      Text("İlan Bilgileri",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)), SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(10),//kenarların şeklini belirler. burada oval yapıldı
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
                                        Color.fromARGB(255, 209, 199, 226),
                                        Color.fromARGB(255, 148, 129, 180)
                                      ]),
                                  // border: Border.all(color: Colors.deepPurple,style:BorderStyle.solid,width: 3),//kenar kalınlığı ve çizgi rengini belirler
                                  color: Colors.white),
                              child: Text("Tarih")),
                          SizedBox(
                            width: 12,
                          ),
                          Text(snapshot.data!['product']['date'].toString()),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),//kenarların şeklini belirler. burada oval yapıldı
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
                                      Color.fromARGB(255, 209, 199, 226),
                                      Color.fromARGB(255, 148, 129, 180)
                                    ]),
                                // border: Border.all(color: Colors.deepPurple,style:BorderStyle.solid,width: 3),//kenar kalınlığı ve çizgi rengini belirler
                                color: Colors.white),
                            child: Text("Şehir"),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(snapshot.data!['product']['productCity']
                              .toString()),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),//kenarların şeklini belirler. burada oval yapıldı
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
                                      Color.fromARGB(255, 209, 199, 226),
                                      Color.fromARGB(255, 148, 129, 180)
                                    ]),
                                // border: Border.all(color: Colors.deepPurple,style:BorderStyle.solid,width: 3),//kenar kalınlığı ve çizgi rengini belirler
                                color: Colors.white),
                            child: Text("Semt"),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(snapshot.data!['product']['productDistrict']
                              .toString()),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),//kenarların şeklini belirler. burada oval yapıldı
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
                                      Color.fromARGB(255, 209, 199, 226),
                                      Color.fromARGB(255, 148, 129, 180)
                                    ]),
                                // border: Border.all(color: Colors.deepPurple,style:BorderStyle.solid,width: 3),//kenar kalınlığı ve çizgi rengini belirler
                                color: Colors.white),
                            child: Text("Marka"),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(snapshot.data!['product']['productBrand']
                              .toString()),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),//kenarların şeklini belirler. burada oval yapıldı
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
                                      Color.fromARGB(255, 209, 199, 226),
                                      Color.fromARGB(255, 148, 129, 180)
                                    ]),
                                // border: Border.all(color: Colors.deepPurple,style:BorderStyle.solid,width: 3),//kenar kalınlığı ve çizgi rengini belirler
                                color: Colors.white),
                            child: Text("Model"),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(snapshot.data!['product']['productModel']
                              .toString()),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(10),//kenarların şeklini belirler. burada oval yapıldı
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
                                        Color.fromARGB(255, 209, 199, 226),
                                        Color.fromARGB(255, 148, 129, 180)
                                      ]),
                                  // border: Border.all(color: Colors.deepPurple,style:BorderStyle.solid,width: 3),//kenar kalınlığı ve çizgi rengini belirler
                                  color: Colors.white),
                              child: Text("Yıl")),
                          SizedBox(
                            width: 12,
                          ),
                          Text(snapshot.data!['product']['productYear']
                              .toString()),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(10),//kenarların şeklini belirler. burada oval yapıldı
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
                                        Color.fromARGB(255, 209, 199, 226),
                                        Color.fromARGB(255, 148, 129, 180)
                                      ]),
                                  // border: Border.all(color: Colors.deepPurple,style:BorderStyle.solid,width: 3),//kenar kalınlığı ve çizgi rengini belirler
                                  color: Colors.white),
                              child: Text("Motor Gücü")),
                          SizedBox(
                            width: 12,
                          ),
                          Text(snapshot.data!['product']['productMotorPower']
                              .toString()),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),//kenarların şeklini belirler. burada oval yapıldı
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
                                      Color.fromARGB(255, 209, 199, 226),
                                      Color.fromARGB(255, 148, 129, 180)
                                    ]),
                                // border: Border.all(color: Colors.deepPurple,style:BorderStyle.solid,width: 3),//kenar kalınlığı ve çizgi rengini belirler
                                color: Colors.white),
                            child: Text("Km"),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(snapshot.data!['product']['productKm']
                              .toString()),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(10),//kenarların şeklini belirler. burada oval yapıldı
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
                                        Color.fromARGB(255, 209, 199, 226),
                                        Color.fromARGB(255, 148, 129, 180)
                                      ]),
                                  // border: Border.all(color: Colors.deepPurple,style:BorderStyle.solid,width: 3),//kenar kalınlığı ve çizgi rengini belirler
                                  color: Colors.white),
                              child: Text("Durum")),
                          SizedBox(
                            width: 12,
                          ),
                          Text(snapshot.data!['product']['productStatus']
                              .toString()),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 100,
                              decoration: const BoxDecoration(
                                  // borderRadius: BorderRadius.circular(10),//kenarların şeklini belirler. burada oval yapıldı
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
                                        Color.fromARGB(255, 209, 199, 226),
                                        Color.fromARGB(255, 148, 129, 180)
                                      ]),
                                  // border: Border.all(color: Colors.deepPurple,style:BorderStyle.solid,width: 3),//kenar kalınlığı ve çizgi rengini belirler
                                  color: Colors.white),
                              child: Text("Renk")),
                          SizedBox(
                            width: 12,
                          ),
                          Text(snapshot.data!['product']['productColor']
                              .toString()),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                          
                  Container(
                    width: MediaQuery.of(context).size.width*0.9,
           
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

                          border: Border.all(
                              color: Colors.deepPurple,
                              style: BorderStyle.solid,
                              width:
                                  3), //kenar kalınlığı ve çizgi rengini belirler
                          color: Colors.white),
                      child: Column(
                        children: [Text("Açıklama",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                          
                          SizedBox(
                            height: 12,
                          ),
                          Text(snapshot.data!['product']['productExplanation']
                              .toString()),
                        ],
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  ilan_yetkisi(snapshot.data!)
                
                ],
              );
            }
          }
        },
        future: api.product_details(widget.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
        },
        items: [
        BottomNavigationBarItem(
          backgroundColor: Colors.red,
            icon: Icon(Icons.home), label: AutofillHints.birthday),
        const BottomNavigationBarItem(backgroundColor: Colors.red,
            icon: Icon(Icons.home), label: AutofillHints.birthday),
      ]),*/
      backgroundColor: Color.fromARGB(255, 219, 215, 215),
      drawer: DrawerViewPage(),
      appBar: AppBar(
        
        centerTitle: true,
        title: Text('İlan Detayı'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          ilan_detay(context),
         
         // ilan_sahibi(context),
        ],
      )),
    );
  }
}
