library data.matrix.operators;

import '../../type.dart';
import 'matrix.dart';
import 'matrix_format.dart';

export 'operator/iterator.dart' show IteratorExtension;
export 'operator/testing.dart' show TestingExtension;

Matrix<T> _resultMatrix<T>(int rowCount, int colCount, Matrix<T> target,
    MatrixFormat format, DataType<T> dataType) {
  if (target != null) {
    if (target.rowCount != rowCount || target.columnCount != colCount) {
      throw ArgumentError('Expected a matrix with $rowCount * $colCount, '
          'but got ${target.rowCount} * ${target.columnCount}.');
    }
    return target;
  } else if (dataType != null) {
    return Matrix(dataType, rowCount, colCount, format: format);
  }
  throw ArgumentError('Expected either a "target" or a "dataType".');
}

void _unaryOperator<T>(
    Matrix<T> result, Matrix<T> source, T Function(T a) operator) {
  for (var r = 0; r < result.rowCount; r++) {
    for (var c = 0; c < result.columnCount; c++) {
      result.setUnchecked(r, c, operator(source.getUnchecked(r, c)));
    }
  }
}

void _binaryOperator<T>(Matrix<T> result, Matrix<T> sourceA, Matrix<T> sourceB,
    T Function(T a, T b) operator) {
  _checkMatchingDimensions(sourceA, sourceB);
  for (var r = 0; r < result.rowCount; r++) {
    for (var c = 0; c < result.columnCount; c++) {
      result.setUnchecked(r, c,
          operator(sourceA.getUnchecked(r, c), sourceB.getUnchecked(r, c)));
    }
  }
}

void _checkMatchingDimensions<T>(Matrix<T> sourceA, Matrix<T> sourceB) {
  if (sourceA.rowCount != sourceB.rowCount ||
      sourceA.columnCount != sourceB.columnCount) {
    throw ArgumentError('Matrix dimensions do not match: '
        '${sourceA.rowCount} * ${sourceA.columnCount} and '
        '${sourceB.rowCount} * ${sourceB.columnCount}.');
  }
}

/// Generic unary operator on a matrix.
Matrix<T> unaryOperator<T>(Matrix<T> source, T Function(T a) operator,
    {Matrix<T> target, MatrixFormat format, DataType<T> dataType}) {
  final result = _resultMatrix(source.rowCount, source.columnCount, target,
      format, dataType ?? source.dataType);
  _unaryOperator(result, source, operator);
  return result;
}

/// Generic binary operator on two equal sized matrices.
Matrix<T> binaryOperator<T>(
    Matrix<T> sourceA, Matrix<T> sourceB, T Function(T a, T b) operator,
    {Matrix<T> target, MatrixFormat format, DataType<T> dataType}) {
  final result = _resultMatrix(sourceA.rowCount, sourceA.columnCount, target,
      format, dataType ?? sourceA.dataType);
  _binaryOperator(result, sourceA, sourceB, operator);
  return result;
}

/// Adds two matrices [sourceA] and [sourceB].
Matrix<T> add<T>(Matrix<T> sourceA, Matrix<T> sourceB,
    {Matrix<T> target, MatrixFormat format, DataType<T> dataType}) {
  final result = _resultMatrix(sourceA.rowCount, sourceA.columnCount, target,
      format, dataType ?? sourceA.dataType);
  _binaryOperator(result, sourceA, sourceB, result.dataType.field.add);
  return result;
}

/// Subtracts two matrices [sourceB] from [sourceA].
Matrix<T> sub<T>(Matrix<T> sourceA, Matrix<T> sourceB,
    {Matrix<T> target, MatrixFormat format, DataType<T> dataType}) {
  final result = _resultMatrix(sourceA.rowCount, sourceA.columnCount, target,
      format, dataType ?? sourceA.dataType);
  _binaryOperator(result, sourceA, sourceB, result.dataType.field.sub);
  return result;
}

/// Negates a matrix [source].
Matrix<T> neg<T>(Matrix<T> source,
    {Matrix<T> target, MatrixFormat format, DataType<T> dataType}) {
  final result = _resultMatrix(source.rowCount, source.columnCount, target,
      format, dataType ?? source.dataType);
  _unaryOperator(result, source, result.dataType.field.neg);
  return result;
}

/// Scales a matrix [source] with a [factor].
Matrix<T> scale<T>(Matrix<T> source, num factor,
    {Matrix<T> target, MatrixFormat format, DataType<T> dataType}) {
  final result = _resultMatrix(source.rowCount, source.columnCount, target,
      format, dataType ?? source.dataType);
  final scale = result.dataType.field.scale;
  _unaryOperator(result, source, (a) => scale(a, factor));
  return result;
}

/// Interpolates linearly between [sourceA] and [sourceB] with a factor [t].
Matrix<T> lerp<T>(Matrix<T> sourceA, Matrix<T> sourceB, num t,
    {Matrix<T> target, MatrixFormat format, DataType<T> dataType}) {
  final result = _resultMatrix(sourceA.rowCount, sourceA.columnCount, target,
      format, dataType ?? sourceA.dataType);
  final field = result.dataType.field;
  _binaryOperator(result, sourceA, sourceB,
      (a, b) => field.add(field.scale(a, 1.0 - t), field.scale(b, t)));
  return result;
}

/// Multiplies two numeric matrices [sourceA] and [sourceB].
Matrix<T> mul<T>(Matrix<T> sourceA, Matrix<T> sourceB,
    {Matrix<T> target, MatrixFormat format, DataType<T> dataType}) {
  if (sourceA.columnCount != sourceB.rowCount) {
    throw ArgumentError('Inner dimensions of source matrices do not match.');
  }
  final result = _resultMatrix(sourceA.rowCount, sourceB.columnCount, target,
      format, dataType ?? sourceA.dataType);
  if (identical(result, target)) {
    final sourcesStorage = Set.identity()
      ..addAll(sourceA.storage)
      ..addAll(sourceB.storage);
    if (result.storage.any(sourcesStorage.contains)) {
      throw ArgumentError('Matrix multiplication cannot be done in-place.');
    }
  }
  final field = result.dataType.field;
  for (var r = 0; r < result.rowCount; r++) {
    for (var c = 0; c < result.columnCount; c++) {
      var sum = field.additiveIdentity;
      for (var i = 0; i < sourceA.columnCount; i++) {
        sum = field.add(
          sum,
          field.mul(
            sourceA.getUnchecked(r, i),
            sourceB.getUnchecked(i, c),
          ),
        );
      }
      result.setUnchecked(r, c, sum);
    }
  }
  return result;
}

/// Compares two matrices [sourceA] and [sourceB] with each other.
bool compare<T>(Matrix<T> sourceA, Matrix<T> sourceB,
    {bool Function(T a, T b) equals}) {
  if (equals == null && identical(sourceA, sourceB)) {
    return true;
  }
  if (sourceA.rowCount != sourceB.rowCount ||
      sourceA.columnCount != sourceB.columnCount) {
    return false;
  }
  equals ??= sourceA.dataType.equality.isEqual;
  for (var r = 0; r < sourceA.rowCount; r++) {
    for (var c = 0; c < sourceA.columnCount; c++) {
      if (!equals(sourceA.getUnchecked(r, c), sourceB.getUnchecked(r, c))) {
        return false;
      }
    }
  }
  return true;
}