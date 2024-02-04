import 'package:flutter/material.dart';

import '../shared/custom_picker.dart';

/// Represents the widget for picking assets.
class ActualAssetPickerWidget extends StatefulWidget {
  const ActualAssetPickerWidget({
    Key? key,
    required this.pickMethod,
    required this.onMethodSelected,
    required this.child,
  }) : super(key: key);

  final PickMethod pickMethod;
  final void Function(PickMethod method) onMethodSelected;
  final Widget child;

  @override
  State<ActualAssetPickerWidget> createState() =>
      _ActualAssetPickerWidgetState();
}

class _ActualAssetPickerWidgetState extends State<ActualAssetPickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ).copyWith(bottom: 10.0),
      child: Scaffold(
        body: Center(
          child: GestureDetector(
                onTap: () => widget.onMethodSelected(widget.pickMethod),
                child: widget.child),
          ),
        ),
    );
  }
}
