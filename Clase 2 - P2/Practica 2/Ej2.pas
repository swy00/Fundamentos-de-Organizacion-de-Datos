program Ej2;

type
	alumno = record 
		codigo: integer; 
		apellido, nombre: string[20]; 
		cantSF, cantCF: integer;
		end;
	info_detalle = record
		codigo: integer;
		aprobo: boolean; //FALSE aprobó una cursada sin final, TRUE con
		end;
	arch_alu = file of alumno;
	arch_det = file of info_detalle;

var
	userInput: string;

procedure Leer(var arch: arch_det; var infodet: info_detalle);
	begin
		if not eof(arch) then
			read(arch, infodet)
		else
			infodet.codigo:= 999;
	end;

procedure ResetPos(var arch: arch_alu);
	begin
		if (FilePos(arch) > 0) then
			seek(arch, 0);
	end;
	
procedure Actualizar(var maestro: arch_alu);
	var
		det: arch_det;
		info_det: info_detalle;
		alu_aux: alumno;
		cod_aux, sf_aux, cf_aux: integer;
	begin
		writeln;
		writeln(' -- ACTUALIZAR ARCHIVO MAESTRO -- ');
		write(' -- nombre del archivo detalle: '); read(userInput); writeln(' -- ');
		assign(det, 'ej2' + userInput);
		reset(det);
		ResetPos(maestro); //Resetear posición del maestro por si es diferente de 0
		Leer(det, info_det);
		read(maestro, alu_aux);
		//Recorrer archivo detalle y maestro
		while (info_det.codigo <> 999) do begin
			//Averiguar cuantas materias aprobó solo la cursada o el final también
			cod_aux:= info_det.codigo;
			sf_aux:= 0;
			cf_aux:= 0;
			//Leer hasta que cambie el código de alumno
			while (info_det.codigo = cod_aux) do begin
				//Comprobar si aprobo es FALSE o TRUE
				if (info_det.aprobo) then begin
					cf_aux:= cf_aux + 1;
					sf_aux:= sf_aux - 1;
				end else begin
					sf_aux:= sf_aux + 1;
				end;
				Leer(det, info_det);
			end;
			//Recorrer el archivo maestro hasta encontrar el código de alumno
			while (alu_aux.codigo <> cod_aux) do
				read(maestro, alu_aux);
			//Una vez se llegó ir un lugar para atrás y sobreescribir registro
			seek(maestro, filepos(maestro)-1);
			alu_aux.cantSF:= alu_aux.cantSF + sf_aux;
			alu_aux.cantCF:= alu_aux.cantCF + cf_aux;
			write(maestro, alu_aux);
			write(' -- archivo actualizado -- ');
			//Avanzar en el maestro
			if not eof(maestro) then
				read(maestro, alu_aux);
		end;
		close(det);
	end;
	
procedure Exportar(var maestro: arch_alu);
	var
		texto: Text;
		alu_aux: alumno;
	begin
		writeln;
		writeln(' -- EXPORTAR A TEXTO -- ');
		write(' -- nombre para exportar: '); readln(userInput);
		assign(texto, 'ej2' + userInput + '.txt');
		rewrite(texto);
		ResetPos(maestro); //Resetear posición del maestro por si es diferente de 0
		read(maestro, alu_aux);
		while not eof(maestro) do begin
			if (alu_aux.cantCF > alu_aux.cantSF) then
				writeln(texto, 'CODIGO: ', alu_aux.codigo, ' / Solo aprobo la cursada: ', alu_aux.cantSF, ' / Aprobadas con final: ', alu_aux.cantCF, ' / Apellido: ', alu_aux.apellido, ' / Nombre: ', alu_aux.nombre);
			read(maestro, alu_aux);
		end;
		close(texto);
	end;

// Programa principal
var
	arc_mae: arch_alu;
begin
	//Abrir archivos
	writeln;
	write(' -- nombre del archivo maestro: '); read(userInput); writeln(' -- ');
	assign(arc_mae, 'ej2' + userInput);
	reset(arc_mae);
	writeln(' -- archivo abierto -- ');
	writeln;
	
	while (userInput <> 'TERMINAR') do begin
		writeln(' -- MENU (opciones: ACTUALIZAR, EXPORTAR, TERMINAR) -- ');
		write(' -- OPCION: '); readln(userInput);
		case userInput of
			'ACTUALIZAR': Actualizar(arc_mae);
			'EXPORTAR': Exportar(arc_mae);
		end;
		writeln;
	end;
	close(arc_mae);
end.
