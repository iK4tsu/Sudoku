module algorithm.multiCartisianProduct;

/**
 * Calculates the cartisian product of N arrays inside an array
 *
 * Params:
 *     T =     variable type
 *     range = matrix to process
 *
 * Returns: A T matrix type with the cartisian product
 *
 * Examples:
 * --------------------
 * int[] a = [1, 2], b[1, 4];
 * multiCartisianProduct!int([a, b]) == [[1, 1], [2, 1], [1, 4], [2, 4]];
 * --------------------
 *
 * Authors: Era Scarecrow
 * See_Also: https://forum.dlang.org/post/leugranlzvwcdizvmagf@forum.dlang.org
 */
auto multiCartisianProduct(T)(T[][] range)
{
    static struct Result
    {
        T[][] data;
        int iteration;
        int max;

        this(T[][] _d, int iter=0)
        {
            data = _d;
            iteration = iter;

            max = 1;
            foreach(a; _d) {
                if (a.length)
                    max *= a.length;
            }
        }

        T[] front()
        {
            int i = iteration;
            T[] val;

            foreach(d; data) {
                if (d.length) {
                    val ~= d[i % d.length];
                    i /= d.length;
                }
            }

            return val;
        }

        void popFront()
        {
            iteration++;
        }

        bool empty()
        {
            return iteration >= max;
        }
    }

    return Result(range);
}

@("MultiCartisianProduct: example test")
unittest
{
    import std.array: array;

    auto a = [1, 2], b = [1, 4];
    auto ab = [[1, 1], [2, 1], [1, 4], [2, 4]];

    assert(multiCartisianProduct!int([a,b]).array == ab);
}
