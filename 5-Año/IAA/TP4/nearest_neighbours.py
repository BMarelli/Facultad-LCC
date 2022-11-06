from pandas import DataFrame
from sklearn.neighbors import KNeighborsClassifier, KNeighborsRegressor
from sklearn.neighbors import RadiusNeighborsClassifier, RadiusNeighborsRegressor
from sklearn.metrics import accuracy_score, mean_squared_error
import pickle

class NNService:
    clf: KNeighborsClassifier | KNeighborsRegressor | RadiusNeighborsClassifier | RadiusNeighborsRegressor

    # Errors

    train_error: float | None = None
    val_error: float | None = None
    test_error: float | None = None

    def save(self, filename: str) -> None:
        with open(filename, 'wb') as file:
            pickle.dump(self, file, pickle.HIGHEST_PROTOCOL)

    def train(self, x_train: DataFrame, y_train: DataFrame, x_val: DataFrame=None, y_val: DataFrame=None) -> None:
        self.clf.fit(x_train, y_train)

        train_pred = self.clf.predict(x_train)
        if self.clf is KNClassifier or self.clf is RadiusNeighborsClassifier:
            self.train_error = 1 - accuracy_score(y_train, train_pred)
        else:
            self.train_error = mean_squared_error(y_train, train_pred)
        if x_val is not None and y_val is not None:
            val_pred = self.clf.predict(x_val)
            if self.clf is KNClassifier or self.clf is RadiusNeighborsClassifier:
                self.val_error = 1 - accuracy_score(y_val, val_pred)
            else:
                self.val_error = mean_squared_error(y_val, val_pred)

    def predict(self, df_test: DataFrame) -> DataFrame:
        n_cols = len(df_test.columns)

        pred = self.clf.predict(df_test.loc[:, range(n_cols-1)])
        if self.clf is KNClassifier or self.clf is RadiusNeighborsClassifier:
            self.test_error = 1 - accuracy_score(df_test.loc[:, 'CLASS'], pred)
        else:
            self.test_error = mean_squared_error(df_test.loc[:, 'CLASS'], pred)
        df_test['CLASS'] = pred
        
        return df_test

class KNClassifier(NNService):
    k: int
    weights: str | None = None

    def __init__(self, k: int, weights: str | None = None) -> None:
        if weights:
            self.clf = KNeighborsClassifier(n_neighbors=k, weights=weights)
            self.k = k
            self.weights = weights
        else:
            self.clf = KNeighborsClassifier(n_neighbors=k)
            self.k = k

class KNRegressor(NNService):
    k: int
    weights: str | None = None

    def __init__(self, k: int, weights: str | None = None) -> None:
        if weights:
            self.clf = KNeighborsRegressor(n_neighbors=k, weights=weights)
            self.k = k
            self.weights = weights
        else:
            self.clf = KNeighborsRegressor(n_neighbors=k)
            self.k = k

class RNClassifier(NNService):
    r: int
    weights: str | None = None

    def __init__(self, r: int, weights: str | None = None) -> None:
        if weights:
            self.clf = RadiusNeighborsClassifier(radius=r, weights=weights)
            self.r = r
            self.weights = weights
        else:
            self.clf = RadiusNeighborsClassifier(radius=r)
            self.r = r

class RNClassifier(NNService):
    def __init__(self, r: int, weights: str | None = None) -> None:
        if weights:
            self.clf = RadiusNeighborsRegressor(radius=r, weights=weights)
            self.r = r
            self.weights = weights
        else:
            self.clf = RadiusNeighborsRegressor(radius=r)
            self.r = r
