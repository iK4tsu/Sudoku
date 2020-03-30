module grid.cell;

// FIXME: cell: refactor to struct
class Cell
{
    public uint number;
    public const bool isBlocked;

    this(in uint number)
    {
        this.number = number;
        isBlocked = (number != 0);
    }
}


@("Cell: ctor")
unittest
{
    Cell cell1 = new Cell(2);
    Cell cell2 = new Cell(0);

    assert(cell1.number == 2);
    assert(cell1.isBlocked);
    assert(!cell2.isBlocked);
}
