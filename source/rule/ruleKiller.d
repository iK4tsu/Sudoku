module rule.ruleKiller;

import grid.cage;
import puzzle.sudoku;
import rule.rule;

class RuleKiller : Rule
{
    // FIXME: rule_killer: change visibility attribute
    public Cage[] cages;

    this(Sudoku sudoku)
    {
        super(sudoku);
    }


    override public bool find(in uint row, in uint column, in uint number)
    {
        // TODO: rule_killer: implement find
        // every cage;
        return false;
    }
}
