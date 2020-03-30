module rule.rule;

import grid.grid;
import puzzle.sudoku;

abstract class Rule
{
    // FIXME: rule: change visibility attribute
    public Sudoku sudoku;

    this (Sudoku sudoku)
    {
        this.sudoku = sudoku;
    }


    public abstract bool validate(in uint row, in uint column, in uint number);
}
