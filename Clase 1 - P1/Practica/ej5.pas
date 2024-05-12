program ej5;

type

	celular=record
		codigo:integer;
		nombre:string;
		descripcion:string;
		marca:string;
		precio:real;
		stock_min:integer;
		stock_disp:integer;
		end;
	
	archivo= file of celular;

procedure crearYcargar(var a:archivo);
var
	carga:text;
	cel:celular;
begin
	assign(carga,'celulares.txt');
	
	rewrite(a);
	reset(carga);
	{Saco la info del archivo}
	while not eof(a) do
	begin
		with cel do readln(carga,cel.codigo,cel.precio,cel.marca);
		with cel do readln(carga,cel.stock_min,cel.stock_disp,cel.descripcion);
		with cel do readln(carga,cel.nombre);
	end;
	close(a);
	close(carga);
	write('Archivo cargado');
end;

procedure exportarTXT(var a:archivo);
var
	carga:text;
	cel:celular;
begin
	assign(carga,'celulares.txt');
	
	while not eof(a) do
	begin
		read(a,cel);
		with cel do writeln(carga,(cel.codigo),cel.precio,cel.marca);
		with cel do readln(carga,cel.stock_min,cel.stock_disp,cel.descripcion);
		with cel do readln(carga,cel.nombre);
	end;
	close(carga);
	close(a);
end;

procedure imprimirCelular(var cel:celular);
begin
    writeln('Codigo: ',cel.codigo);
    writeln('Nombre: ',cel.nombre);
    writeln('Descripcion: ',cel.descripcion);
    writeln('Marca: ',cel.marca);
    writeln('Precio: ',cel.precio);
    writeln('Stock Minimo: ',cel.stock_min);
    writeln('Stock Disponible: ',cel.stock_disp);
end;

procedure buscarDesc(var a:archivo);
var
	c:celular;
	d:string;
begin
	reset(a);
	write('Descripcion a buscar');
	readln(d);
	
	while not eof(a) do
	begin
		read(a,c);
		if(c.descripcion  = d)then
		begin
			imprimirCelular(c);
		end;
	end;
	close(a);
end;

procedure celPocoStock(var a:archivo);
var
	c:celular;
begin
	reset(a);
	while not eof(a) do
	begin
		read(a,c);
		if(c.stock_disp < c.stock_min)then
		begin
			imprimirCelular(c);
		end;
	end;
	close(a);
end;

var
	opcion:integer;
	a:archivo;
	aF,nombre_archivo:String;
begin
	opcion:=0;
	aF:='Test';
	write('Nombre del archivo: '); readln(nombre_archivo);
	Assign(a, nombre_archivo);
	
	while (opcion <> 5) do 
	begin
		writeln('/////////////////////////////////////////////');
		writeln('----------------MENU OPCIONES----------------');
		writeln('1 ] Crear y cargar archivo');
		writeln('2 ] Mostrar celulares con poco STOCK');
		writeln('3 ] Buscar celulares con DESCRIPCION ingresada');
		writeln('4 ] Exportar a "celulares.txt"');
		writeln('5 ] Salir');
		writeln('/////////////////////////////////////////////');
		write('Numero Opcion: ');
		readln(opcion);
		case opcion of
			1:crearYcargar(a);
			2:celPocoStock(a);
			3:buscarDesc(a);
			4:exportarTXT(a);
			5:writeln('>Saliendo de Programa');
			else writeln('>Opcion iválida.');
		end;
	end;
end.

















