program arbolito;
const 
    ORDEN = 5;
type 
    tnodo = record 
        hijos: array [1..ORDEN] of integer;
        claves: array [1..ORDEN-1] of integer;
        enlaces: array [1..ORDEN-1] of integer;
        cant_elementos:integer;
    end;

    tindice = file of tnodo;