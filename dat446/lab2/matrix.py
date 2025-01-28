from typing import Self


class Matrix:
    """A 2-dimensional mathematical matrix of floating-point numbers."""
    def __init__(self, rows: list[list[float]]):
        if (len(rows) != 0):
            rowSize = len(rows[0])
            for row in rows:
                assert len(row) == rowSize

        self._rows: list[list[float]] = rows


    @staticmethod
    def _filled_mat(rows: int, columns: int, val: float) -> list[list[float]]:
        return [[val] * columns for _ in range(rows)]
    
    @classmethod
    def filled(cls, rows: int, columns: int, value: int) -> Self:
        """Create a matrix with a fixed number of [rows] and [columns] by filling it with the given [value]."""
        return cls(cls._filled_mat(rows, columns, value))
    
    @classmethod
    def powers(cls, lst: list[float], a: int, b: int) -> Self:
        """For each number in the original [lst] it creates one row by raising the number to each exponent between [a] and [b]."""
        if len(lst) == 0: return cls([])

        exponents = range(a, b+1)
        res = []
        for row in range(len(lst)):
            res.append([lst[row] ** exponent for exponent in exponents])
        
        return cls(res)

    @classmethod
    def loadtxt(cls, fileName) -> Self:
        """Load a matrix from a file. 
        
        Values should be separated by whitespace characters. A new line indicates a new row."""
        rows = []
        with open(fileName, encoding="utf-8") as file:
            for line in file.readlines():
                row = list(map(float, line.split()))
                rows.append(row)
                
        return cls(rows)
    

    @property
    def rows(self) -> list[list[float]]:
        """The rows in this matrix."""
        return self._rows
    
    @property
    def columns(self) -> list[list[float]]:
        """The columns in this matrix."""
        if self.is_empty(): return []
        return [[row[j]  for row in self.rows] for j in range(len(self.rows[0]))] 

    @property
    def numRows(self) -> int:
        """The number of rows in this matrix."""
        return len(self.rows)

    @property
    def numColumns(self) -> int:
        """The number of columns in this matrix."""
        if self.is_empty(): return 0
        return len(self.rows[0])
    
    
    def is_empty(self) -> bool:
        """Whether this matrix is empty of elements."""
        return len(self.rows) == 0 or len(self.rows[0]) == 0
    
    def transposed(self) -> Self:
        """Transpose this matrix and return the transposed matrix.

        This does not modify the original matrix."""
        return Matrix(self.columns)

    def inverted(self) -> Self:
        """Invert this matrix and return the inverted matrix.

        This does not modify the original matrix.
        
        Currently only works for 2x2 matrices."""
        a = self.rows[0][0]
        b = self.rows[0][1]
        c = self.rows[1][0]
        d = self.rows[1][1]
        det = a * d - b * c
        return Matrix([[d/det, -b/det],
                [-c/det, a/det]])

    def matmul(self, other: Self) -> Self:
        """Multiply this matrix with [other] using matrix multiplication."""
        if (self.is_empty() and other.is_empty()): return Matrix([])

        rows = len(self.rows)
        columns = len(other.rows[0])
        res = self._filled_mat(rows,  columns, 0)
        for i in range(rows):
            for j in range(columns):
                res[i][j] = sum([self.rows[i][k] * other.rows[k][j] for k in range(len(other.rows))])
        return Matrix(res)

    def __matmul__(self, other: Self) -> Self:
        return self.matmul(other)
    
    def __str__(self) -> str:
        return str(self.rows)



type MatrixRows = list[list[float]]

def transpose(matrix: MatrixRows) -> MatrixRows: 
    return Matrix(matrix).transposed().rows

def powers(lst: list[float], a: int, b: int) -> MatrixRows:
    return Matrix.powers(lst, a, b).rows

def matmul(A: MatrixRows, B: MatrixRows) -> MatrixRows:
    return (Matrix(A) @ Matrix(B)).rows

def invert(A: MatrixRows) -> MatrixRows:
    """Only works for 2x2 matrices."""
    return Matrix(A).inverted().rows

def loadtxt(fileName) -> MatrixRows:
    return Matrix.loadtxt(fileName).rows