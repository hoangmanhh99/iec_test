import "dart:io";
import "dart:typed_data";

import "package:bloc/bloc.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:iec/domain/models/draw_controller.dart";
import 'dart:ui' as ui;

import "package:image_gallery_saver/image_gallery_saver.dart";
import "package:path_provider/path_provider.dart";
import "package:screenshot/screenshot.dart";

import "paint_event.dart";
import "paint_state.dart";

class PaintBloc extends Bloc<PaintEvent, PaintState> {
  DrawController? drawController;
  var index = 0;

  PaintBloc({this.drawController}) : super(UpdateCanvasState());

  @override
  Stream<PaintState> mapEventToState(PaintEvent event) async* {
    if (event is ClearPointEvent) {
      drawController!.points!.clear();
      yield UpdateCanvasState(drawController: drawController);
    } else if (event is ClearStampsEvent) {
      if (event.ok) {
        if (drawController!.stamp!.isEmpty) {
          return;
        }
        drawController!.stamp!.clear();
        yield UpdateCanvasState(drawController: drawController);
      }
    } else if (event is AddPointEvent) {
      if (drawController!.isPanActive) {
        drawController!.points!.add(event.point);
        if (event.end) {
          add(TakePageStampEvent(drawController!.globalKey!));
          // add(AddASceneEvent());
        }
        yield UpdateCanvasState(drawController: drawController);
      }
    } else if (event is ChangeCurrentColorEvent) {
      drawController = drawController?.copyWith(
        currentColor: event.color,
        isRandomColor: event.isRandomColor,
      );
      yield UpdateCanvasState(drawController: drawController);
    } else if (event is ChangePenToolEvent) {
      drawController = drawController?.copyWith(penTool: event.penTool);
      yield UpdateCanvasState(drawController: drawController);
    } else if (event is SavePageToGalleryEvent) {
      save(event.screenshotController);
    } else if (event is InitGlobalKeyEvent) {
      drawController = drawController?.copyWith(globalKey: event.globalKey);
      // drawController!.globalKey = event.globalKey;
    } else if (event is UpdateSymmetryLines) {
      drawController =
          drawController?.copyWith(symmetryLines: event.symmetryLines);
      // drawController!.globalKey = event.globalKey;
    } else if (event is TakePageStampEvent) {
      try {
        ui.Image image = await canvasToImage(event.globalKey);
        List<Stamp?>? stamps = List.from(drawController!.stamp!);
        stamps.add(Stamp(image: image));
        drawController = drawController!.copyWith(stamp: stamps);

        add(ClearPointEvent());
      } catch (e) {
        print("===$e ${(e as Error).stackTrace}");
        yield MessageState(e.toString());
      }
      yield UpdateCanvasState(drawController: drawController);
    } else if (event is ShareImageEvent) {
      try {
        screenShotAndShare(
            event.globalKey ?? drawController!.globalKey!, event.context!);
      } catch (e) {
        yield MessageState(e.toString());
      }
      // yield UpdateCanvasState(drawController: drawController);
    } else if (event is MessageEvent) {
      yield MessageState(event.message, isClear: event.isClear);
      yield UpdateCanvasState(drawController: drawController);
    } else if (event is ChangePenSizeEvent) {
      drawController!.copyWith(
        penSize: event.penSize,
      );
      yield UpdateCanvasState(drawController: drawController);
    }
    //  else if (event is PanActiveEvent) {
    //   drawController = drawController!.copyWith(isPanActive: event.isActive);
    //   yield UpdateCanvasState(drawController: drawController);
    // }
  }

  Future<ui.Image> canvasToImage(GlobalKey globalKey) async {
    final boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage();
    return image;
  }

  // Future<void> save(GlobalKey globalKey) async {
  //   try {
  //     final boundary =
  //         globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //     final image = await boundary.toImage();
  //     final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //     final pngBytes = byteData!.buffer.asUint8List();
  //
  //     final saved = await ImageGallerySaver.saveImage(
  //       pngBytes,
  //       quality: 100,
  //       name: "${DateTime.now().toIso8601String()}.jpeg",
  //       isReturnImagePathOfIOS: true,
  //     );
  //     add(MessageEvent("Image Saved To Gallery ♥"));
  //   } catch (e) {
  //     add(MessageEvent(e.toString()));
  //   }
  // }

  Future<void> save(ScreenshotController screenshotController) async {
    try {
      var imagePath = "";
      // if (Platform.isAndroid) {
      //   imagePath = (await getExternalStorageDirectory())!
      //       .path
      //       .trim(); //from path_provide package
      // } else if (Platform.isIOS) {
      //   imagePath = (await getApplicationDocumentsDirectory()).path.trim();
      // }
      imagePath = (await getApplicationDocumentsDirectory()).path.trim();
      String fileName = "${DateTime.now().toIso8601String()}.png";
      await screenshotController.captureAndSave(
        imagePath, //set path where screenshot will be saved
        fileName: fileName,
      );
      final saved = await ImageGallerySaver.saveFile(
        '$imagePath/$fileName',
        name: "${DateTime.now().toIso8601String()}.jpeg",
        isReturnPathOfIOS: true,
      );
      add(MessageEvent("Image Saved To Gallery ♥"));
    } catch (e) {
      add(MessageEvent(e.toString()));
    }
  }

  Future<Null> screenShotAndShare(
      GlobalKey globalKey, BuildContext context) async {
    try {
      print("Phase 1" * 200);
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage();
      final directory = (await getExternalStorageDirectory())?.path;
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      print("Phase 2" * 200);

      File imgFile = File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);
      print('Screenshot Path:${imgFile.path}');

      print("Phase 3" * 200);
      final RenderBox box = context.findRenderObject() as RenderBox;
      // Share.shareFiles(['$directory/screenshot.png'],
      //     subject: 'Doddle App',
      //     text: 'Hey, check it out My Amazing Doddle!',
      //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      print("Phase 4" * 200);
    } catch (e) {
      add(MessageEvent(e.toString()));
    }
  }
}
