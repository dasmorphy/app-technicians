import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kontrol_app/presentation/models/technical_control.dart';
import 'package:kontrol_app/presentation/providers/technical-kontrol/technical_repository_provider.dart';

final getHistoryTechnical =
    StateNotifierProvider<CatalogNotifier<TechnicalControl>, List<TechnicalControl>>((ref) {
  final repo = ref.watch(technicalRepositoryProvider);

  return CatalogNotifier<TechnicalControl>(
    (_) => repo.getAllTechnical(),
  );
});

typedef FetchListCallback<T> = Future<List<T>> Function(
  Map<String, dynamic>? filters,
);

class CatalogNotifier<T> extends StateNotifier<List<T>> {
  final FetchListCallback<T> fetch;
  bool _isLoading = false;

  CatalogNotifier(this.fetch) : super(const []);

  Future<void> load({Map<String, dynamic>? filters}) async {
    if (_isLoading || !mounted) return;

    _isLoading = true;

    try {
      final data = await fetch(filters);

      if (!mounted) return;
      state = data;
    } catch (_) {
      if (mounted) state = [];
    } finally {
      _isLoading = false;
    }
  }
}