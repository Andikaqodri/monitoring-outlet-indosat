class IccidCard {
  final String id;
  final String outletId;
  final String iccid;
  final String msisdn;

  const IccidCard({
    required this.id,
    required this.outletId,
    required this.iccid,
    required this.msisdn,
  });

  IccidCard copyWith({
    String? id,
    String? outletId,
    String? iccid,
    String? msisdn,
  }) {
    return IccidCard(
      id: id ?? this.id,
      outletId: outletId ?? this.outletId,
      iccid: iccid ?? this.iccid,
      msisdn: msisdn ?? this.msisdn,
    );
  }
}
