PROGRAM sistemas_olimpiadas;
USES crt;

TYPE
    total_medallas = array[1..3]of integer;

    atletas = RECORD
            dni: string;
            nombre_apellido: string;
            pais_atleta: string;
            activo: boolean;
            END;

    disciplinas = RECORD
                cod_disciplina: string;
                descripcion: string;
                equipo: string;
                activo: boolean;
                anio_competencia: integer;
                END;

    participantes = RECORD
                  cod_disciplina: string;
                  anio_competencia: integer;
                  dni: string;
                  activo: boolean;
                  END;

    sedes = RECORD
          cod_internacional: string;
          descripcion: string;
          anio_competencia: integer;
          activo: boolean;
          END;

   medallasXatletas = RECORD
                    dni: string;
                    anio_competencia: integer;
                    cod_internacional: string;
                    medalla: array [1..3]of integer;
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
tot_medal: total_medallas;

PROCEDURE incializar_arreglo_medallas;
VAR
 f: integer;
 BEGIN
 FOR f:= 1 TO 3 DO
  BEGIN
  registro_medallasXatletas.medalla[f]:= 0;
  END;
 END;

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

FUNCTION verificar_estado_archivo_disciplinas(): boolean;
 BEGIN
 reset(archivo_disciplinas);
 IF filesize(archivo_disciplinas) = 0 THEN
  verificar_estado_archivo_disciplinas:= true
 ELSE
  verificar_estado_archivo_disciplinas:= false;
 close(archivo_disciplinas);
 END;

FUNCTION verificar_estado_archivo_participantes(): boolean;
 BEGIN
 reset(archivo_participantes);
 IF filesize(archivo_participantes) = 0 THEN
  verificar_estado_archivo_participantes:= true
 ELSE
  verificar_estado_archivo_participantes:= false;
 close(archivo_participantes);
 END;

FUNCTION verificar_estado_archivo_sedes(): boolean;
 BEGIN
 reset(archivo_sedes);
 IF filesize(archivo_sedes) = 0 THEN
  verificar_estado_archivo_sedes:= true
 ELSE
  verificar_estado_archivo_sedes:= false;
 close(archivo_sedes);
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

FUNCTION existe_disciplina(codigo_disciplina: string): boolean;
VAR
 f: boolean;
 BEGIN
 f:= false;
 REPEAT
 read(archivo_disciplinas,registro_disciplinas);
 IF codigo_disciplina = registro_disciplinas.cod_disciplina THEN
  f:= true;
 UNTIL eof(archivo_disciplinas) OR (f = true);
 IF f = true THEN
  existe_disciplina:= true
 ELSE
  existe_disciplina:= false;
 END;

FUNCTION existe_codigo_internacional(codigo_internacional: string): boolean;
VAR
 f: boolean;
 BEGIN
 f:= false;
 REPEAT
 read(archivo_sedes,registro_sedes);
 IF codigo_internacional = registro_sedes.cod_internacional THEN
  f:= true;
 UNTIL eof(archivo_sedes) OR (f = true);
 IF f = true THEN
  existe_codigo_internacional:= true
 ELSE
  existe_codigo_internacional:= false;
 END;

FUNCTION verifica_estado_archivo_medallasXatletas(): boolean;
  BEGIN
  reset(archivo_medallasXatletas);
  IF filesize(archivo_medallasXatletas) = 0 THEN
   verifica_estado_archivo_medallasXatletas:= true
  ELSE
   verifica_estado_archivo_medallasXatletas:= false;
  close(archivo_medallasXatletas);
  END;

FUNCTION valida_anio_competencia(): integer;
VAR
 anio_comp: integer;
 BEGIN
 REPEAT
 textcolor(white);
 write('>>> Ingrese anio de competencia entre 1900 y 2017: ');
 readln(anio_comp);
 IF (anio_comp < 1900) OR (anio_comp > 2017) THEN
  BEGIN
  textcolor(lightred);
  writeln();
  writeln('======================================');
  writeln('X Fuera de rango. Intente nuevamente X');
  writeln('======================================');
  writeln();
  END;
 UNTIL (anio_comp >= 1900) AND (anio_comp <= 2017);
 valida_anio_competencia:= anio_comp;
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

PROCEDURE ordena_particpantes_por_anio();
VAR
 i,j: integer;
 registro_disciplinas_auxiliar: disciplinas;
 BEGIN
 reset(archivo_disciplinas);
 FOR i:= 0 TO filesize(archivo_disciplinas) - 2 DO
  BEGIN
  FOR j:= i + 1 TO filesize(archivo_disciplinas) - 1 DO
   BEGIN
   seek(archivo_disciplinas,i);
   read(archivo_disciplinas,registro_disciplinas);
   seek(archivo_disciplinas,j);
   read(archivo_disciplinas,registro_disciplinas_auxiliar);
   IF registro_disciplinas.anio_competencia > registro_disciplinas_auxiliar.anio_competencia THEN
    BEGIN
    seek(archivo_disciplinas,i);
    write(archivo_disciplinas,registro_disciplinas_auxiliar);
    seek(archivo_disciplinas,j);
    write(archivo_disciplinas,registro_disciplinas);
    END;
   END;
  END;
  close(archivo_disciplinas);
 END;

PROCEDURE alta_atletas;
VAR
 documento,opcion: string;
 BEGIN
  reset(archivo_atletas);
  IF verifica_estado_archivo_atletas() = true THEN
   BEGIN
   textcolor(lightcyan);
   writeln('INGRESE TODOS LOS DATOS DEL ATLETA');
   writeln('----------------------------------');
   writeln();
   write('>>> Ingrese nro de DNI: ');
   readln(registro_atletas.dni);
   writeln();
   write('>>> Ingrese nombre y apellido: ');
   readln(registro_atletas.nombre_apellido);
   writeln();
   write('>>> Ingrese pais de origen: ');
   readln(registro_atletas.pais_atleta);
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
   textcolor(lightcyan);
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
    writeln();
    write('>>> Ingrese pais de origen: ');
    readln(registro_atletas.pais_atleta);
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

PROCEDURE alta_disciplinas;
VAR
 anio: integer;
 op,codigo_disciplina,opcion: string;
 BEGIN
 IF verificar_estado_archivo_disciplinas() = true THEN
  BEGIN
  reset(archivo_disciplinas);
  textcolor(cyan);
  writeln('INGRESE TODOS LOS DATOS DE LA DISCIPLINA');
  writeln('----------------------------------------');
  writeln();
  write('>>> Ingrese codigo de disciplina: ');
  readln(registro_disciplinas.cod_disciplina);
  writeln();
  write('>>> Ingrese la descripcion: ');
  readln(registro_disciplinas.descripcion);
  writeln();
  REPEAT
  write('>>> Disciplina en equipo[s/n]?: ');
  readln(op);
  IF (op <> 's') AND (op <> 'n') THEN
   BEGIN
   textcolor(lightred);
   writeln();
   writeln('=========================================');
   writeln('X Valor incorrecto. Ingrese nuevamente X ');
   writeln('=========================================');
   END;
  UNTIL (op = 's') OR (op = 'n');
  registro_disciplinas.equipo:= op;
  writeln();
  anio:= valida_anio_competencia;
  registro_disciplinas.anio_competencia:= anio;
  registro_disciplinas.activo:= true;
  seek(archivo_disciplinas,filesize(archivo_disciplinas));
  write(archivo_disciplinas,registro_disciplinas);
  close(archivo_disciplinas);
  textcolor(lightgreen);
  writeln();
  writeln('===================================================');
  writeln('*** Disciplina cargada con exito y dada de alta ***');
  writeln('===================================================');
  delay(2000);
  END
 ELSE
  BEGIN
  REPEAT
  reset(archivo_disciplinas);
  clrscr;
  textcolor(cyan);
  writeln('INGRESE TODOS LOS DATOS DE LA DISCIPLINA');
  writeln('----------------------------------------');
  writeln();
  write('>>> Ingrese codigo de disciplina: ');
  readln(codigo_disciplina);
  IF existe_disciplina(codigo_disciplina) = true THEN
   BEGIN
   textcolor(lightred);
   writeln();
   writeln('============================');
   writeln('X Competencia ya existente X');
   writeln('============================');
   writeln();
   END
  ELSE
   BEGIN
   registro_disciplinas.cod_disciplina:= codigo_disciplina;
   writeln();
   write('>>> Ingrese la descripcion: ');
   readln(registro_disciplinas.descripcion);
   writeln();
   REPEAT
   write('>>> Disciplina en equipo[s/n]?: ');
   readln(op);
   IF (op <> 's') AND (op <> 'n') THEN
    BEGIN
    textcolor(lightred);
    writeln();
    writeln('=========================================');
    writeln('X Valor incorrecto. Ingrese nuevamente X ');
    writeln('=========================================');
   END;
   UNTIL (op = 's') OR (op = 'n');
   registro_disciplinas.equipo:= op;
   writeln();
   anio:= valida_anio_competencia;
   registro_disciplinas.anio_competencia:= anio;
   registro_disciplinas.activo:= true;
   seek(archivo_disciplinas,filesize(archivo_disciplinas));
   write(archivo_disciplinas,registro_disciplinas);
   close(archivo_disciplinas);
   textcolor(lightgreen);
   writeln();
   writeln('===================================================');
   writeln('*** Disciplina cargada con exito y dada de alta ***');
   writeln('===================================================');
   writeln();
   END;
   REPEAT
   textcolor(lightgreen);
   writeln('Desea volver a cargar otra disciplina[s/n]:? ');
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

PROCEDURE alta_participantes;
VAR
 anio:integer;
 opcion: string;
 BEGIN
 textcolor(white);
 IF verificar_estado_archivo_participantes = true THEN
  BEGIN
  reset(archivo_participantes);
  writeln('INGRESE LOS DATOS DE LOS PARTICIPANTES');
  writeln('--------------------------------------');
  writeln();
  write('>>> Ingrese codigo de disciplina: ');
  readln(registro_participantes.cod_disciplina);
  writeln();
  anio:= valida_anio_competencia();
  registro_participantes.anio_competencia:= anio;
  writeln();
  write('>>> Ingrese DNI del participante: ');
  readln(registro_participantes.dni);
  registro_participantes.activo:= true;
  seek(archivo_participantes,filesize(archivo_participantes));
  write(archivo_participantes,registro_participantes);
  close(archivo_participantes);
  writeln();
  textcolor(lightgreen);
  writeln('=====================================================');
  writeln('*** Participante cargado con exito y dado de alta ***');
  writeln('=====================================================');
  delay(2000);
  END
 ELSE
  BEGIN
  REPEAT
  reset(archivo_participantes);
  clrscr;
  textcolor(white);
  writeln('INGRESE LOS DATOS DE LOS PARTICIPANTES');
  writeln('--------------------------------------');
  writeln();
  write('>>> Ingrese codigo de disciplina: ');
  readln(registro_participantes.cod_disciplina);
  writeln();
  write('>>> Ingrese anio de competencia: ');
  readln(registro_participantes.anio_competencia);
  writeln();
  write('>>> Ingrese DNI del participante: ');
  readln(registro_participantes.dni);
  registro_participantes.activo:= true;
  seek(archivo_participantes,filesize(archivo_participantes));
  write(archivo_participantes,registro_participantes);
  close(archivo_participantes);
  writeln();
  textcolor(lightgreen);
  writeln('=====================================================');
  writeln('*** Participante cargado con exito y dado de alta ***');
  writeln('=====================================================');
  writeln();
  REPEAT
  textcolor(lightgreen);
  write('Desea volver a cargar otro participante[s/n]?: ');
  readln(opcion);
  IF (opcion <> 's') AND (opcion <> 'n') THEN
   BEGIN
   textcolor(lightred);
   writeln();
   writeln('======================================');
   writeln('X Valor incorrecto. Ingrese nuevamente');
   writeln('======================================');
   END;
  UNTIL (opcion = 's') OR (opcion = 'n');
  UNTIL (opcion = 'n');
  ordena_particpantes_por_anio;
  END;
 END;

PROCEDURE alta_sedes;
VAR
 anio: integer;
 opcion,codigo_internacional: string;
 BEGIN
 IF verificar_estado_archivo_sedes = true THEN
  BEGIN
  reset(archivo_sedes);
  textcolor(white);
  writeln('INGRESE LOS DATOS DE LA SEDE');
  writeln('----------------------------');
  writeln();
  write('>>> Ingrese codigo internacional: ');
  readln(registro_sedes.cod_internacional);
  writeln();
  write('>>> Ingrese descripcion: ');
  readln(registro_sedes.descripcion);
  writeln();
  anio:= valida_anio_competencia;
  registro_sedes.anio_competencia:= anio;
  registro_sedes.activo:= true;
  seek(archivo_sedes,filesize(archivo_sedes));
  write(archivo_sedes,registro_sedes);
  close(archivo_sedes);
  writeln();
  textcolor(lightgreen);
  writeln('=============================================');
  writeln('*** Sede cargada con exito y dada de alta ***');
  writeln('=============================================');
  delay(2000);
  END
 ELSE
  BEGIN
  REPEAT
  clrscr;
  reset(archivo_sedes);
  textcolor(white);
  writeln('INGRESE LOS DATOS DE LA SEDE');
  writeln('----------------------------');
  writeln();
  write('>>> Ingrese codigo internacional: ');
  readln(codigo_internacional);
  IF existe_codigo_internacional(codigo_internacional) = true THEN
   BEGIN
   textcolor(lightred);
   writeln();
   writeln('=====================================');
   writeln('X Codigo internacional ya existente X');
   writeln('=====================================');
   END
  ELSE
   BEGIN
   registro_sedes.cod_internacional:= codigo_internacional;
   writeln();
   write('>>> Ingrese descripcion: ');
   readln(registro_sedes.descripcion);
   registro_sedes.activo:= true;
   seek(archivo_sedes,filesize(archivo_sedes));
   write(archivo_sedes,registro_sedes);
   close(archivo_sedes);
   writeln();
   textcolor(lightgreen);
   writeln('=============================================');
   writeln('*** Sede cargada con exito y dada de alta ***');
   writeln('=============================================');
   writeln();
   END;
   REPEAT
   writeln();
   textcolor(lightgreen);
   writeln('Desea volver a cargar otra sede[s/n]?: ');
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

FUNCTION medalla_ganada(): integer;
VAR
 op: integer;
 BEGIN
 incializar_arreglo_medallas;
 writeln('Que medalla ha ganado? ');
 writeln('-----------------------');
 writeln();
 textcolor(yellow);
 writeln('1. Oro');
 textcolor(brown);
 writeln('2. Plata');
 textcolor(white);
 writeln('3. Bronce');
 writeln();
 writeln('-----------------------');
 write('Seleccione medalla(teclas 1 al 3): ');
 readln(op);
 CASE op OF
      1:BEGIN
        medalla_ganada:= 1;
        END;
      2:BEGIN
        medalla_ganada:= 2;
        END;
      3:BEGIN
        medalla_ganada:= 3;
        END;
 END;
 END;

PROCEDURE alta_medallasXatletas;
VAR
 opcion: string;
 medalla,anio: integer;
 BEGIN
 REPEAT
 clrscr;
 reset(archivo_medallasXatletas);
 writeln('INGRESE MEDALLAS X CADA ATLETA');
 writeln('------------------------------');
 writeln();
 write('>>> Ingrese DNI del atleta: ');
 readln(registro_medallasXatletas.dni);
 writeln();
 anio:= valida_anio_competencia();
 registro_medallasXatletas.anio_competencia:= anio;
 writeln();
 write('>>> Ingrese codigo internacional: ');
 readln(registro_medallasXatletas.cod_internacional);
 writeln();
 medalla:= medalla_ganada;
 registro_medallasXatletas.medalla[medalla]:= 1;
 registro_medallasXatletas.activo:= true;
 seek(archivo_medallasXatletas,filesize(archivo_medallasXatletas));
 write(archivo_medallasXatletas,registro_medallasXatletas);
 close(archivo_medallasXatletas);
 writeln();
 textcolor(lightgreen);
 writeln('================================================');
 writeln('*** Atleta cargado con su respectiva medalla ***');
 writeln('================================================');
 writeln();
 REPEAT
  write('Desea volver a cargar otro atleta con su medalla[s/n]?: ');
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
    textcolor(magenta);
    writeln('------------------------------');
    writeln('1. Alta de atletas');
    writeln('------------------------------');
    writeln('2. Alta de disciplinas');
    writeln('------------------------------');
    writeln('3. Alta de participantes');
    writeln('------------------------------');
    writeln('4. Alta de sedes');
    writeln('------------------------------');
    writeln('5. Alta de medallas X atletas');
    writeln('------------------------------');
    writeln('6. Volver al menu de ABM');
    writeln('-----------------------------');
    writeln();
    textcolor(cyan);
    writeln('==========================');
    write('Seleccione opcion: ');
    readln(opcion);
    CASE opcion OF
         1:BEGIN
           clrscr;
           alta_atletas;
           END;
         2:BEGIN
           clrscr;
           alta_disciplinas;
           END;
         3:BEGIN
           clrscr;
           alta_participantes;
           END;
         4:BEGIN
           clrscr;
           alta_sedes;
           END;
         5:BEGIN
           clrscr;
           alta_medallasXatletas
           END;
    END;
   UNTIL (opcion = 6);
   END;

PROCEDURE menu_abm;
VAR
 opcion: integer;
 BEGIN
 REPEAT
 clrscr;
 textcolor(lightgreen);
 writeln('------------------');
 writeln('MENU PRINCIPAL ABM');
 writeln('------------------');
 writeln();
 textcolor(lightmagenta);
 writeln('------------------------------------');
 writeln('1. Altas');
 writeln('------------------------------------');
 writeln('2. Bajas(solo para el archivo sedes)');
 writeln('------------------------------------');
 writeln('3. Modificaciones(solo para el archivo sedes)');
 writeln('------------------------------------');
 writeln('4. Volver al menu principal');
 writeln('------------------------------------');
 writeln();
 textcolor(yellow);
 writeln('====================================');
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

FUNCTION busca_sede(anio: integer): string;
VAR
 f: boolean;
 BEGIN
 reset(archivo_sedes);
 f:= false;
 REPEAT
 read(archivo_sedes,registro_sedes);
 IF anio = registro_sedes.anio_competencia THEN
  f:= true;
 UNTIL eof(archivo_sedes) OR (f = true);
 close(archivo_sedes);
 IF f = true THEN
  busca_sede:= registro_sedes.descripcion;
 END;

FUNCTION busca_atleta(documento: string): string;
VAR
 f: boolean;
 inf,sup,medio: integer;
 BEGIN
 reset(archivo_atletas);
 f:= false;
 sup:= filesize(archivo_atletas) - 1;
 inf:= 0;
 REPEAT
 medio:= (inf + sup) div 2;
 seek(archivo_atletas,medio);
 read(archivo_atletas,registro_atletas);
 IF documento = registro_atletas.dni THEN
  f:= true
 ELSE
  BEGIN
  IF registro_atletas.dni > documento THEN
    sup:= medio - 1
  ELSE
    inf:= medio + 1;
  END;
 UNTIL eof(archivo_atletas) OR (f = true);
 IF f = true THEN
   busca_atleta:= registro_atletas.nombre_apellido;
 close(archivo_atletas);
 END;

PROCEDURE mostrar_atletas(anio: integer);
VAR
 documento,atleta: string;
 BEGIN
 WHILE NOT eof(archivo_participantes) DO
  BEGIN
  read(archivo_participantes,registro_participantes);
  IF anio = registro_participantes.anio_competencia THEN
   BEGIN
   documento:= registro_participantes.dni;
   atleta:= busca_atleta(documento);
   IF documento =  registro_participantes.dni THEN
    BEGIN
    write(documento,' ',atleta);
    writeln();
    END;
   END;
  END;
 END;

PROCEDURE listado_atletas_por_anio;
VAR
 sede,opcion: string;
 anio: integer;
 BEGIN
 IF verificar_estado_archivo_participantes = true THEN
  BEGIN
  textcolor(lightred);
  writeln('=========================================================================');
  writeln('X No hay registros cargados en el archivo participantes por el momento. X');
  writeln('=========================================================================');
  delay(2000);
  END
 ELSE
  BEGIN
  IF verificar_estado_archivo_sedes = true THEN
   BEGIN
   textcolor(lightred);
   writeln('=================================================================');
   writeln('X No hay registros cargados en el archivo sedes por el momento. X');
   writeln('=================================================================');
   delay(2000);
   END
  ELSE
   BEGIN
   REPEAT
   clrscr;
   reset(archivo_participantes);
   writeln('PARA VER TODOS LOS ATLETAS DE UNA COMPETENCIA DETERMINADA INGRESE UN ANIO');
   writeln('-------------------------------------------------------------------------');
   writeln();
   anio:= valida_anio_competencia();
   sede:= busca_sede(anio);
   writeln();
   writeln('Olimpiada ',anio,' de,',sede);
   writeln();
   mostrar_atletas(anio);
   close(archivo_participantes);
   writeln();
   REPEAT
   writeln('Desea volver otro listado[s/n]?: ');
   readln(opcion);
   IF (opcion <> 's') AND (opcion <> 'n') THEN
    BEGIN
    textcolor(lightred);
    writeln('========================================');
    writeln('X Valor incorrecto. Ingrese nuevamente X');
    writeln('========================================');
    END;
   UNTIL (opcion = 's') OR (opcion = 'n');
   UNTIL (opcion = 'n');
   END;
  END;
 END;

FUNCTION busca_codigo_internacional(anio: integer): string;
VAR
 f: boolean;
 BEGIN
 reset(archivo_sedes);
 f:= false;
 REPEAT
 read(archivo_sedes,registro_sedes);
 IF anio = registro_sedes.anio_competencia THEN
  f:= true;
 UNTIL eof(archivo_sedes) OR (f = true);
 close(archivo_sedes);
 IF f = true THEN
  busca_codigo_internacional:= registro_sedes.cod_internacional;
 END;

PROCEDURE muestra_lista_medallas(cod_int: string);
VAR
 f: integer;
 BEGIN
 reset(archivo_medallasXatletas);
 writeln('DNI    |  ORO - PLATA - BRONCE ');
 WHILE NOT eof(archivo_medallasXatletas) DO
  BEGIN
  read(archivo_medallasXatletas,registro_medallasXatletas);
  IF cod_int = registro_medallasXatletas.cod_internacional THEN
   BEGIN
   writeln();
   writeln(registro_medallasXatletas.dni);
   FOR f:= 1 TO 3 DO
    BEGIN
    write(registro_medallasXatletas.medalla[f]);
    END;
   END;
  END;
 close(archivo_medallasXatletas);
 END;

PROCEDURE muestra_listado_medallas;
VAR
 cod_int,opcion: string;
 anio: integer;
 BEGIN
 IF verifica_estado_archivo_medallasXatletas = true THEN
  BEGIN
  textcolor(lightred);
  writeln('============================================================');
  writeln('X El archivo de medallas se encuentra vacio. Intente Luego X');
  writeln('============================================================');
  delay(2000);
  END
 ELSE
  BEGIN
  REPEAT
  clrscr;
  writeln('INGRESE UN ANIO PARA PODER VER LISTADO DE MEDALLAS');
  writeln('--------------------------------------------------');
  writeln();
  anio:= valida_anio_competencia;
  cod_int:= busca_codigo_internacional(anio);
  writeln('SEDE: ',cod_int,' ANIO: ',anio);
  writeln('-------------------------------');
  writeln();
  muestra_lista_medallas(cod_int);
  writeln();
   REPEAT
   textcolor(lightgreen);
   write('Desea volver a ver otro listado[s/n]?: ');
   readln(opcion);
   IF (opcion <> 's') AND (opcion <> 'n') THEN
    BEGIN
    writeln();
    textcolor(lightred);
    writeln('========================================');
    writeln('X Valor incorrecto. Ingrese nuevamente X');
    writeln('========================================');
    END;
   UNTIL (opcion = 's') OR (opcion = 'n');
 UNTIL (opcion = 'n');
  END;
 END;

PROCEDURE muestra_disciplinas(anio: integer);
 BEGIN
 reset(archivo_disciplinas);
 WHILE NOT eof(archivo_disciplinas) DO
  BEGIN
  read(archivo_disciplinas,registro_disciplinas);
  IF anio = registro_disciplinas.anio_competencia THEN
  BEGIN
  writeln();
  write(registro_disciplinas.cod_disciplina,' ',registro_disciplinas.descripcion,' ',registro_disciplinas.equipo);
  END;
  END;
 close(archivo_disciplinas);
 END;

PROCEDURE muestra_listado_disciplinas;
VAR
 opcion,cod_int: string;
 anio: integer;
 BEGIN
 IF verificar_estado_archivo_disciplinas = true THEN
  BEGIN
  textcolor(lightred);
  writeln('===============================================================');
  writeln('X El archivo de disciplinas se encuentra vacio. Intente luego X');
  writeln('===============================================================');
  delay(2000);
  END
 ELSE
  BEGIN
  REPEAT
  textcolor(white);
  writeln('INGRESE UN ANIO DETERMINADO PARA PODER VER TODAS SUS DISCILPLINAS');
  writeln('-----------------------------------------------------------------');
  writeln();
  anio:= valida_anio_competencia;
  cod_int:= busca_codigo_internacional(anio);
  writeln('SEDE: ',cod_int,' ','ANIO: ',anio);
  muestra_disciplinas(anio);
  REPEAT
  textcolor(lightgreen);
  writeln();
  write('Desea volver a ver otro listado[s/n]?: ');
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

FUNCTION existe_atleta(documento: string): boolean;
VAR
 f: boolean;
 inf,sup,medio: integer;
 BEGIN
 reset(archivo_atletas);
 f:= false;
 sup:= filesize(archivo_atletas) - 1;
 inf:= 0;
 REPEAT
 medio:= (inf + sup) div 2;
 seek(archivo_atletas,medio);
 read(archivo_atletas,registro_atletas);
 IF documento = registro_atletas.dni THEN
  f:= true
 ELSE
  BEGIN
  IF registro_atletas.dni > documento THEN
    sup:= medio - 1
  ELSE
    inf:= medio + 1;
  END;
 UNTIL eof(archivo_atletas) OR (f = true);
 IF f = true THEN
   existe_atleta:= true
 ELSE
   existe_atleta:= false;
 close(archivo_atletas);
 END;

FUNCTION busca_sede_descripcion(anio_comp: integer): string;
VAR
 f: boolean;
 BEGIN
 reset(archivo_sedes);
 f:= false;
 REPEAT
 read(archivo_sedes,registro_sedes);
 IF anio_comp = registro_sedes.anio_competencia THEN
  f:= true;
 UNTIL eof(archivo_sedes) OR (f = true);
 IF f = true THEN
  busca_sede_descripcion:= registro_sedes.descripcion;
 close(archivo_sedes);
 END;

FUNCTION busca_descripcion_disciplina(cod_dis: string): string;
VAR
 f: boolean;
 BEGIN
 f:= false;
 reset(archivo_disciplinas);
 REPEAT
 read(archivo_disciplinas,registro_disciplinas);
 IF cod_dis = registro_disciplinas.cod_disciplina THEN
  f:= true;
 UNTIL eof(archivo_disciplinas) OR (f = true);
 IF f = true THEN
   busca_descripcion_disciplina:= registro_disciplinas.descripcion;
 close(archivo_disciplinas);
 END;

PROCEDURE contador_medallas(documento: string; anio_comp: integer);
VAR
 f:integer;
 BEGIN
 reset(archivo_medallasXatletas);
 WHILE NOT eof(archivo_medallasXatletas) DO
  BEGIN
  read(archivo_medallasXatletas,registro_medallasXatletas);
  IF documento = registro_medallasXatletas.dni THEN
   IF anio_comp = registro_medallasXatletas.anio_competencia THEN
    BEGIN
    FOR f:= 1 TO 3 DO
     BEGIN
      IF registro_medallasXatletas.medalla[f] = 1 THEN
       tot_medal[f]:= tot_medal[f] + 1;
     END;
    END;
  END;
 close(archivo_medallasXatletas);
 END;

PROCEDURE ubica_dni_en_participantes(documento: string);
VAR
 anio_comp: integer;
 sede,almacena_desc_dis,cod_dis: string;
 BEGIN
 reset(archivo_participantes);
 WHILE NOT eof(archivo_participantes) DO
  BEGIN
  read(archivo_participantes,registro_participantes);
  IF documento = registro_participantes.dni THEN
   BEGIN
   anio_comp:= registro_participantes.anio_competencia;
   sede:= busca_sede_descripcion(anio_comp);
   writeln('SEDE: ',sede);
   writeln('-----------');
   writeln();
   cod_dis:= registro_participantes.cod_disciplina;
   almacena_desc_dis:= busca_descripcion_disciplina(cod_dis);
   writeln('CODIGO DISCIPLINA: ',registro_participantes.cod_disciplina,'|','DESCRIPCION: ',almacena_desc_dis);
   writeln();
   writeln('------------------------------------------------------------------------------------------------');
   END;
  END;
  contador_medallas(documento,anio_comp);
  writeln('ORO | PLATA | BRONCE');
  writeln('--------------------');
  write(tot_medal[1],' ',tot_medal[2],' ',tot_medal[3]);
 close(archivo_participantes);
 END;

PROCEDURE muestra_trayectoria_atleta;
VAR
 documento,nom_ape,opcion: string;
 BEGIN
 reset(archivo_atletas);
 IF verifica_estado_archivo_atletas = true THEN
  BEGIN
  textcolor(lightred);
  writeln('==========================================================');
  writeln('X El archivo atletas no contiene registro. Intente luego X');
  writeln('==========================================================');
  close(archivo_atletas);
  delay(2000);
  END
 ELSE
  BEGIN
  REPEAT
  clrscr;
  writeln('INGRESE UN ATLETA MEDIANTE SU DNI PARA VER SU TRAYECTORIA');
  writeln('---------------------------------------------------------');
  readln(documento);
  IF existe_atleta(documento) = true THEN
   BEGIN
   nom_ape:= busca_atleta(documento);
   writeln('======================================');
   writeln('|| NOMBRE DEL ATLETA: ',nom_ape);
   writeln('======================================');
   writeln();
   ubica_dni_en_participantes(documento);
   END
  ELSE
   BEGIN
   textcolor(lightred);
   writeln('========================');
   writeln('X No existe ese atleta X');
   writeln('========================');
   writeln();
   END;
  writeln();
  REPEAT
  writeln('Desea volver a ver otra trayectoria de otro atleta[s/n]?: ');
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

PROCEDURE filtra_disciplina_anio(anio: integer; disciplina: string);
VAR
 documento,almacena_nombre_apellido,cod_dis,almacena_descrip_disciplina: string;
 BEGIN
 reset(archivo_participantes);
 writeln('DISCIPLINA: ',disciplina);
 WHILE NOT eof(archivo_participantes) DO
  BEGIN
  read(archivo_participantes,registro_participantes);
  IF anio = registro_participantes.anio_competencia THEN
   IF disciplina = registro_participantes.cod_disciplina THEN
    BEGIN
     writeln();
     cod_dis:= registro_participantes.cod_disciplina;
     almacena_descrip_disciplina:= busca_descripcion_disciplina(cod_dis);
     documento:= registro_participantes.dni;
     almacena_nombre_apellido:= busca_atleta(documento);
     writeln('==============================================');
     writeln('Nombre: ',almacena_nombre_apellido);
     writeln('Descripcion: ',almacena_descrip_disciplina);
     writeln('==============================================');
    END;
  END;
  close(archivo_participantes);
 END;

PROCEDURE muestra_disciplina_participantes;
VAR
 disciplina,opcion: string;
 anio: integer;
 BEGIN
 IF verificar_estado_archivo_participantes = true THEN
  BEGIN
  textcolor(lightred);
  writeln('=========================================================');
  writeln('X El archivo de participantes esta vacio. Intente luego X');
  writeln('=========================================================');
  delay(2000);
  END
 ELSE
  BEGIN
  REPEAT
  writeln('INGRESE UN ANIO DE COMPETENCIA Y UNA DISCIPLINA PARA VER TODOS LOS PARTICIPANTES DE LA MISMA');
  writeln('--------------------------------------------------------------------------------------------');
  anio:= valida_anio_competencia;
  writeln();
  write('>>> Ingrese un codigo de disciplina: ');
  readln(disciplina);
  filtra_disciplina_anio(anio,disciplina);
  writeln();
  REPEAT
  writeln('Desea volver a ver otro listado[s/n]?: ');
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

PROCEDURE muestra_mayor_sede;
 BEGIN
 IF verifica_estado_archivo_medallasXatletas = true THEN
  BEGIN
  textcolor(lightred);
  writeln('========================================');
  writeln('X El archivo esta vacio. Intente luego X');
  writeln('========================================');
  delay(2000);
  END
 ELSE
  BEGIN
  END;
 END;

PROCEDURE menu_principal;
VAR
  opcion: integer;
   BEGIN
   REPEAT
    clrscr;
    textcolor(lightgreen);
    writeln('--------------');
    writeln('MENU PRINCIPAL');
    writeln('--------------');
    writeln();
    textcolor(yellow);
    writeln('---------------------------------------------------------------------------');
    writeln('1. ABM');
    writeln('---------------------------------------------------------------------------');
    writeln('2. Listado de atletas olimpicos en un anio determinado');
    writeln('---------------------------------------------------------------------------');
    writeln('3. Listado de metallas ganadas de cada tipo para un anio determinado');
    writeln('---------------------------------------------------------------------------');
    writeln('4. Listado de disiciplinas de cierto anio');
    writeln('---------------------------------------------------------------------------');
    writeln('5. Mostrar trayectoria individual y grupal de cierto atleta');
    writeln('---------------------------------------------------------------------------');
    writeln('6. Mostrar participantes mediante disciplina y anio de competencia');
    writeln('---------------------------------------------------------------------------');
    writeln('7. Pais sede donde se compitio con mayor cantidad de medallas ganadas');
    writeln('---------------------------------------------------------------------------');
    writeln('8. Ranking del top 10 de deportistas con mayor cantidad de medallas ganadas');
    writeln('---------------------------------------------------------------------------');
    writeln('9. Salir');
    writeln('---------------------------------------------------------------------------');
    writeln();
    textcolor(lightcyan);
    writeln('========================================================');
    write('Seleccione una opcion <teclas del 1 al 9 inclusive> : ');
    readln(opcion);
    CASE opcion OF
         1: BEGIN
            clrscr;
            menu_abm;
            END;
         2: BEGIN
            clrscr;
            listado_atletas_por_anio;
            END;
         3: BEGIN
            clrscr;
            muestra_listado_medallas;
            END;
         4: BEGIN
            clrscr;
            muestra_listado_disciplinas;
            END;
         5: BEGIN
            clrscr;
            muestra_trayectoria_atleta;
            END;
         6: BEGIN
            clrscr;
            muestra_disciplina_participantes;
            END;
         7: BEGIN
            clrscr;
            muestra_mayor_sede;
            END;
       {  8: BEGIN
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
