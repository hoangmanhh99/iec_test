import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iec/domain/models/draw_controller.dart';
import 'package:iec/domain/models/picture_model.dart';
import 'package:iec/domain/models/point.dart';
import 'package:iec/gen/assets.gen.dart';
import 'package:iec/presentation/painter/widget/last_image_as_background.dart';
import 'package:iec/presentation/painter/widget/sketcher.dart';
import 'package:iec/presentation/widgets/sticker_editing_box.dart';
import 'package:iec/utils/single_gesture_recognizer.dart';
import 'package:screenshot/screenshot.dart';

import '../blocs/paint_bloc/paint_bloc.dart';
import '../blocs/paint_bloc/paint_event.dart';
import '../blocs/paint_bloc/paint_state.dart';

class PaintBoard extends StatefulWidget {
  static GlobalKey? globalKey = GlobalKey();
  const PaintBoard({super.key, this.assetList});
  final List<String>? assetList;

  @override
  State<PaintBoard> createState() => _PaintBoardState();
}

class _PaintBoardState extends State<PaintBoard> {
  static Size kCanvasSize = Size.zero;
  DrawController? drawController;
  late bool ignorePointer;
  late int pointerCount;

  ScreenshotController screenshotController = ScreenshotController();
  String fileName = '';
  String imagePath = '';
  File? file;

  // offset
  double x = 120.0;
  double y = 160.0;
  double x1 = 100.0;
  double y1 = 50.0;

  List<PictureModel> newImageList = <PictureModel>[];

  @override
  void initState() {
    super.initState();
    drawController = context.read<PaintBloc>().drawController;
    ignorePointer = false;
    pointerCount = 1;
    if (drawController?.globalKey == null) {
      BlocProvider.of<PaintBloc>(context)
          .add(InitGlobalKeyEvent(PaintBoard.globalKey!));
    }
  }

  @override
  Widget build(BuildContext context) {
    drawController = context.read<PaintBloc>().drawController;
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    return Column(
      children: [
        Expanded(
          child: BlocConsumer<PaintBloc, PaintState>(
            listener: (context, state) {
              if (state is MessageState) {
                showDialog(
                    context: context,
                    builder: (contextM) {
                      return AlertDialog(
                        title: const Text("Message"),
                        content: Text(state.message),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                if (state.isClear) {
                                  context
                                      .read<PaintBloc>()
                                      .add(ClearStampsEvent(ok: true));
                                }
                                Navigator.of(context).pop();
                              },
                              child: const Text("Ok")),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"))
                        ],
                      );
                    });
              }
            },
            builder: (context, state) {
              if (state is UpdateCanvasState) {
                return InteractiveViewer(
                  panEnabled: false,
                  scaleEnabled: true,
                  minScale: 0.1,
                  maxScale: 5,
                  boundaryMargin: const EdgeInsets.all(80),
                  onInteractionEnd: (details) {
                    setState(() {
                      ignorePointer = details.pointerCount > 1;
                      pointerCount = 1;
                      BlocProvider.of<PaintBloc>(context).add(
                        AddPointEvent(
                            point: Point(
                                offset: null,
                                paint: Paint()
                                  ..color = Color.fromRGBO(
                                      Random().nextInt(255),
                                      Random().nextInt(255),
                                      Random().nextInt(255),
                                      1)
                                  ..strokeCap = StrokeCap.square
                                  ..strokeJoin = StrokeJoin.bevel
                                  ..strokeWidth = (Random().nextInt(10)) * 1.0),
                            end: false),
                      );
                      print(
                          "onInteractionEnd = ignorePointer = $ignorePointer  fingers = ${details.pointerCount}");
                    });
                  },
                  onInteractionUpdate: (details) {
                    setState(() {
                      ignorePointer = details.pointerCount > 1;
                      pointerCount = details.pointerCount;
                      print(
                          "onInteractionUpdate = ignorePointer = $ignorePointer  fingers = ${details.pointerCount}");
                    });
                  },
                  onInteractionStart: (details) {
                    setState(() {
                      ignorePointer = details.pointerCount > 1;
                      pointerCount = details.pointerCount;
                      print(
                          "onInteractionStart = ignorePointer = $ignorePointer  fingers = ${details.pointerCount}");
                    });
                  },
                  child: Screenshot(
                    controller: screenshotController,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          color: Colors.black,
                          child: IgnorePointer(
                            ignoring: false,
                            child: RawGestureDetector(
                              behavior: HitTestBehavior.opaque,
                              gestures: <Type, GestureRecognizerFactory>{
                                SingleGestureRecognizer:
                                    GestureRecognizerFactoryWithHandlers<
                                            SingleGestureRecognizer>(
                                        () => SingleGestureRecognizer(
                                            debugOwner: this), (instance) {
                                  instance.onStart = (pointerEvent) {
                                    if (ignorePointer == false &&
                                        pointerCount == 1) {
                                      if (state.drawController != null &&
                                          state.drawController!.isRandomColor) {
                                        BlocProvider.of<PaintBloc>(context).add(
                                          ChangeCurrentColorEvent(
                                            Color.fromRGBO(
                                                Random().nextInt(255),
                                                Random().nextInt(255),
                                                Random().nextInt(255),
                                                1),
                                            true,
                                          ),
                                        );
                                      }
                                      // if (drawController!.penTool == PenTool.customPen) {
                                      //   BlocProvider.of<PaintBloc>(context)
                                      //       .add(AddRandomPoints([
                                      //     List.generate(
                                      //         10,
                                      //         (index) => randomOffsets.add(Offset(
                                      //             points[j]!.offset!.dx +
                                      //                 Random().nextInt(a) * 1.0,
                                      //             points[j]!.offset!.dy -
                                      //                 Random().nextInt(a) * 1.0)))
                                      //   ]));
                                      // }
                                    }
                                  };
                                  instance.onUpdate = (pointerEvent) {
                                    if (ignorePointer == false &&
                                        pointerCount == 1) {
                                      // print(pointerEvent.pointer);
                                      setState(() {
                                        kCanvasSize = Size(
                                            MediaQuery.sizeOf(context).width,
                                            MediaQuery.sizeOf(context).height -
                                                (AppBar()
                                                    .preferredSize
                                                    .height));
                                        var pinSpaceX = -20;
                                        var pinSpaceY = -160;

                                        Offset point =
                                            pointerEvent.localPosition;

                                        point = point.translate(
                                            -((kCanvasSize.width / 2) +
                                                pinSpaceX),
                                            -((kCanvasSize.height / 2) +
                                                pinSpaceY));

                                        // print("x = ${point.dx} , y = ${point.dy}");
                                        BlocProvider.of<PaintBloc>(context).add(
                                            AddPointEvent(
                                                point: Point(
                                                    offset: point,
                                                    paint: Paint()
                                                      ..color =
                                                          state.drawController ==
                                                                  null
                                                              ? Colors.white
                                                              : state
                                                                  .drawController!
                                                                  .currentColor
                                                      ..strokeCap =
                                                          StrokeCap.round
                                                      ..strokeJoin =
                                                          StrokeJoin.miter
                                                      ..strokeWidth = (Random()
                                                              .nextInt(10)) *
                                                          1.0)));
                                      });
                                    }
                                  };
                                  instance.onEnd = (pointerEvent) {
                                    if (ignorePointer == false &&
                                        pointerCount == 1) {
                                      BlocProvider.of<PaintBloc>(context).add(
                                        AddPointEvent(
                                            point: Point(
                                                offset: null,
                                                paint: Paint()
                                                  ..color = Color.fromRGBO(
                                                      Random().nextInt(255),
                                                      Random().nextInt(255),
                                                      Random().nextInt(255),
                                                      1)
                                                  ..strokeCap = StrokeCap.square
                                                  ..strokeJoin =
                                                      StrokeJoin.bevel
                                                  ..strokeWidth =
                                                      (Random().nextInt(10)) *
                                                          1.0),
                                            end: true),
                                      );
                                      setState(() {
                                        for (var e in newImageList) {
                                          e.isSelected = false;
                                        }
                                      });
                                    }
                                  };
                                }),
                              },
                              child: RepaintBoundary(
                                key: PaintBoard.globalKey,
                                child: Stack(
                                  children: [
                                    ClipRect(
                                      child: Container(
                                        color: Colors.black,
                                        height:
                                            MediaQuery.sizeOf(context).height,
                                        width: MediaQuery.sizeOf(context).width,
                                        child: CustomPaint(
                                          foregroundPainter: Sketcher(
                                              state.drawController?.points ??
                                                  [],
                                              kCanvasSize,
                                              state.drawController != null
                                                  ? state.drawController!
                                                      .symmetryLines!
                                                  : 5,
                                              state.drawController != null
                                                  ? state.drawController!
                                                      .currentColor
                                                  : Colors.red,
                                              drawController!.penTool!,
                                              drawController!.penSize ?? 3),
                                          painter: LastImageAsBackground(
                                            image: state.drawController == null
                                                ? null
                                                : state.drawController!.stamp!
                                                        .isEmpty
                                                    ? null
                                                    : state.drawController!
                                                        .stamp!.last!.image,
                                          ),
                                          size: Size(
                                            kCanvasSize.width / 2,
                                            kCanvasSize.height / 2,
                                          ),
                                          willChange: true,
                                          isComplex: true,
                                          child: const SizedBox.expand(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     setState(() {
                        //       for (var e in newImageList) {
                        //         e.isSelected = false;
                        //       }
                        //     });
                        //   },
                        // ),
                        ...newImageList.map((v) {
                          return StickerEditingBox(
                              onCancel: () {
                                int index = newImageList
                                    .indexWhere((element) => v == element);

                                newImageList.removeAt(index);
                              },
                              onTap: () {
                                if (!v.isSelected) {
                                  setState(() {
                                    for (var e in newImageList) {
                                      e.isSelected = false;
                                    }
                                    v.isSelected = true;
                                  });
                                } else {
                                  setState(() {
                                    v.isSelected = false;
                                  });
                                }
                              },
                              boundWidth: width,
                              boundHeight: height,
                              pictureModel: v);
                        }),
                      ],
                    ),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8, bottom: height * .11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: const Icon(
                  Icons.emoji_emotions_outlined,
                  size: 36,
                  color: Colors.white,
                ),
                onTap: () {
                  stickerWidget(context);
                },
              ),
              const SizedBox(width: 32,),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  BlocProvider.of<PaintBloc>(context).add(
                      SavePageToGalleryEvent(
                          screenshotController: screenshotController));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Sticker widget
  Future stickerWidget(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Material(
            elevation: 15,
            child: SizedBox(
              height: height * .4,
              width: width,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemCount: widget.assetList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        for (var e in newImageList) {
                          e.isSelected = false;
                        }
                        newImageList.add(PictureModel(
                            isNetwork: false,
                            stringUrl: widget.assetList![index],
                            top: y1 + 10 < 300 ? y1 + 10 : 300,
                            isSelected: true,
                            angle: 0.0,
                            scale: 1,
                            left: x1 + 10 < 300 ? x1 + 10 : 300));
                        x1 = x1 + 10 < 200 ? x1 + 10 : 200;
                        y1 = y1 + 10 < 200 ? y1 + 10 : 200;
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Image.asset(widget.assetList![index],
                          height: 50, width: 50),
                    );
                  }),
            ),
          );
        });
  }
}
