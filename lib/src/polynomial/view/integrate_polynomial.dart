library data.polynomial.view.integrate;

import 'package:data/src/polynomial/polynomial.dart';
import 'package:data/tensor.dart';
import 'package:data/type.dart';

/// Integrate modifiable view of a polynomial.
class IntegratePolynomial<T> extends Polynomial<T> {
  final Polynomial<T> _polynomial;
  T _constant;

  IntegratePolynomial(this._polynomial, [T constant])
      : _constant = constant ?? _polynomial.dataType.nullValue;

  @override
  DataType<T> get dataType => _polynomial.dataType;

  @override
  int get degree => _polynomial.degree < 0 ? -1 : _polynomial.degree + 1;

  @override
  Set<Tensor> get storage => _polynomial.storage;

  @override
  Polynomial<T> copy() => IntegratePolynomial(_polynomial.copy(), _constant);

  @override
  T getUnchecked(int exponent) => exponent == 0
      ? _constant
      : dataType.field.div(
          _polynomial.getUnchecked(exponent - 1),
          dataType.cast(exponent),
        );

  @override
  void setUnchecked(int exponent, T value) {
    if (exponent == 0) {
      _constant = value;
    } else {
      _polynomial.setUnchecked(
        exponent - 1,
        dataType.field.mul(
          value,
          dataType.cast(exponent),
        ),
      );
    }
  }
}