module rule.rule;

import grid.grid;
import puzzle.sudoku;

abstract class Rule
{
    protected Sudoku _sudoku;


    public void sudoku(Sudoku sudoku) @property
    {
        _sudoku = sudoku;
    }


    public Sudoku sudoku() @property
    {
        return _sudoku;
    }


    public abstract bool validate(in uint row, in uint column, in uint number);
}
