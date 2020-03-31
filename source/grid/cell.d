module grid.cell;

class Cell
{
    public uint number;
    private bool _isBlocked;

    this(in uint number)
    {
        this.number = number;
        _isBlocked = (number != 0);
    }


    public auto isBlocked() @property
    {
        return _isBlocked;
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
