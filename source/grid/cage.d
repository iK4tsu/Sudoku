module grid.cage;

import grid.cell;

class Cage
{
    public Cell[] cells;

    this(Cell[] cells ...)
    {
        foreach (ref Cell cell; cells)
        {
            this.cells ~= cell;
        }
    }
}
