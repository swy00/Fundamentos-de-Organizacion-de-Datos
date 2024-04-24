program Ej5;

const 
	VALORALTO=9999;
	DF=3;
type 
	
	producto = record
		codigo:integer;
		nombre:string;
		descripcion:string;
		stock:integer;
		stock_min:integer;
		precio:real
	end;

	detalle_producto = record
		codigo:integer;
		cantidad:integer;
	end;

	detalle = file of detalle_producto;


	data = record
		d:detalle_producto;
		f:detalle;
	end;

	archivo = file of producto;


	vector=array[1..DF] of data;


procedure leerDetalle(var det:detalle; var dato:detalle_producto);
begin
	if(not eof(det))then
		read(det,dato)
	else
		dato.codigo:=VALORALTO;
end;

procedure inicializarArregloDetalles(var n_detalles:vector);
var
	i:integer;
	nombre:string;
begin
	for i:=0 to DF do 
		begin
			write('Elija el nombre del archivo: ');
			readln(nombre);
			assign(n_detalles[i].f,nombre)
			reset(n_detalles[i].f);
			leerDetalle(n_detalles[i].f,n_detalles[i].d);
		end;
end;

procedure cerrarDetalles(var n_detalles:vector);
var
	i:integer;
begin
	for i:=0 to DF do
		begin
			close(n_detalles[i].f);
		end;
end;


procedure minimo (var n_detalles:vector; var min:detalle_producto);
var 
	i,pos:integer;
begin
	min.codigo:=VALORALTO;
	pos:=-1;
	for i:=1 to DF do
	begin
		if(n_detalles[i].d.codigo<>VALORALTO) and (n_detalles[i].d.codigo<min.codigo)then
			pos:=i;
			min:=n_detalles[i].d;
	end;
	if(pos= -1)then
		min.codigo:=VALORALTO
	else
		leerDetalle(n_detalles[pos].f,n_detalles[pos].d);
end;

procedure actualizarMaestro(var maestro : archivo);
var
	detalles:vector;
	min,dTotal:detalle_producto;
	p:producto;
	txt:Text;
begin
	inicializarArregloDetalles(detalles);
	assign(txt,'stocks_minimos.txt');
	rewrite(txt);
	reset(maestro);
	read(maestro,p);
	minimo(detalles,min);
	while(min.codigo<>VALORALTO)do
	begin
		dTotal.codigo:=min.codigo;
		dTotal.cantidad:=0;
		while (min.codigo <> VALORALTO) and (dTotal.codigo = min.codigo) do 
		begin
            dTotal.cantidad += min.cantidad;
            minimo(detalles, min);
        end;
		while(dTotal.codigo<>p.codigo)do
		begin
			read(maestro,p);
		end;
		seek(maestro,filepos(maestro)-1);
		p.stock:=p.stock - dTotal.cantidad;
		write(maestro,p);
		if(p.stock<p.stock_min)then
			writeln(txt,p.nombre);
			writeln(txt,p.descripcion);
			writeln(txt,p.stock);
			writeln(txt,p.precio);
	end;
	close(maestro);
	close(txt);
	cerrarDetalles(detalles);
end;

var
	maestro:archivo;
BEGIN
	assign(maestro,'maestro');
	rewrite(maestro);
	actualizarMaestro(maestro);
END.
