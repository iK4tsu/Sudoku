module rule.ruleX;

import rule.rule;

class RuleX : Rule
{
    override public bool validate(in uint row, in uint column, in uint number)
    {
        // [row, column] belongs to the midle Cell ?
        // check both diagonals
        if (row == sudoku.grid.side/2 && row == column)
            return !sudoku.grid.findInDiagonalUL(number) &&
                    !sudoku.grid.findInDiagonalUR(number);

        // [row, column] belongs to the main diagonal ?
        // check main diagonal
        else if (row == column)
            return !sudoku.grid.findInDiagonalUL(number);

        // [row, column] belongs to the anti-diagonal?
        // check anti-diagonal
        else if (row + column == sudoku.grid.side - 1)
            return !sudoku.grid.findInDiagonalUR(number);

        // [row, column] isn't in any diagonals
        else
            return true;
    }
}