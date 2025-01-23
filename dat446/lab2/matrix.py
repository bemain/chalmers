type Matrix = list[list[float]]

def is_empty(matrix: Matrix) -> bool:
    return len(matrix) == 0 or len(matrix[0]) == 0

def mat_filled(rows: int, columns: int, val: int) -> Matrix:
    return [[val] * columns for _ in range(rows)]


def transpose(matrix: Matrix) -> Matrix:   
    if is_empty(matrix): return matrix 

    rows = len(matrix)
    columns = len(matrix[0])
    
    res = mat_filled(columns, rows,  0)
    for row in range(rows):
        for column in range(columns):
            res[column][row] = matrix[row][column]

    return res

def powers(lst: list, a: int, b: int) -> Matrix:
    if len(lst) == 0: return [] 

    exponents = range(a, b+1)
    res = []
    for row in range(len(lst)):
        res.append([lst[row] ** exponent for exponent in exponents])
    
    return res

def matmul(A: Matrix, B: Matrix) -> Matrix:
    if (is_empty(A) and is_empty(B)): return []

    rows = len(A)
    columns = len(B[0])
    C = mat_filled(rows,  columns, 0)
    for i in range(rows):
        for j in range(columns):
            C[i][j] = sum([A[i][k] * B[k][j] for k in range(len(B))])
    return C


def invert(A: Matrix) -> Matrix:
    """Only works for 2x2 matrices."""
    a = A[0][0]
    b = A[0][1]
    c = A[1][0]
    d = A[1][1]
    det = a * d - b * c
    return [[d/det, -b/det],
            [-c/det, a/det]]


def loadtxt(fileName) -> Matrix:
    matrix: Matrix = []
    with open(fileName, encoding="utf-8") as file:
        for line in file.readlines():
            row = list(map(float, line.split()))
            matrix.append(row)
            
    return matrix


class Matrix:
    def __init__(self, rows: list[list[float]]):
        if (len(rows) != 0):
            rowSize = len(rows[0])
            for row in rows:
                assert len(row) == rowSize

        self._rows: list[list[float]] = rows


    @staticmethod
    def _filled_mat(rows: int, columns: int, val: int):
        return [[val] * columns for _ in range(rows)]
    
    @classmethod
    def filled(cls, rows: int, columns: int, val: int) -> Matrix:
        return cls(cls._filled_mat())
    
    @classmethod
    def powers(cls, lst: list, a: int, b: int) -> Matrix:
        if len(lst) == 0: return cls([])

        exponents = range(a, b+1)
        res = []
        for row in range(len(lst)):
            res.append([lst[row] ** exponent for exponent in exponents])
        
        return cls(res)

    @classmethod
    def loadtxt(cls, fileName) -> Matrix:
        rows = []
        with open(fileName, encoding="utf-8") as file:
            for line in file.readlines():
                row = list(map(float, line.split()))
                rows.append(row)
                
        return cls(rows)
    

    @property
    def rows(self) -> list[list[float]]:
        return self._rows
    
    @property
    def columns(self) -> list[list[float]]:
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
    
    def transposed(self) -> Matrix:
        return Matrix(self.columns)

    def inverted(self) -> Matrix:
        """Only works for 2x2 matrices."""
        a = self.rows[0][0]
        b = self.rows[0][1]
        c = self.rows[1][0]
        d = self.rows[1][1]
        det = a * d - b * c
        return [[d/det, -b/det],
                [-c/det, a/det]]

    def matmul(self, other: Matrix) -> Matrix:
        if (self.is_empty() and other.is_empty()): return []

        rows = len(self.rows)
        columns = len(other.rows[0])
        res = self._filled_mat(rows,  columns, 0)
        for i in range(rows):
            for j in range(columns):
                res[i][j] = sum([self.rows[i][k] * other.rows[k][j] for k in range(len(other.rows))])
        return Matrix(res)
    
    def __str__(self):
        return str(self.rows)
