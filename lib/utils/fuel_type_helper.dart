class FuelTypeHelper {
  static const Map<String, String> _fuelTypeMap = {
    '92': '92#汽油',
    '95': '95#汽油',
    '98': '98#汽油',
    '0': '0#柴油',
    '-10': '-10#柴油',
    '-20': '-20#柴油',
    '-35': '-35#柴油',
  };

  static String getDisplayName(String? fuelType) {
    if (fuelType == null || fuelType.isEmpty) {
      return '';
    }

    final trimmedType = fuelType.trim();

    if (_fuelTypeMap.containsKey(trimmedType)) {
      return _fuelTypeMap[trimmedType]!;
    }

    if (trimmedType.contains('92') ||
        trimmedType.contains('95') ||
        trimmedType.contains('98')) {
      final parts = <String>[];
      if (trimmedType.contains('92')) parts.add('92#汽油');
      if (trimmedType.contains('95')) parts.add('95#汽油');
      if (trimmedType.contains('98')) parts.add('98#汽油');
      return parts.join('、');
    }

    if (trimmedType.contains('0') || trimmedType.contains('柴油')) {
      if (trimmedType.contains('-10')) return '-10#柴油';
      if (trimmedType.contains('-20')) return '-20#柴油';
      if (trimmedType.contains('-35')) return '-35#柴油';
      if (trimmedType.contains('0')) return '0#柴油';
    }

    return fuelType;
  }
}
