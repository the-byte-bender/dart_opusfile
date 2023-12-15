import "dart:ffi";
import "dart:typed_data";
import "package:ffi/ffi.dart";
import "./opusfile_generated_bindings.dart";

class OpusFile {
  static const int bytesPerSample = 2;
  final OpusfileBindings _bindings;
  late final Pointer<OggOpusFile> _ofPointer;
  late final int channels;
  final int rate = 48000;
  late final Uint8List data;

  OpusFile(this._bindings, String path) {
    Pointer<Utf8> cPath = path.toNativeUtf8();
    _ofPointer = _bindings.op_open_file(cPath.cast<Char>(), nullptr);
    calloc.free(cPath);
    if (_ofPointer == nullptr) {
      throw ArgumentError("$path could not be opened.");
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
