import 'package:more/collection.dart' show IntegerRange;

import '../../../type.dart';
import '../../shared/storage.dart';
import '../matrix.dart';

/// Mutable indexed view of the rows and columns of a matrix.
class IndexMatrix<T> with Matrix<T> {
  IndexMatrix(
      this.matrix, Iterable<int> rowIndexes, Iterable<int> columnIndexes)
      : rowIndexes = DataType.indexDataType.copyList(rowIndexes),
        columnIndexes = DataType.indexDataType.copyList(columnIndexes);

  final Matrix<T> matrix;
  final List<int> rowIndexes;
  final List<int> columnIndexes;

  @override
  DataType<T> get dataType => matrix.dataType;

  @override
  int get rowCount => rowIndexes.length;

  @override
  int get colCount => columnIndexes.length;

  @override
  Set<Storage> get storage => matrix.storage;

  @override
  T getUnchecked(int row, int col) =>
      matrix.getUnchecked(rowIndexes[row], columnIndexes[col]);

  @override
  void setUnchecked(int row, int col, T value) =>
      matrix.setUnchecked(rowIndexes[row], columnIndexes[col], value);
}

extension IndexMatrixExtension<T> on Matrix<T> {
  /// Returns a mutable view onto row indexes. Throws a [RangeError], if
  /// any of the [rowIndexes] are out of bounds.
  Matrix<T> rowIndex(Iterable<int> rowIndexes) =>
      index(rowIndexes, IntegerRange(0, colCount));

  /// Returns a mutable view onto row indexes. The behavior is undefined, if
  /// any of the [rowIndexes] are out of bounds.
  Matrix<T> rowIndexUnchecked(Iterable<int> rowIndexes) =>
      indexUnchecked(rowIndexes, IntegerRange(0, colCount));

  /// Returns a mutable view onto column indexes. Throws a [RangeError], if
  /// any of the [colIndexes] are out of bounds.
  Matrix<T> colIndex(Iterable<int> colIndexes) =>
      index(IntegerRange(0, rowCount), colIndexes);

  /// Returns a mutable view onto column indexes. The behavior is undefined, if
  /// any of the [colIndexes] are out of bounds.
  Matrix<T> colIndexUnchecked(Iterable<int> colIndexes) =>
      indexUnchecked(IntegerRange(0, rowCount), colIndexes);

  /// Returns a mutable view onto row and column indexes. Throws a
  /// [RangeError], if any of the indexes are out of bounds.
  Matrix<T> index(Iterable<int> rowIndexes, Iterable<int> colIndexes) {
    for (final index in rowIndexes) {
      RangeError.checkValueInInterval(index, 0, rowCount - 1, 'rowIndexes');
    }
    for (final index in colIndexes) {
      RangeError.checkValueInInterval(index, 0, colCount - 1, 'colIndexes');
    }
    return indexUnchecked(rowIndexes, colIndexes);
  }

  /// Returns a mutable view onto row and column indexes. The behavior is
  /// undefined if any of the indexes are out of bounds.
  Matrix<T> indexUnchecked(
          Iterable<int> rowIndexes, Iterable<int> colIndexes) =>
      _indexUnchecked(this, rowIndexes, colIndexes);

  // TODO(renggli): https://github.com/dart-lang/sdk/issues/39959
  static Matrix<T> _indexUnchecked<T>(
          Matrix<T> self, Iterable<int> rowIndexes, Iterable<int> colIndexes) =>
      self is IndexMatrix<T>
          ? IndexMatrix<T>(
              self.matrix,
              rowIndexes.map((index) => self.rowIndexes[index]),
              colIndexes.map((index) => self.columnIndexes[index]))
          : IndexMatrix<T>(self, rowIndexes, colIndexes);
}
