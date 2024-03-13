@echo off
CALL flutter build appbundle --release --flavor prod -t "lib/main_prod_mobile.dart"

CALL flutter build appbundle --release --flavor dev -t "lib/main_dev_mobile.dart"

CALL flutter build appbundle --release --flavor demo -t "lib/main_demo_mobile.dart"
