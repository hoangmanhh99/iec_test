import 'package:iec/domain/models/draw_controller.dart';

abstract class PaintState {}

class InitPaintState extends PaintState {}

class UpdateCanvasState extends PaintState {
  DrawController? drawController;
  UpdateCanvasState({this.drawController});
}

class MessageState extends PaintState {
  final String message;
  final bool isClear;
  MessageState(this.message, {this.isClear = false});
}

class ChangeSliderValueState extends PaintState {
  final double penSize;

  ChangeSliderValueState({this.penSize = 1});
}
