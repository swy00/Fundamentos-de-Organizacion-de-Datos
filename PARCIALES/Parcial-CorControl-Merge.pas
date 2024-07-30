{Una empresa de productos de limpieza posee un archivo conteniendo información sobre los productos que tiene a la venta al público. 
* De cada producto se registra: código de producto, precio, stock actual y stock mínimo. 
* Diariamente se efectúan envíos a cada uno de las 2 sucursales que posee. 
* Para esto, cada sucursal envía un archivo con los pedidos de los productos que necesita cada sucursal. 
* Cada pedido contiene código de producto, fecha y cantidad pedida. 
* Se pide realizar el proceso de actualización del archivo maestro con los dos archivos detalle, obteniendo un informe en pantalla 
* de aquellos productos que quedaron debajo del stock mínimo y de aquellos pedidos que no pudieron satisfacerse 
* totalmente, informando: la sucursal, el producto y la cantidad que no pudo ser enviada (diferencia entre lo que pidió y lo que se tiene en stock) .

NOTA 1: Todos los archivos están ordenados por código de producto y el archivo maestro debe ser recorrido sólo una vez y en forma simultánea con los detalle.

NOTA 2: En los archivos detalle puede no aparecer algún producto del maestro. 
* Además, tenga en cuenta que puede aparecer el mismo producto en varios detalles. 
* Sin embargo, en un mismo detalle cada producto aparece a lo sumo una vez.}
program ParcialCorControlMerge;
const 
    CANTIDAD = 2;	{Cantida de Sucursales}
    VALOR_ALTO = 9999;{Para el corte}
type
    RANGO = 1..CANTIDAD;
    
    producto = record
        codigo:integer;
        precio:real;
        stock_actual:integer;
        stock_minimo:integer;
    end;
    
    pedido = record
        codigo:integer;
        fecha:string;
        cant_pedida:integer;
    end;
    
    maestro = file of producto;
    detalle = file of pedido;
    vector_detalle = array [RANGO] of detalle;
    vector_detalle_registro = array [RANGO] of pedido;

procedure LeerD(var d:detalle;var dato:pedido);
    begin
        if not eof(d) then
            Read(d,dato)
        else
            dato.codigo:=VALOR_ALTO
    end;
    
procedure LeerM(var m:maestro;var dato:producto);
    begin
        if not eof(m) then
            Read(m,dato)
        else
            dato.codigo:=VALOR_ALTO;
    end;
    
procedure ResetDetalles(var vd:vector_detalle;var vdr:vector_detalle_registro);
    var
        i:integer;
        iStr:string;
    begin
        for i:=1 to CANTIDAD do
        begin
            Str(i,iStr);{transforma el valor entero i a un string, para guardar detalle1,detalle2, etc}
            Assign(vd[i],'detalle ' + iStr);
            Reset(vd[i]);
            LeerD(vd[i],vdr[i]);
        end;
    end;
    
procedure CloseDetalles(var vd:vector_detalle);
    var
        i:integer;
    begin
        for i:=1 to CANTIDAD do
        begin
            Close(vd[i]);
        end;
    end;
    
procedure minimo(var vd:vector_detalle;var vdr:vector_detalle_registro;var sucursal:integer;var min:pedido);
    var
        i:integer;
    begin
        min.codigo:=VALOR_ALTO;
        for i:=1 to CANTIDAD do begin
            if vdr[i].codigo<min.codigo then
                min:=vdr[i];
                sucursal:=i;
        end;
        if min.codigo <> VALOR_ALTO then
            LeerD(vd[sucursal],vdr[sucursal]);
    end;
    
procedure merge(var m:maestro;var vd:vector_detalle;var vdr:vector_detalle_registro);
var
    min:pedido;
    datoM:producto;
    sucursal:integer;
    cant_total:integer;
    cantidad:integer;
begin
    Reset(m); 
    ResetDetalles(vd,vdr);{Hace el assign y guarda el primer valor del detalle en el array}
    minimo(vd,vdr,min,sucursal);
    while min.codigo <> VALOR_ALTO do
    begin
        LeerM(m,datoM);
        while datoM.codigo <> min.codigo do //Puede no existir
            LeerM(m,datoM);
        cant_total:=0;
        while datoM.codigo = min.codigo do
        begin
            cant_total:=cant_total+min.cant_pedida;
            minimo(vd,vdr,min,sucursal);
        end;
        datoM.stock_actual:=datoM.stock_actual-cant_total;
        if (datoM.stock_actual<datoM.stock_minimo) and (0<=datoM.stock_actual) then
        begin
            Write('debajo del stock mínimo ');
            Writeln(datoM.codigo);
        end;
        if datoM.stock_actual<0 then
        begin
            Write(sucursal);
            write(datoM.codigo);
            cantidad:=datoM.stock_actual*-1;
            writeln(cantidad);
            datoM.stock_actual:=0;
        end;
        Seek(m,FilePos(m)-1);
        Write(m,datoM);   
    end;
    Close(m); CloseDetalles(vd);
end;

var
    m:maestro;
    vd:vector_detalle;
    vdr:vector_detalle_registro;
begin
    Assign(m,'maestro.data');
    merge(m,vd,vdr);
end.
