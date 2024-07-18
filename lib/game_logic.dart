class GameLogic {
  static int checkWinner(List<dynamic> board) {
    const List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      int a = combination[0];
      int b = combination[1];
      int c = combination[2];
      if (board[a] != 0 && board[a] == board[b] && board[a] == board[c]) {
        return board[a];
      }
    }

    return 0;
  }

  static bool hasEmptyCell(List<dynamic> board) {
    return board.contains(0);
  }
}
