class BindStationState {
  bool loading;
  String businessLicenseUrl;
  String fuelRetailPermitUrl;

  BindStationState({
    this.loading = false,
    this.businessLicenseUrl = '',
    this.fuelRetailPermitUrl = '',
  });

  BindStationState copyWith({
    bool? loading,
    String? businessLicenseUrl,
    String? fuelRetailPermitUrl,
  }) {
    return BindStationState(
      loading: loading ?? this.loading,
      businessLicenseUrl: businessLicenseUrl ?? this.businessLicenseUrl,
      fuelRetailPermitUrl: fuelRetailPermitUrl ?? this.fuelRetailPermitUrl,
    );
  }
}
