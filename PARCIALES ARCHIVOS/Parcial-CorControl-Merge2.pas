program parcial;

const
    VALOR_ALTO = 9999;
    DIMF = 3; {Cantidad de restaurantes}

type
    producto = record
        codigo: integer;
        nombre: string;
        desc: string;
        codigo_barras: integer;
        categoria: string;
        stock_actual: integer;
        stock_minimo: integer;
    end;

    pedido = record
        codigo: integer;
        cant_pedida: integer;
        desc: string;
    end;

    archivoM = file of producto;
    archivoD = file of pedido;

    vector_archivoD = array[1..DIMF] of archivoD; {array con los pedidos de cada restaurante}
    vector_registroD = array[1..DIMF] of pedido; {donde voy a ir guardando el registro de cada restaurante}

procedure leerMaestro(var m: archivoM; var dato: producto);
begin
    if not eof(m) then
        Read(m, dato)
    else
        dato.codigo := VALOR_ALTO;
end;

procedure leerDetalle(var d: archivoD; var dato: pedido);
begin
    if not (eof(d)) then
        Read(d, dato)
    else
        dato.codigo := VALOR_ALTO;
end;

procedure resetDetalles(var vd: vector_archivoD; var vrd: vector_registroD);
var
    iStr: string;
    i: integer;
begin
    for i := 1 to DIMF do
    begin
        Str(i, iStr);
        Assign(vd[i], 'detalle' + iStr);
        Reset(vd[i]);
        leerDetalle(vd[i], vrd[i]);
    end;
end;

procedure minimo(var vd: vector_archivoD; var vrd: vector_registroD; var min: pedido; var minPos: integer);
var
    i: integer;
begin
    min.codigo := VALOR_ALTO;
    for i := 1 to DIMF do
    begin
        if (vrd[i].codigo < min.codigo) then
        begin
            min := vrd[i];
            minPos := i;
        end;
    end;
    if (min.codigo <> VALOR_ALTO) then
        leerDetalle(vd[minPos], vrd[minPos]);
end;

procedure merge(var m: archivoM; var vd: vector_archivoD; var vrd: vector_registroD);
var
    min: pedido;
    datoM: producto; {el producto que estoy en el maestro}
    diferencia: integer;
    posMin: integer;
    i: integer;
begin
    Reset(m);
    resetDetalles(vd, vrd); { Assign y reset de los detalles, ya lee el primer valor }
    minimo(vd, vrd, min, posMin); { busca entre los registros el de código mínimo y lo retorna en min }
    while (min.codigo <> VALOR_ALTO) do
    begin
        leerMaestro(m, datoM);
        while (datoM.codigo <> min.codigo) do { recorro el maestro hasta llegar al código min }
            leerMaestro(m, datoM);
        
        while (datoM.codigo = min.codigo) and (min.codigo <> VALOR_ALTO) do
        begin
            { Si no me alcanza el stock, informo diferencia faltante }
            if (datoM.stock_actual < min.cant_pedida) then
            begin
                diferencia := ((datoM.stock_actual - min.cant_pedida) * -1);
                writeln('Diferencia: ', diferencia, ' en sucursal: ', posMin);
                min.cant_pedida := datoM.stock_actual;
            end;
            { Si tengo stock, actualizo con lo pedido }
            datoM.stock_actual := datoM.stock_actual - min.cant_pedida;
            { Si el stock es menor a cero, actualizo su valor a 0 }
            if (datoM.stock_actual < 0) then
            begin
                datoM.stock_actual := 0;
            end;
            { Luego de actualizar las cantidades, busco un nuevo mínimo }
            minimo(vd, vrd, min, posMin);
            { Si corresponde al mismo código maestro, va a loopear y actualizar nuevamente el stock }
        end;
        { Cuando termino de actualizar el stock del producto informo lo que hay }
        if (datoM.stock_actual < datoM.stock_minimo) then
        begin
            writeln('Código: ', datoM.codigo);
            writeln('Categoría: ', datoM.categoria);
        end;

        { Vuelvo a escribir el maestro actualizado }
        Seek(m, FilePos(m) - 1); { Vuelvo a la posición donde estaba el producto leído y escribo el registro actualizado }
        Write(m, datoM);
    end;
    { Cuando termina de recorrer todos los detalles, cierro todo }
    Close(m);
    for i := 1 to DIMF do
        Close(vd[i]);
end;

var
    m: archivoM;
    vd: vector_archivoD;
    vrd: vector_registroD;
begin
    Assign(m, 'maestro.data');
    merge(m, vd, vrd);
end.
