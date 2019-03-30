library data.matrix.view.overlay_mask;

import 'package:data/src/matrix/matrix.dart';
import 'package:data/tensor.dart';
import 'package:data/type.dart';

/// Mutable overlay of one matrix over another controlled by a mask.
///
/// All matrices (mask, overlay, base) have to be of the same size. The mask
/// determines whether the overlay is revealed or not.
class OverlayMaskMatrix<T> extends Matrix<T> {
  final Matrix<bool> _mask;
  final Matrix<T> _overlay;
  final Matrix<T> _base;

  OverlayMaskMatrix(this._mask, this._overlay, this._base);

  @override
  DataType<T> get dataType => _base.dataType;

  @override
  int get rowCount => _base.rowCount;

  @override
  int get colCount => _base.colCount;

  @override
  Set<Tensor> get storage => {}
    ..addAll(_mask.storage)
    ..addAll(_overlay.storage)
    ..addAll(_base.storage);

  @override
  Matrix<T> copy() =>
      OverlayMaskMatrix(_mask.copy(), _overlay.copy(), _base.copy());

  @override
  T getUnchecked(int row, int col) {
    if (_mask.getUnchecked(row, col)) {
      return _overlay.getUnchecked(row, col);
    } else {
      return _base.getUnchecked(row, col);
    }
  }

  @override
  void setUnchecked(int row, int col, T value) {
    if (_mask.getUnchecked(row, col)) {
      return _overlay.setUnchecked(row, col, value);
    } else {
      return _base.setUnchecked(row, col, value);
    }
  }
}
