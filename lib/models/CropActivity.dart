class CropActivity {
  String id;
  String status; // id của cây trồng
  String nameActivity; // tiêu đề hoạt động
  DateTime dateTime; // thời hạn hoàn thành

CropActivity({
  required this.id,
  required this.status,
  required this.nameActivity,
  required this.dateTime,
});
}