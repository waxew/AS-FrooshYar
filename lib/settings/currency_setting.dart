import 'package:intl/intl.dart';
import 'package:possystem/settings/language_setting.dart';
import 'package:possystem/settings/setting.dart';

/// Currency and cash denomination configuration used by the cashier.
class CurrencySetting extends Setting<CurrencyTypes> {
  static CurrencySetting instance = ._();

  /// FrooshYar targets Persian stores, so Iranian Rial is the default.
  static const CurrencyTypes defaultValue = .irr;

  static const supports = <CurrencyTypes, List<num>>{
    .twd: [1, 5, 10, 50, 100, 500, 1000],
    .usd: [0.01, 0.05, 0.1, 0.25, 0.5, 1, 5, 10, 20, 50, 100],
    .irr: [1000, 5000, 10000, 20000, 50000, 100000, 500000, 1000000],
  };

  /// Current available units of money.
  List<num> unitList = CurrencySetting.supports[defaultValue]!;

  /// Whether this currency only uses integer values.
  bool isInt = true;

  /// Index of first integer denomination in [unitList].
  int intIndex = 0;

  CurrencySetting._() {
    value = defaultValue;
    LanguageSetting.instance.addListener(_refreshFormatter);
  }

  @override
  String get key => 'currency';

  String get recordName => switch (value) {
    .irr => 'ریال',
    .usd => 'USD',
    .twd => 'TWD',
  };

  /// Price formatter deliberately uses grouping rather than compact notation
  /// so values are rendered like 1,250,000 instead of 1.25M.
  NumberFormat formatter = NumberFormat.decimalPattern('fa_IR');

  void _refreshFormatter() {
    formatter = NumberFormat.decimalPattern(LanguageSetting.instance.language.locale.toString());
  }

  /// Ceiling [value] to the next supported cash unit.
  num ceil(num data) {
    assert(data >= 0);

    if (data == 0) return 0;
    if (data != data.ceil()) return data.ceil();

    final next = unitList.indexWhere((e) => e > data);
    if (next == 0 || next == 1) return unitList[next];

    final useUnits = unitList.sublist(1, next == -1 ? null : next + 1);
    for (var unit in useUnits) {
      if (data % unit != 0) {
        return (data / unit).ceil() * unit;
      }
    }

    return data;
  }

  /// Get possible cash values up to the maximum denomination.
  Iterable<num> ceilToMaximum(num minimum) sync* {
    yield minimum;

    var value = minimum;
    var ceiledValue = ceil(value);
    while (ceiledValue != value) {
      yield ceiledValue;
      value = ceiledValue;
      ceiledValue = CurrencySetting.instance.ceil(ceiledValue);
    }
  }

  @override
  void initialize() {
    final storedIndex = service.get<int>(key);
    value = storedIndex != null && storedIndex >= 0 && storedIndex < CurrencyTypes.values.length
        ? CurrencyTypes.values[storedIndex]
        : defaultValue;
    _setMetadata(value);
    _refreshFormatter();
  }

  @override
  Future<void> updateRemotely(CurrencyTypes data) {
    _setMetadata(data);
    return service.set<int>(key, data.index);
  }

  void _setMetadata(CurrencyTypes value) {
    unitList = supports[value]!;

    intIndex = 0;
    for (var money in unitList) {
      if (money.toInt() == money) break;
      intIndex++;
    }

    isInt = intIndex == 0;
  }
}

enum CurrencyTypes { twd, usd, irr }
