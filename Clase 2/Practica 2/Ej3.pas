program Ej3;

type

	producto = record
		codigo:integer;
		nombre:String;
		precio:real;
		stockA:integer;
		stockM:integer;
		end;
		
	
	venta = record
		codigo:integer;
		cantV:integer;
		end;
	
	detalle = file of venta;
	maestro = file of producto;


procedure leerDet(var archDet: detalle; var ven: venta);
	begin
		if not eof(archDet) then
			read(archDet, ven)
		else
			ven.codigo:= 999;
	end;

	
procedure actualizarMaestro(var archMae: maestro);
var
	archDet: detalle;
	prod: producto;
	input:String;
	codigo_aux, tot_ventas: integer;
	ven: venta;
begin
	write('Ingresar nombre archivo detalle: '); 
	readln(input);
	assign(archDet, 'Ej3_' + input);
	reset(archDet);
	
	leerDet(archDet, ven);		
	seek(archMae, 0);
	read(archMae, prod);
	
	while (ven.codigo <> 999) do begin
		
		codigo_aux:= ven.codigo;
		writeln('Producto de Codigo: ', codigo_aux);
		tot_ventas:= 0;
		
		while (ven.codigo = codigo_aux) do begin
			tot_ventas:= tot_ventas + ven.cantV;
			writeln('Ventas realizadas del producto: ', tot_ventas);
			leerDet(archDet, ven);
		end;
		
		while (prod.codigo <> codigo_aux) do
			read(archMae, prod);
		writeln('Stock anterior: ', prod.stockA);
		prod.stockA:= prod.stockA - tot_ventas;
		writeln('Stock Actualizado: ', prod.stockA);
		
		seek(archMae, filepos(archMae)-1);
		write(archMae, prod);
		if not eof(archMae) then
			read(archMae, prod);
	end;
	close(archDet);
end;

procedure Exportar(var archMae: maestro);
	var
		texto: Text;
		prod: producto;
	begin
		assign(texto, 'Ej3_' + 'stock_minimo.txt');
		rewrite(texto);
		seek(archMae, 0);
		while not eof(archMae) do begin
			read(archMae, prod);
			writeln(' CODIGO: ', prod.codigo, ' / Precio: ', prod.precio:2:2, ' / Stock actual: ', prod.stockA,' / Stock mínimo: ', prod.stockM, ' / Nombre: ', prod.nombre);
			if (prod.stockA < prod.stockM) then
				writeln(texto, 'CODIGO: ', prod.codigo, ' / Precio: ', prod.precio:2:2, ' / Stock actual: ', prod.stockA,' / Stock mínimo: ', prod.stockM, ' / Nombre: ', prod.nombre);
		end;
		close(texto);
	end;

var
	m:maestro;
	opcion:integer;
	input:String;
begin
	write('Ingresar nombre archivo maestro: '); 
	readln(input);
	assign(m, input);
	reset(m);
	opcion:= -1;
	while (opcion <> 0) do begin
		writeln('---- MENU ---- ');
		writeln(' 1: Actualizar');
		writeln(' 2: Exportar ');
		writeln(' 0: Terminar programa ');
		write('OPCION: '); 
		readln(opcion);
		case opcion of
			1: actualizarMaestro(m);
			2: exportar(m);
		end;
	end;
end.
