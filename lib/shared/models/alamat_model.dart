class AlamatModel {
  final String? id;
  final String namaPenerima;
  final String noHp;
  final String provinsi;
  final String kabupaten;
  final String kecamatan;
  final String desa;
  final String detail;
  final String kodePos;
  final String catatan;
  final bool utama;

  const AlamatModel({
    this.id,
    required this.namaPenerima,
    required this.noHp,
    required this.provinsi,
    required this.kabupaten,
    required this.kecamatan,
    required this.desa,
    required this.detail,
    this.kodePos = '',
    this.catatan = '',
    this.utama = false,
  });

  Map<String, dynamic> keMap() => {
    'namaPenerima': namaPenerima,
    'noHp': noHp,
    'provinsi': provinsi,
    'kabupaten': kabupaten,
    'kecamatan': kecamatan,
    'desa': desa,
    'detail': detail,
    'kodePos': kodePos,
    'catatan': catatan,
    'utama': utama,
  };

  factory AlamatModel.dariMap(Map<String, dynamic> map, String docId) {
    return AlamatModel(
      id: docId,
      namaPenerima: map['namaPenerima']?.toString() ?? '',
      noHp: map['noHp']?.toString() ?? '',
      provinsi: map['provinsi']?.toString() ?? '',
      kabupaten: map['kabupaten']?.toString() ?? '',
      kecamatan: map['kecamatan']?.toString() ?? '',
      desa: map['desa']?.toString() ?? '',
      detail: map['detail']?.toString() ?? '',
      kodePos: map['kodePos']?.toString() ?? '',
      catatan: map['catatan']?.toString() ?? '',
      utama: map['utama'] == true,
    );
  }

  String alamatLengkap() {
    return '$detail, $desa, $kecamatan, $kabupaten, $provinsi ${kodePos.isNotEmpty ? kodePos : ''}'
        '${catatan.isNotEmpty ? '\nCatatan: $catatan' : ''}';
  }
}
