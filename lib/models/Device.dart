class Device {
  String id;
  String name;
  String status;
  String topic ;
  DateTime turnOnTime;
  DateTime turnOffTime;

  Device({ required this.id, required this.name, required this.status, required this.turnOnTime, required this.turnOffTime, required this.topic});
}
// Data mô tả thiết bị
var descriptions = {
  'RGB': 'Đèn LED RGB dùng để chiếu sáng với các màu khác nhau cho cây trồng. Có thể điều chỉnh độ sáng và màu sắc từ xa',

  'PUMP': 'Bơm nước tự động dùng để tưới tiêu cho cây trồng dựa trên lịch trình. Có cảm biến đo độ ẩm đất để điều chỉnh lượng nước',

  'PAN': 'Quạt thông gió tự động bật/tắt để điều hoà nhiệt độ và độ ẩm trong nhà kính. Giúp tối ưu môi trường cho cây trồng',

  'LED': 'Cảm biến nhiệt độ, độ ẩm không khí và đất. Gửi dữ liệu cảm biến cho hệ thống để theo dõi và điều chỉnh điều kiện'
};