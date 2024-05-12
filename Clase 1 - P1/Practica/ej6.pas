program ej6;

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
procedure leerCelular(var c: celular);
	begin
		with c do begin
			write('Ingrese el codigo del celular: '); readln(codigo);
			write('Ingrese el nombre del celular: '); readln(nombre);
			write('Ingrese la descripcion del celular: '); readln(descripcion);
			write('Ingrese la marca del celular: '); readln(marca);
			write('Ingrese el precio del celular: '); readln(precio);
			write('Ingrese el stock minimo del celular: '); readln(stock_min);
			write('Ingrese el stock actual del celular: '); readln(stock_disp);
		end;
	end;
	
procedure agregarInformacion(var a: archivo);
	var
		cel_aux: celular;
		user_input: string[1];
	begin
		reset(a);
		seek(a, filesize(a));
		user_input:= ' ';
		while (user_input <> 'N') do begin
			write('Ingrese S si quiere agregar un celular, ingrese N en caso contrario: '); readln(user_input);
			if (user_input = 'S') then begin
				leerCelular(cel_aux);
				write(a, cel_aux);
			end;
		end;
		close(a);
	end;
procedure modificarStock(var arch: archivo);
	var
		cel_aux: celular;
		user_input: string[20];
		user_input2: integer;
	begin
		reset(arch);
		write('Ingrese el nombre del celular de cual busca modificar el stock: '); readln(user_input);
		read(arch, cel_aux);
		while (user_input <> cel_aux.nombre) do begin
			read(arch, cel_aux);
		end;
		if (user_input <> cel_aux.nombre) then begin
			writeln('No se pudo encontrar un celular bajo ese nombre');
		end else begin
			write('Ingrese el nuevo numero de stock: '); readln(user_input2);
			cel_aux.stock_disp:= user_input2;
			seek(arch, filepos(arch)-1);
			write(arch, cel_aux); //Sobreescribir registro
		end;
		close(arch);
	end;
	
	
procedure exportarSinStock(var arch: archivo);
	var
		archivo_texto: text;
		cel_aux: celular;
	begin
		Assign(archivo_texto, 'sinStock.txt');
		reset(arch);
		rewrite(archivo_texto);
		while not eof(arch) do begin
			read(arch, cel_aux);
			if (cel_aux.stock_disp = 0) then begin
				writeln(archivo_texto,' ',cel_aux.codigo, ' ',cel_aux.stock_min, ' ',cel_aux.descripcion);
				writeln(archivo_texto, ' ',cel_aux.stock_disp, ' ',cel_aux.precio, ' ',cel_aux.nombre);
				writeln(archivo_texto, ' ',cel_aux.marca);
			end;
		end;
		close(archivo_texto);
		close(arch);
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
		writeln('5 ] Agregar informacion');
		writeln('6 ] Modificar stock de un celular');
		writeln('7 ] Exportar celulares que no tengan stock (texto)');
		writeln('8 ] Salir');
		writeln('/////////////////////////////////////////////');
		write('Numero Opcion: ');
		readln(opcion);
		case opcion of
			1:crearYcargar(a);
			2:celPocoStock(a);
			3:buscarDesc(a);
			4:exportarTXT(a);
			5:agregarInformacion(a);
			6:modificarStock(a);
			7:exportarSinStock(a);
			8:writeln('>Saliendo de Programa');
			else writeln('>Opcion iválida.');
		end;
	end;
end.


















