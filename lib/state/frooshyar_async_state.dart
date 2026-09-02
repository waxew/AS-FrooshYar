/// Shared async state helper for FrooshYar screens.
class FrooshyarAsyncState<T> {
  final bool loading;
  final T? data;
  final String? error;

  const FrooshyarAsyncState({
    this.loading = false,
    this.data,
    this.error,
  });

  const FrooshyarAsyncState.loading()
      : loading = true,
        data = null,
        error = null;

  const FrooshyarAsyncState.success(T value)
      : loading = false,
        data = value,
        error = null;

  const FrooshyarAsyncState.failure(String message)
      : loading = false,
        data = null,
        error = message;
}
