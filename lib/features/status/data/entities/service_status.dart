enum BusServiceStatus {
  working,
  outOfService,
  atRest,
  accident,
  off,
  loading,
  unknown;

  static BusServiceStatus fromInt(int value) {
    return BusServiceStatus.values[value];
  }

  int get asInt {
    return index;
  }

  String get displayName {
    switch (this) {
      case working:
        return 'En ruta';
      case outOfService:
        return 'Fuera de servicio';
      case atRest:
        return 'En descanso';
      case accident:
        return 'Accidente';
      case off:
        return 'Error';
      case BusServiceStatus.loading:
        return 'Cargando';
      case BusServiceStatus.unknown:
        return 'Desconocido';
    }
  }

  static List<BusServiceStatus> selectable() {
    return [
      working,
      outOfService,
      atRest,
      accident,
    ];
  }

  bool get locatable {
    return this == working || this == accident;
  }
}
