# Game Of Life

Is a simple implementation of [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life).

## Run from source

First install the [flutter sdk](https://flutter.dev/docs/get-started/codelab)

Then clone this repo. Enter the directory and run:

`flutter run`

## Build snap

First install `snapcraft` in ubuntu. You can install snapcraft in other distros. Then run:

`snap install snapcraft`

Then create the snap by typing:

`snapcraft`

Once the build is ready, install it:

`snap install --devmode ./the-game-of-life_0.0.1_amd64.snap`

