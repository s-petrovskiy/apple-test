# apple-test

## before project build:

install SDL2:
1. curl -O https://www.libsdl.org/release/SDL2-2.0.16.dmg
2. hdiutil attach SDL2-2.0.16.dmg
3. sudo cp -RP /Volumes/SDL2/SDL2.framework /Library/Frameworks/SDL2.framework

## build project:
Just open existing xcode project and click run. Application may ask for user's Documents folder access.

## test application controls:
F  -- toggle fullscreen
P -- launch video player
Q -- quit app
