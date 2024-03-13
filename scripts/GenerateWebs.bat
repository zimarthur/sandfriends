@echo off

CALL flutter build web --web-renderer html --target "lib/SandfriendsWebPage/main_dev.dart" -o "build/sandfriends_webapp_dev"

CALL flutter build web --web-renderer html --target "lib/SandfriendsWebPage/main_demo.dart" -o "build/sandfriends_webapp_demo"

CALL flutter build web --web-renderer html --target "lib/SandfriendsWebPage/main_prod.dart" -o "build/sandfriends_webapp_prod"


CALL flutter build web --web-renderer html --target "lib/SandfriendsQuadras/main_dev.dart" -o "build/sandfriends_quadras_dev"

CALL flutter build web --web-renderer html --target "lib/SandfriendsQuadras/main_demo.dart" -o "build/sandfriends_quadras_demo"

CALL flutter build web --web-renderer html --target "lib/SandfriendsQuadras/main_prod.dart" -o "build/sandfriends_quadras_prod"


powershell -Command "Compress-Archive -Path '%~dp0..\build\sandfriends_quadras_prod' -DestinationPath '%~dp0..\build\sandfriends_quadras_prod.zip'"

powershell -Command "Compress-Archive -Path '%~dp0..\build\sandfriends_webapp_prod' -DestinationPath '%~dp0..\build\sandfriends_webapp_prod.zip'"

powershell -Command "Compress-Archive -Path '%~dp0..\build\sandfriends_quadras_demo' -DestinationPath '%~dp0..\build\sandfriends_quadras_demo.zip'"

powershell -Command "Compress-Archive -Path '%~dp0..\build\sandfriends_webapp_demo' -DestinationPath '%~dp0..\build\sandfriends_webapp_demo.zip'"

powershell -Command "Compress-Archive -Path '%~dp0..\build\sandfriends_quadras_dev' -DestinationPath '%~dp0..\build\sandfriends_quadras_dev.zip'"

powershell -Command "Compress-Archive -Path '%~dp0..\build\sandfriends_webapp_dev' -DestinationPath '%~dp0..\build\sandfriends_webapp_dev.zip'"
