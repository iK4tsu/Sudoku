module puzzle.sudoku;

import std.stdio : writeln;

import grid.grid;
import rule;

public abstract class Sudoku
{
    public Grid grid;
    public Rule[] rules;


    this(in uint[][] puzzle)
    {
        grid = new Grid(9, puzzle);
        rules ~= new RuleClassic(this);
    }

    this(in uint side, in uint[][] puzzle, Rule[] rules ...)
    {
        grid = new Grid(side, puzzle);
        foreach (ref Rule rule; rules)
        {
            add(rule);
        }
    }


    public void add(Rule rule)
    {
        rules ~= rule;
    }


    // using backtrack algorithm
    public void solve()
    {
        backtrack(0, 0);
    }


    private uint backtrack(in uint column, in uint row)
    {
        // sees whether or not the value in the current cell was a given one
        if (grid[row, column].isBlocked)
        {
            if (column < grid.side - 1)   return backtrack(column + 1, row);
            else if (row < grid.side - 1) return backtrack(0, row + 1);
            else                           return grid[row, column].number;
        }

        uint ret;
        bool valid;
        for (uint i = 1; i <= grid.side; i++)
        {
            foreach (Rule rule; rules)
            {
                valid = !rule.find(row, column, i);
            }

            if (valid)
            {
                grid[row, column].number = i;

                if (column < grid.side - 1)   ret = backtrack(column + 1, row);
                else if (row < grid.side - 1) ret = backtrack(0, row + 1);
                else                           return i;

                if (ret != 0) return ret;
            }
        }

        grid[row, column] = 0;
        return 0;
    }
}
