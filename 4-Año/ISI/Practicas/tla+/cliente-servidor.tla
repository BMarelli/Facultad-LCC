\* Cuando un cliente web solicita un archivo HTML a un servidor web la comunicacion es
\* asincrona, es decir: un navegador solicita un archivo HTML, se corta la conexion y finalmente
\* el servidor se comunica con el cliente, cuando puede satisfacer el pedido, para enviarle el
\* archivo solicitado o el error apropiado.
\* Tambien es asincrona la comunicacion cuando el cliente se autentica ante servidor: se envian
\* los datos, se corta la conexion, el servidor verifica los datos, si son correctos registra al cliente
\* y retorna el error apropiado.
\* Los archivos HTML que almacena el servidor pueden estar restringidos a ciertos clientes. Si
\* este es el caso, el cliente que solicita uno de estos archivos debe estar autenticado y debe ser
\* uno de los clientes autorizados a ver el archivo.
\* Por el contrario, cuando un cliente web desea enviarle un archivo al servidor la comunicacion
\* es asincrona, aunque el servidor puede atender varios pedidos a la vez.
\* Un servidor web puede atender hasta M clientes simultaneamente


\* Auth(user) devuelve True si el usuario se puede autenticar
\* Send(ip, info) envia info a la ip
\* Limite de usuarios conectados == M
\* El conjunto de las IP == IP
\* El conjunto de archivos == Files
\* El conjunto de nombres de archivos == FileName
\* El conjunto de usuarios == Users
\* El conjunto de requests == Req
\* Los usuarios authenticados == users
\* Los archivos en el servidor == files
\* Usuarios autorizados a leer el archio file == file.auth
\* Cola de requests para procesar == queue

--------------------- MODULE SERVIDOR ---------------------
EXTENDS Naturals, Sequences
CONSTANTS M, Auth(_), Send(_,_), IP, Files, Users, Req, FileName
ASSUME M \in Nat, M > 0,
       Auth(_): BOOLEAN,
       Send(_,_): BOOLEAN,
       Req \in [type: {"D", "U", "C"}, ip: IP, body \in (FileName \cup (FileName x Files) \cup Users)],
       FileName \cap Users = \empty
VARIABLES users, files, queue

TypeInv == /\ files \in [FileName -> [auth: SUBSET IP, file: Files]]
           /\ users \in [Users -> [Ip: IP, auth: {0,1}]]
           /\ queue \in Seq(Req)
           /\ \A r \in Req : \/ (r.type = "D" => r.body \in FileName)
                             \/ (r.type = "U" => r.body \in (FileName x Files))
                             \/ (r.type = "C" => r.body \in Users)
vars = << users, files, queue >>
-----------------------------------------------------------

Init == users = {} /\ queue = <>
connectNewUser(u, ip) == /\ Len(queue) < M
                         /\ queue' = Append(queue, [type="C", ip=ip, body=u])
                         /\ UNCHANGED < files, users >
authNewUser(r) == /\ r.type = "C"
                  /\ IF Auth(r.body)
                     THEN /\ users' = [users EXCEPT ![r.body].ip=r.ip, ![r.body].auth=1]
                          /\ Send(r.ip, "Ok connection")
                          /\ UNCHANGED < files >
                     ELSE /\ Send(r.ip, "ERROR! No Auth")
                          /\ UNCHANGED vars
getFile(u, name) == /\ users[u].auth = 1
                    /\ Len(queue) < M
                    /\ queue' = Append(queue, [type="D", ip=u.ip, body=name])
                    /\ UNCHANGED < users, files >
sendFile(u, name, file) == /\ users[u].auth = 1
                           /\ Len(queue) < M
                           /\ queue' = Append(queue, [type="U", ip=u.ip, body=<name, file>])
                           /\ UNCHANGED < users, files >
fileQueue(r) == \/ /\ r.type = "D"
                   /\ LET file = files[r.body]
                      IN /\ r.ip \in file.auth
                         /\ Send(r.ip, file)
                         /\ UNCHANGED < users, files >
                \/ /\ r.type = "U"
                   /\ files' = [files EXCEPT ![r.body[1]] = [auth={r.ip}, file=r.body[2]]]
                   /\ UNCHANGED < users >
manageQueue == LET r = Head(queue)
               IN /\ authNewUser(r) \/ fileQueue(r)
                  /\ queue' = Tail(queue)

Next == \/ \E u in Users : \/ \E ip \in IP : connectNewUser(u, ip)
                           \/ \E name \in FileName : \/ getFile(u, name)
                                                     \/ \E file \in File: sendFile(u, name, file)
        \/ manageQueue

Spec == Init /\ [][Next]_vars /\ WF_vars(manageQueue)

-----------------------------------------------------------

THEOREM Spec => []TypeInv

===========================================================
