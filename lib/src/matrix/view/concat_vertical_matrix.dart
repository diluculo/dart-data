library data.matrix.view.concat_vertical;

import '../../../tensor.dart';
import '../../../type.dart';
import '../../shared/config.dart';
import '../../shared/lists.dart';
import '../matrix.dart';

/// Mutable vertical concatenation of matrices.
class ConcatVerticalMatrix<T> extends Matrix<T> {
  final List<Matrix<T>> matrices;
  final List<int> indexes;

  ConcatVerticalMatrix(DataType<T> dataType, Iterable<Matrix<T>> matrices)
      : this._withList(dataType, matrices.toList(growable: false));

  ConcatVerticalMatrix._withList(DataType<T> dataType, List<Matrix<T>> matrices)
      : this._withListAndIndexes(dataType, matrices, computeIndexes(matrices));

  ConcatVerticalMatrix._withListAndIndexes(
      this.dataType, this.matrices, this.indexes);

  @override
  final DataType<T> dataType;

  @override
  int get rowCount => indexes.last;

  @override
  int get colCount => matrices.first.colCount;

  @override
  Set<Tensor> get storage => {...matrices};

  @override
  Matrix<T> copy() => ConcatVerticalMatrix._withListAndIndexes(dataType,
      matrices.map((vector) => vector.copy()).toList(growable: false), indexes);

  @override
  T getUnchecked(int row, int col) {
    var matrixIndex = binarySearch(indexes, 0, indexes.length, row);
    if (matrixIndex < 0) {
      matrixIndex = -matrixIndex - 2;
    }
    return matrices[matrixIndex].getUnchecked(row - indexes[matrixIndex], col);
  }

  @override
  void setUnchecked(int row, int col, T value) {
    var matrixIndex = binarySearch(indexes, 0, indexes.length, row);
    if (matrixIndex < 0) {
      matrixIndex = -matrixIndex - 2;
    }
    matrices[matrixIndex].setUnchecked(row - indexes[matrixIndex], col, value);
  }
}

List<int> computeIndexes(List<Matrix> matrices) {
  final indexes = indexDataType.newList(matrices.length + 1);
  for (var i = 0; i < matrices.length; i++) {
    indexes[i + 1] = indexes[i] + matrices[i].rowCount;
  }
  return indexes;
}
