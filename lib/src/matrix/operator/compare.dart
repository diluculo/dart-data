library data.matrix.operator.compare;

import '../matrix.dart';

extension CompareExtension<T> on Matrix<T> {
  /// Compares this [Matrix] and with [other].
  bool compare(Matrix<T> other, {bool Function(T a, T b) equals}) {
    if (equals == null && identical(this, other)) {
      return true;
    }
    if (rowCount != other.rowCount || columnCount != other.columnCount) {
      return false;
    }
    equals ??= dataType.equality.isEqual;
    for (var r = 0; r < rowCount; r++) {
      for (var c = 0; c < columnCount; c++) {
        if (!equals(getUnchecked(r, c), other.getUnchecked(r, c))) {
          return false;
        }
      }
    }
    return true;
  }
}
