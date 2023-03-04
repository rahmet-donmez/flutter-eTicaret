import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ikinci_el_arac_mobil/rahmetdonmez.ui/product_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../rahmetdonmez.service/api_service.dart';

import '../rahmetdonmez.ui/home.dart';
import '../rahmetdonmez.ui/product_add.dart';
import '../rahmetdonmez.ui/user_update.dart';

class DrawerViewPage extends StatefulWidget {
  const DrawerViewPage({super.key});

  @override
  State<DrawerViewPage> createState() => DrawerPage();
}

class DrawerPage extends State<DrawerViewPage> {
  ApiService api = ApiService();
  String name = "";
  String email = "";
  String image="";
  List kategoriler = [];

  @override
  void initState() {
    atama();
 Future.delayed(Duration(seconds:3));
    super.initState();
   
  }

  Future<void> atama() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List _kategoriler = await api.categories();
    setState(() {
      kategoriler = _kategoriler;
      image=prefs.get("image").toString();
      name =
          "${prefs.get("isim")} ${prefs.get("soyisim")}";
      email = prefs.get("email").toString();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        ListView(
          shrinkWrap: true,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                    child: Image(image: AssetImage('assets/users/'+image),height: 90,width: 90,fit: BoxFit.cover,)
                    
                    
                   /* Image.network(
                  'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),*/
                    ),
              ),

              /*decoration: BoxDecoration(
              image:DecorationImage(image: AssetImage('assets/images/light-2.png'))
            ),*/
            ),
            
             ListTile(
              title: const Text("Anasayfa"),
              leading: const Icon(FontAwesomeIcons.home),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  HomePage(),
                    ));
                /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyProductsViewPage(),
                    ));*/
              },
            ),
            
            ExpansionTile(
              title: const Text("İlanlar"),
              leading: const Icon(FontAwesomeIcons.car),
              children: [
                ListTile(
                  title:const Text("Tüm İlanlar"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>const ProductsViewPage(
                              title: "İlanlar", category: 0, type: "products"),
                        ));
                  },
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: kategoriler.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(kategoriler[index]['categoryName']),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductsViewPage(
                                    title: kategoriler[index]['categoryName'],
                                    category: kategoriler[index]['categoryId'],
                                    type: "filter_products"),
                              ));
                          /*   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilterProductsViewPage(id:kategoriler[index]['categoryId']),
                    ));*/
                        },
                      );
                    })
              ],
            ),
            ExpansionTile(
              title:const Text("Hesap Ayarları"),
              leading: const Icon(FontAwesomeIcons.wrench),
              children: [
                ListTile(
                  leading: const Icon(FontAwesomeIcons.edit),
                  title:const Text("Hesabımı Güncelle"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>const UserUpdateViewPage(),
                        ));
                  },
                ),
                ListTile(
                  leading:const Icon(FontAwesomeIcons.trash),
                  title:const Text("Hesabımı Sil"),
                  onTap: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        icon: const Icon(FontAwesomeIcons.exclamationCircle),
                        title:const Text('Uyarı'),
                        content: const Text(
                            'Hesabınızı silmek istediğinize emin misiniz?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              //Navigator.pop(context);
                              api.user_delete(context);
                            },
                            child: const Text('Evet'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child:const Text('Hayır'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            ListTile(
              title: const Text("İlanlarım"),
              leading: const Icon(FontAwesomeIcons.carAlt),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductsViewPage(
                          title: "İlanlarım", category: 0, type: "my_products"),
                    ));
                /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyProductsViewPage(),
                    ));*/
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.plus),
              title: Text("İlan Ekle"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductAddViewPage(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.signOutAlt),
              title: Text("Çıkış Yap"),
              onTap: () {
                api.logout(context);
              },
            ),
          ],
        )
      ],
    )));
  }
}
