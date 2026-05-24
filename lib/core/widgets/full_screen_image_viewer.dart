import 'package:flutter/material.dart';

/// Full-screen, zoomable image viewer with swipe navigation between images.
class FullScreenImageViewer extends StatefulWidget {
  const FullScreenImageViewer({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  final List<String> imageUrls;
  final int initialIndex;

  /// Pushes the viewer as a fullscreen dialog route.
  static Future<void> open(
    BuildContext context, {
    required List<String> imageUrls,
    int initialIndex = 0,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => FullScreenImageViewer(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late final PageController _controller;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: const CloseButton(),
        title: widget.imageUrls.length > 1
            ? Text('${_currentPage + 1} / ${widget.imageUrls.length}')
            : null,
      ),
      extendBodyBehindAppBar: true,
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.imageUrls.length,
        onPageChanged: (i) => setState(() => _currentPage = i),
        itemBuilder: (_, index) {
          final url = widget.imageUrls[index];
          return InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            child: Center(
              child: Image.network(
                url,
                fit: BoxFit.contain,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
                errorBuilder: (_, error, __) => const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white54,
                    size: 64,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
