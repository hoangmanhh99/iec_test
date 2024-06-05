import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iec/domain/models/draw_controller.dart';
import 'package:iec/gen/assets.gen.dart';
import 'package:iec/presentation/painter/widget/popover.dart';

import '../../blocs/paint_bloc/paint_bloc.dart';
import '../../blocs/paint_bloc/paint_event.dart';

class ToolsWidget extends StatefulWidget {
  const ToolsWidget({super.key});

  @override
  State<ToolsWidget> createState() => _ToolsWidgetState();
}

class _ToolsWidgetState extends State<ToolsWidget> {
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PaintBloc(),
        ),
      ],
      child: Container(
        height: MediaQuery.sizeOf(context).height * .1,
        color: Colors.purple[800],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              child: Assets.icons.icPen.svg(
                width: 30,
              ),
              onTap: () {
                _handleFABPressed(context, ToolType.brushs);
              },
            ),
            GestureDetector(
              child: Assets.icons.icEraser.svg(
                width: 45,
              ),
              onTap: () {
                BlocProvider.of<PaintBloc>(context)
                    .add(ChangePenToolEvent(penTool: PenTool.eraserPen));
              },
            ),
            GestureDetector(
              child: Assets.icons.icColorWheel.svg(
                width: 45,
              ),
              onTap: () {
                _handleFABPressed(context, ToolType.colors);
              },
            ),
            GestureDetector(
              child: const Icon(Icons.emoji_emotions_outlined, size: 36, color: Colors.white,),
              onTap: () {
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleFABPressed(BuildContext context, ToolType toolType) {
    showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Popover(
          child: _buildToolSettings(context, toolType),
        );
      },
    );
  }

  Widget _buildToolSettings(BuildContext context, ToolType toolType) {
    if (toolType == ToolType.colors) {
      return buildColorTool(context);
    } else if (toolType == ToolType.brushs) {
      return buildBrushesTool(context);
    }
    return buildColorTool(context);
  }

  Widget buildBrushesTool(BuildContext context) {
    final theme = Theme.of(context);
    var brushes = [
      BrushTool(
          penTool: PenTool.glowPen, picture: Assets.icons.icPen1Preview.svg()),
      BrushTool(
          penTool: PenTool.normalPen,
          picture: Assets.icons.icPen2Preview.svg()),
      // BrushTool(
      // penTool: PenTool.normalPen, picture: Assets.svg.pen3Preview.svg()),
      // BrushTool(
      // penTool: PenTool.normalPen, picture: Assets.svg.pen4Preview.svg()),
      BrushTool(
          penTool: PenTool.glowWithDotsPen,
          picture: Assets.icons.icPen3Preview.svg()),
      BrushTool(
          penTool: PenTool.normalWithShaderPen,
          picture: Assets.icons.icPen6Preview.svg()),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: brushes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (BuildContext context, int index) {
            final brush = brushes[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: brush.picture,
                ),
                onTap: () {
                  BlocProvider.of<PaintBloc>(context)
                      .add(ChangePenToolEvent(penTool: brush.penTool));
                  Navigator.of(context).pop();
                },
              ),
            );
          }),
    );
  }

  Widget buildColorTool(BuildContext context) {
    final colors = [
      Colors.green,
      Colors.black,
      Colors.blue,
      Colors.red,
      Colors.grey,
      Colors.yellow,
      Colors.purple,
      Colors.indigo,
      Colors.lime,
      Colors.orange,
      "Random Color",
      "Color Picker"
    ];
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: colors.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (BuildContext context, int index) {
          final color = colors[index];
          if (color is Color) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white70, width: 3),
                  ),
                ),
                onTap: () {
                  BlocProvider.of<PaintBloc>(context)
                      .add(ChangeCurrentColorEvent(color, false));
                  Navigator.of(context).pop();
                },
              ),
            );
          } else {
            if (color == "Random Color") {
              return GestureDetector(
                child: Assets.icons.icColorWheel.svg(
                  width: 60,
                ),
                onTap: () {
                  BlocProvider.of<PaintBloc>(context).add(
                      ChangeCurrentColorEvent(Color(Colors.green.value), true));
                  Navigator.of(context).pop();
                },
              );
            } else if (color == "Color Picker") {
              return IconButton(
                  onPressed: () {
                    // raise the [showDialog] widget
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Pick a color!'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: pickerColor,
                                onColorChanged: changeColor,
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('Got it'),
                                onPressed: () {
                                  BlocProvider.of<PaintBloc>(context).add(
                                      ChangeCurrentColorEvent(
                                          pickerColor, false));
                                  //for the dialog
                                  Navigator.of(context).pop();
                                  //for the model
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.color_lens,
                    color: Colors.red,
                    size: 60,
                  ));
            }
          }
          return Container();
        },
      ),
    );
  }
}

enum ToolType {
  colors,
  brushs,
}

class BrushTool {
  PenTool penTool;
  SvgPicture picture;
  BrushTool({
    required this.penTool,
    required this.picture,
  });
}
