module rule.ruleKiller;

import grid.cage;
import grid.cell;
import puzzle.sudoku;
import rule.rule;

class RuleKiller : Rule
{
    private Cage[] cages;


    override public bool validate(in uint row, in uint column, in uint number)
    {
        // checks if the Cell is in cages
        Cage cage = get(sudoku.grid[row, column]);
        
        // if it is...
        if (cage !is null)
        {
            // checks if an equal number already exists in the Cage
            // checks if the number exists in the possible solutions and
            //     it's sum with the other values
            return !cage.contains(number) &&
                    cage.isValid(number);
        }

        // if it isn't then it's valid
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


    /**
     * Add cages to `this`
     *
     * Params:
     *     cages = cages to add
     *
     * Examples:
     * ---
     * this.add(new Cage(cageSum, new Cell(sudoku.grid[row, column], ...)))
     * ---
     */
    public void add(Cage[] cages...)
    {
        this.cages = cages;
    }
}
