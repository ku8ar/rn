pros:
- aplikacja RN jest całkowicie niezalezna pod wzgledem implementacji, zainstalowanych modulow itd
- brak konfliktow zaleznosci z aplikacja iOS

cons:
- niektóre biblioteki RN mogą nie działać bez dodatkowych zmian w build-bridge.sh 
- niektore biblioteki RN moga dzialac niepoprawnie

- dodanie wielu aplikacji RN do jednego projektu iOS będzie skutkować gigantycznym bundle size.
Da się rozwiązać to ograniczenie, wydzielając z archiwum binary file Hermesa (stanowi on większą część ipa),
ale to spowoduje inny problem: kazda aplikacja RN bedzie musiala byc zbudowana przy pomocy tej samej wersji RN.


TODO:
- dodać argumenty wejściowe [input]
- dodać callback wyjściowy [output]