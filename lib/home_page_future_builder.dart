import 'package:bolum_28_not_sepeti/model/notlar.dart';
import 'package:bolum_28_not_sepeti/not_detail.dart';
import 'package:bolum_28_not_sepeti/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class NotHomePage extends StatefulWidget {
  NotHomePage({Key? key}) : super(key: key);

  @override
  _NotHomePageState createState() => _NotHomePageState();
}

class _NotHomePageState extends State<NotHomePage> {
  DatabaseHelper db = DatabaseHelper();
  String? notOncelik;
  Color? avatarRenk;
  late List<Not> tumNotlar;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db.notlariGetir(),
        builder: (context, AsyncSnapshot<List<Not>> snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            tumNotlar = snapShot.data!;
            sleep(Duration(milliseconds: 500));
            return ListView.builder(
                itemCount: tumNotlar.length,
                itemBuilder: (context, index) {
                  switch (tumNotlar[index].notOncelik) {
                    case 0:
                      notOncelik = 'AZ';
                      avatarRenk = Colors.red.shade100;
                      break;
                    case 1:
                      notOncelik = 'ORTA';
                      avatarRenk = Colors.red.shade300;
                      break;
                    case 2:
                      notOncelik = 'ACİL';
                      avatarRenk = Colors.red.shade600;
                      break;
                    default:
                  }
                  return ExpansionTile(
                      leading: CircleAvatar(
                        child: Text(notOncelik!),
                        backgroundColor: avatarRenk,
                      ),
                      title: Text(tumNotlar[index].notBaslik.toString(),
                          style: TextStyle(fontSize: 20)),
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Kategori:',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  tumNotlar[index].kategoriBaslik.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColor),
                                ),
                              )
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  'Olusturulma Tarihi:',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  db.dateFormat(DateTime.parse(
                                      tumNotlar[index].notTarih!)),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ]),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, top: 8, right: 8, bottom: 4),
                          child: Container(
                              alignment: Alignment.topLeft,
                              child: Text('Not İçeriği',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(style: BorderStyle.solid)),
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    tumNotlar[index].notIcerik == ''
                                        ? 'Not girilmemiş'
                                        : tumNotlar[index].notIcerik!,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black)),
                              )),
                        ),
                        ButtonBar(
                          children: [
                            TextButton(
                                style: ButtonStyle(
                                    side: MaterialStateBorderSide.resolveWith(
                                        (states) => BorderSide(
                                            color: Colors.red,
                                            style: BorderStyle.solid))),
                                onPressed: () {
                                  _notSil(tumNotlar[index].notId!);
                                },
                                child: const Text('Sil',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.red))),
                            TextButton(
                                style: ButtonStyle(
                                    side: MaterialStateBorderSide.resolveWith(
                                        (states) => BorderSide(
                                            color: Colors.green.shade500,
                                            style: BorderStyle.solid))),
                                onPressed: () {
                                  _notGuncelle(tumNotlar[index]);
                                },
                                child: Text('Güncelle',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green.shade500)))
                          ],
                        )
                      ]);
                });
          } else {
            return Center(child: Text("Yükleniyor..."));
          }
        });
  }

  _notSil(int notId) {
    db.deleteNotTable(notId).then((value) {
      if (value != 0) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Not silindi')));
      }
    });

    setState(() {});
  }

  void _notGuncelle(Not not) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NotDetay(
        baslik: 'Notu Düzenle',
        gelenNot: not,
      );
    })).then((value) => setState(() {}));
  }
}
