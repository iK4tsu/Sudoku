module grid.cage;

import std.algorithm : canFind, count, filter, isStrictlyMonotonic, map, sum;
import std.array     : array, join;
import std.range     : iota, repeat, replicate, chunks;

import algorithm.multiCartisianProduct;
import grid.cell;

class Cage
{
    // FIXME: cage: change visibility attribute
    public Cell[] cells;
    public uint[][] possibleSolutions;
    public const uint cageSum;


    this(in uint cageSum, Cell[] cells ...)
    {
        this.cageSum = cageSum;
        this.cells = cells.array;
        possibleSolutions = buildSolutions();
    }


    // TODO: cage: documentation
    private auto buildSolutions()
    {
        const auto maxseq = cageSum <= 9 ? cageSum + 1 : 10;
        uint[] A = iota(1U, maxseq).array;
        uint[][] B;
        for (size_t i; i < cells.length; i++) B ~= A;

        auto BB = multiCartisianProduct!uint(B);

        return BB
                .filter!(x => x.sum == cageSum)
                .filter!(x => x.isStrictlyMonotonic).array;
    }


    public bool contains(Cell cell)
    {
        return canFind(cells, cell);
    }


    public bool contains(in uint number)
    {
        return canFind(ncells, number);
    }


    public bool isValid(in uint number)
    {
        if (isComplete)
            return canFind(possibleSolutions.join, number) &&
                    ncells.sum() + number == cageSum;
        else
            return canFind(possibleSolutions.join, number) &&
                    ncells.sum() + number < cageSum;
    }


    public auto ncells() @property
    {
        return cells.map!(x => x.number);
    }


    public bool isComplete()
    {
        return count(ncells, 0) == 1;
    }
}


// TODO: cage: unittests
