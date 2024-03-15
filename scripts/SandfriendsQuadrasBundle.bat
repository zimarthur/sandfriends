@echo off
CALL flutter build appbundle --release --flavor quadrasProd -t "lib/SandfriendsQuadras/main_prod.dart"

CALL flutter build appbundle --release --flavor quadrasDev -t "lib/SandfriendsQuadras/main_dev.dart"

CALL flutter build appbundle --release --flavor quadrasDemo -t "lib/SandfriendsQuadras/main_demo.dart"
