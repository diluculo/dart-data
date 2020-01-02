library data.vector.view.column;

import '../../../type.dart';
import '../../../vector.dart';
import '../../matrix/matrix.dart';
import '../../shared/storage.dart';

/// Mutable column matrix of a vector.
class ColumnMatrix<T> with Matrix<T> {
  final Vector<T> vector;

  ColumnMatrix(this.vector);

  @override
  DataType<T> get dataType => vector.dataType;

  @override
  int get rowCount => vector.count;

  @override
  int get columnCount => 1;

  @override
  Set<Storage> get storage => vector.storage;

  @override
  Matrix<T> copy() => ColumnMatrix<T>(vector.copy());

  @override
  T getUnchecked(int row, int col) => vector.getUnchecked(row);

  @override
  void setUnchecked(int row, int col, T value) =>
      vector.setUnchecked(row, value);
}

extension ColumnMatrixExtension<T> on Vector<T> {
  /// Returns a [Matrix] with this [Vector] as its single column.
  Matrix<T> get columnMatrix => ColumnMatrix<T>(this);
}