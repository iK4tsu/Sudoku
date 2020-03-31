module grid.grid;

import std.algorithm : map, canFind;
import std.array : array, join;
import std.conv : to;
import std.math : sqrt;
import std.stdio : write, writeln;
import std.typecons;

import grid.cell;

class Grid
{
    // FIXME: grid: change visibility attribute
    public const uint side;
    public Cell[][] cells;


    this(in uint side, in uint[][] puzzle)
    {
        if (isPerfectSquare(side))
        {
            this.side = side;
            cells = new Cell[][](side, side);
            build(puzzle);
        }
    }


    /**
     * Get the size of a subsection \
     * If a grid has 9 length, then the sectionSize is 3
     *
     * Returns: `uint` variable
     */
    public uint sectionSize() const
    {
        return to!(uint)(sqrt(to!double(side)));
    }


    /**
     * Checks if the side makes a perfect square \
     * Sudoku puzzles are composed of 4, 9, 16, ..., side length \
     * These values always make a perfect square \
     * *Method used internaly only*
     *
     * Params:
     *     side = the **Grid** length
     *
     * Returns: `true` is it is \
     *          `false` otherwise
     */
    private bool isPerfectSquare(in uint side) const
    {
        const double dside = to!double(side);
        return dside % sqrt(dside) == 0;
    }


    /**
     * Constructs the puzzle \
     * *Method used internaly only*
     *
     * Params:
     *     puzzle = `uint` matrix to transform into **Cell** matrix
     */
    private void build(in uint[][] puzzle)
    {
        for (uint row = 0; row < side; row++)
            for (uint column = 0; column < side; column++)
                cells[row][column] = new Cell(puzzle[row][column]);
    }


    /**
     * Allows to assign a number by calling the object directly
     *
     * Params:
     *     value = number to be assigned
     *     row = **Grid** row
     *     column = **Grid** column
     *
     * Examples:
     * ---
     * this[row, column] = number;
     * ---
     *
     * Returns: the assigned `uint` number
     */
    auto opIndexAssign(uint value, uint row, uint column)
    {
        return cells[row][column].number = value;
    }


    /**
     * Allows to get a **Cell** by calling the object directly
     *
     * Params:
     *     row = **Grid** row
     *     column = **Grid** column
     *
     * Examples:
     * ---
     * Cell cell = this[row, column];
     * ---
     *
     * Returns:
     *     **Cell** in the row and column of **Grid**
     */
    ref auto opIndex(uint row, uint column)
    {
        return cells[row][column];
    }


    /**
     * Allows to get the numeric grid
     *
     * Examples:
     * ---
     * auto puzzle = this();
     * ---
     *
     * Returns:
     *     `uint[][]` filled with all the numbers in `this`
     */
    public uint[][] opCall()
    {
        return cells.map!(row => row.map!(x => x.number).array).array;
    }


    /**
     * Numeric row of **Grid**
     *
     * Params:
     *     row: **Grid** row
     *
     * Examples:
     * ---
     * auto row = this.nrow(rownumber);
     * ---
     *
     * Returns:
     *     `uint[]` filled with the row numbers
     */
    public uint[] nrow(in uint row)
    {
        return (cells[row]).map!(x => x.number).array;
    }


    /**
     * Numeric column of **Grid**
     *
     * Params:
     *     column = **Grid** column
     *
     * Examples:
     * ---
     * auto column = this.column(columnnumber);
     * ---
     *
     * Returns:
     *     `uint[]` filled with the column numbers
     */
    public uint[] ncolumn(in uint column)
    {
        return cells.map!(x => x[column].number).array;
    }


    /**
     * Numeric section of **Grid**
     *
     * Params:
     *     row = **Grid** row
     *     column = **Grid** column
     *
     * Examples:
     * ---
     * auto section = this.section(rownumber, columnnumber);
     * ---
     *
     * Returns:
     *     `uint[][]` filled with the section numbers
     */
    public uint[][] nsection(uint row, uint column)
    {
        row = row > sectionSize - 1 ? row - row % sectionSize : 0;
        column = column > sectionSize - 1 ? column - column % sectionSize : 0;

        return cells.map!(x => x[column .. column + sectionSize])
                        .map!(x => x.map!(x => x.number).array)
                        .array[row .. row + sectionSize];
    }


    /**
     * Numeric main diagonal of **Grid** \
     * *UL = Upper Left
     *
     * Examples:
     * ---
     * auto diagonal = this.ndiagonalul();
     * ---
     *
     * Returns:
     *     `uint[][]` filled with the diagonal numbers
     */
    public auto ndiagonalul()
    {
        uint[] ret;
        foreach (i, Cell[] arr; cells)
        {
            ret ~= arr[i].number;
        }

        return ret;
    }


    /**
     * Numeric anti-diagonal of **Grid** \
     * *UR = Upper Right
     *
     * Examples:
     * ---
     * auto diagonal = this.ndiagonalur();
     * ---
     *
     * Returns:
     *     `uint[][]` filled with the diagonal numbers
     */
    public auto ndiagonalur()
    {
        uint[] ret;
        foreach (i, Cell[] arr; cells)
        {
            ret ~= arr[side - i - 1].number;
        }

        return ret;
    }


    /**
     * Prints the current numeric puzzle
     */
    public void print()
    {
        for (uint i; i < side; i++) nrow(i).writeln;
    }


    /**
     * Checks if a number exists in a column
     *
     * Params:
     *     column = **Grid** column
     *     n = number to be evaluate
     *
     * Examples:
     * ---
     * !findInColumn(columnnumber, number);
     * ---
     *
     * Returns:
     *     `true` if the column contains the number
     *     `false` otherwise
     */
    public bool findInColumn(in uint column, in uint n)
    {
        return ncolumn(column).canFind(n);
    }


    /**
     * Checks if a number exists in a row
     *
     * Params:
     *     row = **Grid** row
     *     n = number to be evaluate
     *
     * Examples:
     * ---
     * !findInRow(rownumber, number);
     * ---
     *
     * Returns:
     *     `true` if the row contains the number
     *     `false` otherwise
     */
    public bool findInRow(in uint row, in uint n)
    {
        return nrow(row).canFind(n);
    }


    /**
     * Checks if a number exists in a section
     *
     * Params:
     *     section = **Grid** section
     *     n = number to be evaluate
     *
     * Examples:
     * ---
     * !findInSection(sectionnumber, number);
     * ---
     *
     * Returns:
     *     `true` if the section contains the number
     *     `false` otherwise
     */
    public bool findInSection(in uint row, in uint column, in uint n)
    {
        return nsection(row, column).join.canFind(n);
    }


    /**
     * Checks if a number exists in the main diagonal \
     * *UL = Upper Left*
     *
     * Params:
     *     number = number to be evaluated
     *
     * Examples:
     * ---
     * !findInDiagonalUL(number);
     * ---
     *
     * Returns:
     *     `true` if the diagonal contains the number
     *     `false` otherwise
     */
    public bool findInDiagonalUL(in uint number)
    {
        return canFind(ndiagonalul(), number);
    }


    /**
     * Checks if a number exists in the anti-diagonal \
     * *UR = Upper Right*
     *
     * Params:
     *     number = number to be evaluated
     *
     * Examples:
     * ---
     * !findInDiagonalUR(number);
     * ---
     *
     * Returns:
     *     `true` if the diagonal contains the number
     *     `false` otherwise
     */
    public bool findInDiagonalUR(in uint number)
    {
        return canFind(ndiagonalur(), number);
    }
}


version(unittest)
{
    uint[][] puzzle4x4 = [[1, 0, 0, 3],
                          [0, 2, 1, 4],
                          [4, 0, 0, 2],
                          [0, 3, 4, 1]];

    uint[][] puzzle9x9 = [[0, 0, 3, 7, 9, 5, 8, 0, 1],
                          [0, 0, 8, 6, 0, 0, 0, 3, 5],
                          [0, 7, 0, 0, 4, 3, 0, 0, 0],
                          [0, 0, 6, 1, 0, 7, 0, 9, 0],
                          [0, 0, 0, 0, 5, 0, 0, 0, 0],
                          [0, 5, 0, 9, 0, 6, 4, 0, 0],
                          [0, 0, 0, 2, 3, 0, 0, 6, 0],
                          [6, 8, 0, 0, 0, 1, 3, 0, 0],
                          [1, 0, 4, 5, 6, 9, 2, 0, 0]];
}


@("Grid: ctor")
unittest
{
    Grid g = new Grid(4, puzzle4x4);

    assert(g[0, 0].isBlocked);
    assert(!g[0, 1].isBlocked);
}

@("Grid: sub-divisions")
unittest
{
    Grid g4x4 = new Grid(4, puzzle4x4);

    assert(g4x4.nrow(0) == [1, 0, 0, 3]);
    assert(g4x4.ncolumn(2) == [0, 1, 0, 4]);
    assert(g4x4.nsection(1, 1) == [[1, 0], [0, 2]]);
}

@("Grid: search")
unittest
{
    Grid g4x4 = new Grid(4, puzzle4x4);
    Grid g9x9 = new Grid(9, puzzle9x9);

    assert(g9x9.findInColumn(2, 8));
    assert(!g4x4.findInRow(0, 4));
    assert(g9x9.findInSection(1, 2, 7));
}

@("Grid: accessors")
unittest
{
    Grid g4x4 = new Grid(4, puzzle4x4);

    assert(g4x4[0, 1] == g4x4.cells[0][1]);
    assert(g4x4[0, 0].number == 1);

    g4x4[0, 1] = 4;
    assert(g4x4[0, 1].number == 4);
}
