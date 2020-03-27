module grid.cage;

import grid.cell;

class Cage
{
    // FIXME: cage: change visibility attribute
    public Cell[] cells;

    this(Cell[] cells ...)
    {
        foreach (ref Cell cell; cells)
        {
            this.cells ~= cell;
        }
    }

    // TODO: cage: implement methods
}
