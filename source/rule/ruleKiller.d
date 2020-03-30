module rule.ruleKiller;

import grid.cage;
import grid.cell;
import puzzle.sudoku;
import rule.rule;

class RuleKiller : Rule
{
    // FIXME: rule_killer: change visibility attribute
    public Cage[] cages;


    // TODO: ruleKiller: documentation
    override public bool validate(in uint row, in uint column, in uint number)
    {
        Cage cage = get(sudoku.grid[row, column]);
        if (cage !is null)
        {
            return !cage.contains(number) &&
                    cage.isValid(number);
        }

        return true;
    }


    private Cage get(Cell cell)
    {
        foreach (Cage cage; cages)
        {
            if (cage.contains(cell))
                return cage;
        }

        return null;
    }


    public void add(Cage[] cages...)
    {
        this.cages = cages;
    }
}
