# memoryfun

## How to add a new theme
* Add theme name to theme_set.dart
* Add level to levels.dart
* Add folder to assets with theme name
* Add image ${themeName}_x.png where x is a number starting with 0
* Add image ${themeName}_background.png
* Add image ${themeName}_thumbnail.png
optional:
* Add a song to sounds
* Add switch case for theme to sound_player.dart

## Make a release
* Android: `flutter build apk` or `flutter build appbundle`
* iOS: Run `flutter build ipa` -> result is in `build/ios/archive/`.
 Then open build/ios/archive/MyApp.xcarchive in Xcode or open project in Xcode go to Product -> Archive. 
 Validate the app and distribute it.

TODOS
 - add privacy url
 - add refs for image generation
   - Image Creator https://www.bing.com/images/create/
   - https://api.aime.info/
   - Check for color blind people https://www.color-blindness.com/
 - flips twice on first tap
 - two players
    - on one phone
    - play against ki
 - more themes
 - set volume of music
 - simplify GameMovesNumbers and GameMovesTexts
 - why is the wrong match animated with a shimmer?
 - is there a way to shuffle between two different types in one area? (no need to seperate locally?)
 - more images:
   - Haustiere (Hasen, Katze, Hund, Fisch, Schildkröte, Schlange, Hamster, Chamäleon)
   - Blätter von Bäumen (Ahorn, Eiche, Buche, Linde)
   - Planeten (Saturn, Jupiter, Mars)
   - Blumen (Tulpen, Osterglocken, Schneeglöckchen)
- navigate back to group of last played memory
 - compare folders mono and color
   - babiesComplex -> change for mono
   - farm -> remove for both
   - farmComplex -> remove for both
   - farmMud -> change for mono
   - more images for mail
   - ignore only colors in mono mode