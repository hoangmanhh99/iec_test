import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iec/domain/models/draw_controller.dart';
import 'package:iec/presentation/painter/drawing_board.dart';
import 'package:iec/presentation/painter/widget/tool_widget.dart';

import 'presentation/blocs/paint_bloc/paint_bloc.dart';
import 'presentation/blocs/paint_bloc/paint_event.dart';

class PaintScreen extends StatefulWidget {
  const PaintScreen({super.key});

  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  DrawController? drawController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IEC"),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              BlocProvider.of<PaintBloc>(context)
                  .add(ClearStampsEvent(ok: true));
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              BlocProvider.of<PaintBloc>(context)
                  .add(SavePageToGalleryEvent());
            },
          ),
        ],
      ),
      backgroundColor: Colors.red,
      body: const PaintBoard(),
      bottomSheet: const ToolsWidget(),
    );
  }
}
