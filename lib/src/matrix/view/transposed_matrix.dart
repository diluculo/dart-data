library data.matrix.view.transposed;

import '../../../tensor.dart';
import '../../../type.dart';
import '../matrix.dart';

/// Mutable transposed view of a matrix.
class TransposedMatrix<T> extends Matrix<T> {
  final Matrix<T> matrix;

  TransposedMatrix(this.matrix);

  @override
  DataType<T> get dataType => matrix.dataType;

  @override
  int get rowCount => matrix.colCount;

  @override
  int get colCount => matrix.rowCount;

  @override
  Set<Tensor> get storage => matrix.storage;

  @override
  Matrix<T> copy() => TransposedMatrix(matrix.copy());

  @override
  T getUnchecked(int row, int col) => matrix.getUnchecked(col, row);

  @override
  void setUnchecked(int row, int col, T value) =>
      matrix.setUnchecked(col, row, value);
}

extension TransposedMatrixExtension<T> on Matrix<T> {
  /// Returns a mutable view onto the transposed matrix.
  Matrix<T> get transposed => _transposed(this);

  // TODO(renggli): workaround, https://github.com/dart-lang/sdk/issues/39959.
  Matrix<T> _transposed(Matrix<T> self) =>
      self is TransposedMatrix<T> ? self.matrix : TransposedMatrix<T>(self);
}
