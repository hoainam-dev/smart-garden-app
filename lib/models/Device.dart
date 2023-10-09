class Device {
  String id;
  String name;
  String status;
  String topic ;
  DateTime turnOnTime;
  DateTime turnOffTime;

  Device({ required this.id, required this.name, required this.status, required this.turnOnTime, required this.turnOffTime, required this.topic});
}
