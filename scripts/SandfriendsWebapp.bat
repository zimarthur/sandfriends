@echo off

CALL flutter build web --web-renderer html --target "lib/SandfriendsWebPage/main_dev.dart" -o "build/sandfriends_webapp_dev"

CALL flutter build web --web-renderer html --target "lib/SandfriendsWebPage/main_demo.dart" -o "build/sandfriends_webapp_demo"

CALL flutter build web --web-renderer html --target "lib/SandfriendsWebPage/main_prod.dart" -o "build/sandfriends_webapp_prod"