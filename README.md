# Setlist-iOS
Application iPhone permettant de connaître rapidement tous les titres joués d'un artiste/groupe lors de ses derniers concerts.

## API
- **Spotify** : Récupérer la photo de l'artiste via son nom
- **MusicBrainz** : Rechercher un artiste. L'api nous retournera le nom ainsi que l'id (sous la forme 9c9f1380-0000-4fc9-a3e6-f9f61941d090)
- **SetlistFM** : Via l'id de l'artiste, on va chercher la liste de ses derniers concerts.

## Librairies
- [Alamofire](https://github.com/Alamofire/Alamofire) : Permet de faire tous les appels HTTP.
