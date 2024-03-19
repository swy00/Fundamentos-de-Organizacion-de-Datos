{4. Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).
b. Modificar la edad de un empleado dado.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.}
program ej4;
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
function verificar(var a:archivo;var n:integer):boolean;
var
	e:empleado;
	existe:boolean;
begin
	reset(a);
	existe:=false;
	while not eof(a) do
	begin
		read(a,e);
		if (e.nro = n) then
		begin
			existe:= true;
		end;
	end;
	close(a);
	if existe then
	begin
		verificar:=true;
	end
	else begin
		verificar:=false;
	end;
end;

procedure agregarEmpleado(var a:archivo);
var
	e:empleado;
	num:integer;
	existe:boolean;
begin
	writeln('Numero de Empleado: ');
	read(num);
	
	existe:=(verificar(a,num));
	
	if (not(existe)) then
	begin
		reset(a);
		seek(a, (FileSize(a)-1)); {PARA MOVERME AL FINAL DEL ARCHIVO}
		write('Apellido: ');
		readln(e.apellido);
		write('Nombre: ');
		readln(e.nombre);
		write('Edad: ');readln(e.edad);
		write('Dni: ');readln(e.dni);
		e.nro:=num;
		write(a,e);
		writeln('>Empleado agregado correctamente.');
	end
	else begin
		writeln('>El Numero de Empleado ya existe');
	end;
	close(a);
end;

procedure modificarEdad(var a:archivo);
var
	num,edad:integer;
	e:empleado;
	existe:boolean;
begin
	existe:=true;
	write('Ingrese el N° Empleado para modificar edad: ');readln(num);
	reset(a);
	while ((not eof(a)) and (existe)) do
	begin
		read(a,e);
		if (e.nro = num) then
		begin
			existe:=false;
			write('Nueva Edad: ');readln(edad);
			seek(a, filepos(a)-1);{Porque el read lee, y pasa a la prox pos, tengo que volver para volver a escribir}
			e.edad:=edad;
			write(a,e);
		end;
	end;
	close(a);
end;

procedure exportarTodo(var a:archivo);
var
	carga: text;
	e: empleado;
begin
	assign(carga, 'C:\Users\franc\Desktop\FOD\Clase 1\Practica\todos_empleados.txt');
	reset(a);
	rewrite(carga);
	while(not eof(a)) do 
	begin
		read(a,e);
		with e do
			writeln(carga,' ',nro,' ',apellido,' ',nombre,' ', edad,' ', dni);
	end;
	writeln('------------Exportado Correctamente------------');
	close(a); close(carga);
end;

procedure exportarESD(var a:archivo);
var
    carga: text;
	e: empleado;
begin
    assign(carga, 'C:\Users\franc\Desktop\FOD\Clase 1\Practica\empleadoSinDni.txt');
	reset(a);
	rewrite(carga);
    while(not eof(a)) do 
    begin
		read(a,e);
        if (e.dni = 0) then
        begin
            with e do
			    writeln(carga,' ',nro,' ',apellido,' ',nombre,' ', edad,' ', dni);	
		end;
    end;
	writeln('------------Exportado Correctamente------------');
	close(a); close(carga);
end;

var
	eleccion:integer;
	a:archivo;
	aF:String;
begin
	eleccion:=0;
	aF:='Test';
	assign(a,aF);
	while (eleccion <> 9) do 
	begin
		writeln('/////////////////////////////////////////////');
		writeln('----------------MENU OPCIONES----------------');
		writeln('1 ] Crear archivo de empleados');
		writeln('2 ] Empleados con nombre/apellido determinado');
		writeln('3 ] Mostrar todos los empleados');
		writeln('4 ] Mostrar empleados mayores a 70');
		writeln('5 ] Añadir empleado nuevo al archivo');
		writeln('6 ] Modificar la edad a empleado');
		writeln('7 ] Exportar contenido a .TXT');
		writeln('8 ] Exportar empleados SIN DNI a .TXT');
		writeln('9 ] Salir');
		writeln('/////////////////////////////////////////////');
		write('Numero Opcion: ');
		readln(eleccion);
		case eleccion of
			1:crearArchivo(a,aF);
			2:busquedaDato(a);
			3:mostrarEmpleados(a);
			4:mostrarMayores(a);
			5:agregarEmpleado(a);
			6:modificarEdad(a);
			7:exportarTodo(a);
			8:exportarESD(a);
			9:writeln('>Saliendo de Programa');
			else writeln('>Opcion iválida.');
		end;
	end;
end.
