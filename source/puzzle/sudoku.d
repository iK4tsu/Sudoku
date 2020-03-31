module puzzle.sudoku;

import std.algorithm : canFind;
import std.array : array;
import std.stdio : writeln;

import grid.grid;
import rule;

public abstract class Sudoku
{
    // FIXME: sudoku: change visibility attribute
    protected Grid _grid;
    protected Rule[] rules;


    this(in uint side, in uint[][] puzzle)
    {
        this(side, puzzle, new RuleClassic());
    }

    this(in uint side, in uint[][] puzzle, Rule[] rules...)
    {
        _grid = new Grid(side, puzzle);
        add(rules);
        regist();
    }


    /**
     * `_grid` getter
     */
    public auto grid() @property
    {
        return _grid;
    }


    public auto ngrid() @property
    {
        return _grid();
    }


    /**
     * Set `this` for every **Rule** \
     * *Method used internaly only*
     */
    protected void regist()
    {
        foreach (Rule rule; rules)
        {
            rule.sudoku = this;
        }
    }


    /**
     * Append rules to `this` \
     * *Method used internaly*
     *
     * Params:
     *     rules =    rules to add
     *
     * Examples:
     * ---
     * add(new RuleClassic(), new RuleKiller(), ...);
     * ---
     */
    protected void add(Rule[] rules...)
    {
        foreach (Rule rule; rules)
        {
            if (!canFind(this.rules, rule))
                this.rules ~= rules;
        }
    }


    /**
     * Tries to get a solution for `this` \
     * It calls the backtrack algorithm function
     *
     * Returns: uint matrix with or without the solution
     *
     * See_Also:
     *     uint backtrack(in uint column, in uint row)
     */
    public auto solve()
    {
        backtrack(0, 0);
        return ngrid;
    }


    /**
     * Algorithm used to solve `this` \
     * *Method only used internaly only*
     *
     * Params:
     *     column: current **Grid** column
     *     row:    current **Grid** row
     */
    private uint backtrack(in uint column, in uint row)
    {
        // checks whether or not the value in the current cell is a given one
        // if it is...
        if (grid[row, column].isBlocked)
        {
            // not end of column? proceed to next cell in the same row
            // last column but not end of row? proceed to the first column next row
            // last cell of the puzzle, return which number it's got
            if (column < grid.side - 1)   return backtrack(column + 1, row);
            else if (row < grid.side - 1) return backtrack(0, row + 1);
            else                          return grid[row, column].number;
        }

        uint ret;
        bool valid;

        // if the current cell did't have a given number, aka Cell number was 0
        // check for each number of 1 to 9 inclusive if it's valid
        for (uint i = 1; i <= grid.side; i++)
        {
            // every number is tested using `this` rules
            foreach (Rule rule; rules)
            {
                // if a single one of the rules in `this` returns `false`
                // then the number isn't valid and the next in range is tested
                valid = rule.validate(row, column, i);
                if (!valid) break;
            }

            // if it's valid we proceed to same cell using same logic above
            if (valid)
            {
                grid[row, column].number = i; // store `i` in the Grid

                if (column < grid.side - 1)   ret = backtrack(column + 1, row);
                else if (row < grid.side - 1) ret = backtrack(0, row + 1);
                else                          return i;

                // ret != 0 means the puzzle is done
                // ret == 0 means there wasn't a number from 1-9 inclusive
                //     in the next Cell which was valid to store
                //     in that case, the number in the current Cell is resetted
                if (ret != 0) return ret;
                else grid[row, column] = 0;
            }
        }

        // to reach here it means there wasn't a single number which was valid
        // resetting the current Cell
        return grid[row, column] = 0;
    }


    /**
     * Get a Rule in contained in `this`
     *
     * Params:
     *     R: rule extending from **Rule**
     *
     * Returns: R type if found a **Rule** of the same type \
     *          `null` otherwise
     *
     * Examples:
     * ---
     * RuleClassic rc = this.get!RuleClassic;
     * ---
     */
    public R get(R : Rule)()
    {
        R r;
        foreach (Rule rule; rules)
        {
            if ((r = cast(R)(rule)) !is null) return r;
        }

        return null;
    }
}
