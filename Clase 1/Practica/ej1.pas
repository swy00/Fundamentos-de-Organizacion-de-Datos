{1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado.}
program ej1p1;
type
	archivos_enteros = file of integer;

{PROCEDURES}
var
	enteros:archivos_enteros;

procedure cargarEntero(var n:archivos_enteros);
var
	num:integer;
begin
	writeln('Ingrese numero para agregar al archivo: ');
	read(num);
	while (num <> 3000) do 
	begin
		write(n,num);
		writeln('Que otro numero desea agregar? (Ingresar 3000 para frenar)');
		read(num);
	end;
	close(n);
end;

var
	nombre:string;
begin
	writeln('Nombre del archivo: ');
	read(nombre);
	assign(enteros, nombre);
	rewrite(enteros);
	cargarEntero(enteros);
	
end.
