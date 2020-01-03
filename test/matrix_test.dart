library data.test.matrix;

import 'dart:math';

import 'package:data/matrix.dart';
import 'package:data/type.dart';
import 'package:data/vector.dart';
import 'package:test/test.dart';

void matrixTest(String name, MatrixFormat format) {
  group(name, () {
    group('constructor', () {
      test('default', () {
        final matrix = Matrix(DataType.int8, 4, 5, format: format);
        expect(matrix.dataType, DataType.int8);
        expect(matrix.rowCount, 4);
        expect(matrix.columnCount, 5);
        expect(matrix.storage, [matrix]);
        expect(matrix.shape, [matrix.rowCount, matrix.columnCount]);
        for (var r = 0; r < matrix.rowCount; r++) {
          for (var c = 0; c < matrix.columnCount; c++) {
            expect(matrix.get(r, c), 0);
          }
        }
      });
      test('default with error', () {
        expect(() => Matrix(null, 4, 5, format: format), throwsArgumentError);
        expect(() => Matrix(DataType.int8, -4, 5, format: format),
            throwsRangeError);
        expect(() => Matrix(DataType.int8, 4, -5, format: format),
            throwsRangeError);
      });
      test('constant', () {
        final matrix = Matrix.constant(DataType.int8, 5, 6);
        expect(matrix.dataType, DataType.int8);
        expect(matrix.rowCount, 5);
        expect(matrix.columnCount, 6);
        expect(matrix.storage, [matrix]);
        expect(matrix.copy(), matrix);
        expect(matrix.shape, [matrix.rowCount, matrix.columnCount]);
        for (var r = 0; r < matrix.rowCount; r++) {
          for (var c = 0; c < matrix.columnCount; c++) {
            expect(matrix.get(r, c), 0);
          }
        }
        expect(() => matrix.set(0, 0, 1), throwsUnsupportedError);
      });
      test('constant with value', () {
        final matrix = Matrix.constant(DataType.int8, 5, 6, value: 123);
        expect(matrix.dataType, DataType.int8);
        expect(matrix.rowCount, 5);
        expect(matrix.columnCount, 6);
        expect(matrix.storage, [matrix]);
        expect(matrix.copy(), matrix);
        expect(matrix.shape, [matrix.rowCount, matrix.columnCount]);
        for (var r = 0; r < matrix.rowCount; r++) {
          for (var c = 0; c < matrix.columnCount; c++) {
            expect(matrix.get(r, c), 123);
          }
        }
        expect(() => matrix.set(0, 0, 1), throwsUnsupportedError);
      });
      test('constant with format', () {
        final matrix = Matrix.constant(DataType.int8, 5, 6, format: format);
        expect(matrix.dataType, DataType.int8);
        expect(matrix.rowCount, 5);
        expect(matrix.columnCount, 6);
        expect(matrix.storage, [matrix]);
        expect(matrix.shape, [matrix.rowCount, matrix.columnCount]);
        for (var r = 0; r < matrix.rowCount; r++) {
          for (var c = 0; c < matrix.columnCount; c++) {
            expect(matrix.get(r, c), 0);
          }
        }
        matrix.set(0, 0, 1);
        expect(matrix.get(0, 0), 1);
      });
      test('identity', () {
        final matrix = Matrix.identity(DataType.int8, 6, 7);
        expect(matrix.dataType, DataType.int8);
        expect(matrix.rowCount, 6);
        expect(matrix.columnCount, 7);
        expect(matrix.storage, [matrix]);
        expect(matrix.shape, [matrix.rowCount, matrix.columnCount]);
        expect(matrix.copy(), matrix);
        for (var r = 0; r < matrix.rowCount; r++) {
          for (var c = 0; c < matrix.columnCount; c++) {
            expect(matrix.get(r, c), r == c ? 1 : 0);
          }
        }
        expect(() => matrix.set(0, 0, 1), throwsUnsupportedError);
      });
      test('identity with value', () {
        final matrix = Matrix.identity(DataType.int8, 6, 7, value: -1);
        expect(matrix.dataType, DataType.int8);
        expect(matrix.rowCount, 6);
        expect(matrix.columnCount, 7);
        expect(matrix.storage, [matrix]);
        expect(matrix.shape, [matrix.rowCount, matrix.columnCount]);
        expect(matrix.copy(), matrix);
        for (var r = 0; r < matrix.rowCount; r++) {
          for (var c = 0; c < matrix.columnCount; c++) {
            expect(matrix.get(r, c), r == c ? -1 : 0);
          }
        }
        expect(() => matrix.set(0, 0, -1), throwsUnsupportedError);
      });
      test('identity with format', () {
        final matrix = Matrix.identity(DataType.int8, 6, 7, format: format);
        expect(matrix.dataType, DataType.int8);
        expect(matrix.rowCount, 6);
        expect(matrix.columnCount, 7);
        expect(matrix.storage, [matrix]);
        expect(matrix.shape, [matrix.rowCount, matrix.columnCount]);
        for (var r = 0; r < matrix.rowCount; r++) {
          for (var c = 0; c < matrix.columnCount; c++) {
            expect(matrix.get(r, c), r == c ? 1 : 0);
          }
        }
        matrix.set(0, 0, -1);
        expect(matrix.get(0, 0), -1);
      });
      test('generate', () {
        final matrix = Matrix.generate(
            DataType.string, 7, 8, (row, col) => '($row, $col)');
        expect(matrix.dataType, DataType.string);
        expect(matrix.rowCount, 7);
        expect(matrix.columnCount, 8);
        expect(matrix.shape, [matrix.rowCount, matrix.columnCount]);
        expect(matrix.storage, [matrix]);
        for (var r = 0; r < matrix.rowCount; r++) {
          for (var c = 0; c < matrix.columnCount; c++) {
            expect(matrix.get(r, c), '($r, $c)');
          }
        }
        expect(() => matrix.set(0, 0, '*'), throwsUnsupportedError);
      });
      test('generate with format', () {
        final matrix = Matrix.generate(
            DataType.string, 7, 8, (row, col) => '($row, $col)',
            format: format);
        expect(matrix.dataType, DataType.string);
        expect(matrix.rowCount, 7);
        expect(matrix.columnCount, 8);
        expect(matrix.shape, [matrix.rowCount, matrix.columnCount]);
        expect(matrix.storage, [matrix]);
        for (var r = 0; r < matrix.rowCount; r++) {
          for (var c = 0; c < matrix.columnCount; c++) {
            expect(matrix.get(r, c), '($r, $c)');
          }
        }
        matrix.set(0, 0, '*');
        expect(matrix.get(0, 0), '*');
      });
      test('fromRows', () {
        final matrix = Matrix.fromRows(
            DataType.int8,
            [
              [1, 2, 3],
              [4, 5, 6],
            ],
            format: format);
        expect(matrix.dataType, DataType.int8);
        expect(matrix.rowCount, 2);
        expect(matrix.columnCount, 3);
        expect(matrix.shape, [matrix.rowCount, matrix.columnCount]);
        expect(matrix.storage, [matrix]);
        expect(matrix.get(0, 0), 1);
        expect(matrix.get(1, 0), 4);
        expect(matrix.get(0, 1), 2);
        expect(matrix.get(1, 1), 5);
        expect(matrix.get(0, 2), 3);
        expect(matrix.get(1, 2), 6);
      });
      test('fromRows with error', () {
        expect(
            () => Matrix.fromRows(
                DataType.int8,
                [
                  [1],
                  [1, 2]
                ],
                format: format),
            throwsArgumentError);
      });
      test('fromPackedRows', () {
        final matrix = Matrix.fromPackedRows(
            DataType.object, 2, 3, [1, 2, 3, 4, 5, 6],
            format: format);
        expect(matrix.dataType, DataType.object);
        expect(matrix.rowCount, 2);
        expect(matrix.columnCount, 3);
        expect(matrix.shape, [matrix.rowCount, matrix.columnCount]);
        expect(matrix.storage, [matrix]);
        expect(matrix.get(0, 0), 1);
        expect(matrix.get(0, 1), 2);
        expect(matrix.get(0, 2), 3);
        expect(matrix.get(1, 0), 4);
        expect(matrix.get(1, 1), 5);
        expect(matrix.get(1, 2), 6);
      });
      test('fromPackedRows with error', () {
        expect(
            () => Matrix.fromPackedRows(DataType.object, 2, 3, [],
                format: format),
            throwsArgumentError);
      });
      test('fromColumns', () {
        final matrix = Matrix.fromColumns(
            DataType.int8,
            [
              [1, 2, 3],
              [4, 5, 6],
            ],
            format: format);
        expect(matrix.dataType, DataType.int8);
        expect(matrix.rowCount, 3);
        expect(matrix.columnCount, 2);
        expect(matrix.shape, [matrix.rowCount, matrix.columnCount]);
        expect(matrix.storage, [matrix]);
        expect(matrix.get(0, 0), 1);
        expect(matrix.get(1, 0), 2);
        expect(matrix.get(2, 0), 3);
        expect(matrix.get(0, 1), 4);
        expect(matrix.get(1, 1), 5);
        expect(matrix.get(2, 1), 6);
      });
      test('fromColumns with error', () {
        expect(
            () => Matrix.fromColumns(
                DataType.int8,
                [
                  [1],
                  [1, 2]
                ],
                format: format),
            throwsArgumentError);
      });
      test('fromPackedColumns', () {
        final matrix = Matrix.fromPackedColumns(
            DataType.object, 2, 3, [1, 2, 3, 4, 5, 6],
            format: format);
        expect(matrix.dataType, DataType.object);
        expect(matrix.rowCount, 2);
        expect(matrix.columnCount, 3);
        expect(matrix.shape, [matrix.rowCount, matrix.columnCount]);
        expect(matrix.storage, [matrix]);
        expect(matrix.get(0, 0), 1);
        expect(matrix.get(1, 0), 2);
        expect(matrix.get(0, 1), 3);
        expect(matrix.get(1, 1), 4);
        expect(matrix.get(0, 2), 5);
        expect(matrix.get(1, 2), 6);
      });
      test('fromPackedColumns with error', () {
        expect(
            () => Matrix.fromPackedColumns(DataType.object, 2, 3, [],
                format: format),
            throwsArgumentError);
      });
    });
    group('accessing', () {
      final matrix = Matrix.fromRows(
          DataType.int8,
          [
            [1, 2, 3],
            [4, 5, 6]
          ],
          format: format);
      test('random', () {
        final matrix = Matrix(DataType.object, 8, 12, format: format);
        final points = <Point>[];
        for (var r = 0; r < matrix.rowCount; r++) {
          for (var c = 0; c < matrix.columnCount; c++) {
            points.add(Point(r, c));
          }
        }
        // add values
        points.shuffle();
        for (final point in points) {
          matrix.set(point.x, point.y, point);
        }
        for (var r = 0; r < matrix.rowCount; r++) {
          for (var c = 0; c < matrix.columnCount; c++) {
            expect(matrix.get(r, c), Point(r, c));
          }
        }
        // update values
        points.shuffle();
        for (final point in points) {
          matrix.set(point.x, point.y, Point(point.x + 1, point.y + 1));
        }
        for (var r = 0; r < matrix.rowCount; r++) {
          for (var c = 0; c < matrix.columnCount; c++) {
            expect(matrix.get(r, c), Point(r + 1, c + 1));
          }
        }
        // remove values
        points.shuffle();
        for (final point in points) {
          matrix.set(point.x, point.y, matrix.dataType.nullValue);
        }
        for (var r = 0; r < matrix.rowCount; r++) {
          for (var c = 0; c < matrix.columnCount; c++) {
            expect(matrix.get(r, c), matrix.dataType.nullValue);
          }
        }
      });
      test('read operator', () {
        expect(matrix[0][0], 1);
        expect(matrix[0][1], 2);
        expect(matrix[0][2], 3);
        expect(matrix[1][0], 4);
        expect(matrix[1][1], 5);
        expect(matrix[1][2], 6);
      });
      test('write operator', () {
        final copy = Matrix(
            matrix.dataType, matrix.rowCount, matrix.columnCount,
            format: format);
        for (var r = 0; r < matrix.rowCount; r++) {
          for (var c = 0; c < matrix.columnCount; c++) {
            copy[r][c] = matrix.get(r, c);
          }
        }
        expect(compare(copy, matrix), isTrue);
      });
      test('read with range error', () {
        expect(() => matrix.get(-1, 0), throwsRangeError);
        expect(() => matrix.get(0, -1), throwsRangeError);
        expect(() => matrix.get(matrix.rowCount, 0), throwsRangeError);
        expect(() => matrix.get(0, matrix.columnCount), throwsRangeError);
      });
      test('write with range error', () {
        expect(() => matrix.set(-1, 0, 0), throwsRangeError);
        expect(() => matrix.set(0, -1, 0), throwsRangeError);
        expect(() => matrix.set(matrix.rowCount, 0, 0), throwsRangeError);
        expect(() => matrix.set(0, matrix.columnCount, 0), throwsRangeError);
      });
      test('format', () {
        final matrix = Matrix.generate(DataType.uint16, 30, 30, (r, c) => r * c,
            format: format);
        expect(
            matrix.format(),
            '0 0 0 … 0 0 0\n'
            '0 1 2 … 27 28 29\n'
            '0 2 4 … 54 56 58\n'
            '⋮ ⋮ ⋮ ⋱ ⋮ ⋮ ⋮\n'
            '0 27 54 … 729 756 783\n'
            '0 28 56 … 756 784 812\n'
            '0 29 58 … 783 812 841');
      });
      test('toString', () {
        expect(
            matrix.toString(),
            '${matrix.runtimeType}'
            '(dataType: int8, rowCount: 2, columnCount: 3):\n'
            '1 2 3\n'
            '4 5 6');
      });
    });
    group('view', () {
      test('copy', () {
        final source = Matrix.generate(
            DataType.object, 8, 6, (row, col) => Point(row, col),
            format: format);
        final copy = source.copy();
        expect(copy.dataType, source.dataType);
        expect(copy.rowCount, source.rowCount);
        expect(copy.columnCount, source.columnCount);
        expect(copy.storage, [copy]);
        expect(compare(source, copy), isTrue);
        source.set(3, 5, null);
        expect(copy.get(3, 5), const Point(3, 5));
      });
      test('row', () {
        final source = Matrix.generate(
            DataType.string, 4, 5, (r, c) => '($r, $c)',
            format: format);
        for (var r = 0; r < source.rowCount; r++) {
          final row = source.row(r);
          expect(row.dataType, source.dataType);
          expect(row.count, source.columnCount);
          expect(row.storage, [source]);
          expect(row.copy().compare(row), isTrue);
          for (var c = 0; c < source.columnCount; c++) {
            expect(row[c], '($r, $c)');
            row[c] += '*';
          }
          expect(() => row[-1], throwsRangeError);
          expect(() => row[source.columnCount], throwsRangeError);
          expect(() => row[-1] += '*', throwsRangeError);
          expect(() => row[source.columnCount] += '*', throwsRangeError);
        }
        expect(() => source.row(-1), throwsRangeError);
        expect(() => source.row(4), throwsRangeError);
        for (var r = 0; r < source.rowCount; r++) {
          for (var c = 0; c < source.columnCount; c++) {
            expect(source.get(r, c), '($r, $c)*');
          }
        }
      });
      test('column', () {
        final source = Matrix.generate(
            DataType.string, 5, 4, (r, c) => '($r, $c)',
            format: format);
        for (var c = 0; c < source.columnCount; c++) {
          final column = source.column(c);
          expect(column.dataType, source.dataType);
          expect(column.count, source.rowCount);
          expect(column.storage, [source]);
          expect(column.copy().compare(column), isTrue);
          for (var r = 0; r < source.rowCount; r++) {
            expect(column[r], '($r, $c)');
            column[r] += '*';
          }
          expect(() => column[-1], throwsRangeError);
          expect(() => column[source.rowCount], throwsRangeError);
          expect(() => column[-1] += '*', throwsRangeError);
          expect(() => column[source.rowCount] += '*', throwsRangeError);
        }
        expect(() => source.column(-1), throwsRangeError);
        expect(() => source.column(4), throwsRangeError);
        for (var r = 0; r < source.rowCount; r++) {
          for (var c = 0; c < source.columnCount; c++) {
            expect(source.get(r, c), '($r, $c)*');
          }
        }
      });
      group('diagonal', () {
        test('vertical', () {
          final source = Matrix.generate(
              DataType.string, 2, 3, (row, col) => '($row, $col)',
              format: format);
          final offsets = {
            1: ['(1, 0)'],
            0: ['(0, 0)', '(1, 1)'],
            -1: ['(0, 1)', '(1, 2)'],
            -2: ['(0, 2)'],
          };
          for (final offset in offsets.keys) {
            final expected = offsets[offset];
            final diagonal = source.diagonal(offset);
            expect(diagonal.dataType, source.dataType);
            expect(diagonal.count, expected.length);
            expect(diagonal.storage, [source]);
            expect(diagonal.copy().compare(diagonal), isTrue);
            for (var i = 0; i < expected.length; i++) {
              expect(diagonal[i], expected[i]);
              diagonal[i] += '*';
            }
          }
          expect(() => source.diagonal(2), throwsRangeError);
          expect(() => source.diagonal(-3), throwsRangeError);
          for (var r = 0; r < source.rowCount; r++) {
            for (var c = 0; c < source.columnCount; c++) {
              expect(source.get(r, c), '($r, $c)*');
            }
          }
        });
        test('horizontal', () {
          final source = Matrix.generate(
              DataType.string, 3, 2, (row, col) => '($row, $col)',
              format: format);
          final offsets = {
            2: ['(2, 0)'],
            1: ['(1, 0)', '(2, 1)'],
            0: ['(0, 0)', '(1, 1)'],
            -1: ['(0, 1)'],
          };
          for (final offset in offsets.keys) {
            final expected = offsets[offset];
            final diagonal = source.diagonal(offset);
            expect(diagonal.dataType, source.dataType);
            expect(diagonal.count, expected.length);
            expect(diagonal.storage, [source]);
            expect(diagonal.copy().compare(diagonal), isTrue);
            for (var i = 0; i < expected.length; i++) {
              expect(diagonal[i], expected[i]);
              diagonal[i] += '*';
            }
            expect(() => diagonal[-1], throwsRangeError);
            expect(() => diagonal[diagonal.count], throwsRangeError);
          }
          expect(() => source.diagonal(3), throwsRangeError);
          expect(() => source.diagonal(-2), throwsRangeError);
          for (var r = 0; r < source.rowCount; r++) {
            for (var c = 0; c < source.columnCount; c++) {
              expect(source.get(r, c), '($r, $c)*');
            }
          }
        });
      });
      group('range', () {
        final source = Matrix.generate(
            DataType.object, 7, 8, (row, col) => Point(row, col),
            format: format);
        test('row', () {
          final range = source.rowRange(1, 3);
          expect(range.dataType, source.dataType);
          expect(range.rowCount, 2);
          expect(range.columnCount, source.columnCount);
          expect(range.storage, [source]);
          expect(compare(range.copy(), range), isTrue);
          for (var r = 0; r < range.rowCount; r++) {
            for (var c = 0; c < range.columnCount; c++) {
              expect(range.get(r, c), Point(r + 1, c));
            }
          }
        });
        test('row unchecked', () {
          source.rowRangeUnchecked(-1, source.rowCount);
          source.rowRangeUnchecked(0, source.rowCount + 1);
        });
        test('column', () {
          final range = source.colRange(1, 4);
          expect(range.dataType, source.dataType);
          expect(range.rowCount, source.rowCount);
          expect(range.columnCount, 3);
          expect(range.storage, [source]);
          expect(compare(range.copy(), range), isTrue);
          for (var r = 0; r < range.rowCount; r++) {
            for (var c = 0; c < range.columnCount; c++) {
              expect(range.get(r, c), Point(r, c + 1));
            }
          }
        });
        test('column unchecked', () {
          source.colRangeUnchecked(-1, source.columnCount);
          source.colRangeUnchecked(0, source.columnCount + 1);
        });
        test('row and column', () {
          final range = source.range(1, 3, 2, 4);
          expect(range.dataType, source.dataType);
          expect(range.rowCount, 2);
          expect(range.columnCount, 2);
          expect(range.storage, [source]);
          expect(compare(range.copy(), range), isTrue);
          for (var r = 0; r < range.rowCount; r++) {
            for (var c = 0; c < range.columnCount; c++) {
              expect(range.get(r, c), Point(r + 1, c + 2));
            }
          }
        });
        test('sub range', () {
          final range = source
              .range(1, source.rowCount - 2, 1, source.columnCount - 2)
              .range(1, source.rowCount - 3, 1, source.columnCount - 3);
          expect(range.dataType, source.dataType);
          expect(range.rowCount, source.rowCount - 4);
          expect(range.columnCount, source.columnCount - 4);
          expect(range.storage, [source]);
          expect(compare(range.copy(), range), isTrue);
          for (var r = 0; r < range.rowCount; r++) {
            for (var c = 0; c < range.columnCount; c++) {
              expect(range.get(r, c), Point(r + 2, c + 2));
            }
          }
        });
        test('full range', () {
          final range = source.range(0, source.rowCount, 0, source.columnCount);
          expect(range, source);
        });
        test('write', () {
          final original = source.copy();
          final range = original.range(2, 3, 3, 4);
          range.set(0, 0, '*');
          expect(range.get(0, 0), '*');
          expect(original.get(2, 3), '*');
        });
        test('range error', () {
          expect(() => source.range(-1, source.rowCount, 0, source.columnCount),
              throwsRangeError);
          expect(
              () => source.range(0, source.rowCount + 1, 0, source.columnCount),
              throwsRangeError);
          expect(() => source.range(0, source.rowCount, -1, source.columnCount),
              throwsRangeError);
          expect(
              () => source.range(0, source.rowCount, 0, source.columnCount + 1),
              throwsRangeError);
        });
      });
      group('index', () {
        final source = Matrix.generate(
            DataType.object, 6, 4, (row, col) => Point(row, col),
            format: format);
        test('row', () {
          final index = source.rowIndex([5, 0, 4]);
          expect(index.dataType, source.dataType);
          expect(index.rowCount, 3);
          expect(index.columnCount, source.columnCount);
          expect(index.storage, [source]);
          expect(compare(index.copy(), index), isTrue);
          for (var r = 0; r < index.rowCount; r++) {
            for (var c = 0; c < index.columnCount; c++) {
              expect(index.get(r, c), Point(r == 0 ? 5 : r == 1 ? 0 : 4, c));
            }
          }
        });
        test('row unchecked', () {
          source.rowIndexUnchecked([-1, source.rowCount - 1]);
          source.rowIndexUnchecked([0, source.rowCount]);
        });
        test('column', () {
          final index = source.colIndex([3, 0, 0]);
          expect(index.dataType, source.dataType);
          expect(index.rowCount, source.rowCount);
          expect(index.columnCount, 3);
          expect(index.storage, [source]);
          expect(compare(index.copy(), index), isTrue);
          for (var r = 0; r < index.rowCount; r++) {
            for (var c = 0; c < index.columnCount; c++) {
              expect(index.get(r, c), Point(r, c == 0 ? 3 : 0));
            }
          }
        });
        test('column unchecked', () {
          source.colIndexUnchecked([-1, source.columnCount - 1]);
          source.colIndexUnchecked([0, source.columnCount]);
        });
        test('row and column', () {
          final index = source.index([0, 5], [3, 0]);
          expect(index.dataType, source.dataType);
          expect(index.rowCount, 2);
          expect(index.columnCount, 2);
          expect(index.storage, [source]);
          expect(compare(index.copy(), index), isTrue);
          for (var r = 0; r < index.rowCount; r++) {
            for (var c = 0; c < index.columnCount; c++) {
              expect(index.get(r, c), Point(r == 0 ? 0 : 5, c == 0 ? 3 : 0));
            }
          }
        });
        test('sub index', () {
          final index = source.index([2, 3, 0], [1, 2]).index([2], [1]);
          expect(index.dataType, source.dataType);
          expect(index.rowCount, 1);
          expect(index.columnCount, 1);
          expect(index.storage, [source]);
          expect(index.get(0, 0), const Point(0, 2));
        });
        test('write', () {
          final original = source.copy();
          final index = original.index([2], [3]);
          index.set(0, 0, '*');
          expect(index.get(0, 0), '*');
          expect(original.get(2, 3), '*');
        });
        test('range error', () {
          expect(
              () => source.index(
                  [-1, source.rowCount - 1], [0, source.columnCount - 1]),
              throwsRangeError);
          expect(
              () => source
                  .index([0, source.rowCount], [0, source.columnCount - 1]),
              throwsRangeError);
          expect(
              () => source.index(
                  [0, source.rowCount - 1], [-1, source.columnCount - 1]),
              throwsRangeError);
          expect(
              () => source
                  .index([0, source.rowCount - 1], [0, source.columnCount]),
              throwsRangeError);
        });
      });
      group('overlay', () {
        final base = Matrix.generate(
            DataType.string, 8, 10, (row, col) => '($row, $col)',
            format: format);
        test('offset', () {
          final top = Matrix.generate(
              DataType.string, 2, 3, (row, col) => '[$row, $col]',
              format: format);
          final composite = top.overlay(base, rowOffset: 4, colOffset: 5);
          expect(composite.dataType, top.dataType);
          expect(composite.rowCount, base.rowCount);
          expect(composite.columnCount, base.columnCount);
          expect(composite.storage, unorderedMatches([base, top]));
          final copy = composite.copy();
          expect(compare(copy, composite), isTrue);
          for (var r = 0; r < composite.rowCount; r++) {
            for (var c = 0; c < composite.columnCount; c++) {
              expect(
                  composite.get(r, c),
                  4 <= r && r <= 5 && 5 <= c && c <= 7
                      ? '[${r - 4}, ${c - 5}]'
                      : '($r, $c)');
              copy.set(r, c, '${copy.get(r, c)}*');
            }
          }
        });
        test('mask', () {
          final top = Matrix.generate(DataType.string, base.rowCount,
              base.columnCount, (row, col) => '[$row, $col]',
              format: format);
          final mask = Matrix.generate(DataType.boolean, base.rowCount,
              base.columnCount, (row, col) => row.isEven && col.isOdd,
              format: format);
          final composite = top.overlay(base, mask: mask);
          expect(composite.dataType, top.dataType);
          expect(composite.rowCount, base.rowCount);
          expect(composite.columnCount, base.columnCount);
          expect(composite.storage, unorderedMatches([base, top, mask]));
          final copy = composite.copy();
          expect(compare(copy, composite), isTrue);
          for (var r = 0; r < composite.rowCount; r++) {
            for (var c = 0; c < composite.columnCount; c++) {
              expect(composite.get(r, c),
                  r.isEven && c.isOdd ? '[$r, $c]' : '($r, $c)');
              copy.set(r, c, '${copy.get(r, c)}*');
            }
          }
        });
        test('errors', () {
          expect(() => base.overlay(base), throwsArgumentError);
          expect(() => base.overlay(base, rowOffset: 1), throwsArgumentError);
          expect(() => base.overlay(base, colOffset: 1), throwsArgumentError);
          expect(
              () => base.overlay(
                  Matrix.constant(
                      DataType.string, base.rowCount + 1, base.columnCount,
                      value: '', format: format),
                  mask: Matrix.constant(
                      DataType.boolean, base.rowCount, base.columnCount,
                      value: true, format: format)),
              throwsArgumentError);
          expect(
              () => base.overlay(
                  Matrix.constant(
                      DataType.string, base.rowCount, base.columnCount + 1,
                      value: '', format: format),
                  mask: Matrix.constant(
                      DataType.boolean, base.rowCount, base.columnCount,
                      value: true, format: format)),
              throwsArgumentError);
          expect(
              () => base.overlay(base,
                  mask: Matrix.constant(
                      DataType.boolean, base.rowCount + 1, base.columnCount,
                      value: true, format: format)),
              throwsArgumentError);
          expect(
              () => base.overlay(base,
                  mask: Matrix.constant(
                      DataType.boolean, base.rowCount, base.columnCount + 1,
                      value: true, format: format)),
              throwsArgumentError);
        });
      });
      group('transform', () {
        final source = Matrix.generate(
            DataType.object, 3, 4, (row, col) => Point(row, col),
            format: format);
        test('to string', () {
          final mapped = source.map(
              (row, col, value) => '${value.x + 10 * value.y}',
              DataType.string);
          expect(mapped.dataType, DataType.string);
          expect(mapped.rowCount, source.rowCount);
          expect(mapped.columnCount, source.columnCount);
          expect(mapped.storage, [source]);
          expect(compare(mapped.copy(), mapped), isTrue);
          for (var r = 0; r < mapped.rowCount; r++) {
            for (var c = 0; c < mapped.columnCount; c++) {
              expect(mapped.get(r, c), '${r + 10 * c}');
            }
          }
        });
        test('to int', () {
          final mapped = source.map(
              (row, col, value) => value.x + 10 * value.y, DataType.int32);
          expect(mapped.dataType, DataType.int32);
          expect(mapped.rowCount, source.rowCount);
          expect(mapped.columnCount, source.columnCount);
          expect(mapped.storage, [source]);
          for (var r = 0; r < mapped.rowCount; r++) {
            for (var c = 0; c < mapped.columnCount; c++) {
              expect(mapped.get(r, c), r + 10 * c);
            }
          }
        });
        test('to float', () {
          final mapped = source.map(
              (row, col, value) => value.x + 10.0 * value.y, DataType.float64);
          expect(mapped.dataType, DataType.float64);
          expect(mapped.rowCount, source.rowCount);
          expect(mapped.columnCount, source.columnCount);
          expect(mapped.storage, [source]);
          for (var r = 0; r < mapped.rowCount; r++) {
            for (var c = 0; c < mapped.columnCount; c++) {
              expect(mapped.get(r, c), r + 10.0 * c);
            }
          }
        });
        test('readonly', () {
          final map = source.map<int>((row, col, value) => row, DataType.int32);
          expect(() => map.setUnchecked(1, 2, 3), throwsUnsupportedError);
        });
        test('mutable', () {
          final source = Matrix.generate(
              DataType.uint8, 8, 8, (row, col) => 32 + 8 * row + col,
              format: format);
          final transform = source.transform(
            (row, col, value) => String.fromCharCode(value),
            write: (row, col, value) => value.codeUnitAt(0),
            dataType: DataType.string,
          );
          expect(transform.dataType, DataType.string);
          expect(transform.rowCount, source.rowCount);
          expect(transform.columnCount, source.columnCount);
          expect(transform.storage, [source]);
          for (var r = 0; r < transform.rowCount; r++) {
            for (var c = 0; c < transform.columnCount; c++) {
              expect(transform.get(r, c), String.fromCharCode(32 + 8 * r + c));
            }
          }
          transform.set(6, 7, '*');
          expect(transform.get(6, 7), '*');
          expect(source.get(6, 7), 42);
        });
        test('copy', () {
          final mapped =
              source.map((row, col, value) => Point(row, col), DataType.object);
          expect(compare(mapped.copy(), mapped), isTrue);
        });
      });
      group('cast', () {
        final source = Matrix.generate(
            DataType.int32, 3, 5, (row, col) => row * col,
            format: format);
        test('to string', () {
          final cast = source.cast(DataType.string);
          expect(cast.dataType, DataType.string);
          expect(cast.rowCount, source.rowCount);
          expect(cast.columnCount, source.columnCount);
          expect(cast.storage, [source]);
          for (var r = 0; r < cast.rowCount; r++) {
            for (var c = 0; c < cast.columnCount; c++) {
              expect(cast.get(r, c), '${r * c}');
            }
          }
        });
        test('copy', () {
          final cast = source.cast(DataType.int32);
          expect(compare(cast.copy(), cast), isTrue);
        });
      });
      test('transposed', () {
        final source = Matrix.generate(
            DataType.string, 7, 6, (row, col) => '($row, $col)',
            format: format);
        final transposed = source.transposed;
        expect(transposed.dataType, source.dataType);
        expect(transposed.rowCount, source.columnCount);
        expect(transposed.columnCount, source.rowCount);
        expect(transposed.storage, [source]);
        expect(transposed.transposed, same(source));
        expect(compare(transposed.copy(), transposed), isTrue);
        for (var r = 0; r < transposed.rowCount; r++) {
          for (var c = 0; c < transposed.columnCount; c++) {
            expect(transposed.get(r, c), '($c, $r)');
            transposed.set(r, c, '${transposed.get(r, c)}*');
          }
        }
        for (var r = 0; r < source.rowCount; r++) {
          for (var c = 0; c < source.columnCount; c++) {
            expect(source.get(r, c), '($r, $c)*');
          }
        }
      });
      test('flippedHorizontal', () {
        final source = Matrix.generate(
            DataType.string, 7, 6, (row, col) => '($row, $col)',
            format: format);
        final flipped = source.flippedHorizontal;
        expect(flipped.dataType, source.dataType);
        expect(flipped.rowCount, source.rowCount);
        expect(flipped.columnCount, source.columnCount);
        expect(flipped.storage, [source]);
        expect(flipped.flippedHorizontal, same(source));
        expect(compare(flipped.copy(), flipped), isTrue);
        for (var r = 0; r < flipped.rowCount; r++) {
          for (var c = 0; c < flipped.columnCount; c++) {
            expect(flipped.get(r, c), '(${source.rowCount - r - 1}, $c)');
            flipped.set(r, c, '${flipped.get(r, c)}*');
          }
        }
        for (var r = 0; r < source.rowCount; r++) {
          for (var c = 0; c < source.columnCount; c++) {
            expect(source.get(r, c), '($r, $c)*');
          }
        }
      });
      test('flippedVertical', () {
        final source = Matrix.generate(
            DataType.string, 7, 6, (row, col) => '($row, $col)',
            format: format);
        final flipped = source.flippedVertical;
        expect(flipped.dataType, source.dataType);
        expect(flipped.rowCount, source.rowCount);
        expect(flipped.columnCount, source.columnCount);
        expect(flipped.storage, [source]);
        expect(flipped.flippedVertical, same(source));
        expect(compare(flipped.copy(), flipped), isTrue);
        for (var r = 0; r < flipped.rowCount; r++) {
          for (var c = 0; c < flipped.columnCount; c++) {
            expect(flipped.get(r, c), '($r, ${source.columnCount - c - 1})');
            flipped.set(r, c, '${flipped.get(r, c)}*');
          }
        }
        for (var r = 0; r < source.rowCount; r++) {
          for (var c = 0; c < source.columnCount; c++) {
            expect(source.get(r, c), '($r, $c)*');
          }
        }
      });
      test('unmodifiable', () {
        final source = Matrix.generate(
            DataType.string, 2, 3, (row, col) => '($row, $col)',
            format: format);
        final readonly = source.unmodifiable;
        expect(readonly.dataType, source.dataType);
        expect(readonly.rowCount, 2);
        expect(readonly.columnCount, 3);
        expect(readonly.storage, [source]);
        expect(compare(readonly.copy(), readonly), isTrue);
        for (var r = 0; r < readonly.rowCount; r++) {
          for (var c = 0; c < readonly.columnCount; c++) {
            expect(readonly.get(r, c), '($r, $c)');
            expect(() => readonly.set(r, c, '${readonly.get(r, c)}*'),
                throwsUnsupportedError);
          }
        }
        for (var r = 0; r < source.rowCount; r++) {
          for (var c = 0; c < source.columnCount; c++) {
            source.set(r, c, '${source.get(r, c)}!');
          }
        }
        for (var r = 0; r < readonly.rowCount; r++) {
          for (var c = 0; c < readonly.columnCount; c++) {
            expect(readonly.get(r, c), '($r, $c)!');
          }
        }
        expect(readonly.unmodifiable, readonly);
      });
    });
    group('iterables', () {
      test('rows', () {
        final source = Matrix.generate(
            DataType.object, 7, 5, (r, c) => Point(r, c),
            format: format);
        var r = 0;
        for (final row in source.rows) {
          expect(row.dataType, source.dataType);
          expect(row.count, source.columnCount);
          expect(row.storage, [source]);
          for (var c = 0; c < source.columnCount; c++) {
            expect(row[c], source.get(r, c));
          }
          r++;
        }
        expect(r, source.rowCount);
      });
      test('columns', () {
        final source = Matrix.generate(
            DataType.object, 5, 8, (r, c) => Point(r, c),
            format: format);
        var c = 0;
        for (final column in source.columns) {
          expect(column.dataType, source.dataType);
          expect(column.count, source.rowCount);
          expect(column.storage, [source]);
          for (var r = 0; r < source.rowCount; r++) {
            expect(column[r], source.get(r, c));
          }
          c++;
        }
        expect(c, source.columnCount);
      });
      test('diagonals', () {
        final source = Matrix.generate(DataType.string, 3, 4, (r, c) => '$r,$c',
            format: format);
        final values = <List<String>>[];
        for (final diagonal in source.diagonals) {
          expect(diagonal.dataType, source.dataType);
          expect(diagonal.storage, [source]);
          values.add(diagonal.iterable.toList());
        }
        expect(values, [
          ['0,3'],
          ['0,2', '1,3'],
          ['0,1', '1,2', '2,3'],
          ['0,0', '1,1', '2,2'],
          ['1,0', '2,1'],
          ['2,0']
        ]);
      });
      group('spiral', () {
        test('3x2', () {
          final source = Matrix.generate(
              DataType.string, 3, 2, (r, c) => '$r,$c',
              format: format);
          expect(source.spiral, ['0,0', '0,1', '1,1', '2,1', '2,0', '1,0']);
        });
        test('2x3', () {
          final source = Matrix.generate(
              DataType.string, 2, 3, (r, c) => '$r,$c',
              format: format);
          expect(source.spiral, ['0,0', '0,1', '0,2', '1,2', '1,1', '1,0']);
        });
      });
      test('rowMajor', () {
        final source = Matrix.generate(DataType.string, 3, 2, (r, c) => '$r,$c',
            format: format);
        expect(source.rowMajor, ['0,0', '0,1', '1,0', '1,1', '2,0', '2,1']);
      });
      test('columnMajor', () {
        final source = Matrix.generate(DataType.string, 3, 2, (r, c) => '$r,$c',
            format: format);
        expect(source.columnMajor, ['0,0', '1,0', '2,0', '0,1', '1,1', '2,1']);
      });
    });
    group('testing', () {
      final random = Random();
      final identity8x9 =
          Matrix.identity(DataType.int32, 8, 9, value: 1, format: format);
      final identity9x8 =
          Matrix.identity(DataType.int32, 9, 8, value: 1, format: format);
      final identity8x8 =
          Matrix.identity(DataType.int32, 8, 8, value: 1, format: format);
      final fullAsymmetric = Matrix.generate(
          DataType.int32, 8, 8, (r, c) => random.nextInt(1000),
          format: format);
      final fullSymmetric = add(fullAsymmetric, fullAsymmetric.transposed);
      final lowerTriangle = Matrix.generate(
          DataType.int32, 8, 8, (r, c) => r >= c ? random.nextInt(1000) : 0,
          format: format);
      final upperTriangle = Matrix.generate(
          DataType.int32, 8, 8, (r, c) => r <= c ? random.nextInt(1000) : 0,
          format: format);
      test('isSquare', () {
        expect(identity8x9.isSquare, isFalse);
        expect(identity9x8.isSquare, isFalse);
        expect(identity8x8.isSquare, isTrue);
        expect(fullAsymmetric.isSquare, isTrue);
        expect(fullSymmetric.isSquare, isTrue);
        expect(lowerTriangle.isSquare, isTrue);
        expect(upperTriangle.isSquare, isTrue);
      });
      test('isSymmetric', () {
        expect(identity8x9.isSymmetric, isFalse);
        expect(identity9x8.isSymmetric, isFalse);
        expect(identity8x8.isSymmetric, isTrue);
        expect(fullAsymmetric.isSymmetric, isFalse);
        expect(fullSymmetric.isSymmetric, isTrue);
        expect(lowerTriangle.isSymmetric, isFalse);
        expect(upperTriangle.isSymmetric, isFalse);
      });
      test('isDiagonal', () {
        expect(identity8x9.isDiagonal, isTrue);
        expect(identity9x8.isDiagonal, isTrue);
        expect(identity8x8.isDiagonal, isTrue);
        expect(fullAsymmetric.isDiagonal, isFalse);
        expect(fullSymmetric.isDiagonal, isFalse);
        expect(lowerTriangle.isDiagonal, isFalse);
        expect(upperTriangle.isDiagonal, isFalse);
      });
      test('isLowerTriangular', () {
        expect(identity8x9.isLowerTriangular, isTrue);
        expect(identity9x8.isLowerTriangular, isTrue);
        expect(identity8x8.isLowerTriangular, isTrue);
        expect(fullAsymmetric.isLowerTriangular, isFalse);
        expect(fullSymmetric.isLowerTriangular, isFalse);
        expect(lowerTriangle.isLowerTriangular, isTrue);
        expect(upperTriangle.isLowerTriangular, isFalse);
      });
      test('isUpperTriangular', () {
        expect(identity8x9.isUpperTriangular, isTrue);
        expect(identity9x8.isUpperTriangular, isTrue);
        expect(identity8x8.isUpperTriangular, isTrue);
        expect(fullAsymmetric.isUpperTriangular, isFalse);
        expect(fullSymmetric.isUpperTriangular, isFalse);
        expect(lowerTriangle.isUpperTriangular, isFalse);
        expect(upperTriangle.isUpperTriangular, isTrue);
      });
    });
    group('operators', () {
      final random = Random();
      final sourceA = Matrix.generate(
          DataType.int32, 5, 4, (row, col) => random.nextInt(100),
          format: format);
      final sourceB = Matrix.generate(
          DataType.int32, 5, 4, (row, col) => random.nextInt(100),
          format: format);
      test('unary', () {
        final result = unaryOperator(sourceA, (a) => a * a);
        expect(result.dataType, sourceA.dataType);
        expect(result.rowCount, sourceA.rowCount);
        expect(result.columnCount, sourceA.columnCount);
        for (var r = 0; r < result.rowCount; r++) {
          for (var c = 0; c < result.columnCount; c++) {
            final a = sourceA.get(r, c);
            expect(result.get(r, c), a * a);
          }
        }
      });
      test('binary', () {
        final result =
            binaryOperator(sourceA, sourceB, (a, b) => a * a + b * b);
        expect(result.dataType, sourceA.dataType);
        expect(result.rowCount, sourceA.rowCount);
        expect(result.columnCount, sourceA.columnCount);
        for (var r = 0; r < result.rowCount; r++) {
          for (var c = 0; c < result.columnCount; c++) {
            final a = sourceA.get(r, c);
            final b = sourceB.get(r, c);
            expect(result.get(r, c), a * a + b * b);
          }
        }
      });
      group('add', () {
        test('default', () {
          final result = add(sourceA, sourceB);
          expect(result.dataType, sourceA.dataType);
          expect(result.rowCount, sourceA.rowCount);
          expect(result.columnCount, sourceA.columnCount);
          for (var r = 0; r < result.rowCount; r++) {
            for (var c = 0; c < result.columnCount; c++) {
              expect(result.get(r, c), sourceA.get(r, c) + sourceB.get(r, c));
            }
          }
        });
        test('default, bad count', () {
          final sourceB = Matrix(
              DataType.uint32, sourceA.columnCount, sourceA.rowCount,
              format: format);
          expect(() => add(sourceA, sourceB), throwsArgumentError);
        });
        test('target', () {
          final target = Matrix(
              DataType.uint32, sourceA.rowCount, sourceA.columnCount,
              format: format);
          final result = add(sourceA, sourceB, target: target);
          expect(result.dataType, DataType.uint32);
          expect(result.rowCount, sourceA.rowCount);
          expect(result.columnCount, sourceA.columnCount);
          for (var r = 0; r < result.rowCount; r++) {
            for (var c = 0; c < result.columnCount; c++) {
              expect(result.get(r, c), sourceA.get(r, c) + sourceB.get(r, c));
            }
          }
          expect(result, target);
        });
        test('target, bad count', () {
          final target = Matrix(
              DataType.uint32, sourceA.columnCount, sourceA.rowCount,
              format: format);
          expect(
              () => add(sourceA, sourceB, target: target), throwsArgumentError);
        });
        test('builder', () {
          final result =
              add(sourceA, sourceB, dataType: DataType.uint32, format: format);
          expect(result.dataType, DataType.uint32);
          expect(result.rowCount, sourceA.rowCount);
          expect(result.columnCount, sourceA.columnCount);
          for (var r = 0; r < result.rowCount; r++) {
            for (var c = 0; c < result.columnCount; c++) {
              expect(result.get(r, c), sourceA.get(r, c) + sourceB.get(r, c));
            }
          }
        });
      });
      test('sub', () {
        final target = sub(sourceA, sourceB);
        expect(target.dataType, sourceA.dataType);
        expect(target.rowCount, sourceA.rowCount);
        expect(target.columnCount, sourceA.columnCount);
        for (var r = 0; r < target.rowCount; r++) {
          for (var c = 0; c < target.columnCount; c++) {
            expect(target.get(r, c), sourceA.get(r, c) - sourceB.get(r, c));
          }
        }
      });
      test('neg', () {
        final target = neg(sourceA);
        expect(target.dataType, sourceA.dataType);
        expect(target.rowCount, sourceA.rowCount);
        expect(target.columnCount, sourceA.columnCount);
        for (var r = 0; r < target.rowCount; r++) {
          for (var c = 0; c < target.columnCount; c++) {
            expect(target.get(r, c), -sourceA.get(r, c));
          }
        }
      });
      test('scale', () {
        final target = scale(sourceA, 2);
        expect(target.dataType, sourceA.dataType);
        expect(target.rowCount, sourceA.rowCount);
        expect(target.columnCount, sourceA.columnCount);
        for (var r = 0; r < target.rowCount; r++) {
          for (var c = 0; c < target.columnCount; c++) {
            expect(target.get(r, c), 2 * sourceA.get(r, c));
          }
        }
      });
      group('compare', () {
        test('identity', () {
          expect(compare(sourceA, sourceA), isTrue);
          expect(compare(sourceB, sourceB), isTrue);
          expect(compare(sourceA, sourceB), isFalse);
          expect(compare(sourceB, sourceA), isFalse);
        });
        test('views', () {
          expect(compare(sourceA.rowRange(0, 3), sourceA.rowIndex([0, 1, 2])),
              isTrue);
          expect(compare(sourceA.colRange(0, 3), sourceA.colIndex([0, 1, 2])),
              isTrue);
          expect(compare(sourceA.rowRange(0, 3), sourceA.rowIndex([3, 1, 0])),
              isFalse,
              reason: 'row order missmatch');
          expect(compare(sourceA.colRange(0, 3), sourceA.colIndex([2, 1, 0])),
              isFalse,
              reason: 'col order missmatch');
          expect(compare(sourceA.rowRange(0, 3), sourceA.rowIndex([0, 1])),
              isFalse,
              reason: 'row count missmatch');
          expect(compare(sourceA.colRange(0, 3), sourceA.colIndex([0, 1])),
              isFalse,
              reason: 'col count missmatch');
        });
        test('custom', () {
          final negated = neg(sourceA);
          expect(compare(sourceA, negated), isFalse);
          expect(compare<int>(sourceA, negated, equals: (a, b) => a == -b),
              isTrue);
        });
      });
      group('lerp', () {
        final v0 = Matrix.fromRows(
            DataType.float32,
            [
              [1.0, 6.0],
              [9.0, 9.0],
            ],
            format: format);
        final v1 = Matrix.fromRows(
            DataType.float32,
            [
              [9.0, -2.0],
              [9.0, -9.0],
            ],
            format: format);
        test('at start', () {
          final v = lerp(v0, v1, 0.0);
          expect(v.dataType, v0.dataType);
          expect(v.rowCount, v0.rowCount);
          expect(v.columnCount, v0.columnCount);
          expect(v.get(0, 0), 1.0);
          expect(v.get(0, 1), 6.0);
          expect(v.get(1, 0), 9.0);
          expect(v.get(1, 1), 9.0);
        });
        test('at middle', () {
          final v = lerp(v0, v1, 0.5);
          expect(v.dataType, v0.dataType);
          expect(v.rowCount, v0.rowCount);
          expect(v.columnCount, v0.columnCount);
          expect(v.get(0, 0), 5.0);
          expect(v.get(0, 1), 2.0);
          expect(v.get(1, 0), 9.0);
          expect(v.get(1, 1), 0.0);
        });
        test('at end', () {
          final v = lerp(v0, v1, 1.0);
          expect(v.dataType, v0.dataType);
          expect(v.rowCount, v0.rowCount);
          expect(v.columnCount, v0.columnCount);
          expect(v.get(0, 0), 9.0);
          expect(v.get(0, 1), -2.0);
          expect(v.get(1, 0), 9.0);
          expect(v.get(1, 1), -9.0);
        });
        test('at outside', () {
          final v = lerp(v0, v1, 2.0);
          expect(v.dataType, v0.dataType);
          expect(v.rowCount, v0.rowCount);
          expect(v.columnCount, v0.columnCount);
          expect(v.get(0, 0), 17.0);
          expect(v.get(0, 1), -10.0);
          expect(v.get(1, 0), 9.0);
          expect(v.get(1, 1), -27.0);
        });
        test('error', () {
          final other = Matrix(DataType.int8, 2, 3, format: format);
          expect(() => lerp(v0, other, 2.0), throwsArgumentError);
        });
      });
      group('mul', () {
        final sourceA = Matrix.generate(
            DataType.int32, 13, 42, (row, col) => random.nextInt(100),
            format: format);
        final sourceB = Matrix.generate(
            DataType.int32, 42, 27, (row, col) => random.nextInt(100),
            format: format);
        test('default', () {
          final target = mul(sourceA, sourceB);
          expect(target.dataType, DataType.int32);
          expect(target.rowCount, sourceA.rowCount);
          expect(target.columnCount, sourceB.columnCount);
          for (var r = 0; r < target.rowCount; r++) {
            for (var c = 0; c < target.columnCount; c++) {
              final value = sourceA.row(r).dot(sourceB.column(c));
              expect(target.get(r, c), value);
            }
          }
        });
        test('error in-place', () {
          final derivedA = sourceA.range(0, 8, 0, 8);
          final derivedB = sourceB.range(0, 8, 0, 8);
          expect(() => mul(derivedA, derivedB, target: derivedA),
              throwsArgumentError);
          expect(() => mul(derivedA, derivedB, target: derivedB),
              throwsArgumentError);
          expect(() => mul(derivedA.transposed, derivedB, target: derivedA),
              throwsArgumentError);
          expect(() => mul(derivedA, derivedB.transposed, target: derivedB),
              throwsArgumentError);
          expect(() => mul(derivedA, derivedB, target: derivedA.transposed),
              throwsArgumentError);
          expect(() => mul(derivedA, derivedB, target: derivedB.transposed),
              throwsArgumentError);
        });
        test('error dimensions', () {
          expect(() => mul(sourceA, sourceA), throwsArgumentError);
          expect(() => mul(sourceB, sourceB), throwsArgumentError);
          expect(() => mul(sourceB, sourceA), throwsArgumentError);
        });
      });
    });
    group('decomposition', () {
      // Comparator for floating point numbers:
      final epsilon = pow(2.0, -32.0);
      void expectMatrix(Matrix<num> expected, Matrix<num> actual) => expect(
            compare<num>(actual, expected,
                equals: (a, b) => (a - b).abs() <= epsilon),
            isTrue,
            reason: 'Expected $expected, but got $actual.',
          );
      // Example matrices:
      final matrix3 = Matrix.fromRows(
          DataType.float64,
          [
            [1.0, 4.0, 7.0, 10.0],
            [2.0, 5.0, 8.0, 11.0],
            [3.0, 6.0, 9.0, 12.0],
          ],
          format: format);
      final matrix4 = Matrix.fromRows(
          DataType.float64,
          [
            [1.0, 5.0, 9.0],
            [2.0, 6.0, 10.0],
            [3.0, 7.0, 11.0],
            [4.0, 8.0, 12.0],
          ],
          format: format);
      test('norm1', () {
        final result = matrix3.norm1;
        expect(result, closeTo(33.0, epsilon));
      });
      test('normInf', () {
        final result = matrix3.normInfinity;
        expect(result, closeTo(30.0, epsilon));
      });
      test('normFrobenius', () {
        final result = matrix3.normFrobenius;
        expect(result, closeTo(sqrt(650), epsilon));
      });
      test('trace', () {
        final result = matrix3.trace;
        expect(result, closeTo(15.0, epsilon));
      });
      test('det', () {
        final result =
            matrix3.range(0, matrix3.rowCount, 0, matrix3.rowCount).det;
        expect(result, closeTo(0.0, epsilon));
      });
      test('QR Decomposition', () {
        final decomp = matrix4.qr;
        final result = mul(decomp.orthogonal, decomp.upper);
        expectMatrix(matrix4, result);
      });
      test('Singular Value Decomposition', () {
        final decomp = matrix4.singularValue;
        final result = mul(decomp.U, mul(decomp.S, decomp.V.transposed));
        expectMatrix(matrix4, result);
      });
      test('LU Decomposition', () {
        final matrix = matrix4.range(
            0, matrix4.columnCount - 1, 0, matrix4.columnCount - 1);
        final decomp = matrix.lu;
        final result1 = matrix.rowIndex(decomp.pivot);
        final result2 = mul(decomp.lower, decomp.upper);
        expectMatrix(result1, result2);
      });
      test('rank', () {
        final result = matrix3.rank;
        expect(result, min(matrix3.rowCount, matrix3.columnCount) - 1);
      });
      test('cond', () {
        final matrix = Matrix.fromRows(
            DataType.float64,
            [
              [1.0, 3.0],
              [7.0, 9.0],
            ],
            format: format);
        final decomp = matrix.singularValue;
        final singularValues = decomp.s;
        expect(
            matrix.cond,
            singularValues[0] /
                singularValues[min(matrix.rowCount, matrix.columnCount) - 1]);
      });
      test('inverse', () {
        final matrix = Matrix.fromRows(
            DataType.float64,
            [
              [0.0, 5.0, 9.0],
              [2.0, 6.0, 10.0],
              [3.0, 7.0, 11.0],
            ],
            format: format);
        final actual = mul(matrix, matrix.inverse);
        final expected = Matrix.identity(
            DataType.float64, matrix.rowCount, matrix.columnCount);
        expectMatrix(expected, actual);
      });
      test('solve', () {
        final first = Matrix<double>.fromRows(
            DataType.float64,
            [
              [5, 8],
              [6, 9],
            ],
            format: format);
        final second = Matrix<double>.fromRows(
            DataType.float64,
            [
              [13],
              [15],
            ],
            format: format);
        final actual = first.solve(second);
        final expected = Matrix<double>.constant(
            DataType.float64, second.rowCount, second.columnCount,
            value: 1);
        expectMatrix(expected, actual);
      });
      group('choleski', () {
        final matrix = Matrix<double>.fromRows(
            DataType.float64,
            [
              [4, 1, 1],
              [1, 2, 3],
              [1, 3, 6],
            ],
            format: format);
        final decomposition = matrix.cholesky;
        test('triangular factor', () {
          final triangularFactor = decomposition.L;
          expectMatrix(
              matrix, mul(triangularFactor, triangularFactor.transposed));
        });
        test('solve', () {
          final identity = Matrix<double>.identity(DataType.float64, 3, 3,
              value: 1, format: format);
          final solution = decomposition.solve(identity);
          expectMatrix(identity, mul(matrix, solution));
        });
      });
      group('eigen', () {
        test('symmetric', () {
          final a = Matrix.fromRows(
              DataType.float64,
              [
                [4.0, 1.0, 1.0],
                [1.0, 2.0, 3.0],
                [1.0, 3.0, 6.0],
              ],
              format: format);
          final decomposition = a.eigenvalue;
          final d = decomposition.D;
          final v = decomposition.V;
          expectMatrix(mul(a, v), mul(v, d));
        });
        test('non-symmetric', () {
          final a = Matrix.fromRows(
              DataType.float64,
              [
                [0.0, 1.0, 0.0, 0.0],
                [1.0, 0.0, 2.0e-7, 0.0],
                [0.0, -2.0e-7, 0.0, 1.0],
                [0.0, 0.0, 1.0, 0.0],
              ],
              format: format);
          final decomposition = a.eigenvalue;
          final d = decomposition.D;
          final v = decomposition.V;
          expectMatrix(mul(a, v), mul(v, d));
        });
        test('bad', () {
          final a = Matrix.fromRows(
              DataType.float64,
              [
                [0.0, 0.0, 0.0, 0.0, 0.0],
                [0.0, 0.0, 0.0, 0.0, 1.0],
                [0.0, 0.0, 0.0, 1.0, 0.0],
                [1.0, 1.0, 0.0, 0.0, 1.0],
                [1.0, 0.0, 1.0, 0.0, 1.0],
              ],
              format: format);
          final decomposition = a.eigenvalue;
          final d = decomposition.D;
          final v = decomposition.V;
          expectMatrix(mul(a, v), mul(v, d));
        });
      });
    });
  });
}

void main() {
  matrixTest('rowMajor', MatrixFormat.rowMajor);
  matrixTest('columnMajor', MatrixFormat.columnMajor);
  matrixTest('compressedRow', MatrixFormat.compressedRow);
  matrixTest('compressedColumn', MatrixFormat.compressedColumn);
  matrixTest('coordinateList', MatrixFormat.coordinateList);
  matrixTest('keyed', MatrixFormat.keyed);
  matrixTest('diagonal', MatrixFormat.diagonal);
}
