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

