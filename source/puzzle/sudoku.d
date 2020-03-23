module puzzle.sudoku;

import std.stdio : writeln;

import grid.grid;

public abstract class Sudoku
{
    public Grid grid;


    this(in uint[][] puzzle)
    {
        grid = new Grid(9, puzzle);
    }

    this(in uint side, in uint[][] puzzle)
    {
        grid = new Grid(side, puzzle);
    }


    // using backtrack algorithm
    public void solve()
    {
        backtrack(0, 0);
    }


    private uint backtrack(in uint column, in uint row)
    {
        // sees whether or not the value in the current cell was a given one
        if (grid[row, column].blocked)
        {
            if (column < grid.side - 1)   return backtrack(column + 1, row);
            else if (row < grid.side - 1) return backtrack(0, row + 1);
            else                           return grid[row, column].n;
        }

        uint ret;
        for (uint i = 1; i <= grid.side; i++)
        {
            if (!grid.find(row, column, i))
            {
                grid[row, column].n = i;

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
