import 'package:bolum_28_not_sepeti/main.dart';
import 'package:bolum_28_not_sepeti/model/kategori.dart';
import 'package:bolum_28_not_sepeti/model/notlar.dart';
import 'package:bolum_28_not_sepeti/utils/database_helper.dart';
import 'package:flutter/material.dart';

class NotDetay extends StatefulWidget {
  NotDetay({this.baslik, this.gelenNot, Key? key}) : super(key: key);
  String? baslik;
  Not? gelenNot;
  @override
  _NotDetayState createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  late DatabaseHelper db1;
  late List<Kategori> kategoriListem;
  List<String> oncelikListem = ['Dusuk', 'Orta', 'Yuksek'];
  int? kategoriId = 1;
  int? oncelikId = 0;
  String? baslikBilgisi;
  String? icerikBilgisi;
  @override
  void initState() {
    super.initState();
    db1 = DatabaseHelper();
    kategoriListem = [];

    db1.mapKategorileriGetir().then((value) {
      for (Map<String, dynamic> gezginci in value) {
        kategoriListem.add(Kategori.fromMap(gezginci));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:
            widget.gelenNot != null ? Text(widget.baslik!) : Text('Yeni Not'),
      ),
      body: Form(
        key: formKey,
        child: Column(children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Kategori:',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: DropdownButtonHideUnderline(
                    child: kategoriListem.isEmpty
                        ? const CircularProgressIndicator()
                        : DropdownButton<int>(
                            items: kategorileriGetirr(),
                            value: widget.gelenNot != null
                                ? widget.gelenNot!.kategoriId
                                : kategoriId,
                            onChanged: (secilenId) {
                              setState(() {
                                kategoriId = secilenId;
                                widget.gelenNot = null;
                              });
                            },
                          )),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              initialValue:
                  widget.gelenNot != null ? widget.gelenNot!.notBaslik : '',
              validator: (text) {
                if (text!.length < 3) {
                  return 'En az 3 karakter giriniz.';
                }
              },
              onSaved: (deger) {
                baslikBilgisi = deger;
              },
              decoration: const InputDecoration(
                hintText: 'Başlık Giriniz.',
                labelText: 'Başlık',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              initialValue:
                  widget.gelenNot != null ? widget.gelenNot!.notIcerik : '',
              onSaved: (deger) {
                icerikBilgisi = deger;
              },
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Not Giriniz.',
                labelText: 'Not',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Öncelik:',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                  items: oncelikListem.map((e) {
                    return DropdownMenuItem<int>(
                      child: Text(e),
                      value: oncelikListem.indexOf(e),
                    );
                  }).toList(),
                  value: widget.gelenNot != null
                      ? widget.gelenNot!.notOncelik
                      : oncelikId,
                  onChanged: (secilenId) {
                    setState(() {
                      if (widget.gelenNot != null) {
                        widget.gelenNot!.notOncelik = secilenId;
                      } else {
                        oncelikId = secilenId;
                      }
                    });
                  },
                )),
              ),
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Vazgeç',
                    style: TextStyle(fontSize: 24),
                  )),
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate() == true) {
                      formKey.currentState!.save();
                      var tarih = DateTime.now();
                      if (widget.gelenNot != null) {
                        db1
                            .updateNotTable(Not.withId(
                                widget.gelenNot!.notId,
                                kategoriId,
                                baslikBilgisi,
                                icerikBilgisi,
                                tarih.toString(),
                                widget.gelenNot!.notOncelik))
                            .then((value) {
                          if (value != 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Not Güncellendi')));
                          }
                        });

                        Navigator.pop(context);
                      } else {
                        db1.insertNotTable(Not(kategoriId, baslikBilgisi,
                            icerikBilgisi, tarih.toString(), oncelikId));

                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text(
                    'Kaydet',
                    style: TextStyle(fontSize: 24),
                  ))
            ],
          )
        ]),
      ),
    );
  }

  List<DropdownMenuItem<int>> kategorileriGetirr() {
    debugPrint('kategorigetirr e geklfdi');
    db1.kategorileriGetir().then((value) => kategoriListem = value);
    var listeDropDown = kategoriListem
        .map((e) => DropdownMenuItem(
              child: Text(e.kategoriBaslik!),
              value: e.kategoriId,
            ))
        .toList();
    if (kategoriId == 1) {
      kategoriId = kategoriListem[0].kategoriId;
    }

    return listeDropDown;
  }

  int kategoriIdGetir() {
    db1.kategorileriGetir().then((value) => kategoriListem = value);
    return kategoriListem[0].kategoriId!;
  }
}
