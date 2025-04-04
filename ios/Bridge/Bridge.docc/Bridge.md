pros:
- aplikacja RN jest całkowicie niezalezna pod wzgledem implementacji, zainstalowanych modulow itd
- brak konfliktow zaleznosci z aplikacja iOS
- szybszy czas kompilacji aplikacji iOS

cons:
- niektóre biblioteki RN mogą nie działać bez dodatkowych zmian w build-bridge.sh 
- niektore biblioteki RN moga dzialac niepoprawnie

- dodanie wielu aplikacji RN do jednego projektu iOS będzie skutkować gigantycznym bundle size.
Da się rozwiązać to ograniczenie, wydzielając z archiwum binary file Hermesa (stanowi on większą część ipa),
ale to spowoduje inny problem: kazda aplikacja RN bedzie musiala byc zbudowana przy pomocy tej samej wersji RN.


TODO:
- dodać argumenty wejściowe [input]
- dodać callback wyjściowy [output]


Konfiguracja projektu w Xcode
- dodaj nowy target Framework i nazwij go np. "Bridge"
(nazwa "Bridge" jest uzywana takze w pliku podspec i build-bridge.sh wiec jezeli wybierzesz inna, to zmien ja takze tam)
- wejdz do Build Phases -> target "Bridge" i usun faze "[CP] Copy Pods Resources"
(budowany framework w przeciwienstwie do aplikacji nie moze edytowac bezposrednio katalogu "Target Support Files")


Zawartość build-bridge.sh
- Zarchiwizuj bibliotekę w celu wykorzystania jej w symulatorze i na urządzeniu
- Wyodrębnij struktury z bibliotek i utwórz XCFramework


Konfiguracja hosta

1. w podfile dodaj wygenerowanego poda

pod 'Bridge', :path => '../rn-project/ios' # zamiast sciezki do poda mozesz umiescic link

2. w klasie AppDelegate.swift dodaj:

@objc var window: UIWindow?

3. w docelowej klasie zaimportuj biblioteke

import Bridge

4. a nastepnie gdzies w kodzie wywolaj ViewController:

let vc = RNBridgeViewController()
...