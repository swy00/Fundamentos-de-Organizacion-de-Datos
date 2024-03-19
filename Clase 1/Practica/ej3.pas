{3. Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}
program ej3;
type
	empleado = record
		nro:integer;
		apellido:String;
		nombre:String;
		edad:integer;
		dni:integer;
		end;
		
		archivo = file of empleado;

{PROCEDURES}
procedure leerEmpleado(var e:empleado);
begin
	writeln('----------------EMPLEADO NUEVO----------------');
	write('Apellido: '); 
	readln(e.apellido);
    if(e.apellido <> 'fin')then
    begin
        write('Nombre: '); 
        readln(e.nombre);
        write('Edad: '); 
        readln(e.edad);
        write('Dni: '); 
        readln(e.dni);
        write('N° Empleado: '); 
        readln(e.nro);
    end;

end;
procedure crearArchivo(var a:archivo;var aF:String);
var
	e:empleado;
begin
	{Creacion del archivo, traigo como referencia aF para que se modifique en el programa MENU, para cuando necesite acceder}
	writeln('Ingresar nombre del archivo: ');
	readln(aF);
	assign(a,aF);
	{Creo el archivo con el nuevo nombre}
	rewrite(a);
	{Leo la informacion para agregar al archivo, si no es 'fin' el apellido lo agrego al archivo y sigo leyendo}
	leerEmpleado(e);
	while (e.apellido <> 'fin') do
	begin
		write(a,e);
		leerEmpleado(e);
	end;	
	close(a);

end;

procedure imprimirEmpleado(e:empleado);
begin
    writeln('Nro Empleado: ',e.nro);
    writeln('Apellido: ',e.apellido);
    writeln('Nombre: ',e.nombre);
    writeln('Dni: ',e.dni);
    writeln('Edad: ',e.edad);
end;

procedure busquedaDato(var a:archivo);
var
	buscar:String;
	e:empleado;
begin
	write('Apellido/Nombre que desea buscar: ');
	readln(buscar);
	reset(a);
	while not eof(a) do
	begin
		read(a,e);
		if (e.nombre = buscar) or (e.apellido = buscar) then
		begin
			imprimirEmpleado(e);
		end;
	end;
	close(a);
end;

procedure mostrarEmpleados(var a:archivo);
var
	e:empleado;
begin
	reset(a);
	while not eof(a) do
	begin
		read(a,e);
		imprimirEmpleado(e);
		writeln('');
	end;
	close(a);
end;

procedure mostrarMayores(var a:archivo);
var
	e:empleado;
begin
	reset(a);
	while not eof(a) do
	begin
		read(a,e);
		if (e.edad > 70) then
		begin
			imprimirEmpleado(e);
		end;
	end;
	close(a);
end;

var
	eleccion:integer;
	a:archivo;
	aF:String;
begin
	eleccion:=0;
	aF:='Test';
	assign(a,aF);
	while (eleccion <> 5) do 
	begin
		writeln('/////////////////////////////////////////////');
		writeln('----------------MENU OPCIONES----------------');
		writeln('1 ] Crear archivo de empleados');
		writeln('2 ] Empleados con nombre/apellido determinado');
		writeln('3 ] Mostrar todos los empleados');
		writeln('4 ] Mostrar empleados mayores a 70');
		writeln('5 ] Salir');
		writeln('/////////////////////////////////////////////');
		write('Numero Opcion: ');
		readln(eleccion);
		case eleccion of
			1:crearArchivo(a,aF);
			2:busquedaDato(a);
			3:mostrarEmpleados(a);
			4:mostrarMayores(a);
			5:writeln('>Saliendo de Programa')
			else writeln('>Opcion iválida.');
		end;
	end;
end.
