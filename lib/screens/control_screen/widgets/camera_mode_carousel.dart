import 'package:flutter/material.dart';
import 'package:heroctrl/gopro_settings/actions/camera_mode.dart';
import 'package:heroctrl/models/camera_state.dart';
import 'package:heroctrl/services/gopro_api_service.dart';
import 'package:heroctrl/utils/camera_state_conditions.dart';
import 'package:heroctrl/utils/logger.dart';
import 'package:heroctrl/utils/snackbar.dart';

class CameraModeCarousel extends StatefulWidget {
  final CameraState cameraState;
  final String password;
  final Future<void> Function() onStatusUpdated;

  const CameraModeCarousel({
    super.key,
    required this.cameraState,
    required this.password,
    required this.onStatusUpdated,
  });

  @override
  State<CameraModeCarousel> createState() => _CameraModeCarouselState();
}

class _CameraModeCarouselState extends State<CameraModeCarousel> {
  bool _isLoading = false;
  bool _wasRecording = false;
  late PageController _pageController;
  late int _selectedModeIndex;
  double _viewportFraction = 0.4;

  static const int _visibleItemCount = 5;
  static const double _carouselHeight = 80;
  static const double _cardSize = 64;
  static const double _cardGap = 8;

  static const List<CameraMode> _modeOrder = [
    CameraMode.videoMode,
    CameraMode.photoMode,
    CameraMode.burstMode,
    CameraMode.timelapseMode,
  ];

  @override
  void initState() {
    super.initState();
    _selectedModeIndex = _modeIndex(widget.cameraState.status.cameraMode);
    // Start at a high offset to allow infinite scrolling in both directions
    _pageController = PageController(
      initialPage: 1000 + _selectedModeIndex,
      viewportFraction: _viewportFraction,
    );
  }

  @override
  void didUpdateWidget(covariant CameraModeCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextIndex = _modeIndex(widget.cameraState.status.cameraMode);
    if (nextIndex != _selectedModeIndex) {
      _selectedModeIndex = nextIndex;
      if (_pageController.hasClients) {
        _jumpToSelectedModePage(nextIndex);
      }
      // If !hasClients (recording), _wasRecording will trigger the page sync
      // when the carousel reattaches.
    }
  }

  void _jumpToSelectedModePage(int modeIndex) {
    final currentPage =
        _pageController.page?.round() ?? _pageController.initialPage;
    final currentModeIndex = _modeIndexFromPage(currentPage);
    final offset = currentPage - currentModeIndex;
    _pageController.jumpToPage(offset + modeIndex);
  }

  int _modeIndex(CameraMode mode) {
    final index = _modeOrder.indexOf(mode);
    return index >= 0 ? index : 0;
  }

  int _modeIndexFromPage(int pageIndex) {
    final remainder = pageIndex % _modeOrder.length;
    return remainder < 0 ? remainder + _modeOrder.length : remainder;
  }

  double _scaleForPageIndex(int pageIndex) {
    final currentPage = _pageController.hasClients
        ? (_pageController.page ?? _pageController.initialPage.toDouble())
        : _pageController.initialPage.toDouble();
    final distanceFromCenter = (currentPage - pageIndex).abs();
    final normalizedDistance = distanceFromCenter.clamp(0.0, 2.0);

    const double shrinkPerStep = 0.09;
    final scale = 1 - (normalizedDistance * shrinkPerStep);
    return scale.clamp(0.70, 1.0);
  }

  void _updateViewportFraction(double availableWidth) {
    if (availableWidth <= 0) return;

    final nextViewportFraction = ((_cardSize + _cardGap) / availableWidth)
        .clamp(0.0001, 1.0);

    if ((nextViewportFraction - _viewportFraction).abs() < 0.0001) {
      return;
    }

    final currentPage = _pageController.hasClients
        ? (_pageController.page?.round() ?? _pageController.initialPage)
        : 1000 + _selectedModeIndex;

    _pageController.dispose();
    _viewportFraction = nextViewportFraction;
    _pageController = PageController(
      initialPage: currentPage,
      viewportFraction: _viewportFraction,
    );
  }

  Future<void> _changeMode(CameraMode mode) async {
    final isRecording = CameraStateConditions.isRecording(widget.cameraState);
    if (_isLoading ||
        isRecording ||
        mode == widget.cameraState.status.cameraMode) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      AppLogger.info(
        'Changing camera mode to ${mode.getLocalizedName(context)}',
      );
      await GoProApiService.setCameraMode(widget.password, mode);
      await Future.delayed(const Duration(milliseconds: 500));
      await widget.onStatusUpdated();
    } catch (e, stackTrace) {
      AppLogger.error('Error changing camera mode', e, stackTrace);
      if (mounted) {
        showSnackBarError(context, 'Error: Cannot change mode: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleShutterPress() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (CameraStateConditions.isInPhotoOrBurstMode(widget.cameraState)) {
        AppLogger.info('Capturing photo');
        await GoProApiService.startShutter(widget.password);
      } else {
        if (CameraStateConditions.isRecording(widget.cameraState)) {
          AppLogger.info('Stopping recording');
          await GoProApiService.stopShutter(widget.password);
        } else {
          AppLogger.info('Starting recording');
          await GoProApiService.startShutter(widget.password);
        }

        await Future.delayed(const Duration(milliseconds: 500));
      }

      await widget.onStatusUpdated();
    } catch (e, stackTrace) {
      AppLogger.error('Error toggling shutter', e, stackTrace);
      if (mounted) {
        final action =
            CameraStateConditions.isInPhotoOrBurstMode(widget.cameraState)
            ? 'capture photo'
            : (CameraStateConditions.isRecording(widget.cameraState)
                  ? 'stop recording'
                  : 'start recording');
        showSnackBarError(context, 'Error: Cannot $action: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (CameraStateConditions.isInSettingsMode(widget.cameraState)) {
      return const SizedBox.shrink();
    }

    final isShutterDown = CameraStateConditions.isShutterDown(
      widget.cameraState,
    );
    final isRecording = CameraStateConditions.isRecording(widget.cameraState);
    final canSwitchModes = !_isLoading && !isRecording;
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxCarouselWidth =
            (_visibleItemCount * _cardSize) +
            ((_visibleItemCount - 1) * _cardGap);
        final carouselWidth = constraints.maxWidth < maxCarouselWidth
            ? constraints.maxWidth
            : maxCarouselWidth;

        _updateViewportFraction(carouselWidth);

        if (isRecording) {
          _wasRecording = true;
          final recordingMode = widget.cameraState.status.cameraMode;
          return SizedBox(
            height: _carouselHeight,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: _cardSize,
                height: _cardSize,
                child: _buildActionButton(
                  recordingMode,
                  isShutterDown,
                  colorScheme,
                ),
              ),
            ),
          );
        }

        // PageView is re-appearing after recording: the controller re-attaches
        // at its baked-in initialPage which may differ from the selected mode.
        if (_wasRecording) {
          _wasRecording = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || !_pageController.hasClients) return;
            _jumpToSelectedModePage(_selectedModeIndex);
          });
        }

        return SizedBox(
          height: _carouselHeight,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: carouselWidth,
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  final settledPage = _pageController.page?.round();
                  if (settledPage != null) {
                    final modeIndex = _modeIndexFromPage(settledPage);
                    _changeMode(_modeOrder[modeIndex]);
                  }
                  return false;
                },
                child: PageView.builder(
                  controller: _pageController,
                  physics: canSwitchModes
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    final modeIndex = _modeIndexFromPage(index);
                    setState(() {
                      _selectedModeIndex = modeIndex;
                    });
                  },
                  itemBuilder: (context, index) {
                    final modeIndex = _modeIndexFromPage(index);
                    final mode = _modeOrder[modeIndex];
                    final isSelected = modeIndex == _selectedModeIndex;

                    if (isSelected) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        child: SizedBox(
                          width: _cardSize,
                          height: _cardSize,
                          child: _buildActionButton(
                            mode,
                            isShutterDown,
                            colorScheme,
                          ),
                        ),
                        builder: (context, child) {
                          final scale = _scaleForPageIndex(index);
                          return Align(
                            alignment: Alignment.topCenter,
                            child: Transform.scale(
                              scale: scale,
                              alignment: Alignment.topCenter,
                              child: child,
                            ),
                          );
                        },
                      );
                    }

                    return AnimatedBuilder(
                      animation: _pageController,
                      child: GestureDetector(
                        onTap: canSwitchModes
                            ? () {
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOut,
                                );
                              }
                            : null,
                        child: SizedBox(
                          width: _cardSize,
                          height: _cardSize,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  mode.icon,
                                  size: 18,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 2),
                                Flexible(
                                  child: Text(
                                    mode.getLocalizedName(context),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                          fontSize: 9,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      builder: (context, child) {
                        final scale = _scaleForPageIndex(index);
                        return Align(
                          alignment: Alignment.topCenter,
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.topCenter,
                            child: child,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    CameraMode mode,
    bool isShutterDown,
    ColorScheme colorScheme,
  ) {
    final isVideoMode =
        mode == CameraMode.videoMode || mode == CameraMode.timelapseMode;

    if (isVideoMode) {
      return Material(
        color: isShutterDown ? Colors.red : Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        child: InkWell(
          onTap: _isLoading ? null : _handleShutterPress,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: _cardSize,
            height: _cardSize,
            alignment: Alignment.center,
            child: Icon(
              isShutterDown
                  ? Icons.stop_rounded
                  : (mode == CameraMode.videoMode
                        ? Icons.circle
                        : Icons.video_camera_back),
              size: isShutterDown ? 24 : 28,
              color: isShutterDown ? Colors.white : Colors.red,
            ),
          ),
        ),
      );
    } else {
      return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        child: InkWell(
          onTap: _isLoading ? null : _handleShutterPress,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: _cardSize,
            height: _cardSize,
            alignment: Alignment.center,
            child: Icon(mode.icon, size: 24, color: Colors.black87),
          ),
        ),
      );
    }
  }
}
