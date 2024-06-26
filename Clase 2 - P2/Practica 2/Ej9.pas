program Ej9;

const valorAlto = 9999;

type
    mesas = record
        codigoP:Integer;
        codigoL:integer;
        nro:integer;
        votos:integer;
    end;
    maestro = file of mesas;


//________________________________________________
procedure ImportarMaestro(var m:maestro);
var
    carga:text;
    dato:mesas;
begin
    Assign(m,'maestro.data');
    Assign(carga,'maestro.txt');
    Rewrite(m);
    Reset(carga);
    while (not (Eof(carga))) do
    begin
        with dato do readln(carga, codigoP, codigoL, nro, votos);
        Write(m,dato);
    end;
    Close(m);
    Close(carga);
end;

//________________________________________________
procedure leer(var arch:maestro; var aux:mesas);
begin
    if(not eof(arch))then 
		read(arch,aux)
    else 
		aux.codigoP:=valorAlto;
end;

//________________________________________________
procedure listado(var m:maestro);
var
	x,actual:mesas;
	totalMes: real;
	total: real;
    totalP,totalL:Integer;
begin
	assign(m,'maestro.data');
	reset(m);
	leer(m,x);
    total:=0;
	while (x.codigoP <> valoralto) do begin
		actual:= x;
        totalP:=0;
        WriteLn('-------------');
		writeln('Codigo de Provincia: ', actual.codigoP);
		while(actual.codigoP = x.codigoP)do begin
			actual:=x;
			totalL:=0;
			while(actual.codigoL = x.codigoL)and(actual.codigoP = x.codigoP) do begin
                totalL:=totalL+x.votos;
                totalP:=totalP+x.votos;
                leer(m,x);
			end;
			writeln('Total de votos locales: ', totalL);
		end;
        writeln('Total de votos provinciales: ', totalP);
	end;
	close(m);
end;

//________________________________________________
var
    m:maestro;
begin
    importarMaestro(m);
    listado(m);
end.
