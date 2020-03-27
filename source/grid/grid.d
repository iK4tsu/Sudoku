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


    public uint sectionSize() const
    {
        return to!(uint)(sqrt(to!double(side)));
    }


    private bool isPerfectSquare(in uint side) const
    {
        const double dside = to!double(side);
        return dside % sqrt(dside) == 0;
    }


    private void build(in uint[][] puzzle)
    {
        for (uint row = 0; row < side; row++)
            for (uint column = 0; column < side; column++)
                cells[row][column] = new Cell(puzzle[row][column]);
    }


    auto opIndexAssign(uint value, uint row, uint column)
    {
        return cells[row][column].number = value;
    }


    ref auto opIndex(uint row, uint column)
    {
        return cells[row][column];
    }


    public uint[][] opCall()
    {
        return cells.map!(row => row.map!(x => x.number).array).array;
    }


    public uint[] nrow(in uint row)
    {
        return (cells[row]).map!(x => x.number).array;
    }


    public uint[] ncolumn(in uint column)
    {
        return cells.map!(x => x[column].number).array;
    }


    public uint[][] nsection(uint row, uint column)
    {
        row = row > sectionSize - 1 ? row - row % sectionSize : 0;
        column = column > sectionSize - 1 ? column - column % sectionSize : 0;

        return cells.map!(x => x[column .. column + sectionSize])
                        .map!(x => x.map!(x => x.number).array)
                        .array[row .. row + sectionSize];
    }


    public void print()
    {
        for (uint i; i < side; i++) nrow(i).writeln;
    }


    public bool findInColumn(in uint column, in uint n)
    {
        return ncolumn(column).canFind(n);
    }


    public bool findInRow(in uint row, in uint n)
    {
        return nrow(row).canFind(n);
    }


    public bool findInSection(in uint row, in uint column, in uint n)
    {
        return nsection(row, column).join.canFind(n);
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
