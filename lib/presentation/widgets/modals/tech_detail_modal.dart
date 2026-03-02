import 'package:flutter/material.dart';
import 'package:kontrol_app/config/constants/environments.dart';
import 'package:kontrol_app/config/utils/helper.dart';
import 'package:kontrol_app/presentation/models/technical_control.dart';
import 'package:kontrol_app/presentation/models/technical_label.dart';

class TechDetailModal extends StatelessWidget {
  final TechnicalControl item;

  const TechDetailModal({super.key, required this.item});

  String _prettyKey(String key) {
    return key
        .replaceAll('_', ' ')
        .splitMapJoin(
          RegExp(r'\w+'),
          onMatch: (m) {
            final s = m.group(0)!;
            return s[0].toUpperCase() + s.substring(1);
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    const hiddenFields = {
      'updated_by',
      'final_gasoline_id',
      'updated_at',
      'license_id',
      'initial_gasoline_id',
      'images', // ocultamos del listado de campos, lo mostramos aparte
    };

    final entries = item
        .toJson()
        .entries
        .where((e) => !hiddenFields.contains(e.key))
        .toList();

    final images = item.images; // List<String>

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 40),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Detalle control técnico',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 520),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Campos de texto ──────────────────────────────
                      ...entries.map((e) {
                        final key = e.key;
                        final value = e.value;

                        String displayKey =
                            technicalLabels[key] ?? _prettyKey(key);

                        String displayValue;
                        if (value == null) {
                          displayValue = '—';
                        } else if ((key == 'reasons' ||
                                key == 'clients' ||
                                key == 'copilots') &&
                            value is List) {
                          displayValue = value
                              .map((e) {
                                if (e is Map && e.containsKey('name')) {
                                  return e['name'].toString();
                                }
                                return '';
                              })
                              .where((e) => e.isNotEmpty)
                              .join(', ');
                        } else if (key.toLowerCase().contains('date') ||
                            key.toLowerCase().contains('created_at')) {
                          displayValue = formatDateDetails(value.toString());
                        } else {
                          displayValue = value.toString();
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  displayKey,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.white70),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  displayValue,
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      // ── Imágenes 2x2 ─────────────────────────────────
                      if (images.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Imágenes',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: images.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _openImageFullscreen(
                                  context, images, index),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  '${Environments.baseUrl}${images[index]}',
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return Container(
                                      color: Colors.white10,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, _, __) => Container(
                                    color: Colors.white10,
                                    child: const Icon(
                                      Icons.broken_image_outlined,
                                      color: Colors.white30,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 58),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF444444),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Visor fullscreen al tocar una imagen ──────────────────────────────────
  void _openImageFullscreen(
      BuildContext context, List<dynamic> images, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ImageViewer(images: images, initialIndex: initialIndex, baseUrl: Environments.baseUrl),
      ),
    );
  }
}

// ── Visor de imágenes con PageView ────────────────────────────────────────────
class _ImageViewer extends StatefulWidget {
  final List<dynamic> images;
  final int initialIndex;
  final String baseUrl;

  const _ImageViewer({required this.images, required this.initialIndex, required this.baseUrl});

  @override
  State<_ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<_ImageViewer> {
  late final PageController _controller;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
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
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${_current + 1} / ${widget.images.length}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.images.length,
        onPageChanged: (i) => setState(() => _current = i),
        itemBuilder: (context, index) => InteractiveViewer(
          child: Center(
            child: Image.network(
              '${widget.baseUrl}${widget.images[index]}',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.broken_image_outlined,
                color: Colors.white30,
                size: 64,
              ),
            ),
          ),
        ),
      ),
    );
  }
}