PROGRAM sistemas_olimpiadas;
USES crt;

TYPE
    medallas = array [1..3]of string;

    atletas = RECORD
            dni: string;
            nombre_apellido: string;
            activo: boolean;
            END;

    disciplinas = RECORD
                cod_disciplina: integer;
                descripcion: string;
                equipo: string;
                activo: boolean;
                END;

    participantes = RECORD
                  cod_disciplina: integer;
                  anio_competencia: integer;
                  dni: string;
                  activo: boolean;
                  END;

    sedes = RECORD
          cod_internacional: integer;
          descripcion: string;
          activo: boolean;
          END;

   medallasXatletas = RECORD
                    dni: string;
                    anio_competencia: integer;
                    cod_internacional: integer;
                    medalla: medallas;
                    activo: boolean;
                    END;

VAR
archivo_atletas: FILE OF atletas;
registro_atletas: atletas;
archivo_disciplinas: FILE OF disciplinas;
registro_disciplinas: disciplinas;
archivo_participantes: FILE OF participantes;
registro_participantes: participantes;
archivo_sedes: FILE OF sedes;
registro_sedes: sedes;
archivo_medallasXatletas: FILE OF medallasXatletas;
registro_medallasXatletas: medallasXatletas;

PROCEDURE crear_archivo_atletas;
 BEGIN
 rewrite(archivo_atletas);
 close(archivo_atletas);
 END;

PROCEDURE crear_archivo_disciplinas;
 BEGIN
 rewrite(archivo_disciplinas);
 close(archivo_disciplinas);
 END;

PROCEDURE crear_archivo_participantes;
 BEGIN
 rewrite(archivo_participantes);
 close(archivo_participantes);
 END;

PROCEDURE crear_archivo_sedes;
 BEGIN
 rewrite(archivo_sedes);
 close(archivo_sedes);
 END;

PROCEDURE crear_archivo_medallasXatletas;
 BEGIN
 rewrite(archivo_medallasXatletas);
 close(archivo_medallasXatletas);
 END;

FUNCTION verifica_estado_archivo_atletas(): boolean;
 BEGIN
 IF FILESIZE(archivo_atletas) = 0 THEN
  verifica_estado_archivo_atletas:= true
 ELSE
  verifica_estado_archivo_atletas:= false;
 END;

FUNCTION existe_documento(documento: string): boolean;
VAR
 f: boolean;
 BEGIN
  f:= false;
  REPEAT
  read(archivo_atletas,registro_atletas);
  IF documento = registro_atletas.dni THEN
   f:= true;
  UNTIL eof(archivo_atletas) OR (f = true);
  IF f = true THEN
   existe_documento:= true
  ELSE
   existe_documento:= false;
 END;

PROCEDURE ordena_atletas_por_DNI();
VAR
 i,j: integer;
 registro_atletas_auxiliar: atletas;
 BEGIN
 reset(archivo_atletas);
 FOR i:= 0 TO filesize(archivo_atletas) - 2 DO
  BEGIN
  FOR j:= i + 1 TO filesize(archivo_atletas) - 1 DO
   BEGIN
   seek(archivo_atletas,i);
   read(archivo_atletas,registro_atletas);
   seek(archivo_atletas,j);
   read(archivo_atletas,registro_atletas_auxiliar);
   IF registro_atletas.dni > registro_atletas_auxiliar.dni THEN
    BEGIN
    seek(archivo_atletas,i);
    write(archivo_atletas,registro_atletas_auxiliar);
    seek(archivo_atletas,j);
    write(archivo_atletas,registro_atletas);
    END;
   END;
  END;
  close(archivo_atletas);
 END;

PROCEDURE alta_atletas;
VAR
 documento,opcion: string;
 BEGIN
  reset(archivo_atletas);
  IF verifica_estado_archivo_atletas() = true THEN
   BEGIN
   writeln('INGRESE TODOS LOS DATOS DEL ATLETA');
   writeln('----------------------------------');
   writeln();
   write('>>> Ingrese nro de DNI: ');
   readln(registro_atletas.dni);
   writeln();
   write('>>> Ingrese nombre y apellido: ');
   readln(registro_atletas.nombre_apellido);
   registro_atletas.activo:= true;
   seek(archivo_atletas,filesize(archivo_atletas));
   write(archivo_atletas,registro_atletas);
   close(archivo_atletas);
   writeln();
   textcolor(lightgreen);
   writeln('===============================================');
   writeln('*** Atleta cargado con exito y dado de alta ***');
   writeln('===============================================');
   delay(2000);
   END
  ELSE
   BEGIN
   REPEAT
   reset(archivo_atletas);
   clrscr;
   writeln('INGRESE TODOS LOS DATOS DEL ATLETA');
   writeln('----------------------------------');
   writeln();
   write('>>> Ingrese nro de DNI: ');
   readln(documento);
   IF existe_documento(documento) = true THEN
    BEGIN
    textcolor(lightred);
    writeln();
    writeln('=================');
    writeln('X DNI existente X');
    writeln('=================');
    END
   ELSE
   BEGIN
    registro_atletas.dni:= documento;
    writeln();
    write('>>> Ingrese nombre y apellido: ');
    readln(registro_atletas.nombre_apellido);
    registro_atletas.activo:= true;
    seek(archivo_atletas,filesize(archivo_atletas));
    write(archivo_atletas,registro_atletas);
    close(archivo_atletas);
    writeln();
    textcolor(lightgreen);
    writeln('===============================================');
    writeln('*** Atleta cargado con exito y dado de alta ***');
    writeln('===============================================');
    writeln();
   END;
    ordena_atletas_por_DNI();
    writeln();
    REPEAT
    textcolor(lightgreen);
    write('Desea volver a cargar otro atleta[s/n]?: ');
    readln(opcion);
    IF (opcion <> 's') AND (opcion <> 'n') THEN
     BEGIN
     textcolor(lightred);
     writeln();
     writeln('========================================');
     writeln('X Valor incorrecto. Ingrese nuevamente X');
     writeln('========================================');
     writeln();
     END;
    UNTIL (opcion = 's') OR (opcion = 'n');
   UNTIL (opcion = 'n');
 END;
END;

PROCEDURE menu_altas;
VAR
   opcion: integer;
   BEGIN
   REPEAT
    clrscr;
    textcolor(green);
    writeln('----------');
    writeln('MENU ALTAS');
    writeln('----------');
    writeln();
    writeln('------------------------------');
    writeln('1. Alta de atletas');
    writeln('2. Alta de disciplinas');
    writeln('3. Alta de participantes');
    writeln('4. Alta de sedes');
    writeln('5. Alta de medallas X atletas');
    writeln('6. Volver al menu de ABM');
    writeln('-----------------------------');
    writeln();
    write('Seleccione opcion: ');
    readln(opcion);
    CASE opcion OF
         1:BEGIN
           clrscr;
           alta_atletas;
           END;
        { 2:BEGIN
           END;
         3:BEGIN
           END;
         4:BEGIN
           END;
         5:BEGIN
           END; }
    END;
   UNTIL (opcion = 6);
   END;

PROCEDURE menu_abm;
VAR
 opcion: integer;
 BEGIN
 REPEAT
 clrscr;
 writeln('------------------');
 writeln('MENU PRINCIPAL ABM');
 writeln('------------------');
 writeln();
 writeln('------------------------------------');
 writeln('1. Altas');
 writeln('2. Bajas(solo para el archivo sedes)');
 writeln('3. Modificaciones(solo para el archivo sedes)');
 writeln('4. Volver al menu principal');
 writeln('------------------------------------');
 writeln();
 write('Seleccione opcion: ');
 readln(opcion);
 CASE opcion OF
      1:BEGIN
        clrscr;
        menu_altas;
        END;
     { 2:BEGIN
        END;
      3:BEGIN
        END; }
 END;
 UNTIL (opcion = 4);
 END;

PROCEDURE menu_principal;
VAR
  opcion: integer;
   BEGIN
   REPEAT
    clrscr;
    writeln('--------------');
    writeln('MENU PRINCIPAL');
    writeln('--------------');
    writeln();
    writeln('---------------------------------------------------------------------------');
    writeln('1. ABM');
    writeln('2. Listado de atletas olimpicos en un año determinado');
    writeln('3. Listado de metallas ganadas de cada tipo para un anio determinado');
    writeln('4. Listado de disiciplinas de cierto aino');
    writeln('5. Mostrar trayectoria individual y grupal de cierto atleta');
    writeln('6. Mostrar participantes mediante disciplina y anio de competencia');
    writeln('7. Pais sede donde se compitio con mayor cantidad de medallas ganadas');
    writeln('8. Ranking del top 10 de deportistas con mayor cantidad de medallas ganadas');
    writeln('9. Salir');
    writeln('---------------------------------------------------------------------------');
    writeln();
    write('Seleccione una opcion <teclas del 1 al 9 inclusive>');
    readln(opcion);
    CASE opcion OF
         1: BEGIN
            clrscr;
            menu_abm;
            END;
       {  2: BEGIN
            END;
         3: BEGIN
            END;
         4: BEGIN
            END;
         5: BEGIN
            END;
         6: BEGIN
            END;
         7: BEGIN
            END;
         8: BEGIN
            END; }

    END;
   UNTIL (opcion = 9);
   END;

BEGIN
assign(archivo_atletas,'C:\Users\JULIO\Desktop\sistema-olimpiadas\atletas.dat');
assign(archivo_disciplinas,'C:\Users\JULIO\Desktop\sistema-olimpiadas\disciplinas.dat');
assign(archivo_participantes,'C:\Users\JULIO\Desktop\sistema-olimpiadas\participantes.dat');
assign(archivo_sedes,'C:\Users\JULIO\Desktop\sistema-olimpiadas\sedes.dat');
assign(archivo_medallasXatletas,'C:\Users\JULIO\Desktop\sistema-olimpiadas\medallasXatletas.dat');
crear_archivo_atletas;
crear_archivo_disciplinas;
crear_archivo_participantes;
crear_archivo_sedes;
crear_archivo_medallasXatletas;
menu_principal;
END.
