import "dart:ffi";
import "dart:typed_data";
import "package:ffi/ffi.dart";
import "./opusfile_generated_bindings.dart";

/// Represents the result of decoding the opus data from memory, as well as the raw pcm data.
class OpusMemoryFile {
  final OpusfileBindings _bindings;
  late final Pointer<OggOpusFile> _ofPointer;

  /// The number of channels: mono, stereo, etc.
  late final int channels;

  /// The sampling rate. Always 48000, as this is how opus works.
  final int rate = 48000;

  /// The decoded pcm data.
  late final Uint8List data;
  late final Uint8List _cData;

  /// @nodoc
  OpusMemoryFile(this._bindings, List<int> data) {
    Pointer<Uint8> cData = calloc<Uint8>(data.length);
    _cData = cData.asTypedList(data.length, finalizer: calloc.nativeFree);
    _cData.setAll(0, data);
    _ofPointer = _bindings.op_open_memory(
        cData.cast<UnsignedChar>(), data.length, nullptr);
    if (_ofPointer == nullptr) {
      throw ArgumentError("data cannot be parsed.");
    }
    channels = _bindings.op_channel_count(_ofPointer, -1);
    int pcmLength = _bindings.op_pcm_total(_ofPointer, -1);
    Pointer<Int16> cBuffer = calloc<Int16>(pcmLength * channels);
    int index = 0;
    try {
      while (true) {
        int samplesRead = _bindings.op_read(_ofPointer,
            cBuffer.elementAt(index).cast<Int>(), pcmLength - index, nullptr);
        if (samplesRead < 0) {
          throw StateError("Error while decoding file");
        }
        index += samplesRead * channels;
        if (samplesRead == 0) {
          break;
        }
      }
      data = cBuffer
          .asTypedList(pcmLength * channels, finalizer: calloc.nativeFree)
          .buffer
          .asUint8List();
    } finally {
      _bindings.op_free(_ofPointer);
    }
  }
}
