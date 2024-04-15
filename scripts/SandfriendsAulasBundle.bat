@echo off
CALL flutter build appbundle --release --flavor aulasProd -t "lib/SandfriendsAulas/main_prod.dart"

CALL flutter build appbundle --release --flavor aulasDev -t "lib/SandfriendsAulas/main_dev.dart"

CALL flutter build appbundle --release --flavor aulasDemo -t "lib/SandfriendsAulas/main_demo.dart"
