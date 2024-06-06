import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iec/domain/models/draw_controller.dart';
import 'package:iec/home_screen.dart';
import 'package:iec/paint_screen.dart';

import 'presentation/blocs/paint_bloc/paint_bloc.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PaintBloc(
            drawController: DrawController(
              isPanActive: true,
              penTool: PenTool.glowPen,
              points: [],
              currentColor: Colors.green,
              symmetryLines: 1,
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'IEC',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
