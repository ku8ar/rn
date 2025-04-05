## omowienie
pros:
- aplikacja RN jest całkowicie niezalezna pod wzgledem implementacji, zainstalowanych modulow itd
- brak konfliktow zaleznosci z aplikacja iOS
- szybszy czas kompilacji aplikacji iOS
- prawidlowa separacja ownership (niezalezne projekty)

cons:
- niektóre biblioteki RN mogą nie działać bez dodatkowych zmian w build-bridge.sh
Sa biblioteki (np. do trackingu), ktore kompiluja dodatkowe frameworki, ktore bedzie trzeba kompilowac manualnie
- niektore biblioteki RN moga dzialac niepoprawnie
Przyklad to react-native-reanimated, ktore na szczescie da sie latwo spatchowac
- dodanie wielu aplikacji RN do jednego projektu iOS będzie skutkować gigantycznym bundle size.
Da się rozwiązać to ograniczenie, wydzielając z archiwum binary file Hermesa (stanowi on większą część ipa),
ale to spowoduje inny problem: kazda aplikacja RN zaimportowana w projekcie hosta bedzie musiala byc zbudowana
przy pomocy tej samej wersji RN.

## Konfiguracja projektu w Xcode
- dodaj nowy target Framework i nazwij go np. "Bridge"
(nazwa "Bridge" jest uzywana takze w pliku podspec i build-bridge.sh wiec jezeli wybierzesz inna, to zmien ja takze tam)
- wejdz do Build Phases -> target "Bridge" i usun faze "[CP] Copy Pods Resources"
(budowany framework w przeciwienstwie do aplikacji nie moze edytowac bezposrednio katalogu "Target Support Files" z powodu SiP)
- dodaj pliki Bridge.h, BridgeWrapperViewController.h, BridgeWrapperViewController.m, RNBridgeViewController.swift do targetu "Bridge".
W przypadku headerow ustaw dodatkowo "Header Visibility = Public)
(pliki dodajemy bezposrednio przez XCode, by zaktualizowac poprawnie pbxproj)

## Konfiguracja kodu zrodlowego
- przekopiuj kod z template do BridgeWrapperViewController.m a nastepnie edytuj zmienna moduleName na odpowiadajaca twojemu projektowi
(moduleName mozesz sprawdzic w AppDelegate.swift swojego RN projektu)
- przekopiuj kod z template do ios/Bridge/BridgeWrapperViewController.h
- przekopiuj kod z template do ios/Bridge/Bridge.h
- przekopiuj kod z template do ios/Bridge/RNBridgeViewController.swift
- przekopiuj kod z template do ios/build-bridge.sh, a nastepnie dostosuj zmienna WORKSPACE do twojego projektu
(WORKSPACE to nazwa projektu aplikacji RN, mozesz ja sprawdzic w app.json)
- przekopiuj kod z template do ios/Bridge.podspec
(prawdopodobnie bedziesz chcial tu takze dostosowac "version", "homepage", "author", itd)

## Budowa frameworka
// wejdz do root projektu
npm install
cd ios
pod install
chmod +x build-bridge.sh
./build-bridge.sh

## Zawartość build-bridge.sh
- Zarchiwizuj bibliotekę w celu wykorzystania jej w symulatorze i na urządzeniu
- Wyodrębnij struktury z bibliotek i utwórz XCFramework

## Konfiguracja hosta
1. w podfile dodaj wygenerowanego poda

pod 'Bridge', :path => '../rn-project/ios' # w przykladzie podana lokalna sciezka, ale to zwykly pod

2. pobierz biblioteke

pod install

3. w klasie AppDelegate.swift dodaj:

@objc var window: UIWindow?

4. w docelowej klasie zaimportuj biblioteke

import Bridge

5. a nastepnie gdzies w kodzie wywolaj:

let vc = RNBridgeViewController()
...

## TODO:
- dodać argumenty wejściowe [input]
- dodać callback wyjściowy [output]

## co dalej
- podpisywanie
- CI/CD

## słowniczek
Bridge - target budujacy aplikacje RN jako xcframework
host - aplikacja iOS w której importowane sa projekty RN