import 'dart:convert';
import 'dart:typed_data';

const hexEncoder = HexEncoder._();

class HexEncoder extends Converter<List<int>, String> {
  const HexEncoder._();

  @override
  String convert(List<int> input) => _convert(input, 0, input.length);

  @override
  ByteConversionSink startChunkedConversion(Sink<String> sink) =>
      _HexEncoderSink(sink);
}

/// A conversion sink for chunked hexadecimal encoding.
class _HexEncoderSink extends ByteConversionSinkBase {
  final Sink<String> _sink;

  _HexEncoderSink(this._sink);

  @override
  void add(List<int> chunk) {
    _sink.add(_convert(chunk, 0, chunk.length));
  }

  @override
  void addSlice(List<int> chunk, int start, int end, bool isLast) {
    RangeError.checkValidRange(start, end, chunk.length);
    _sink.add(_convert(chunk, start, end));
    if (isLast) _sink.close();
  }

  @override
  void close() {
    _sink.close();
  }
}

String _convert(List<int> bytes, int start, int end) {
  var buffer = Uint8List((end - start) * 2);
  var bufferIndex = 0;
  var byteOr = 0;

  for (var i = start; i < end; i++) {
    var byte = bytes[i];
    byteOr |= byte;

    // The bitwise arithmetic here is equivalent to `byte ~/ 16` and `byte % 16`
    // for valid byte values, but is easier for dart2js to optimize given that
    // it can't prove that [byte] will always be positive.
    buffer[bufferIndex++] = _codeUnitForDigit((byte & 0xF0) >> 4);
    buffer[bufferIndex++] = _codeUnitForDigit(byte & 0x0F);
  }

  if (byteOr >= 0 && byteOr <= 255) return String.fromCharCodes(buffer);

  // If there was an invalid byte, find it and throw an exception.
  for (var i = start; i < end; i++) {
    int byte = bytes[i];
    if (byte >= 0 && byte <= 0xff) continue;
    throw FormatException(
        "Invalid byte ${byte < 0 ? "-" : ""}0x${byte.abs().toRadixString(16)}.",
        bytes,
        i);
  }

  throw StateError('unreachable');
}

/// Returns the ASCII/Unicode code unit corresponding to the hexadecimal digit
int _codeUnitForDigit(int digit) => digit < 10 ? digit + $0 : digit + $a - 10;

/// Character `0`.
const int $0 = 0x30;

/// Character `a`.
const int $a = 0x61;
