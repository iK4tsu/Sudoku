module grid.number;

class Number
{
    public uint n;
    public bool blocked;

    this(in uint n)
    {
        this.n = n;
        blocked = n != 0;
    }
}


@("Number: ctor")
unittest
{
    Number number2 = new Number(2);
    Number number0 = new Number(0);

    assert(number2.n == 2);
    assert(number2.blocked);
    assert(!number0.blocked);
}
