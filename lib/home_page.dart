import 'package:bolum_28_not_sepeti/kategori_name.dart';
import 'package:bolum_28_not_sepeti/model/kategori.dart';
import 'package:bolum_28_not_sepeti/not_detail.dart';
import 'package:bolum_28_not_sepeti/home_page_future_builder.dart';
import 'package:bolum_28_not_sepeti/utils/database_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  int? deger;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    var keyScaffold = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: keyScaffold,
        appBar: AppBar(
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    title: const Text(
                      'Kategoriler',
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.w700),
                    ),
                    leading: const Icon(
                      Icons.import_contacts,
                      color: Colors.orange,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      return kategorileriGetir(context);
                    },
                  ),
                )
              ];
            })
          ],
          title: const Text('Not Defteri'),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                heroTag: 'Kategori Ekle',
                tooltip: "Kategori Ekle",
                onPressed: () {
                  kategoriShowDialog(context);
                },
                child: const Icon(
                  Icons.import_contacts,
                  color: Colors.white,
                ),
                mini: true),
            FloatingActionButton(
              heroTag: 'Not Ekle',
              tooltip: "Not Ekle",
              onPressed: () {
                db.kategorileriGetir().then((value) {
                  if (value.isEmpty) {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                                'Not oluşturabilmeniz icin lütfen bir kategori oluşturunuz'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    kategoriShowDialog(context);
                                  },
                                  child: Text('Kategori Ekle'))
                            ],
                          );
                        });
                  } else {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => NotDetay(
                                  baslik: 'Yeni Not',
                                )))
                        .then((value) => setState(() {}));
                  }
                });
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: NotHomePage());
  }

  Future<dynamic> kategoriShowDialog(BuildContext context) {
    var keyForm = GlobalKey<FormState>();

    String? yeniKategori;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            titleTextStyle: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
            title: const Text('Kategori Ekle'),
            children: [
              Form(
                  key: keyForm,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (data) {
                        if (data!.length < 3) {
                          return 'en az 3 karakter giriniz.';
                        }
                      },
                      onSaved: (data) {
                        yeniKategori = data!;
                      },
                      decoration: const InputDecoration(
                          label: Text('Kategori Adi'),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(style: BorderStyle.solid))),
                    ),
                  )),
              ButtonBar(
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          side: MaterialStateBorderSide.resolveWith((states) =>
                              BorderSide(
                                  color: Theme.of(context).primaryColor))),
                      onPressed: () {
                        if (keyForm.currentState!.validate() == true) {
                          keyForm.currentState!.save();
                          db.insertKategoriTable(Kategori(yeniKategori));
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Ekle',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700))),
                  ElevatedButton(
                      style: ButtonStyle(
                          side: MaterialStateBorderSide.resolveWith((states) =>
                              BorderSide(
                                  color: Theme.of(context).primaryColor))),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Vazgec',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)))
                ],
              )
            ],
          );
        });
  }

  void kategorileriGetir(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return KategoriIslemleri();
    })).then((value) => setState(() {}));
  }
}
