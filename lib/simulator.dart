import 'dart:math';

enum CellType {
  LIVE,
  DEAD,
}

class Simulator {
  var _board;
  int width;
  int height;

  Simulator(int width, int height) {
    this.width = width;
    this.height = height;
    _board = List.generate(
        width, (i) => List.generate(height, (j) => CellType.DEAD));
    _board[10][10] = CellType.LIVE;
    _board[10][11] = CellType.LIVE;
    _board[11][11] = CellType.LIVE;
  }

  void tick() {
    var newBoard = List.generate(
        this.width, (i) => List.generate(this.height, (j) => CellType.DEAD));
    for (int x = 0; x < this.width; x++) {
      for (int y = 0; y < this.height; y++) {
        newBoard[x][y] = newState(x, y);
      }
    }
    _board = newBoard;
  }

  bool test(int x, int y, CellType material) {
    return inBounds(x, y) && _board[x][y] == material;
  }

  bool inBounds(int x, int y) {
    return x < this.width && x >= 0 && y < this.height && y >= 0;
  }

  CellType getCellType(int x, int y) {
    return _board[x % this.width][y % this.height];
  }

  bool isAlive(int x, int y) {
    return getCellType(x, y) == CellType.LIVE;
  }

  void changeState(int x, int y) {
    if (!inBounds(x, y)) {
      return;
    }
    _board[x][y] =
        _board[x][y] == CellType.LIVE ? CellType.DEAD : CellType.LIVE;
  }

  void resizeWidth(int newWidth) {
    if (this.width == newWidth) {
      return;
    }
    print("resizing to $newWidth");
    this.width = newWidth;
    clear();
  }

  clear() {
    _board = List.generate(
        this.width, (i) => List.generate(this.height, (j) => CellType.DEAD));
  }

  CellType newState(int x, int y) {
    int count = countAlive(x, y);
    var alive = isAlive(x, y);
    if (alive && count < 2) {
      return CellType.DEAD;
    }
    if (alive && count >= 2 && count <= 3) {
      return CellType.LIVE;
    }
    if (alive && count >= 4) {
      return CellType.DEAD;
    }
    if (!alive && count == 3) {
      return CellType.LIVE;
    }
    return CellType.DEAD;
  }

  int countAlive(int x, int y) {
    return [
      [x - 1, y - 1],
      [x, y - 1],
      [x + 1, y - 1],
      [x - 1, y],
      [x + 1, y],
      [x - 1, y + 1],
      [x, y + 1],
      [x + 1, y + 1]
    ].where((element) => isAlive(element[0], element[1])).toList().length;
  }

  void shuffle() {
    Random random = new Random();
    var newBoard = List.generate(
        this.width, (i) => List.generate(this.height, (j) => CellType.DEAD));
    for (int x = 0; x < this.width; x++) {
      for (int y = 0; y < this.height; y++) {
        newBoard[x][y] = random.nextInt(2) == 0 ? CellType.DEAD : CellType.LIVE;
        print(newBoard[x][y] );
      }
    }
    _board = newBoard;
  }
}
