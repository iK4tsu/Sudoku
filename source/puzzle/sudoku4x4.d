module puzzle.sudoku4x4;

import puzzle.sudoku;

class Sudoku4x4 : Sudoku
{
    this(in uint[][] puzzle)
    {
        super(4, puzzle);
    }
}


version(unittest)
{
    uint[][] puzzle4x4 = [[1, 0, 0, 3],
                          [0, 2, 1, 4],
                          [4, 0, 0, 2],
                          [0, 3, 4, 1]];
}

@("Sudoku4x4: ctor")
unittest
{
    Sudoku sudoku = new Sudoku4x4(puzzle4x4);

    assert(sudoku.grid() == puzzle4x4);
}

@("Sudoku4x4: solver")
unittest
{
    Sudoku sudoku = new Sudoku4x4(puzzle4x4);

    sudoku.solve();

    assert(sudoku.grid() == [[1, 4, 2, 3],
                             [3, 2, 1, 4],
                             [4, 1, 3, 2],
                             [2, 3, 4, 1]]);
}
