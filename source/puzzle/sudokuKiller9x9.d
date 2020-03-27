module puzzle.sudokuKiller9x9;

import puzzle.sudoku;
import rule.ruleClasssic;
import rule.ruleKiller;

class SudokuKiller9x9 : Sudoku
{
    this(in uint[][] puzzle)
    {
        super(9, puzzle, new RuleClassic(this), new RuleKiller(this));
        // TODO: sudoku_killer_9x9: implement ctor cage set
    }
}
