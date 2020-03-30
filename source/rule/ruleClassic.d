module rule.ruleClassic;

import grid.grid;
import puzzle.sudoku;
import rule.rule;

class RuleClassic : Rule
{
    override public bool validate(in uint row, in uint column, in uint number)
    {
        // check rows, columns, section
        return !sudoku.grid.findInColumn(column, number) &&
                !sudoku.grid.findInRow(row, number)      &&
                !sudoku.grid.findInSection(row, column, number);
    }
}
