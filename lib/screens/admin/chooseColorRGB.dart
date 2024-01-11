import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color selectedColor;
  bool showCheck = false;
  final List<List<int>> _colorsRGB = [
    [255, 0, 0], // Red
    [0, 255, 0], // Green
    [0, 0, 255], // Blue
    [255, 255, 0], // Yellow
    [255, 0, 255], // Purple
    [0, 255, 255], // Cyan
    [238, 130, 238], // Violet
    [255, 165, 0], // Orange
    [128, 128, 128], // Gray
    [255, 192, 203], // Pink
    [0, 128, 0], // Dark Green
    [128, 0, 128], // Dark Purple
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(_colorsRGB.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = Color.fromRGBO(
                    _colorsRGB[index][0],
                    _colorsRGB[index][1],
                    _colorsRGB[index][2],
                    1,
                  );
                  showCheck = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(
                        _colorsRGB[index][0],
                        _colorsRGB[index][1],
                        _colorsRGB[index][2],
                        1,
                      ),
                    ),
                  ),
                  if (showCheck && selectedColor == Color.fromRGBO(_colorsRGB[index][0], _colorsRGB[index][1], _colorsRGB[index][2], 1))
                    Icon(Icons.check, color: Colors.green, size: 30),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  String _getHexCode(List<int> colorRGB) {
    String hex = '#${colorRGB[0].toRadixString(16).padLeft(2, '0')}' +
        '${colorRGB[1].toRadixString(16).padLeft(2, '0')}' +
        '${colorRGB[2].toRadixString(16).padLeft(2, '0')}';
    return hex.toUpperCase();
  }
}