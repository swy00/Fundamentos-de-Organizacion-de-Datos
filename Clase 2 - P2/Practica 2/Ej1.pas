program Ej1;
type
	empleado = record
		codigo: integer;
		nombre: string[20];
		monto: real;
		end;
	detalle = file of empleado;

procedure Leer(var arch: detalle; var emp: empleado);
	begin
		if not eof(arch) then
			read(arch, emp)
		else
			emp.codigo:= 999;
	end;

var
	archivo_detalle, archivo_maestro: detalle;
	codigo_aux: integer;
	info_empleado, nuevo_empleado: empleado;
	monto_total: real;
	user_input: string;
	
// Programa principal
begin
	//Cargar archivos
	write('Ingrese el nombre del archivo'); readln(user_input);
	assign(archivo_detalle, user_input);
	assign(archivo_maestro, 'maestro.dat');
	reset(archivo_detalle);
	rewrite(archivo_maestro);
	
	//Leer archivo detalle
	Leer(archivo_detalle, info_empleado);
	while (info_empleado.codigo <> 999) do begin
		codigo_aux:= info_empleado.codigo;
		nuevo_empleado:= info_empleado;
		monto_total:= 0;
		while (info_empleado.codigo = codigo_aux) do begin
			monto_total:= monto_total + info_empleado.monto;
			Leer(archivo_detalle, info_empleado);
		end;
		nuevo_empleado.monto:= monto_total;
		write(archivo_maestro, nuevo_empleado);
	end;
	
	//Cerrar archivos
	close(archivo_detalle);
	close(archivo_maestro);
end.
