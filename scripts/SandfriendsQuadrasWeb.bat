@echo off

CALL flutter build web --web-renderer html --target "lib/SandfriendsQuadras/main_dev.dart" -o "build/sandfriends_quadras_dev"

CALL flutter build web --web-renderer html --target "lib/SandfriendsQuadras/main_demo.dart" -o "build/sandfriends_quadras_demo"

CALL flutter build web --web-renderer html --target "lib/SandfriendsQuadras/main_prod.dart" -o "build/sandfriends_quadras_prod"