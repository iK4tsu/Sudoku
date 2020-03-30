module rule.rule;

import grid.grid;
import puzzle.sudoku;

abstract class Rule
{
    protected Sudoku _sudoku;


    /**
     * `_sudoku` setter
     * Method used internaly only
     *
     * Params:
     *     sudoku: **Sudoku** to set
     *
     * Examples:
     * ---
     * this.sudoku = somesudoku;
     * ---
     */
    public void sudoku(Sudoku sudoku) @property
    {
        _sudoku = sudoku;
    }


    /**
     * `_sudoku` getter
     */
    public Sudoku sudoku() @property
    {
        return _sudoku;
    }


    /**
     * Checks if a *number* is valid for certaint **Cell**
     *
     * Params:
     *     row = **Cell** row
     *     column = **Cell** column
     *     number = number to validate
     *
     * Returns:
     *     `true` if it's valid \
     *     `false` otherwise
     */
    public abstract bool validate(in uint row, in uint column, in uint number);
}
