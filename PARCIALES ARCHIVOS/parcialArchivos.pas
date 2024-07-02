{Considere que se tiene un archivo que contiene información de los préstamos otorgados por una empresa financiera que cuenta con varias sucursales. 
* Por cada préstamo se tiene la siguiente información: 
* número de sucursal donde se otorgó, DNI del empleado que lo otorgó, número de préstamo, fecha de otorgación y monto otorgado. 
* Cada préstamo otorgado por la empresa se considera como una venta. Además, se sabe que el archivo
está ordenado por los siguientes criterios: 
* código de sucursal, DNI del empleado y fecha de otorgación(en ese orden)
Se le solicita definir las estructuras de datos necesarias y escribir el módulo que reciba el archivo de datos y genere un informe en un archivo de texto con el siguiente formato:

Informe de ventas de la empresa
Sucursal <número sucursal>
Empleado: DNI <DNI empleado>
Año
Cantidad de ventas
Monto de ventas
Totales <Total ventas empleado>
<Monto total empleado>
Empleado: DNI <Dni empleado>
Cantidad total de ventas sucursal.
Monto total vendido por sucursal:
Sucursal <numero sucursal>
Cantidad de ventas de la empresa
Monto total vendido por la empresa
Notas:
* El archivo de datos se debe recorrer solo una vez. 
* Para determinar el año de otorgación de un préstamo, puede asumir que existe una función extraer Año(fecha) 
* que, a partir de una fecha dada, devuelve el año de la misma.
En la generación del archivo de texto solo interesa que aparezca la información requerida, NO es necesario que
se incluyan los espacios en blanco o tabulaciones que se incluyen en el informe dade como ejemplo.}

program primerParcialArchivos;
const 
	VALOR_ALTO = 9999;

type 
	prestamo = record
		sucursal:integer;
		empleado:integer;
		num:integer;
		fecha:integer;
		monto:real;
		end;
		
	archivoM = file of prestamo;

procedure leerM(var archivo: archivoM; var prestamo: prestamo);
begin
    if not eof(archivo) then
    begin
        Read(archivo, prestamo);
    end
    else
        prestamo.num := VALOR_ALTO;
end;

{código de sucursal, DNI del empleado y fecha de otorgación(en ese orden)}
procedure generarTxt(var m: archivoM; var t:Text);
var
	datoM: prestamo;
	sucursal_actual, empleado_actual, fecha_actual: integer;
    cant_ventas_fecha, cant_ventas_empleado, cant_ventas_sucursal, cant_ventas_empresa: integer;
    monto_ventas_fecha, monto_ventas_empleado, monto_ventas_sucursal, monto_ventas_empresa: real;
	
begin
	{Reset de maestro y creo el .txt}
	reset(m);rewrite(t);
	{Inicializo variables de totales de la empresa}
	cant_ventas_empresa := 0;
	monto_ventas_empresa:=0;
	{Inicio el .txt}
	writeln(t, 'Informe de ventas de la empresa');
	
	leerM(m,datoM);
	{Esta ordenado por 3 valores, por lo tanto voy a tener 4 cortes de control de while, incrementando cada vez la cantidad de contenaciones}
	while (datoM.num <> VALOR_ALTO) do
	begin
		{Reinicio variables de sucursal}
		sucursal_actual := datoM.sucursal;
		cant_ventas_sucursal:= 0;
		monto_ventas_sucursal:=0;
		writeln(t, 'Sucursal ', sucursal_actual);
		while (datoM.num = sucursal_actual) do
        begin
			{Reinicio variables de empleado}
			empleado_actual:= datoM.empleado;
			cant_ventas_empleado := 0;
			monto_ventas_empleado:=0;
			writeln(t, 'Empleado DNI', empleado_actual);
			while (datoM.num = sucursal_actual) and (datoM.empleado = empleado_actual) do 
			begin
				{Reinicio variables de fecha}
				fecha_actual := datoM.fecha;
				cant_ventas_fecha:=0;
				monto_ventas_fecha:=0;
				
				writeln(t, 'Año ', fecha_actual);
				while (datoM.num = sucursal_actual) and (datoM.empleado = empleado_actual) and (datoM.fecha = fecha_actual)  do
				begin
					cant_ventas_fecha :=  cant_ventas_fecha +1;
					monto_ventas_fecha:=  monto_ventas_fecha + datoM.monto;
					leerM(m,datoM){leo el proximo registro, si es de todo lo mismo, sigo actualizando los datos}
				end;{end fecha}
				{Una vez que termino el año, escribo en el .txt}
				writeln(t,'Año', fecha_actual);
				write(t,'Cantidad de Ventas', cant_ventas_fecha);
				write(t,'Monto de ventas', monto_ventas_fecha);
				
				{Acumulo totales del empleado, sumando lo vendido en el año}
				cant_ventas_empleado := cant_ventas_empleado + cant_ventas_fecha;
				monto_ventas_empleado := monto_ventas_empleado + monto_ventas_fecha;
			end;{end empleado}
			{Termino el empleado, escribo toda la info obtenida}
			writeln(t,'Totales ', empleado_actual);
			write(t,'Cantidad de ventas: ', cant_ventas_empleado);
			write(t,'Monto de ventas', monto_ventas_empleado);
			
			{Acumulo total de sucursal}
			cant_ventas_sucursal := cant_ventas_sucursal + cant_ventas_empleado;
            monto_ventas_sucursal := monto_ventas_sucursal + monto_ventas_empleado;
        end;{end sucursal}
        { Info de la sucursal}
        writeln(t, 'Cantidad total de ventas sucursal: ', cant_ventas_sucursal);
        writeln(t, 'Monto total vendido por sucursal: ', monto_ventas_sucursal);

        {Acumlo total de empresa}
        cant_ventas_empresa := cant_ventas_empresa + cant_ventas_sucursal;
        monto_ventas_empresa := monto_ventas_empresa + monto_ventas_sucursal;
	end;{end registros}
	writeln(t, 'Cantidad de ventas de la empresa: ', cant_ventas_empresa);
    writeln(t, 'Monto total vendido por la empresa: ', monto_ventas_empresa);

    Close(m);
    Close(t);
end;

var
	archivo: archivoM;
	archivoTexto: Text;
begin
	Assign(archivo, 'prestamos.dat');
	Assign(archivoTexto, 'informe.txt');
	
	generarTxt(archivo,archivoTexto);
end.
