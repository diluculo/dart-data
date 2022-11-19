import '../../../type.dart';
import '../../shared/storage.dart';
import '../matrix.dart';
import '../mixin/unmodifiable_matrix.dart';

/// Read-only matrix with a constant value.
class ConstantMatrix<T> with Matrix<T>, UnmodifiableMatrixMixin<T> {
  ConstantMatrix(this.dataType, this.rowCount, this.columnCount, this.value);

  final T value;

  @override
  final DataType<T> dataType;

  @override
  final int rowCount;

  @override
  final int columnCount;

  @override
  Set<Storage> get storage => {this};

  @override
  Matrix<T> copy() => this;

  @override
  T getUnchecked(int row, int col) => value;
}
