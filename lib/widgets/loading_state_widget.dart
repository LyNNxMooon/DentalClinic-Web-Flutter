import 'package:flutter/material.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:dental_clinic/widgets/loading_widget.dart';

class LoadingStateWidget extends StatefulWidget {
  const LoadingStateWidget(
      {super.key,
      required this.loadingState,
      required this.loadingSuccessWidget,
      required this.loadingInitWidget,
      required this.paddingTop,
      required this.paddingBottom});

  final LoadingState loadingState;
  final Widget loadingSuccessWidget;
  final Widget loadingInitWidget;
  final double paddingTop;
  final double paddingBottom;

  @override
  State<LoadingStateWidget> createState() => _LoadingStateWidgetState();
}

class _LoadingStateWidgetState extends State<LoadingStateWidget> {
  @override
  Widget build(BuildContext context) {
    return switch (widget.loadingState) {
      LoadingState.init => widget.loadingInitWidget,
      LoadingState.loading => Padding(
          padding: EdgeInsets.only(
              top: widget.paddingTop, bottom: widget.paddingBottom),
          child: const LoadingWidget(),
        ),
      LoadingState.error => widget.loadingInitWidget,
      _ => widget.loadingSuccessWidget,
    };
  }
}
