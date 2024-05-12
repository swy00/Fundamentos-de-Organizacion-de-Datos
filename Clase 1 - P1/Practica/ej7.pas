program pr1ej7;

Uses sysutils;

type
	novela = record
		codigo: integer;
		nombre: string;
		genero: string;
		precio: real;
	end;
	archivo_nov = file of novela;

procedure crearArchivo(var arch: archivo_nov);
	var
		archivo_texto: text;
		nov_aux: novela;
	begin
		rewrite(arch);
		Assign(archivo_texto, 'novelas.txt');
		reset(archivo_texto);
		while not eof(archivo_texto) do begin
			readln(archivo_texto, nov_aux.codigo, nov_aux.precio, nov_aux.genero);
			readln(archivo_texto, nov_aux.nombre);
			write(arch, nov_aux);
		end;
		close(archivo_texto);
		close(arch);
	end;

procedure leerNovela(var nov: novela);
	begin
		with nov do begin
			write('-Codigo de la novela: '); readln(codigo);
			write('-Nombre de la novela: '); readln(nombre);
			write('-Genero de la novela: '); readln(genero);
			write('-Precio de la novela: '); readln(precio);
		end;
		writeln;
	end;

procedure agregarNovela(var arch: archivo_nov);
	var
		nov_aux: novela;
	begin
		seek(arch, filesize(arch));
		leerNovela(nov_aux);
		write(arch, nov_aux);
	end;
	
procedure modificarNovela(var arch: archivo_nov);
	var
		nov_cod: integer;
		nov_aux: novela;
	begin
		write('-Ingrese un codigo: '); readln(nov_cod);
		seek(arch, 0);
		read(arch, nov_aux);
		while (nov_cod <> nov_aux.codigo) do begin
			read(arch, nov_aux);
		end;
		if (nov_cod <> nov_aux.codigo) then begin
			writeln('!No se encontro ese codigo');
		end else begin
			seek(arch, filepos(arch)-1);
			writeln('!Novela encontrada');
			leerNovela(nov_aux);
			write(arch, nov_aux);
		end;
	end;

procedure actualizarArchivo(var arch: archivo_nov);
	var
		menu: integer;
	begin
		reset(arch);
		menu:= 0;
		while (menu <> 3) do begin
			writeln('QUE DESEA HACER: ');
			writeln(' 1 ] Agregar informacion');
			writeln(' 2 ] Modificar informacion');
			writeln(' 3 ] Salir ');
			writeln('/////////////////////////////////////////////');
			write('Numero Opcion: '); readln(menu);
			case menu of
				1:crearArchivo(archivo);
				2:actualizarArchivo(archivo);
				3:writeln('>Saliendo de Programa');
				else writeln('>Opcion iválida.');
			end;
			
		end;
		close(arch);
	end;


var
	archivo: archivo_nov;
	opcion: string;
	menu: integer;
begin
	menu:= 0;
	write('Nombre del archivo que desea abrir: '); readln(opcion);
	Assign(archivo, user_input);
	writeln;
	
	while (opcion <> 3) do 
	begin
		writeln('/////////////////////////////////////////////');
		writeln('----------------MENU OPCIONES----------------');
		writeln('1 ] Crear y cargar archivo');
		writeln('2 ] Mostrar celulares con poco STOCK');
		writeln('3 ] Salir');
		writeln('/////////////////////////////////////////////');
		write('Numero Opcion: ');
		readln(opcion);
		case opcion of
			1:crearArchivo(archivo);
			2:actualizarArchivo(archivo);
			3:writeln('>Saliendo de Programa');
			else writeln('>Opcion iválida.');
		end;
	end;
end.
