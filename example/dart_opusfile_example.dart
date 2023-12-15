import "dart:io";
import 'package:dart_opusfile/dart_opusfile.dart';

void main() {
  final Opus opus = Opus("opusfile.dll");
  final OpusFile a = opus.decodeFile("test.opus");
  print(a.channels);
  print(a.rate);
  print(a.data.length);
  File("./test.pcm").writeAsBytesSync(a.data);
  print("Done");
}
