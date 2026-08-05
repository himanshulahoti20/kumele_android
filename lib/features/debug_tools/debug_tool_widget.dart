import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/visible_by_page/visible_by_page.dart';

class DebugTool extends StatefulWidget {
  final double size;

  const DebugTool({
    this.size = 45,
    super.key,
  });

  @override
  State<DebugTool> createState() => DebugToolState();
}

class DebugToolState extends State<DebugTool> {
  Offset oldPos = Offset(0.0, 100.0);
  Offset newPos = Offset(0.0, 500.0);
  Offset dragEndPos = Offset(0.0, 100.0);
  bool startAnim = false;

  void startAnimation(Offset currentPos) {
    double screenWidth = Utils.getWidth;
    double xPos = currentPos.dx + (widget.size / 2) < screenWidth / 2
        ? 0
        : screenWidth - widget.size;
    setState(() {
      dragEndPos = currentPos;
      newPos = Offset(xPos, currentPos.dy);
      startAnim = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibleByPage(
      screenNotShow: const [
        'MainDebugPage',
        'APIDebugPage',
      ],
      child: buildDraggable(context),
    );
  }

  Widget buildDraggable(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => Stack(
            children: [
              Draggable(
                childWhenDragging: SizedBox.shrink(),
                onDragEnd: (details) => startAnimation(details.offset),
                feedback: buildIconDebug(),
                child: buildIconDebug(),
              )
                  .animate(
                    target: startAnim ? 1 : 0,
                    onComplete: (controller) => setState(() {
                      startAnim = false;
                      dragEndPos = newPos;
                    }),
                  )
                  .move(
                    begin: dragEndPos,
                    end: newPos,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linearToEaseOut,
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildIconDebug() {
    return ClickWidget(
      onPressed: () =>
          InjectionHelper.navKey.currentContext!.push(AppRoutes.mainDebug),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
        child: Icon(Icons.terminal, size: 35, color: Colors.white),
      ),
    );
  }
}
