import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iec/domain/models/draw_controller.dart';
import 'package:iec/domain/models/point.dart';
import 'package:iec/gen/assets.gen.dart';
import 'package:iec/presentation/painter/widget/last_image_as_background.dart';
import 'package:iec/presentation/painter/widget/sketcher.dart';
import 'package:iec/utils/single_gesture_recognizer.dart';

import '../blocs/paint_bloc/paint_bloc.dart';
import '../blocs/paint_bloc/paint_event.dart';
import '../blocs/paint_bloc/paint_state.dart';

class PaintBoard extends StatefulWidget {
  static GlobalKey? globalKey = GlobalKey();
  const PaintBoard({super.key});

  @override
  State<PaintBoard> createState() => _PaintBoardState();
}

class _PaintBoardState extends State<PaintBoard> {
  static Size kCanvasSize = Size.zero;
  DrawController? drawController;
  late bool ignorePointer;
  late int pointerCount;

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
    return BlocConsumer<PaintBloc, PaintState>(
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
                            ..color = Color.fromRGBO(Random().nextInt(255),
                                Random().nextInt(255), Random().nextInt(255), 1)
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
            child: Container(
              margin: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height * .1),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: 64,
                        left: 20,
                        right: 20,
                        top: 64,
                      ),
                      color: Colors.black,
                      child: IgnorePointer(
                        ignoring: false,
                        child: RawGestureDetector(
                          behavior: HitTestBehavior.opaque,
                          gestures: <Type, GestureRecognizerFactory>{
                            SingleGestureRecognizer:
                                GestureRecognizerFactoryWithHandlers<
                                        SingleGestureRecognizer>(
                                    () =>
                                        SingleGestureRecognizer(debugOwner: this),
                                    (instance) {
                              instance.onStart = (pointerEvent) {
                                if (ignorePointer == false && pointerCount == 1) {
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
                                if (ignorePointer == false && pointerCount == 1) {
                                  // print(pointerEvent.pointer);
                                  setState(() {
                                    kCanvasSize = Size(
                                        MediaQuery.sizeOf(context).width,
                                        MediaQuery.sizeOf(context).height -
                                            (AppBar().preferredSize.height));
                                    var pinSpaceX = -20;
                                    var pinSpaceY = -160;

                                    Offset point = pointerEvent.localPosition;

                                    point = point.translate(
                                        -((kCanvasSize.width / 2) + pinSpaceX),
                                        -((kCanvasSize.height / 2) + pinSpaceY));

                                    // print("x = ${point.dx} , y = ${point.dy}");
                                    BlocProvider.of<PaintBloc>(context).add(
                                        AddPointEvent(
                                            point: Point(
                                                offset: point,
                                                paint: Paint()
                                                  ..color =
                                                      state.drawController == null
                                                          ? Colors.white
                                                          : state.drawController!
                                                              .currentColor
                                                  ..strokeCap = StrokeCap.round
                                                  ..strokeJoin = StrokeJoin.miter
                                                  ..strokeWidth =
                                                      (Random().nextInt(10)) *
                                                          1.0)));
                                  });
                                }
                              };
                              instance.onEnd = (pointerEvent) {
                                if (ignorePointer == false && pointerCount == 1) {
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
                                              ..strokeWidth =
                                                  (Random().nextInt(10)) * 1.0),
                                        end: true),
                                  );
                                }
                              };
                            }),
                          },
                          child: RepaintBoundary(
                            key: PaintBoard.globalKey,
                            child: ClipRect(
                              child: Container(
                                color: Colors.black,
                                height: MediaQuery.sizeOf(context).height,
                                width: MediaQuery.sizeOf(context).width,
                                child: CustomPaint(
                                  foregroundPainter: Sketcher(
                                      state.drawController?.points ?? [],
                                      kCanvasSize,
                                      state.drawController != null
                                          ? state.drawController!.symmetryLines!
                                          : 5,
                                      state.drawController != null
                                          ? state.drawController!.currentColor
                                          : Colors.red,
                                      drawController!.penTool!,
                                      drawController!.penSize ?? 3),
                                  painter: LastImageAsBackground(
                                    image: state.drawController == null
                                        ? null
                                        : state.drawController!.stamp!.isEmpty
                                            ? null
                                            : state.drawController!.stamp!.last!
                                                .image,
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
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Assets.icons.icSmileySvg.svg(),
                      ],
                    ),
                  )
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
    );
  }
}
