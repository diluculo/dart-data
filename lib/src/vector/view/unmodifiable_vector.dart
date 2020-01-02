library data.vector.view.unmodifiable;

import '../../../tensor.dart';
import '../../../type.dart';
import '../mixins/unmodifiable_vector.dart';
import '../vector.dart';

/// Read-only view of a mutable vector.
class UnmodifiableVector<T> extends Vector<T> with UnmodifiableVectorMixin<T> {
  final Vector<T> vector;

  UnmodifiableVector(this.vector);

  @override
  DataType<T> get dataType => vector.dataType;

  @override
  int get count => vector.count;

  @override
  Set<Tensor> get storage => vector.storage;

  @override
  Vector<T> copy() => UnmodifiableVector(vector.copy());

  @override
  T getUnchecked(int index) => vector.getUnchecked(index);
}

extension UnmodifiableVectorExtension<T> on Vector<T> {
  /// Returns a unmodifiable view of this [Vector].
  Vector<T> get unmodifiable =>
      this is UnmodifiableVectorMixin<T> ? this : UnmodifiableVector<T>(this);
}
