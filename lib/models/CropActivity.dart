class CropActivity {
  String id;
  String cropId; // id của cây trồng
  String title; // tiêu đề hoạt động
  DateTime dueDate; // thời hạn hoàn thành

  CropActivity({
    required this.id,
    required this.cropId,
    required this.title,
    required this.dueDate
  });
}