program Ej5;

const 
	VALORALTO = 9999;
	DF = 2;
	RUTA_MAESTRO = './nav/log';

type 
	
	detalle_usuario = record
		cod_usuario:integer;
		fecha:string;
		tiempo_sesion:real;
	end;

	usuario_maestro = record
		cod_usuario:integer;
		fecha:string;
		tiempo_total_acumulado:real;
	end;

	archivo_detalle = file of detalle_usuario;

	detalles = record
		d : detalle_usuario;
		f : archivo_detalle;
	end;

	archivo_maestro = file of usuario_maestro;

	vector = array[0..DF] of detalles;

procedure leerDetalle (var detalle : archivo_detalle; var dato:detalle_usuario);
begin
	reset(detalle);
	if(not eof(detalle))then
		read(detalle,dato)
	else
		dato.cod_usuario:=VALORALTO;
end;

procedure inicializarArregloDetalles (var n_detalles:vector);
var
	i:integer;
	nombre:string;
begin
	for i:=0 to DF do
	begin
		write('Elija el nombre del archivo: ');
		readln(nombre);
		assign(n_detalles[i].f,nombre);
		rewrite(n_detalles[i].f);
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


procedure minimo(var n_detalles:vector; var min:detalle_usuario);
var
	i,pos:integer;
begin
	min.cod_usuario:=VALORALTO;
	pos:=-1;
	for i:=0 to DF do
	begin
		if(n_detalles[i].d.cod_usuario<min.cod_usuario)then
		begin	
			pos:=i;
			min:=n_detalles[i].d;
		end;
	end;
	if(pos=-1)then
		min.cod_usuario:=VALORALTO
	else
		leerDetalle(n_detalles[pos].f,n_detalles[pos].d);
end;

procedure crearMaestro();
var
	maestro:archivo_maestro;
	n_detalles:vector;
	min:detalle_usuario;
	total:usuario_maestro;
begin
	inicializarArregloDetalles(n_detalles);
	assign(maestro,RUTA_MAESTRO);
	rewrite(maestro);
	minimo(n_detalles,min);
	while(min.cod_usuario<>VALORALTO)do
	begin
		total.cod_usuario:=min.cod_usuario;
		while(min.cod_usuario<>VALORALTO) and (total.cod_usuario = min.cod_usuario)do
		begin
			total.fecha:= min.fecha;
			total.tiempo_total_acumulado := 0;
			while(min.cod_usuario<>VALORALTO)and (total.cod_usuario = min.cod_usuario) and(total.fecha=min.fecha)do
			begin
				total.tiempo_total_acumulado := total.tiempo_total_acumulado + min.tiempo_sesion;
				minimo(n_detalles,min);
			end;
			write(maestro,total);
		end;
	end;
	close(maestro);
	cerrarDetalles(n_detalles);
end;

begin
	crearMaestro();
end.
