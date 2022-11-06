from pandas import DataFrame
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score
import pickle

class DecisionTreeService:
    clf: DecisionTreeClassifier

    # Errors
    train_error: float | None = None
    test_error: float | None = None

    def __init__(self) -> None:
        self.clf = DecisionTreeClassifier(criterion="entropy",
                                          min_impurity_decrease=0.005,
                                          random_state=0,
                                          min_samples_leaf=5)

    def save(self, filename: str) -> None:
        with open(filename, 'wb') as file:
            pickle.dump(self, file, pickle.HIGHEST_PROTOCOL)

    def train(self, x_train: DataFrame, y_train: DataFrame) -> None:
        self.clf.fit(x_train, y_train)

        train_pred = self.clf.predict(x_train)

        self.train_error = 1 - accuracy_score(y_train, train_pred)

    def predict(self, df_test: DataFrame) -> DataFrame:
        n_cols = len(df_test.columns)

        pred = self.clf.predict(df_test.loc[:, range(n_cols-1)])
        self.test_error = 1 - accuracy_score(df_test.loc[:, 'CLASS'], pred)
        df_test['CLASS'] = pred

        return df_test
