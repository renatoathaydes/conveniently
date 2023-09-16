.PHONY: all
all:
	echo "Format..."
	dart format .
	echo "Analyze..."
	dart analyze
	echo "Test..."
	dart test
	echo "Generate README.md ..."
	dart generate_readme.dart
	echo "Done"
