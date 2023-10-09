class Crop {
  int id;
  String name;
  DateTime plantedDate;
  int harvestDays; // số ngày để thu hoạch

  Crop({
    required this.id,
    required this.name,
    required this.plantedDate,
    required this.harvestDays
  });
}
