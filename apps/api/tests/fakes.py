"""Query doubles that actually apply filter methods (unlike a no-op FakeQuery)."""

from uuid import uuid4


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


class MutableQuery:
    """Select / update / insert against a shared in-memory store."""

    def __init__(self, store, name, op="select", payload=None):
        self.store = store
        self.name = name
        self.op = op
        self.payload = payload
        self.applied: list[tuple] = []
        self._limit = None
        self._order_col = None
        self._order_desc = False

    def select(self, *_args, **_kwargs):
        return self

    def eq(self, column, value):
        self.applied.append(("eq", column, value))
        return self

    def in_(self, column, values):
        self.applied.append(("in_", column, list(values)))
        return self

    def neq(self, column, value):
        self.applied.append(("neq", column, value))
        return self

    def or_(self, *_args, **_kwargs):
        return self

    def order(self, column, desc=False, **_kwargs):
        self._order_col = column
        self._order_desc = desc
        return self

    def range(self, *_args, **_kwargs):
        return self

    def limit(self, n, *_args, **_kwargs):
        self._limit = n
        return self

    def _matches(self, row: dict) -> bool:
        for kind, column, value in self.applied:
            if kind == "eq" and row.get(column) != value:
                return False
            if kind == "neq" and row.get(column) == value:
                return False
            if kind == "in_" and row.get(column) not in value:
                return False
        return True

    def execute(self):
        rows = self.store.setdefault(self.name, [])
        if self.op == "insert":
            payloads = self.payload if isinstance(self.payload, list) else [dict(self.payload)]
            inserted = []
            for item in payloads:
                row = dict(item)
                row.setdefault("id", str(uuid4()))
                rows.append(row)
                inserted.append(row)
            return FakeResult(inserted)
        matched = [row for row in rows if self._matches(row)]
        if self.op == "update":
            for row in matched:
                row.update(self.payload or {})
            return FakeResult(matched)
        out = list(matched)
        if self._order_col:
            out.sort(key=lambda row: row.get(self._order_col) or "", reverse=self._order_desc)
        if self._limit is not None:
            out = out[: self._limit]
        return FakeResult(out)


class MutableTable:
    def __init__(self, store, name):
        self.store = store
        self.name = name

    def select(self, *_args, **_kwargs):
        return MutableQuery(self.store, self.name, "select")

    def update(self, payload):
        return MutableQuery(self.store, self.name, "update", dict(payload))

    def insert(self, payload):
        return MutableQuery(self.store, self.name, "insert", payload)


class MutableClient:
    """In-memory Supabase stand-in that persists update/insert across calls."""

    def __init__(self, rows_by_table):
        self.rows_by_table = {key: [dict(row) for row in rows] for key, rows in rows_by_table.items()}

    def table(self, name):
        return MutableTable(self.rows_by_table, name)
