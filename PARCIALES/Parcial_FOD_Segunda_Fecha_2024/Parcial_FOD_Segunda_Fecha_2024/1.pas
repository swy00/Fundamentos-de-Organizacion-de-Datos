program parcial;
const 
    VALORALTO = 9999;
    DIMF = 30;
type 
    tmunicipio = record 
        codigo:integer;
        nombre:string;
        cantidad:integer;
    end;

    tregistro = record 
        codigo:integer;
        cantidad:integer;
    end;

    tarch = file of tmunicipio;
    tdetalle = file of tregistro;
    tdetalles = array [1..DIMF] of tdetalle;
    tregistros = array [1..DIMF] of tregistro;

procedure leer(var detalle:tdetalle; var registro: tregistro);
begin 
    if (eof(detalle)) then 
        registro.codigo:=VALORALTO
    else 
        read(detalle,registro);
end;

procedure asignarDetalles(var detalles:tdetalles);
var 
    i:integer;
    ruta:string;
begin 
    for i:=1 to DIMF do 
        begin 
            writeln('Ingrese la ruta del detalle ',i,':');
            read(ruta);
            assign(detalles[i],ruta);
        end;
end;

procedure cargarRegistros(var detalles:tdetalles;var registros:tregistros);
var 
    i:integer;
begin 
    for i:=1 to DIMF do 
        begin 
            reset(detalles[i]);
            leer(detalles[i],registros[i]);
        end;
end;


procedure cerrarDetalles(var detalles:tdetalles);
var 
    i:integer;
begin 
    for i:=1 to DIMF do 
        begin 
            close(detalles[i]);
        end;
end;

procedure informar(municipio:tmunicipio);
begin 
    if (municipio.cantidad>15) then 
        writeln('El municipio ',municipio.nombre,' con codigo ',municipio.codigo,' tiene mas de 15 casos activos');
end;

procedure minimo(var min:tregistro;var registros:tregistros;var detalles:tdetalles);
var 
    i,i_min:integer;
begin 
    i_min:=1;
    min:=registros[1];
    for i:=2 to DIMF do 
        begin 
            if (registros[i].codigo<min.codigo) then 
                begin 
                    min:=registros[i];
                    i_min:=i;
                end;
        end;
    leer(detalles[i],registros[i]);
end;

procedure actualizar(var maestro:tarch;var detalles:tdetalles);
var 
    min,actual:tregistro;
    mae:tmunicipio;
    registros:tregistros;
begin 
    reset(maestro);
    cargarRegistros(detalles,registros);
    minimo(min,registros,detalles);
    mae.codigo:=0; //para que no informe si el maestro esta vacio (0<15)
    if (not eof(maestro)) then 
        read(maestro,mae);
    while (min.codigo<>VALORALTO) do 
        begin 
            actual:=min;
            actual.cantidad:=0;
            while (min.codigo=actual.codigo) do 
                begin 
                    actual.cantidad:=actual.cantidad+min.cantidad;
                    minimo(min,registros,detalles);
                end;
            while (actual.codigo<>mae.codigo) do 
                begin 
                    informar(mae);
                    read(maestro,mae);
                end;
            mae.cantidad:=mae.cantidad+actual.cantidad;
            informar(mae);
            seek(maestro,filepos(maestro)-1);
            write(maestro,mae);
            if (not eof(maestro)) then 
                read(maestro,mae);
        end;
    while (not eof(maestro)) do     
        begin 
            informar(mae);
            read(maestro,mae);
        end;
    informar(mae);
    close(maestro);
    cerrarDetalles(detalles);
end;

var 
    detalles:tdetalles;
    maestro:tarch;
    ruta:string;
begin 
    writeln('Ingrese la ruta del archivo maestro: ');
    readln(ruta);
    assign(maestro,ruta);
    asignarDetalles(detalles);
    actualizar(maestro,detalles);
end.

