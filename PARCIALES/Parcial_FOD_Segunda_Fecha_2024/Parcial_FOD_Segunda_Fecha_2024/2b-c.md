### Estado inicial
                             8:2(150)7
                    2:0(120)3           7:4(210)6(300)1(600)9
    0:(30) 3:(130) 4:(160)(170) 6:(220)(230)(240)(250) 1:(400)(500) 9:(700)

### +280 
se genera overflow en el nodo 6, divido el mismo y promuevo la clave 240.
E/L: L8,L7,L6,E6,E5,E7
                             8:2(150)7
                    2:0(120)3           7:4(210)6(240)5(300)1(600)9
    0:(30) 3:(130) 4:(160)(170) 6:(220)(230) 5:(250)(280) 1:(400)(500) 9:(700)

### -120 
COmo la clave 120 no se encuentra en un nodo hoja primero debo remplazarlo por la clave mas chica de su subarbol derecho (clave 130). 
Esto genera un underflow en el nodo 3, como la politica es derecha deberia intentar redistribuir con el hermano adyacente derecho del nodo, pero este no existe ya que el nodo 3 se encuentra en un extremo derecho. 
por esto aplico la excepcion a la politica e intento redistribuir con el nodo adyacente izquierdo (nodo 0), esto no tiene exito ya que el nodo 0 no tiene la cantidad de elementos suficientes, 
por lo que debo concatenar el nodo 0 con el 3, liberando el nodo 3. 
El underflow se propaga el nodo 2, para solucionarlo intento redistribuir con su nodo adyacente derecho (nodo 7) lo cual tiene exito ya que el nodo 7 tiene elementos suficientes.

E/L L8, L2, L3, L0, E0, L7, E7, E2, E8

                             8:2(210)7
                    2:0(150)4           7:6(240)5(300)1(600)9
    0:(30)(130) 4:(160)(170) 6:(220)(230) 5:(250)(280) 1:(400)(500) 9:(700)