class Answers {
  String? _a;
  String? _b;
  String? _c;
  String? _d;

  Answers({
    String? a,
    String? b,
    String? c,
    String? d,
  })  : _a = a,
        _b = b,
        _c = c,
        _d = d;

  Answers.fromJson(Map<String, dynamic> json) {
    _a = json['A'];
    _b = json['B'];
    _c = json['C'];
    _d = json['D'];
  }

  String? get a => _a;
  String? get b => _b;
  String? get c => _c;
  String? get d => _d;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['A'] = _a;
    data['B'] = _b;
    data['C'] = _c;
    data['D'] = _d;
    return data;
  }
}
