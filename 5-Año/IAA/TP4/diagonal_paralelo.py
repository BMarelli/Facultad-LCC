from pandas import DataFrame
import numpy as np

def create_points_diagonal(d: int, n: int, C: float) -> DataFrame:
    '''
    create_points_diagonal: int -> int -> float -> DataFrame
    d: Dimension de los puntos
    n: Cantidad de puntos a crear
    C: Flotante para calcular la desviación estándar

    '''
    
    center0, center1 = np.array([-1]*d), np.array([1]*d)
    cov = np.diag([(C*np.sqrt(d))**2]*d)
    mid = n // 2

    # Generate randoms points
    class0 = np.random.multivariate_normal(center0, cov, mid)
    class1 = np.random.multivariate_normal(center1, cov, n-mid)
    
    # Add class column
    class0 = np.c_[class0, np.zeros(mid)]
    class1 = np.c_[class1, np.ones(n-mid)]
    dataframe: DataFrame = DataFrame(data=np.r_[class0, class1], columns=list(range(d))+['CLASS'])

    return dataframe

def create_points_paralelo(d: int, n: int, C: float) -> DataFrame:
    '''
    create_points_paralelo: int -> int -> float -> DataFrame
    d: Dimension de los puntos
    n: Cantidad de puntos a crear
    C: Flotante para calcular la desviación estándar

    '''
    
    center0, center1 = np.array([-1]+[0]*(d-1)), np.array([1]+[0]*(d-1))
    cov = np.diag([C**2]*d)
    mid = n // 2

    # GGeneramos los puntos alertorios
    class0 = np.random.multivariate_normal(center0, cov, mid)
    class1 = np.random.multivariate_normal(center1, cov, n-mid)
    
    # Agregamos la columna de clases
    class0 = np.c_[class0, np.zeros(mid)]
    class1 = np.c_[class1, np.ones(n-mid)]

    # Creamos el DataFrame
    dataframe: DataFrame = DataFrame(data=np.r_[class0, class1], columns=list(range(d))+['CLASS'])

    return dataframe
