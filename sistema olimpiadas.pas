PROGRAM sistemas-olimpiadas;
USES crt;

TYPE
    medallas = array [1..3]of string;

    atletas = RECORD
            dni: string;
            nombre_apellido: string;
            END;

    disciplinas = RECORD
                cod_disciplina: integer;
                descripcion: string;
                equipo: string;
                END;

    participantes = RECORD
                  cod_disciplina: integer;
                  anio_competencia: integer;
                  dni: string;
                  END;

    sedes = RECORD
          cod_internacional: integer;
          descripcion: string;
          END;

   medallasXatletas = RECORD
                    dni: string;
                    anio_competencia: integer;
                    cod_internacional: integer;
                    medalla: medallas;
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
menu_principal;

END.
