import '../../../type.dart';
import '../../shared/storage.dart';
import '../matrix.dart';

/// Mutable range of the rows and columns of a matrix.
class RangeMatrix<T> with Matrix<T> {
  RangeMatrix(
      this.matrix, this.rowStart, this.rowEnd, this.columnStart, this.columnEnd)
      : rowCount = rowEnd - rowStart,
        columnCount = columnEnd - columnStart;

  final Matrix<T> matrix;
  final int rowStart, rowEnd;
  final int columnStart, columnEnd;

  @override
  DataType<T> get dataType => matrix.dataType;

  @override
  final int rowCount;

  @override
  final int columnCount;

  @override
  Set<Storage> get storage => matrix.storage;

  @override
  T getUnchecked(int row, int col) =>
      matrix.getUnchecked(rowStart + row, columnStart + col);

  @override
  void setUnchecked(int row, int col, T value) =>
      matrix.setUnchecked(rowStart + row, columnStart + col, value);
}

extension RangeMatrixExtension<T> on Matrix<T> {
  /// Returns a mutable view onto the row range. Throws a [RangeError], if
  /// [rowStart] or [rowEnd] are out of bounds.
  Matrix<T> rowRange(int rowStart, [int? rowEnd]) {
    rowEnd = RangeError.checkValidRange(
        rowStart, rowEnd, rowCount, 'rowStart', 'rowEnd');
    return rowRangeUnchecked(rowStart, rowEnd);
  }

  /// Returns a mutable view onto the row range. The behavior is undefined, if
  /// [rowStart] or [rowEnd] are out of bounds.
  Matrix<T> rowRangeUnchecked(int rowStart, int rowEnd) =>
      rangeUnchecked(rowStart, rowEnd, 0, columnCount);

  /// Returns a mutable view onto the row range. Throws a [RangeError], if
  /// [columnStart] or [columnEnd] are out of bounds.
  Matrix<T> colRange(int columnStart, [int? columnEnd]) {
    columnEnd = RangeError.checkValidRange(
        columnStart, columnEnd, columnCount, 'columnStart', 'columnEnd');
    return colRangeUnchecked(columnStart, columnEnd);
  }

  /// Returns a mutable view onto the row range. The behavior is undefined, if
  /// [columnStart] or [columnEnd] are out of bounds.
  Matrix<T> colRangeUnchecked(int columnStart, int columnEnd) =>
      rangeUnchecked(0, rowCount, columnStart, columnEnd);

  /// Returns a mutable view onto the row and column ranges. Throws a
  /// [RangeError], if any of the ranges are out of bounds.
  Matrix<T> range(int rowStart, int rowEnd, int columnStart, int columnEnd) {
    rowEnd = RangeError.checkValidRange(
        rowStart, rowEnd, rowCount, 'rowStart', 'rowEnd');
    columnEnd = RangeError.checkValidRange(
        columnStart, columnEnd, columnCount, 'columnStart', 'columnEnd');
    return rangeUnchecked(rowStart, rowEnd, columnStart, columnEnd);
  }

  /// Returns a mutable view onto the row and column ranges. The behavior is
  /// undefined if any of the ranges are out of bounds.
  Matrix<T> rangeUnchecked(
          int rowStart, int rowEnd, int columnStart, int columnEnd) =>
      rowStart == 0 &&
              rowEnd == rowCount &&
              columnStart == 0 &&
              columnEnd == columnCount
          ? this
          : _rangeUnchecked(this, rowStart, rowEnd, columnStart, columnEnd);

  // TODO(renggli): https://github.com/dart-lang/sdk/issues/39959
  static Matrix<T> _rangeUnchecked<T>(Matrix<T> self, int rowStart, int rowEnd,
          int columnStart, int columnEnd) =>
      self is RangeMatrix<T>
          ? RangeMatrix<T>(
              self.matrix,
              self.rowStart + rowStart,
              self.rowStart + rowEnd,
              self.columnStart + columnStart,
              self.columnStart + columnEnd)
          : RangeMatrix<T>(self, rowStart, rowEnd, columnStart, columnEnd);
}
