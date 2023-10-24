class GetParkingLotName {
  String? parkingLot;

  GetParkingLotName({
    this.parkingLot,
  });

  GetParkingLotName.fromMap(Map<String, dynamic> map)
      : parkingLot = map['parkingLot'];
}
