library data.vector.view.column_matrix;

import 'package:data/src/matrix/matrix.dart';
import 'package:data/tensor.dart';
import 'package:data/type.dart';
import 'package:data/vector.dart';

/// Mutable column vector of a matrix.
class ColumnMatrixVector<T> extends Vector<T> {
  final Matrix<T> _matrix;
  final int _col;

  ColumnMatrixVector(this._matrix, this._col);

  @override
  DataType<T> get dataType => _matrix.dataType;

  @override
  int get count => _matrix.rowCount;

  @override
  Set<Tensor> get storage => _matrix.storage;

  @override
  Vector<T> copy() => ColumnMatrixVector(_matrix.copy(), _col);

  @override
  T getUnchecked(int index) => _matrix.getUnchecked(index, _col);

  @override
  void setUnchecked(int index, T value) =>
      _matrix.setUnchecked(index, _col, value);
}