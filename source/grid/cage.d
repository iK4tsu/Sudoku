module grid.cage;

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
    }


    {
    }

    // TODO: cage: implement methods
}
