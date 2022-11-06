from pandas import DataFrame
import random
import numpy as np

def generate_polars_points(n: int, r: int) -> tuple[list[float], list[float]]:
    ro = [r * np.sqrt(random.random()) for _ in range(n)]
    theta = [2 * np.pi * random.random() for _ in range(n)]
    return ro, theta

def classify_polars_points(ro: list[float], theta: list[float]) -> DataFrame:
    def fun1(t):
        return t/(4*np.pi)

    def fun2(t):
        return (t+np.pi)/(4*np.pi)
    
    def condition(t, r):
        return (fun1(t) <= r and r <= fun2(t) 
                or fun1(t+2*np.pi) <= r and r <= fun2(t+2*np.pi)
                or fun1(t-2*np.pi) <= r and r <= fun2(t-2*np.pi))

    classes = [1 if condition(t, r) else 0 for (r,t) in zip(ro, theta)]
    
    return classes

def generate_spirals_dataframe(n: int, r: int):
    ro, theta = generate_polars_points(n, r)
    classes = classify_polars_points(ro, theta)
    
    xs = [r * np.cos(t) for (r, t) in zip(ro, theta)]
    ys = [r * np.sin(t) for (r, t) in zip(ro, theta)]

    df = DataFrame({0:xs, 1:ys, "CLASS": classes})
    return df
