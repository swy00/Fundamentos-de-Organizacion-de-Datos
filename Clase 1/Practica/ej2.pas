{2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla. }
program ej2;
type
	archivo_enteros= file of integer;
var
	enteros:archivo_enteros;


procedure imprimirNumeros(var a:archivo_enteros);
var
	num:integer;
begin
	reset(a);
	while not eof(a) do
	begin
		read(a,num);
		writeln(num);
	end;
	close(a);
end;

function minimos(var a:archivo_enteros):integer;
var
	num,cantidad:integer;
begin
	cantidad:=0;
	reset(a);
	while not eof(a) do
	begin
		read(a,num);
		if(num < 1500)then
		begin
			cantidad:=cantidad+1;
		end;
	end;
	minimos:=cantidad;
end;

function promedio(var a:archivo_enteros):integer;
var
	num,prom:integer;
begin
	prom:=0;
	reset(a);
	while not eof(a) do
	begin
		read(a,num);
		prom:= prom + num;
	end;
	promedio:=prom;
end;

var 
	nombre:string;
begin
	writeln('Que archivo desea abrir?');
	read(nombre);
	assign(enteros, nombre);
	reset(enteros);
	{Para testear que abra el archivo, imprimo todos los numeros}
	imprimirNumeros(enteros);
	writeln('La cantidad de numeros menores a 1500 es de ',minimos(enteros));
	writeln('El promedio de los numeros en el archivo es de ',promedio(enteros));
end.
