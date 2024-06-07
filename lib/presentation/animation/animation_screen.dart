import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:iec/gen/assets.gen.dart';
import 'package:iec/presentation/widgets/heart_widget.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../widgets/tooltip_widget.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  int initHeart = 2;
  int sumHeart = 10;

  late Animation<Offset> _offsetAnimation1;
  late Animation<Offset> _offsetAnimation2;
  final heartKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPositionWidget();
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: const Offset(0, 0.1),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _offsetAnimation1 =
        Tween<Offset>(begin: Offset.zero, end: const Offset(1.5, 1.5)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  Offset getPositionWidget() {
    final RenderBox renderBox =
        heartKey.currentContext?.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    print("===${position} $size ${renderBox.parent}");
    return position;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 64, 16, 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 36),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SlideTransition(
                        position: Tween<Offset>(
                                begin: Offset.zero, end: const Offset(4, 2.5))
                            .animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: const Interval(0.6, 1.0,
                                curve: Curves.easeInOut),
                          ),
                        ),
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 1.0, end: 0.5).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve:
                                  Interval(0.0, 0.5, curve: Curves.easeInOut),
                            ),
                          ),
                          child: HeartWidget(),
                        ),
                      ),
                      HeartWidget(),
                      HeartWidget(),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "NEXT MILESTONE",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Assets.icons.icPurpleHeart
                                        .svg(key: heartKey, width: 12),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text("$initHeart/$sumHeart")
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            LinearPercentIndicator(
                              percent: initHeart / sumHeart,
                              lineHeight: 8,
                              progressColor: const Color(0xFFAA8ED6),
                              padding: EdgeInsets.zero,
                              barRadius: const Radius.circular(4),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Assets.icons.icCoins.image(
                        width: 48,
                        height: 48,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            child: Row(
              children: [
                Expanded(
                  child: PortalTarget(
                    visible: true,
                    anchor: const Aligned(
                        follower: Alignment.bottomCenter,
                        target: Alignment.topCenter),
                    portalFollower: SlideTransition(
                      position: _animation,
                      child: Container(
                        width: 160,
                        padding: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CustomPaint(
                          painter: CustomStyleArrow(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Can you Perfect your Design?",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.rotate_right,
                            color: Colors.redAccent,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Redesign",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
