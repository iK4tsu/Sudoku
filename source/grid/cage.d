module grid.cage;

import std.algorithm : canFind, count, filter, isStrictlyMonotonic, map, sum;
import std.array : array, join;
import std.range : iota, repeat, replicate, chunks;

import algorithm.multiCartisianProduct;
import grid.cell;

class Cage
{
    private Cell[] cells;
    private uint[][] possibleSolutions;
    private const uint cageSum;


    this(in uint cageSum, Cell[] cells ...)
    {
        this.cageSum = cageSum;
        add(cells);
        possibleSolutions = buildSolutions();
    }


    /**
     * Constructs every possible solution in `this` \
     * *Method used only internaly*
     *
     * Examples:
     * ---
     * new Cage(5, new Cell(...), new Cell(...));
     * assert(possibleSolutions == [[1,4],[2,3]]);
     * ---
     *
     * Returns:
     *     `uint[][]` with every solution possible
     */
    private auto buildSolutions()
    {
        // calculate the max range of numbers possible for each Cell
        // if the cageSum is 5, then maxSeq will be 5
        // A: the range of 1 until maxSeq
        // B: matrix of A*numberOfCells arrays
        const auto maxseq = cageSum <= 9 ? cageSum + 1 : 10;
        uint[] A = iota(1U, maxseq).array;
        uint[][] B;
        for (size_t i; i < cells.length; i++) B ~= A;

        auto BB = multiCartisianProduct!uint(B);

        return BB
                .filter!(x => x.sum == cageSum)
                .filter!(x => x.isStrictlyMonotonic).array;
    }


    /**
     * Checks if a **Cell** exist in `this`
     *
     * Params:
     *     cell = the **Cell** to be checked
     *
     * Examples:
     * ---
     * !this.contains(cell);
     * ---
     *
     * Returns:
     *     `true` if `this` contains the **Cell**
     *     `false` otherwise
     */
    public bool contains(Cell cell)
    {
        return canFind(cells, cell);
    }


    /**
     * Checks if a number exist in `this`
     *
     * Params:
     *     number = the number to be checked
     *
     * Examples:
     * ---
     * !this.contains(number);
     * ---
     *
     * Returns:
     *     `true` if `this` contains the number
     *     `false` otherwise
     */
    public bool contains(in uint number)
    {
        return canFind(ncells, number);
    }


    /**
     * Checks if a number can be stored in `this`
     *
     * Params:
     *     number = number to be checked
     *
     * Examples:
     * ---
     * !this.isValid(number);
     * ---
     *
     * Returns:
     *     `true` if is valid
     *     `false` otherwise
     */
    public bool isValid(in uint number)
    {
        if (isComplete)
            return canFind(possibleSolutions.join, number) &&
                    ncells.sum() + number == cageSum;
        else
            return canFind(possibleSolutions.join, number) &&
                    ncells.sum() + number < cageSum;
    }


    /**
     * Numeric array of cells \
     * *Method used internaly only*
     *
     * Returns:
     *     Range of the numbers in `this`
     */
    private auto ncells() @property
    {
        return cells.map!(x => x.number);
    }


    /**
     * Checks if `this` is full \
     * A **Cage** is full when there is just one `0` in it \
     * The reason being, the number isn't placed in the puzzle until
     *     it's considered valid \
     * *Method used internaly only*
     *
     * Examples:
     * ---
     * !this.isComplete();
     * ---
     *
     * Returns:
     *     `true` if it's filled with numbers
     *     `false` otherwise
     */
    private bool isComplete()
    {
        return count(ncells, 0) == 1;
    }


    /**
     * Appends cells to `this` \
     * *Method used internaly only*
     *
     * Examples:
     * ---
     * this.add(new Cell(...), new Cell(...), ...)
     * ---
     *
     * Params:
     *     cells = cells to add
     */
    private void add(Cell[] cells ...)
    {
        foreach (ref Cell cell; cells)
        {
            if(!canFind(this.cells, cell))
                this.cells ~= cell;
        }
    }
}


@("Cage: ctor")
unittest
{
    const Cage cage = new Cage(5, new Cell(0), new Cell(0));

    assert(cage.cageSum == 5);
    assert(cage.possibleSolutions == [[2,3],[1,4]]);
    assert(cage.cells.length == 2);
}


@("Cage: valid check")
unittest
{
    Cage cage = new Cage(5, new Cell(0), new Cell(2));

    assert(cage.isValid(3));
    assert(!cage.isValid(2));
}


@("Cage: search")
unittest
{
    Cell cell = new Cell(0);
    Cage cage = new Cage(5, cell, new Cell(2));

    assert(cage.contains(cell));
    assert(!cage.contains(new Cell(2)));

    assert(cage.contains(2));
}


@("Cage: complete check")
unittest
{
    Cage cage = new Cage(5, new Cell(0), new Cell(2));

    assert(cage.isComplete());
}


@("Cage: numeric cells")
unittest
{
    Cage cage = new Cage(5, new Cell(2), new Cell(0));

    assert(cage.ncells.array == [2,0]);
}


@("Cage: add cells")
unittest
{
    Cell cell = new Cell(2);
    Cage cage = new Cage(5, cell, new Cell(0));

    assert(cage.cells.length == 2);

    // if we were to add a repeated cell in the ctor...
    cage.add(cell);

    assert(cage.cells.length == 2);
}
