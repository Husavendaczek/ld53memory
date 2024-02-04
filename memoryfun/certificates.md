# App Zertifikate

## **iOS - Apple Certificates**

Apple Certificates werden benötigt, um eine App auf einem iOS Gerät zu bauen und die App im App Store zu veröffentlichen.

**Eine App hat einen Identifier. Ein Zertifikat kann für mehrere Apps verwendet werden. Ein Provisioning Profile setzt sich aus Identifier und Zertifikat zusammen.**

Login unter https://developer.apple.com mit dem Developer Account.

**Zertifikat abgelaufen? → neues Zertifikat erstellen + Provisioning Profile bearbeiten und das neue Zertifikat auswählen + Provisioning Profile und Zertifikat in Pipeline neu hochladen**

**Identifier erstellen**

- Auf https://developer.apple.com/account/resources/identifiers/list einen Identifier hinzufügen (+ Symbol)
- 'App Ids' wählen
- 'App' wählen
- Bundle Identifier eintragen und 'explicit' wählen. Optional kann eine Beschreibung hinzugefügt werden.
- Create
- Register

**Certificate erstellen**

- Auf https://developer.apple.com/account/resources/certificates/list ein Certificate hinzufügen (+ Symbol)
- 'iOS Distribution (App Store and Ad Hoc)' wählen
- Um eine Certificate Signing Request zu erstellen, den Schritten auf [https://developer.apple.com/help/account/create-certificates/create-a-certificate-signing-request](https://developer.apple.com/help/account/create-certificates/create-a-certificate-signing-request) folgen
- Die erstellte Request hochladen
- Distribution Certificate herunterladen
- Distribution Certificate in der lokalen Keychain importieren und danach als .p12 Datei exportieren. Das benötigte Distribution Certificate wird am einfachsten durch das Ablaufdatum gefunden.

> **Hinweis: Falls p12 nicht auswählbar ist:** Schlüsselbundverwaltung -> Anmeldung -> Meine Zertifikate -> gesuchtes Zertifikat ausklappen + Rechtsklick
> 

**Provisioning Profile erstellen**

- Auf https://developer.apple.com/account/resources/profiles/list ein Profile hinzufügen (+ Symbol)
- 'App Store' wählen
- Eben erstellten Bundle Identifier wählen
- Certificate wählen (Ablaufdatum vergleichen)
- Ein oder mehrere Geräte auswählen und entitlements auf default setzen
- Name eingeben
- Provisioning Profile herunterladen
- Profil via Doppel-Klick importieren

**XCode Einstellungen**

- Projekt **Target** "Runner" auswählen
- Build Settings -> Signing -> Code Signing Identity
    - Debug: Apple Development
    - Profile: Apple Development
    - Release: Name des Certificates wählen
        - Signing Capabilitys
    - Debug und Profile: automatic
    - Release: manual

## **Android - KeyStore**

- Mit Hilfe des KeyStore Explorers eine .p12 Datei erstellen.
    - Download unter https://keystore-explorer.org/
        - Neues Keystore erstellen, Typ auf "PKCS #12" festlegen
        - Neues Schlüsselpaar erstellen
        - RSA mit 4096 bit
        - Version: Version 3
        - Signaturalgorithmus: SHA-512 mit RSA
        - Gültigkeitsdauers: min 25 Jahre > Anwenden
        - Name: Auf das Buch-Icon klicken
        - CN: **Bundle-Identifier der App**
        - OU: **Optional, Name des Teams**
        - O: **Optional, Name der Firma**
        - L: **Optional, Name der Stadt**
        - ST: **Optional, Name des Bundeslandes**
        - C: **Optional, Name des Landes (DE)**
    - OK > Alias Name so lassen > OK
    - Passwort festlegen
        - Speichern
    - Hier am besten das gleiche Passwort wie für das Schlüsselpaar verwenden
    - Als `.p12` Datei speichern
    - Um den Keystore zum Signieren zu verwenden, muss die App im Release-Modus gebaut werden. Außerdem müssen vorher folgende Umgebungsvariablen gesetzt werden, damit der Android-Build den korrekten store verwendet:

```dart
export keystoreFilePath=/path/to/keystore.p12
export keystorePassword=****

flutter build ... //für flutter apps
```