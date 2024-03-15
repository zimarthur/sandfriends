@echo off

CALL flutter build appbundle --release --flavor prod -t "lib/Sandfriends/main_prod.dart"

CALL flutter build appbundle --release --flavor dev -t "lib/Sandfriends/main_dev.dart"

CALL flutter build appbundle --release --flavor demo -t "lib/Sandfriends/main_demo.dart"
