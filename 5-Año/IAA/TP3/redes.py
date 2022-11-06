from sklearn.neural_network import MLPRegressor
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import zero_one_loss, mean_squared_error
from pandas import DataFrame
import pickle

class RedClassifier:
    net: MLPClassifier
    eval_times: int

    # Errors
    train_error: float = None
    val_error: float = None
    test_error: float = None

    # Errors during training
    train_errors: list[float] = []
    val_errors: list[float] = []
    test_errors: list[float] = []

    # Variables for classifier
    N2: int
    eta: float
    alpha: float
    gamma: float
    time4training: int


    def __init__(self, N2: int, eta: float, alpha: float, time4training: int, eval_times: int, gamma=0.0) -> None:
        self.eval_times = eval_times
        self.N2 = N2
        self.eta = eta
        self.alpha = alpha
        self.gamma = gamma
        self.time4training = time4training
        self.val_error = None
    
    def save(self, filename: str) -> None:
        with open(filename, 'wb') as file:
            pickle.dump(self, file, pickle.HIGHEST_PROTOCOL)

    def train(self, x_train: DataFrame, x_val: DataFrame, y_train: DataFrame, y_val: DataFrame) -> None:
        net = MLPClassifier(hidden_layer_sizes=(self.N2,),
                            activation='logistic',
                            solver='sgd', alpha=self.gamma,
                            batch_size=1, learning_rate='constant',
                            learning_rate_init=self.eta,momentum=self.alpha,
                            nesterovs_momentum=False,tol=0.0,
                            warm_start=True,
                            max_iter=self.time4training)
        
        for _ in range(self.eval_times):
            net.fit(x_train, y_train)

            pred_train = net.predict(x_train)
            pred_val = net.predict(x_val)

            train_error = zero_one_loss(y_train, pred_train)
            val_error = zero_one_loss(y_val, pred_val)

            if not self.val_error or val_error < self.val_error:
                self.net = net
                self.train_error = train_error
                self.val_error = val_error

    def train_val_predict(self, x_train: DataFrame, x_val: DataFrame,
                      y_train: DataFrame, y_val: DataFrame,
                      df_test: DataFrame) -> None:
        net = MLPClassifier(hidden_layer_sizes=(self.N2,),
                            activation='logistic',
                            solver='sgd', alpha=self.gamma,
                            batch_size=1, learning_rate='constant',
                            learning_rate_init=self.eta,momentum=self.alpha,
                            nesterovs_momentum=False,tol=0.0,
                            warm_start=True,
                            max_iter=self.time4training)
        
        train_errors, val_errors, test_errors = [], [], []
        
        for _ in range(self.eval_times):
            net.fit(x_train, y_train)

            pred_train = net.predict(x_train)
            pred_val = net.predict(x_val)
            pred_test = net.predict(df_test.loc[:, range(len(df_test.columns)-1)])

            train_error = zero_one_loss(y_train, pred_train)
            val_error = zero_one_loss(y_val, pred_val)
            test_error = zero_one_loss(df_test.loc[:, 'CLASS'], pred_test)

            train_errors.append(train_error)
            val_errors.append(val_error)
            test_errors.append(test_error)

            if not self.val_error or val_error < self.val_error:
                self.net = net
                self.train_error = train_error
                self.val_error = val_error
                self.test_error = test_error
            
        self.train_errors = train_errors
        self.val_errors = val_errors
        self.test_errors = test_errors
    
    def train_predict(self, x_train: DataFrame, y_train: DataFrame, df_test: DataFrame) -> None:
        net = MLPClassifier(hidden_layer_sizes=(self.N2,),
                            activation='logistic',
                            solver='sgd', alpha=self.gamma,
                            batch_size=1, learning_rate='constant',
                            learning_rate_init=self.eta,momentum=self.alpha,
                            nesterovs_momentum=False,tol=0.0,
                            warm_start=True,
                            max_iter=self.time4training)
        
        train_errors, test_errors = [], []
        
        for _ in range(self.eval_times):
            net.fit(x_train, y_train)

            pred_train = net.predict(x_train)
            pred_test = net.predict(df_test.loc[:, range(len(df_test.columns)-1)])

            train_error = zero_one_loss(y_train, pred_train)
            test_error = zero_one_loss(df_test.loc[:, 'CLASS'], pred_test)

            train_errors.append(train_error)
            test_errors.append(test_error)

            if not self.test_error or test_error < self.test_error:
                self.net = net
                self.train_error = train_error
                self.test_error = test_error
            
        self.train_errors = train_errors
        self.test_errors = test_errors
    
    def predict(self, df_test: DataFrame) -> DataFrame:
        nCols = len(df_test.columns)
        pred = self.net.predict(df_test.loc[:,range(nCols-1)])
        self.test_error = zero_one_loss(pred, df_test.loc[:, 'CLASS'])
        df_test['CLASS'] = pred
        
        return df_test

class RedRegressor:
    net: MLPRegressor
    eval_times: int

    # Errors
    train_error: float = None
    val_error: float = None
    test_error: float = None

    # Errors during training
    train_errors: list[float] = []
    val_errors: list[float] = []
    test_errors: list[float] = []

    # Variables for classifier
    N2: int
    eta: float
    alpha: float
    gamma: float
    time4training: int


    def __init__(self, N2: int, eta: float, alpha: float, time4training: int, eval_times: int, gamma=0.0) -> None:
        self.eval_times = eval_times
        self.N2 = N2
        self.eta = eta
        self.alpha = alpha
        self.gamma = gamma
        self.time4training = time4training
    
    def save(self, filename: str) -> None:
        with open(filename, 'wb') as file:
            pickle.dump(self, file, pickle.HIGHEST_PROTOCOL)

    def train(self, x_train: DataFrame, x_val: DataFrame, y_train: DataFrame, y_val: DataFrame) -> None:
        net = MLPRegressor(hidden_layer_sizes=(self.N2,),
                            activation='logistic',
                            solver='sgd', alpha=self.gamma,
                            batch_size=1, learning_rate='constant',
                            learning_rate_init=self.eta,momentum=self.alpha,
                            nesterovs_momentum=False,tol=0.0,
                            warm_start=True,
                            max_iter=self.time4training)
        
        for _ in range(self.eval_times):
            net.fit(x_train, y_train)

            pred_train = net.predict(x_train)
            pred_val = net.predict(x_val)

            train_error = mean_squared_error(y_train, pred_train)
            val_error = mean_squared_error(y_val, pred_val)

            if not self.val_error or val_error < self.val_error:
                self.net = net
                self.train_error = train_error
                self.val_error = val_error

    def train_val_predict(self, x_train: DataFrame, x_val: DataFrame,
                          y_train: DataFrame, y_val: DataFrame,
                          df_test: DataFrame) -> None:
        net = MLPRegressor(hidden_layer_sizes=(self.N2,),
                            activation='logistic',
                            solver='sgd', alpha=self.gamma,
                            batch_size=1, learning_rate='constant',
                            learning_rate_init=self.eta,momentum=self.alpha,
                            nesterovs_momentum=False,tol=0.0,
                            warm_start=True,
                            max_iter=self.time4training)
        
        train_errors, val_errors, test_errors = [], [], []
        
        for _ in range(self.eval_times):
            net.fit(x_train, y_train)

            pred_train = net.predict(x_train)
            pred_val = net.predict(x_val)
            pred_test = net.predict(df_test.loc[:, range(len(df_test.columns)-1)])

            train_error = mean_squared_error(y_train, pred_train)
            val_error = mean_squared_error(y_val, pred_val)
            test_error = mean_squared_error(df_test.loc[:, 'CLASS'], pred_test)

            train_errors.append(train_error)
            val_errors.append(val_error)
            test_errors.append(test_error)

            if not self.val_error or val_error < self.val_error:
                self.net = net
                self.train_error = train_error
                self.val_error = val_error
                self.test_error = test_error
            
        self.train_errors = train_errors
        self.val_errors = val_errors
        self.test_errors = test_errors

    def train_predict(self, x_train: DataFrame, y_train: DataFrame,
                      df_test: DataFrame) -> None:
        net = MLPRegressor(hidden_layer_sizes=(self.N2,),
                            activation='logistic',
                            solver='sgd', alpha=self.gamma,
                            batch_size=1, learning_rate='constant',
                            learning_rate_init=self.eta,momentum=self.alpha,
                            nesterovs_momentum=False,tol=0.0,
                            warm_start=True,
                            max_iter=self.time4training)
        
        train_errors, test_errors = [], []
        
        for _ in range(self.eval_times):
            net.fit(x_train, y_train)

            pred_train = net.predict(x_train)
            pred_test = net.predict(df_test.loc[:, range(len(df_test.columns)-1)])

            train_error = mean_squared_error(y_train, pred_train)
            test_error = mean_squared_error(df_test.loc[:, 'CLASS'], pred_test)

            train_errors.append(train_error)
            test_errors.append(test_error)

            if not self.test_error or test_error < self.test_error:
                self.net = net
                self.train_error = train_error
                self.test_error = test_error
            
        self.train_errors = train_errors
        self.test_errors = test_errors

    def predict(self, df_test: DataFrame) -> DataFrame:
        nCols = len(df_test.columns)
        pred = self.net.predict(df_test.loc[:,range(nCols-1)])
        self.test_error = mean_squared_error(pred, df_test.loc[:, 'CLASS'])
        df_test['CLASS'] = pred
        
        return df_test
