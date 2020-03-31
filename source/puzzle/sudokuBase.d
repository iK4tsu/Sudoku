module puzzle.sudokuBase;

import puzzle.sudoku;
import rule.rule;

class SudokuBase(uint N) : Sudoku
{
    this(uint[][] puzzle)
    {
        super(N, puzzle);
    }

    this(uint[][] puzzle, Rule[] rules...)
    {
        super(N, puzzle, rules);
    }
}


public alias Sudoku4x4 = SudokuBase!4;
public alias Sudoku9x9 = SudokuBase!9;


version(unittest)
{
    uint[][] puzzle4x4 = [[1, 0, 0, 3],
                          [0, 2, 1, 4],
                          [4, 0, 0, 2],
                          [0, 3, 4, 1]];

    uint[][] puzzle9x9 = [[0, 0, 3, 7, 9, 5, 8, 0, 1],
                          [0, 0, 8, 6, 0, 0, 0, 3, 5],
                          [0, 7, 0, 0, 4, 3, 0, 0, 0],
                          [0, 0, 6, 1, 0, 7, 0, 9, 0],
                          [0, 0, 0, 0, 5, 0, 0, 0, 0],
                          [0, 5, 0, 9, 0, 6, 4, 0, 0],
                          [0, 0, 0, 2, 3, 0, 0, 6, 0],
                          [6, 8, 0, 0, 0, 1, 3, 0, 0],
                          [1, 0, 4, 5, 6, 9, 2, 0, 0]];

    uint[][] puzzleKiller9x9 = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                [0, 0, 0, 0, 0, 0, 0, 0, 0]];

    uint[][] puzzleX9x9 = [[0, 9, 0, 0, 0, 0, 0, 4, 0],
                           [0, 0, 6, 0, 0, 0, 2, 9, 0],
                           [0, 3, 7, 6, 0, 0, 0, 0, 0],
                           [1, 0, 3, 0, 0, 4, 0, 0, 0],
                           [0, 0, 0, 7, 0, 0, 9, 0, 0],
                           [0, 0, 0, 8, 0, 6, 3, 0, 4],
                           [0, 0, 0, 2, 9, 0, 4, 0, 0],
                           [0, 0, 0, 0, 0, 1, 0, 5, 0],
                           [0, 0, 9, 0, 0, 0, 0, 0, 8]];
}


@("SudokuBase: ctor")
unittest
{
    Sudoku4x4 puzzle = new Sudoku4x4(puzzle4x4);

    assert(puzzle.ngrid == puzzle4x4);
}


@("SudokuBase: rule getter")
unittest
{
    import rule;

    Sudoku4x4 puzzle = new Sudoku4x4(puzzle4x4, new RuleClassic());
    assert(typeid(puzzle.get!RuleClassic) == typeid(RuleClassic));
}


@("SudokuBase: classic4x4 solver")
unittest
{
    Sudoku4x4 puzzle = new Sudoku4x4(puzzle4x4);

    assert(puzzle.solve() == [[1, 4, 2, 3],
                              [3, 2, 1, 4],
                              [4, 1, 3, 2],
                              [2, 3, 4, 1]]);
}


@("SudokuBase: classic9x9 solver")
unittest
{
    Sudoku9x9 puzzle = new Sudoku9x9(puzzle9x9);

    assert(puzzle.solve() == [[2, 6, 3, 7, 9, 5, 8, 4, 1],
                              [9, 4, 8, 6, 1, 2, 7, 3, 5],
                              [5, 7, 1, 8, 4, 3, 9, 2, 6],
                              [4, 2, 6, 1, 8, 7, 5, 9, 3],
                              [8, 1, 9, 3, 5, 4, 6, 7, 2],
                              [3, 5, 7, 9, 2, 6, 4, 1, 8],
                              [7, 9, 5, 2, 3, 8, 1, 6, 4],
                              [6, 8, 2, 4, 7, 1, 3, 5, 9],
                              [1, 3, 4, 5, 6, 9, 2, 8, 7]]);
}


@("SudokuBase: killer9x9 solver")
unittest
{
    import grid.cage;
    import rule : RuleClassic, RuleKiller;
    Sudoku9x9 puzzle = new Sudoku9x9(puzzleKiller9x9, new RuleClassic(), new RuleKiller());

    // TODO: unittest_killer9x9: find a better way to handle cages
    Cage[] cages9x9 = [ new Cage(14, puzzle.grid[0,0], puzzle.grid[1,0], puzzle.grid[1,1]),
                        new Cage(18, puzzle.grid[0,1], puzzle.grid[0,2], puzzle.grid[0,3]),
                        new Cage(8,  puzzle.grid[0,4], puzzle.grid[0,5]),
                        new Cage(15, puzzle.grid[0,6], puzzle.grid[1,6]),
                        new Cage(13, puzzle.grid[0,7], puzzle.grid[1,7]),
                        new Cage(6,  puzzle.grid[0,8], puzzle.grid[1,8]),
                        new Cage(10, puzzle.grid[1,2], puzzle.grid[1,3], puzzle.grid[1,4]),
                        new Cage(15, puzzle.grid[1,5], puzzle.grid[2,5]),
                        new Cage(12, puzzle.grid[2,0], puzzle.grid[2,1]),
                        new Cage(13, puzzle.grid[2,2], puzzle.grid[3,2], puzzle.grid[4,2]),
                        new Cage(5,  puzzle.grid[2,3], puzzle.grid[2,4]),
                        new Cage(12, puzzle.grid[2,6], puzzle.grid[2,7], puzzle.grid[3,7]),
                        new Cage(14, puzzle.grid[2,8], puzzle.grid[3,8]),
                        new Cage(23, puzzle.grid[3,0], puzzle.grid[4,0], puzzle.grid[5,0]),
                        new Cage(5,  puzzle.grid[3,1], puzzle.grid[4,1]),
                        new Cage(18, puzzle.grid[3,3], puzzle.grid[3,4], puzzle.grid[4,3]),
                        new Cage(12, puzzle.grid[3,5], puzzle.grid[4,5]),
                        new Cage(12, puzzle.grid[3,6], puzzle.grid[4,6], puzzle.grid[5,6]),
                        new Cage(3,  puzzle.grid[4,4], puzzle.grid[5,4]),
                        new Cage(8,  puzzle.grid[4,7], puzzle.grid[4,8]),
                        new Cage(18, puzzle.grid[5,1], puzzle.grid[5,2], puzzle.grid[6,2]),
                        new Cage(7,  puzzle.grid[5,3], puzzle.grid[6,3]),
                        new Cage(9,  puzzle.grid[5,5], puzzle.grid[6,5]),
                        new Cage(10, puzzle.grid[5,7], puzzle.grid[5,8]),
                        new Cage(5,  puzzle.grid[6,0], puzzle.grid[7,0]),
                        new Cage(5,  puzzle.grid[6,1], puzzle.grid[7,1]),
                        new Cage(19, puzzle.grid[6,4], puzzle.grid[7,4], puzzle.grid[7,5]),
                        new Cage(20, puzzle.grid[6,6], puzzle.grid[6,7], puzzle.grid[7,6]),
                        new Cage(19, puzzle.grid[6,8], puzzle.grid[7,7], puzzle.grid[7,8]),
                        new Cage(16, puzzle.grid[7,2], puzzle.grid[8,2]),
                        new Cage(18, puzzle.grid[7,3], puzzle.grid[8,3], puzzle.grid[8,4]),
                        new Cage(13, puzzle.grid[8,0], puzzle.grid[8,1]),
                        new Cage(5,  puzzle.grid[8,5], puzzle.grid[8,6]),
                        new Cage(5,  puzzle.grid[8,7], puzzle.grid[8,8]) ];

    puzzle.get!RuleKiller.add(cages9x9);

    assert(puzzle.solve() == [[2, 6, 4, 8, 5, 3, 7, 9, 1],
                              [3, 9, 1, 2, 7, 6, 8, 4, 5],
                              [7, 5, 8, 1, 4, 9, 2, 3, 6],
                              [9, 1, 2, 6, 3, 5, 4, 7, 8],
                              [8, 4, 3, 9, 1, 7, 5, 6, 2],
                              [6, 7, 5, 4, 2, 8, 3, 1, 9],
                              [4, 2, 6, 3, 8, 1, 9, 5, 7],
                              [1, 3, 7, 5, 9, 2, 6, 8, 4],
                              [5, 8, 9, 7, 6, 4, 1, 2, 3]]);
}


@("SudokuBase: X9x9 solver")
unittest
{
    import rule : RuleClassic, RuleX;
    Sudoku9x9 puzzle = new Sudoku9x9(puzzleX9x9, new RuleClassic(), new RuleX());

    assert(puzzle.solve() == [[2, 9, 5, 1, 8, 3, 7, 4, 6],
                              [8, 1, 6, 5, 4, 7, 2, 9, 3],
                              [4, 3, 7, 6, 2, 9, 5, 8, 1],
                              [1, 7, 3, 9, 5, 4, 8, 6, 2],
                              [6, 8, 4, 7, 3, 2, 9, 1, 5],
                              [9, 5, 2, 8, 1, 6, 3, 7, 4],
                              [5, 6, 1, 2, 9, 8, 4, 3, 7],
                              [3, 2, 8, 4, 7, 1, 6, 5, 9],
                              [7, 4, 9, 3, 6, 5, 1, 2, 8]]);
}
