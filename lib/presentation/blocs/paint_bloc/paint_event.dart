import 'package:flutter/material.dart';
import 'package:iec/domain/models/draw_controller.dart';
import 'package:iec/domain/models/point.dart';

abstract class PaintEvent {}

class ClearPointEvent extends PaintEvent {
  ClearPointEvent();
}

class AddASceneEvent extends PaintEvent {
  AddASceneEvent();
}

class ClearStampsEvent extends PaintEvent {
  final bool ok;
  ClearStampsEvent({this.ok = false});
}

class ShareImageEvent extends PaintEvent {
  final BuildContext? context;
  final GlobalKey? globalKey;
  ShareImageEvent({this.globalKey, this.context});
}

class AddPointEvent extends PaintEvent {
  final Point? point;
  final bool end;
  AddPointEvent({this.point, this.end = false});
}

class ChangePenToolEvent extends PaintEvent {
  final PenTool penTool;
  ChangePenToolEvent({
    this.penTool = PenTool.glowPen,
  });
}

class ChangePenSizeEvent extends PaintEvent {
  final double penSize;
  ChangePenSizeEvent({
    this.penSize = 2,
  });
}

class InitGlobalKeyEvent extends PaintEvent {
  GlobalKey globalKey;
  InitGlobalKeyEvent(
    this.globalKey,
  );
}

class TakePageStampEvent extends PaintEvent {
  GlobalKey globalKey;
  TakePageStampEvent(
    this.globalKey,
  );
}

class ChangeCurrentColorEvent extends PaintEvent {
  final Color? color;
  final bool isRandomColor;
  ChangeCurrentColorEvent(this.color, this.isRandomColor);
}

class SavePageToGalleryEvent extends PaintEvent {
  final GlobalKey? globalKey;
  SavePageToGalleryEvent({this.globalKey});
}

class UpdateSymmetryLines extends PaintEvent {
  final double? symmetryLines;
  UpdateSymmetryLines({this.symmetryLines});
}

class CallNextFrameEvent extends PaintEvent {
  CallNextFrameEvent();
}

class MessageEvent extends PaintEvent {
  final String message;
  final bool isClear;
  MessageEvent(this.message, {this.isClear = false});
}
