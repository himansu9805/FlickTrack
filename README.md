# FlickTrack Mobile Application

FlickTrack is a mobile application built using Flutter that allows users to search for movies and TV shows, view their details, and keep track of the ones they have watched or want to watch. The app uses the TMDb API to fetch movie and TV show data.

### Getting Started

To get started with FlickTrack, you can follow these steps:

1. Clone the repository to your local machine using git clone https://github.com/himansu9805/FlickTrack.git
2. Open the project in your preferred IDE or editor (we recommend using Visual Studio Code with the Flutter extension installed)
3. Run flutter pub get to install the app's dependencies
4. Create a folder named auth inside the lib directory.
5. Inside the auth folder, create a file named secrets.dart.
6. Inside secrets.dart, create a variable named tmdbApiKey and assign it the API key provided by TMDB.
```dart
var tmdbApiKey = 'INSERT_YOUR_API_KEY_HERE';
```
7. Save the secrets.dart file.
8. Run the app on your preferred device or emulator by running flutter run in the terminal.

### Features

FlickTrack offers the following features:

- Search for movies and TV shows by title
- View details about movies and TV shows, including ratings, release dates, cast, and crew
- Keep track of movies and TV shows you have watched or want to watch
- Mark movies and TV shows as favorites
- Get personalized movie and TV show recommendations based on your watch history

### Contributing

If you would like to contribute to FlickTrack, feel free to submit a pull request. Before doing so, please make sure to:

- Fork the repository
- Create a new branch for your changes
- Write clear and concise commit messages
- Make sure all tests pass before submitting your pull request

### License

FlickTrack is released under the MIT License. See [LICENSE](/LICENSE.md) for more details.

### Contact

If you have any questions or feedback about FlickTrack, feel free to email us at [himansu9805@gmail.com](mailto:himansu9805@gmail.com). We would love to hear from you!
