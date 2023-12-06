@echo off

CALL flutter build appbundle --release --flavor prod -t "lib/main_prod.dart"

CALL flutter build appbundle --release --flavor dev -t "lib/main_dev.dart"

CALL flutter build appbundle --release --flavor demo -t "lib/main_demo.dart"
