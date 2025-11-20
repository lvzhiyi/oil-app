class FuelTypeHelper {
  static const Map<String, String> _fuelTypeMap = {
    '92': '92号汽油',
    '95': '95号汽油',
    '98': '98号汽油',
    '0': '0号柴油',
    '-10': '-10号柴油',
    '-20': '-20号柴油',
    '-35': '-35号柴油',
  };

  static String getDisplayName(String? fuelType) {
    if (fuelType == null || fuelType.isEmpty) {
      return '';
    }

    final trimmedType = fuelType.trim();
    
    if (_fuelTypeMap.containsKey(trimmedType)) {
      return _fuelTypeMap[trimmedType]!;
    }

    if (trimmedType.contains('92') || trimmedType.contains('95') || trimmedType.contains('98')) {
      final parts = <String>[];
      if (trimmedType.contains('92')) parts.add('92号汽油');
      if (trimmedType.contains('95')) parts.add('95号汽油');
      if (trimmedType.contains('98')) parts.add('98号汽油');
      return parts.join('、');
    }

    if (trimmedType.contains('0') || trimmedType.contains('柴油')) {
      if (trimmedType.contains('-10')) return '-10号柴油';
      if (trimmedType.contains('-20')) return '-20号柴油';
      if (trimmedType.contains('-35')) return '-35号柴油';
      if (trimmedType.contains('0')) return '0号柴油';
    }

    return fuelType;
  }
}

