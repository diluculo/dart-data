library data.matrix.matrix;

import 'package:data/type.dart' show DataType;
import 'package:data/vector.dart' show Vector;
import 'package:more/collection.dart' show IntegerRange;
import 'package:more/printer.dart' show Printer;

import 'builder.dart';
import 'impl/row_major_matrix.dart';
import 'view/column_vector.dart';
import 'view/diagonal_vector.dart';
import 'view/index_matrix.dart';
import 'view/mapped_matrix.dart';
import 'view/range_matrix.dart';
import 'view/row_vector.dart';
import 'view/transpose_matrix.dart';
import 'view/unmodifiable_matrix.dart';

/// Abstract matrix type.
abstract class Matrix<T> {
  /// Default builder for new matrices.
  static Builder<Object> get builder =>
      Builder<Object>(RowMajorMatrix, DataType.object);

  /// Unnamed default constructor.
  const Matrix();

  /// The data type of this matrix.
  DataType<T> get dataType;

  /// Returns the value at the provided [row] and [col] index. Throws a
  /// [RangeError] if [row] or [col] are outside of bounds.
  T get(int row, int col) {
    RangeError.checkValidIndex(row, this, 'row', rowCount);
    RangeError.checkValidIndex(col, this, 'col', colCount);
    return getUnchecked(row, col);
  }

  /// Returns the value at the provided [row] and [col] index. The behavior is
  /// undefined if [row] or [col] are outside of bounds.
  T getUnchecked(int row, int col);

  /// Sets the value at the provided [row] and [col] index to [value]. Throws a
  /// [RangeError] if [row] or [col] are outside of bounds.
  void set(int row, int col, T value) {
    RangeError.checkValidIndex(row, this, 'row', rowCount);
    RangeError.checkValidIndex(col, this, 'col', colCount);
    setUnchecked(row, col, value);
  }

  /// Sets the value at the provided [row] and [col] index to [value]. The
  /// behavior is undefined if [row] or [col] are outside of bounds.
  void setUnchecked(int row, int col, T value);

  /// Returns the number of rows in the matrix.
  int get rowCount;

  /// Returns a mutable row vector of this matrix. Throws a [RangeError], if
  /// [row] is out of bounds.
  Vector<T> row(int row) {
    RangeError.checkValidIndex(row, this, 'row', rowCount);
    return rowUnchecked(row);
  }

  /// Returns a mutable row vector of this matrix. The behavior is undefined,
  /// if [row] is out of bounds.
  Vector<T> rowUnchecked(int row) => RowVector<T>(this, row);

  /// Returns the number of columns in the matrix.
  int get colCount;

  /// Returns a mutable column vector of this matrix. Throws a [RangeError], if
  /// [col] is out of bounds.
  Vector<T> col(int col) {
    RangeError.checkValidIndex(col, this, 'col', colCount);
    return colUnchecked(col);
  }

  /// Returns a mutable column vector of this matrix. The behavior is undefined,
  /// if [col] is out of bounds. An offset of `0` refers to the diagonal in the
  /// center of the matrix, a negative offset to the diagonals above, a positive
  /// offset to the diagonals below.
  Vector<T> colUnchecked(int col) => ColumnVector<T>(this, col);

  /// Returns a mutable diagonal vector of this matrix. Throws a [RangeError],
  /// if [offset] is out of bounds. An offset of `0` refers to the diagonal
  /// in the center of the matrix, a negative offset to the diagonals above,
  /// and a positive offset to the diagonals below.
  Vector<T> diagonal([int offset = 0]) {
    RangeError.checkValueInInterval(
        offset, -colCount + 1, rowCount - 1, 'offset');
    return diagonalUnchecked(offset);
  }

  /// Returns a mutable diagonal vector of the matrix. The behavior is
  /// undefined, if [offset] is out of bounds. An offset of `0` refers to the
  /// diagonal in the center of the matrix, a negative offset to the diagonals
  /// above, and a positive offset to the diagonals below.
  Vector<T> diagonalUnchecked([int offset = 0]) =>
      DiagonalVector<T>(this, offset);

  /// Returns a mutable view onto the row range. Throws a [RangeError], if
  /// [rowStart] or [rowEnd] are out of bounds.
  Matrix<T> rowRange(int rowStart, int rowEnd) =>
      range(rowStart, rowEnd, 0, colCount);

  /// Returns a mutable view onto the row range. The behavior is undefined, if
  /// [rowStart] or [rowEnd] are out of bounds.
  Matrix<T> rowRangeUnchecked(int rowStart, int rowEnd) =>
      rangeUnchecked(rowStart, rowEnd, 0, colCount);

  /// Returns a mutable view onto the row range. Throws a [RangeError], if
  /// [colStart] or [colEnd] are out of bounds.
  Matrix<T> colRange(int colStart, int colEnd) =>
      range(0, rowCount, colStart, colEnd);

  /// Returns a mutable view onto the row range. The behavior is undefed, if
  /// [colStart] or [colEnd] are out of bounds.
  Matrix<T> colRangeUnchecked(int colStart, int colEnd) =>
      rangeUnchecked(0, rowCount, colStart, colEnd);

  /// Returns a mutable view onto the row and column ranges. Throws a
  /// [RangeError], if any of the ranges are out of bounds.
  Matrix<T> range(int rowStart, int rowEnd, int colStart, int colEnd) {
    RangeError.checkValidRange(
        rowStart, rowEnd, rowCount, 'rowStart', 'rowEnd');
    RangeError.checkValidRange(
        colStart, colEnd, colCount, 'colStart', 'colEnd');
    if (rowStart == 0 &&
        rowEnd == rowCount &&
        colStart == 0 &&
        colEnd == colCount) {
      return this;
    } else {
      return rangeUnchecked(rowStart, rowEnd, colStart, colEnd);
    }
  }

  /// Returns a mutable view onto the row and column ranges. The behavior is
  /// undefined if any of the ranges are out of bounds.
  Matrix<T> rangeUnchecked(
          int rowStart, int rowEnd, int colStart, int colEnd) =>
      RangeMatrix<T>(this, rowStart, rowEnd, colStart, colEnd);

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
    for (var index in rowIndexes) {
      RangeError.checkValueInInterval(index, 0, rowCount - 1, 'rowIndexes');
    }
    for (var index in colIndexes) {
      RangeError.checkValueInInterval(index, 0, colCount - 1, 'colIndexes');
    }
    return indexUnchecked(rowIndexes, colIndexes);
  }

  /// Returns a mutable view onto row and column indexes. The behavior is
  /// undefined if any of the indexes are out of bounds.
  Matrix<T> indexUnchecked(
          Iterable<int> rowIndexes, Iterable<int> colIndexes) =>
      IndexMatrix<T>(this, rowIndexes, colIndexes);

  /// Returns a lazy [Matrix] with elements that are created by calling
  /// `callback` on each element of this `Matrix`.
  Matrix<S> map<S>(MatrixTransformation<T, S> callback, DataType<S> dataType) =>
      MappedMatrix<T, S>(this, callback, dataType);

  /// Returns a mutable view onto the transposed matrix.
  Matrix<T> get transpose => TransposeMatrix<T>(this);

  /// Returns a unmodifiable view of the matrix.
  Matrix<T> get unmodifiable => UnmodifiableMatrix<T>(this);

  /// Returns a human readable representation of the matrix.
  String format([Printer printer]) {
    final formatter = printer ?? dataType.printer;
    final buffer = StringBuffer();
    for (var r = 0; r < rowCount; r++) {
      if (r > 0) {
        buffer.writeln();
      }
      for (var c = 0; c < colCount; c++) {
        if (c > 0) {
          buffer.write(' ');
        }
        buffer.write(formatter(getUnchecked(r, c)));
      }
    }
    return buffer.toString();
  }

  /// Pretty prints the matrix.
  @override
  String toString() => '$runtimeType[$rowCount, $colCount]: ${format()}';
}
