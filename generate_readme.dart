import 'dart:io';

const warning = '''
<!--                  DO NOT EDIT                        -->
<!-- This file is auto-generated from README.template.md -->
''';

Future<void> main() async {
  final template = File('README.template.md');
  final readme = File('README.md');
  final lines = await template.readAsLines();

  final readmeWriter = readme.openWrite();
  try {
    readmeWriter.write(warning);
    for (final line in lines) {
      if (line.trimLeft().startsWith('--')) continue;
      readmeWriter.writeln(await _replaceVariables(line));
    }
  } finally {
    await readmeWriter.flush();
    await readmeWriter.close();
  }
}

Future<String> _replaceVariables(String line) async {
  if (line == '{{ EXAMPLES }}') {
    final exampleFile = File('example/conveniently_example.dart');
    return await exampleFile.readAsString();
  }
  return line;
}
