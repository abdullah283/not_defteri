import 'dart:io';
import 'dart:ui';

import 'package:bolum_28_not_sepeti/model/kategori.dart';
import 'package:bolum_28_not_sepeti/utils/database_helper.dart';
import 'package:flutter/material.dart';

class KategoriIslemleri extends StatefulWidget {
  KategoriIslemleri({Key? key}) : super(key: key);

  @override
  State<KategoriIslemleri> createState() => _KategoriIslemleriState();
}

class _KategoriIslemleriState extends State<KategoriIslemleri> {
  late DatabaseHelper db2;
  late List<Kategori> tumKategoriler;
  int i = 0;
  @override
  void initState() {
    super.initState();
    db2 = DatabaseHelper();
    tumKategoriler = [];
    _tumListeleriGuncelle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori işlemleri'),
      ),
      body: tumKategoriler.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tumKategoriler.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tumKategoriler[index].kategoriBaslik!),
                  onTap: () {
                    return _kategoriGuncelle(tumKategoriler[index]);
                  },
                  trailing: InkWell(
                    child: Icon(Icons.delete),
                    onTap: () => _kategoriSil(tumKategoriler[index].kategoriId),
                  ),
                );
              }),
    );
  }

  _kategoriSil(int? kategoriId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Kategoriyi Sil'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Bu işlemi yaptığınızda ilgili kategorideki tüm notlar kaybolacaktır. Emin misiniz.'),
                ButtonBar(
                  children: [
                    TextButton(
                        onPressed: () {
                          db2.deleteKategoriTable(kategoriId!);
                          setState(() {
                            _tumListeleriGuncelle();
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Kategoriyi Sil',
                          style: TextStyle(color: Colors.black),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Vazgeç',
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                )
              ],
            ),
          );
        });
  }

  void _tumListeleriGuncelle() {
    db2.kategorileriGetir().then((value) {
      setState(() {
        tumKategoriler = value;
      });
    });
  }

  _kategoriGuncelle(Kategori kategori) {
    var keyForm = GlobalKey<FormState>();
    String? yeniKategori;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            titleTextStyle: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
            title: const Text('Kategori Güncelle'),
            children: [
              Form(
                  key: keyForm,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: kategori.kategoriBaslik,
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
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.orange)),
                      onPressed: () {
                        if (keyForm.currentState!.validate() == true) {
                          keyForm.currentState!.save();
                          db2.updateKategoriTable(Kategori.withId(
                              kategori.kategoriId, yeniKategori));
                          setState(() {
                            _tumListeleriGuncelle();
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Güncelle')),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.red)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Vazgec'))
                ],
              )
            ],
          );
        });
  }
}
