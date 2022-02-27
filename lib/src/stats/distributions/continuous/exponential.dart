import 'dart:math';

import '../continuous.dart';
import '../errors.dart';
import 'uniform.dart';

/// The exponential distribution.
///
/// See https://en.wikipedia.org/wiki/Exponential_distribution.
class ExponentialDistribution extends ContinuousDistribution {
  const ExponentialDistribution(this.lambda)
      : assert(lambda > 0.0, 'lambda > 0.0');

  /// The lambda parameter (rate, inverse scale).
  final double lambda;

  @override
  double get lowerBound => 0.0;

  @override
  double get mean => 1.0 / lambda;

  @override
  double get median => ln2 / lambda;

  @override
  double get mode => 0;

  @override
  double get variance => 1.0 / (lambda * lambda);

  @override
  double probability(double x) => x < 0.0 ? 0.0 : lambda * exp(-lambda * x);

  @override
  double cumulativeProbability(double x) =>
      x < 0.0 ? 0.0 : 1.0 - exp(-lambda * x);

  @override
  double inverseCumulativeProbability(num p) {
    InvalidProbability.check(p);
    return -log(1.0 - p) / lambda;
  }

  @override
  double sample({Random? random}) {
    const uniform = UniformDistribution.standard();
    return -1.0 / lambda * log(uniform.sample(random: random));
  }

  @override
  bool operator ==(Object other) =>
      other is ExponentialDistribution && lambda == other.lambda;

  @override
  int get hashCode => Object.hash(ExponentialDistribution, lambda);

  @override
  String toString() => 'ExponentialDistribution{lambda: $lambda}';
}