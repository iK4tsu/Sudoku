module puzzle.sudoku9x9;

import puzzle.sudoku;

class Sudoku9x9 : Sudoku
{
    public this(in uint[][] puzzle)
    {
        super(9, puzzle);
    }
}


version(unittest)
{
    uint[][] puzzle9x9 = [[0, 0, 3, 7, 9, 5, 8, 0, 1],
                          [0, 0, 8, 6, 0, 0, 0, 3, 5],
                          [0, 7, 0, 0, 4, 3, 0, 0, 0],
                          [0, 0, 6, 1, 0, 7, 0, 9, 0],
                          [0, 0, 0, 0, 5, 0, 0, 0, 0],
                          [0, 5, 0, 9, 0, 6, 4, 0, 0],
                          [0, 0, 0, 2, 3, 0, 0, 6, 0],
                          [6, 8, 0, 0, 0, 1, 3, 0, 0],
                          [1, 0, 4, 5, 6, 9, 2, 0, 0]];
}

@("Sudoku4x4: ctor")
unittest
{
    Sudoku sudoku = new Sudoku9x9(puzzle9x9);

    assert(sudoku.grid() == puzzle9x9);
}

@("Sudoku4x4: solver")
unittest
{
    Sudoku sudoku = new Sudoku9x9(puzzle9x9);

    sudoku.solve();

    assert(sudoku.grid() == [[2, 6, 3, 7, 9, 5, 8, 4, 1],
                             [9, 4, 8, 6, 1, 2, 7, 3, 5],
                             [5, 7, 1, 8, 4, 3, 9, 2, 6],
                             [4, 2, 6, 1, 8, 7, 5, 9, 3],
                             [8, 1, 9, 3, 5, 4, 6, 7, 2],
                             [3, 5, 7, 9, 2, 6, 4, 1, 8],
                             [7, 9, 5, 2, 3, 8, 1, 6, 4],
                             [6, 8, 2, 4, 7, 1, 3, 5, 9],
                             [1, 3, 4, 5, 6, 9, 2, 8, 7]]);
}
