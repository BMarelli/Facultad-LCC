from matplotlib.pyplot import clf
from sklearn.naive_bayes import GaussianNB, CategoricalNB, MultinomialNB
from sklearn.preprocessing import KBinsDiscretizer
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics import accuracy_score
from pandas import DataFrame
import pickle

class GaussianNaiveBayes:
    clf: GaussianNB

    # Errors
    train_error: float | None = None
    test_error: float | None = None

    def __init__(self) -> None:
        self.clf = GaussianNB()

    def save(self, filename: str) -> None:
        with open(filename, 'wb') as file:
            pickle.dump(self, file, pickle.HIGHEST_PROTOCOL)

    def train(self, x_train: DataFrame, y_train: DataFrame) -> None:
        self.clf.fit(x_train, y_train)

        pred = self.clf.predict(x_train)
        self.train_error = 1 - accuracy_score(y_train, pred)

    def predict(self, df_test: DataFrame) -> DataFrame:
        nCols = len(df_test.columns)
        
        pred = self.clf.predict(df_test.loc[:, range(nCols-1)])
        self.test_error = 1 - accuracy_score(df_test.loc[:, 'CLASS'], pred)
        df_test['CLASS'] = pred

        return df_test


class CategoricalNaiveBayes:
    clf: CategoricalNB
    discretizer: KBinsDiscretizer
    n_bins: int

    # Errors
    train_error: float | None = None
    val_error: float | None = None
    test_error: float | None = None

    def __init__(self, n_bins: int) -> None:
        self.clf = CategoricalNB(min_categories=n_bins)
        self.discretizer = KBinsDiscretizer(n_bins=n_bins, encode='ordinal', strategy='uniform')
        self.n_bins = n_bins

    def save(self, filename: str) -> None:
        with open(filename, 'wb') as file:
            pickle.dump(self, file, pickle.HIGHEST_PROTOCOL)

    def train(self, x_train: DataFrame, y_train: DataFrame, x_val: DataFrame, y_val: DataFrame) -> None:
        self.discretizer.fit(x_train)
        d_x_train = self.discretizer.transform(x_train)
        d_x_val = self.discretizer.transform(x_val)
        

        self.clf.fit(d_x_train, y_train)

        train_pred = self.clf.predict(d_x_train)
        val_pred = self.clf.predict(d_x_val)

        self.train_error = 1 - accuracy_score(y_train, train_pred)
        self.val_error = 1 - accuracy_score(y_val, val_pred)
    
    def predict(self, x_test: DataFrame, y_test) -> None:
        d_x_test = self.discretizer.transform(x_test)
        
        pred = self.clf.predict(d_x_test)
        self.test_error = 1 - accuracy_score(y_test, pred)

        return pred

class MultinomialNaiveBayes:
    clf: MultinomialNB
    vect: CountVectorizer
    alpha: float
    len_dict: int

    # Errors
    train_error: float | None = None
    val_error: float | None = None
    test_error: float | None = None

    def __init__(self, alpha: float, len_dict: int) -> None:
        self.clf = MultinomialNB(alpha=alpha)
        self.vect = CountVectorizer(stop_words='english',max_features=len_dict)
        self.alpha = alpha
        self.len_dict = len_dict

    def save(self, filename: str) -> None:
        with open(filename, 'wb') as file:
            pickle.dump(self, file, pickle.HIGHEST_PROTOCOL)

    def train(self, x_train: DataFrame, y_train: DataFrame, x_val: DataFrame, y_val: DataFrame) -> None:
        vec_x_train = self.vect.fit_transform(x_train).toarray()
        vec_x_val = self.vect.transform(x_val).toarray()
        
        self.clf.fit(vec_x_train, y_train)

        train_pred = self.clf.predict(vec_x_train)
        val_pred = self.clf.predict(vec_x_val)

        self.train_error = 1 - accuracy_score(y_train, train_pred)
        self.val_error = 1 - accuracy_score(y_val, val_pred)
    
    def predict(self, x_test: DataFrame, y_test) -> None:
        vec_x_test = self.vect.transform(x_test).toarray()
        
        pred = self.clf.predict(vec_x_test)
        self.test_error = 1 - accuracy_score(y_test, pred)

        return pred

class NotNaiveBayes:
    pass
