"""Query doubles that actually apply filter methods (unlike a no-op FakeQuery)."""


class FakeResult:
    def __init__(self, data, count=None):
        self.data = data
        self.count = count if count is not None else len(data)


class FilteringQuery:
    def __init__(self, rows, applied=None):
        self.rows = [dict(row) for row in rows]
        self.applied: list[tuple] = list(applied or [])

    def select(self, *_args, **_kwargs):
        return self

    def eq(self, column, value):
        self.applied.append(("eq", column, value))
        self.rows = [row for row in self.rows if row.get(column) == value]
        return self

    def in_(self, column, values):
        allowed = list(values)
        self.applied.append(("in_", column, allowed))
        self.rows = [row for row in self.rows if row.get(column) in allowed]
        return self

    def neq(self, column, value):
        self.applied.append(("neq", column, value))
        self.rows = [row for row in self.rows if row.get(column) != value]
        return self

    def or_(self, *_args, **_kwargs):
        return self

    def order(self, *_args, **_kwargs):
        return self

    def range(self, *_args, **_kwargs):
        return self

    def limit(self, *_args, **_kwargs):
        return self

    def execute(self):
        return FakeResult(self.rows, count=len(self.rows))


class FilteringTable:
    def __init__(self, rows_by_table):
        self.rows_by_table = rows_by_table
        self.name = None

    def select(self, *_args, **_kwargs):
        rows = self.rows_by_table.get(self.name, [])
        return FilteringQuery(rows)


class FilteringClient:
    def __init__(self, rows_by_table):
        self.rows_by_table = rows_by_table

    def table(self, name):
        table = FilteringTable(self.rows_by_table)
        table.name = name
        return table
