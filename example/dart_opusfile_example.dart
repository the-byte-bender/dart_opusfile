import "dart:io";
import 'package:dart_opusfile/dart_opusfile.dart';

void main() {
  /// Initialize the bindings.
  final Opus opus = Opus("opusfile.dll");

  /// Decode a file.
  final OpusFile decodedFile = opus.decodeFile("test.opus");
  print(decodedFile.channels);
  print(decodedFile.rate);
  print(decodedFile.data.length);
  File("./test.pcm").writeAsBytesSync(decodedFile.data);
  print("Done");
}
