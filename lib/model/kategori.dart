class Kategori {
  int? kategoriId;
  String? kategoriBaslik;
  Kategori(
    this.kategoriBaslik,
  );
  Kategori.withId(
    this.kategoriId,
    this.kategoriBaslik,
  );
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['kategoriId'] = kategoriId;
    map['kategoriBaslik'] = kategoriBaslik;
    return map;
  }

  Kategori.fromMap(Map<String, dynamic> map) {
    kategoriId = map['kategoriId'];
    kategoriBaslik = map['kategoriBaslik'];
  }

  @override
  String toString() =>
      'Kategori(kategoriId: $kategoriId, kategoriBaslik: $kategoriBaslik)';
}
