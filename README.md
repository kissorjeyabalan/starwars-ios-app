#Star Wars - Eksamen
## Info
Jeg bestemte meg for synkronisere alt fra API om karakterer og filmer til Core Data. Dette gjøres en gang i uken, og gjøres når appen startes.
Det kan ta opp til 5-6 sekunder å synkronisere, siden SWAPI API ikke er så rask. Det blir gjort 10 kall mot API, så det er viktig at man ikke har overskredet maks 10,000 kall mot SWAPI per døgn per IP.

Det er plassert flere MARK i koden, for å finne frem ting enklere.


## Kilder
Kilder skal være nevnt i koden, men i tilfelle det mangler noe, så er dette _alle_ kildene jeg har tatt i bruk:

- NSManagedObject & Codable: https://stackoverflow.com/a/46917019
- NSFetchedResultsController: https://github.com/BeiningBogen/iOS-Westerdals/blob/master/forelesning08/README.pdf
- NSFetchedResultsController: https://cocoacasts.com/populate-a-table-view-with-nsfetchedresultscontroller-and-swift-3
- Multiple FRC: https://stackoverflow.com/a/2309855
- Date variance: https://stackoverflow.com/questions/24723431/swift-days-between-two-nsdates
- Release viewcontrollers: https://stackoverflow.com/questions/40100696/removing-all-previously-loaded-viewcontrollers-from-memory-ios-swift?rq=1
- Map: https://developer.apple.com/documentation/swift/enumeratedsequence/2907233-map
- Bilde: https://vignette.wikia.nocookie.net/starwars/images/d/d8/Emperor_Sidious.png/revision/latest