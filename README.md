# apple-test

## before project build:

install SDL2:

1. **curl -O https://www.libsdl.org/release/SDL2-2.0.16.dmg**
2. **hdiutil attach SDL2-2.0.16.dmg** _(check device name to detach it later. For example ***/dev/disk2s1*** Apple_HFS /Volumes/SDL2)_
3. **sudo cp -RP /Volumes/SDL2/SDL2.framework /Library/Frameworks/SDL2.framework**
4. **hdiutil detach** _(apend device name from p. 2, ex. hdiutil detach /dev/disk2s1)_
5. **rm -r SDL2-2.0.16.dmg**

## build project:
Just open apple-test.xcodeproj project and click run. Application may ask for user's Documents folder access.

## test application controls:
F  -- toggle fullscreen
P -- launch video player
Q -- quit app
