Program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,windows;
//-----------------------------------------------
const
 beginStuffNumber=0;
 firstArrCountI=0;
 firstArrCountJ =0;
 firstStartId =0;
//-----------------------------------------------
Type
 ListInfo = ^info;
 info = record
  Tip:string[15];
  Name:string[25];
  Author:string[25];
  Cost:integer;
  Notation:string[50];
  id_tab:integer;
  maxId:integer;
  next:ListInfo;
 end;

 {list = record
  info1:info;
  next:listInfo;
 end;}

 TMDisk = array of info;
//-----------------------------------------------
Var
 MDisk:TMDisk;
 base:file of info;
 stuffNumber,id,sortParam:integer;
 findListHead,findPosition,deletePosition:ListInfo;

//-----------------------------------------------
procedure main;forward;
procedure clrscr;forward;
procedure QuickSortA(L,R:integer);forward;
procedure QuickSortN(L,R:integer);forward;
procedure QuickSortId(L,R:integer);forward;
function  SearchId(var MDisk;const key: integer):integer;forward;
function  SearchA(var MDisk;const key: string):integer;forward;
function  SearchN(var MDisk;const key: string):integer;forward;
//-----------------------------------------------
procedure QuickSortA(L,R:integer);
 var i,j:integer;
     x:string;
     y:info;
  begin
  i:=L;
  j:=R;
  x:=LowerCase(MDisk[(L+R) div 2].Author);
  repeat
   While LowerCase(MDisk[i].Author) < x  do Inc(i);
   While LowerCase(MDisk[j].Author) > x  do Dec(j);
   if i <= j then
    begin
     y:=MDisk[i];
     MDisk[i]:=MDisk[j];
     MDisk[j]:=y;
     inc(i);
     dec(j);
    end;
  until i>j;
   if j>L then QuickSortA(L,j);
   if i<R then QuickSortA(i,R);
  end;
procedure QuickSortT(L,R:integer);
 var i,j:integer;
     x:string;
     y:info;
  begin
  i:=L;
  j:=R;
  x:=LowerCase(MDisk[(L+R) div 2].Tip);
  repeat
   While LowerCase(MDisk[i].Tip) < x  do Inc(i);
   While LowerCase(MDisk[j].Tip) > x  do Dec(j);
   if i <= j then
    begin
     y:=MDisk[i];
     MDisk[i]:=MDisk[j];
     MDisk[j]:=y;
     inc(i);
     dec(j);
    end;
  until i>j;
   if j>L then QuickSortT(L,j);
   if i<R then QuickSortT(i,R);
  end;
procedure QuickSortN(L,R:integer);
 var i,j:integer;
     x:string;
     y:info;
  begin
  i:=L;
  j:=R;
  x:=LowerCase(MDisk[(L+R) div 2].Name);
  repeat
   While LowerCase(MDisk[i].Name) < x  do Inc(i);
   While LowerCase(MDisk[j].Name) > x  do Dec(j);
   if i <= j then
    begin
     y:=MDisk[i];
     MDisk[i]:=MDisk[j];
     MDisk[j]:=y;
     inc(i);
     dec(j);
    end;
  until i>j;
   if j>L then QuickSortN(L,j);
   if i<R then QuickSortN(i,R);
  end;
procedure QuickSortId(L,R:integer);
 var i,j:integer;
     x:integer;
     y:info;
  begin
  i:=L;
  j:=R;
  x:=MDisk[(L+R) div 2].id_tab;
  repeat
   While MDisk[i].id_tab < x  do Inc(i);
   While MDisk[j].id_tab > x  do Dec(j);
   if i <= j then
    begin
     y:=MDisk[i];
     MDisk[i]:=MDisk[j];
     MDisk[j]:=y;
     inc(i);
     dec(j);
    end;
  until i>j;
   if j>L then QuickSortId(L,j);
   if i<R then QuickSortId(i,R);
  end;
procedure clrscr;
var
  cursor: COORD;
  r: cardinal;
begin
  r := 300;
  cursor.X := 0;
  cursor.Y := 0;
  FillConsoleOutputCharacter(GetStdHandle(STD_OUTPUT_HANDLE), ' ', 80 * r, cursor, r);
  SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), cursor);
end;
procedure fileOpen;
var i,j:integer;
 begin
  stuffNumber:=beginStuffNumber;
  SetLength(MDisk,stuffNumber+1);
  i:=firstArrCountI;
  if fileExists('base.txt')
  then
   begin
    reset(base);
    While not Eof (base) do
     begin
      Read(base,MDisk[i]);
      Inc(i);
     end;
    closefile(base);
    for j:=firstArrCountJ to i do
     begin
      if MDisk[j].Tip<>'' then
      inc(stuffNumber);
     end;
    id := MDisk[firstArrCountI].maxId;
    Writeln(' Файл успешно считан.Количество записей: ',stuffNumber);

   end
  else
   begin
    id := firstStartId;
    Rewrite(base);
    Writeln(' Файл успешно создан.');
    Closefile(base);
   end;
 end;
procedure show_list;
var i:integer;
    cost,id_tab,tip,name,author,notation:string;

 begin
  clrscr;
  Writeln('----------------------------------------------------------------------------------------------------------------');
  Writeln('|   Тип товара   |     Наименование     |     Автор     |   Цена   |           Примечание           |    ID    |');
  Writeln('----------------------------------------------------------------------------------------------------------------');
  if stuffNumber = 0 then
     Writeln('                                         Записей нет.                                                        ');
  for i:= 0 to StuffNumber-1 do
    begin
      Tip:=MDisk[i].Tip;
      Name:=MDisk[i].Name;
      Author:=MDisk[i].Author;
      Cost:=IntToStr(MDisk[i].Cost);
      Notation:=MDisk[i].Notation;
      Id_tab:=IntToStr(MDisk[i].id_tab);
      Writeln('|',Tip:16, '|',Name:22, '|',Author:15, '|',Cost:10, '|',Notation:32, '|',Id_tab:10, '|');
      Writeln('----------------------------------------------------------------------------------------------------------------');
    end;
  main;
 end;
procedure add_to_list;
 var i,cmd,cmd1:integer;
     T,Na,A,Pr,cstr:string;
     flag,flagVn:boolean;
  begin
   //assignfile(base,'base.txt');
   //reset(base);
   //Writeln(' Введите номер товара: ');Readln(n);
   clrscr;
   Writeln(' Введите описание товара: ');
   with MDisk[stuffNumber] do
    begin
     Writeln('Выберите необходимый тип: ');
     Writeln('1 - Музыка.');
     Writeln('2 - Игра.');
     Writeln('3 - Фильм.');
     Writeln('4 - СОФТ.');
     Writeln('5 - Другой тип.');
     Readln(cmd);
     case cmd of
     1:
      begin
       clrscr;
       Tip:='Music';
       flagVn:=false;
       while flagVn = false do
        begin
         Writeln('Выберите автора: ');
         Writeln('1 - Rammstein.');
         Writeln('2 - Metallica.');
         Writeln('3 - AC/DC.');
         Writeln('4 - Slipknot.');
         Writeln('5 - Five Fingers Death Punch.');
         Writeln('6 - Little Big.');
         Writeln('7 - Drake.');
         Writeln('8 - Prodigy.');
         Writeln('9 - Depeche Mode.');
         Writeln('10 - Другой вариант.');
         Readln(cmd1);
         case cmd1 of
         1:
          begin
           Author:='Rammstein';
           flagVn:=true;
           clrscr;
          end;
         2:
          begin
           Author:='Metallica';
           flagVn:=true;
           clrscr;
          end;
         3:
          begin
           Author:='AC/DC';
           flagVn:=true;
           clrscr;
          end;
         4:
          begin
           Author:='Slipknot';
           flagVn:=true;
           clrscr;
          end;
         5:
          begin
           Author:='FFDP';
           flagVn:=true;
           clrscr;
          end;
         6:
          begin
           Author:='Little Big';
           flagVn:=true;
           clrscr;
          end;
         7:
          begin
           Author:='Drake';
           flagVn:=true;
           clrscr;
          end;
         8:
          begin
           Author:='Prodigy';
           flagVn:=true;
           clrscr;
          end;
         9:
          begin
           Author:='DM';
           flagVn:=true;
           clrscr;
          end;
         10:
          begin
           clrscr;
           flag:=false;
           while flag=false do
            begin
             Write(' Автор: ');Readln(A);
             A:=trim(a);
             if (Length(A)<=15) and (length(a)<>0) then
              begin
               Author:=A;
               flag:=true;
               flagVn:=true;
              end
             else
              Writeln(' Проверьте правильность введенных данных!');
            end;
          end
          else
           begin
             clrscr;
             Writeln('Неккоректный выбор!');
           end;
         end;
        end;
      end;
     2:
      begin
       clrscr;
       Tip:='Game';
       flagVn:=false;
       while flagVn= false do
        begin
         Writeln('Выберите автора: ');
         Writeln('1 - Valve Corp.');
         Writeln('2 - EA Games.');
         Writeln('3 - Blizzard.');
         Writeln('4 - Wargaming.');
         Writeln('5 - Rockstar.');
         Writeln('6 - Ubisoft.');
         Writeln('7 - Naughty Dog.');
         Writeln('8 - Nintendo.');
         Writeln('9 - Capcom.');
         Writeln('10 - Другой вариант.');
         Readln(cmd1);
          case cmd1 of
          1:
           begin
            Author:='Valve Corp';
            flagVn:=true;
            clrscr;
           end;
          2:
           begin
            Author:='EA Games';
            flagVn:=true;
            clrscr;
           end;
          3:
           begin
            Author:='Blizzard';
            flagVn:=true;
            clrscr;
           end;
          4:
           begin
            Author:='Wargaming';
            flagVn:=true;
            clrscr;
           end;
          5:
           begin
            Author:='Rockstar';
            flagVn:=true;
            clrscr;
           end;
          6:
           begin
            Author:='Ubisoft';
            flagVn:=true;
            clrscr;
           end;
          7:
           begin
            Author:='Naughty Dog';
            flagVn:=true;
            clrscr;
           end;
          8:
           begin
            Author:='Nintendo';
            flagVn:=true;
            clrscr;
           end;
          9:
           begin
            Author:='Capcom';
            flagVn:=true;
            clrscr;
           end;
          10:
           begin
            clrscr;
            flag:=false;
            while flag=false do
             begin
              Write(' Автор: ');Readln(A);
              A:=trim(a);
              if (Length(A)<=15) and (length(a)<>0) then
               begin
                Author:=A;
                flag:=true;
                flagVn:=true;
               end
              else
               Writeln(' Проверьте правильность введенных данных!');
             end;
           end
           else
            begin
             clrscr;
             Writeln('Неккоректный выбор!.');
            end;
          end;
        end;
      end;
     3:
      begin
       clrscr;
       Tip:='Film';
       flagVn:=false;
       while flagVn = false do
        begin
         Writeln('Введите автора:');
         Writeln('1 - Мартин Скорсезе.');
         Writeln('2 - Питер Джексон.');
         Writeln('3 - Стивен Спилберг.');
         Writeln('4 - Тим Бёртон.');
         Writeln('5 - Дэвид Финчер.');
         Writeln('6 - Дэвид Линч.');
         Writeln('7 - Кристофер Нолан.');
         Writeln('8 - Джеймс Кэмерон.');
         Writeln('9 - Гай Ричи.');
         Writeln('10 - Другой вариант.');
         Readln(cmd1);
         case cmd1 of
         1:
          begin
           Author:='Skorsese';
           flagVn:=true;
           clrscr;
          end;
         2:
          begin
           Author:='Jackson';
           flagVn:=true;
           clrscr;
          end;
         3:
          begin
           Author:='Spielberg';
           flagVn:=true;
           clrscr;
          end;
         4:
          begin
           Author:='Berton';
           flagVn:=true;
           clrscr;
          end;
         5:
          begin
           Author:='Fincher';
           flagVn:=true;
           clrscr;
          end;
         6:
          begin
           Author:='Linch';
           flagVn:=true;
           clrscr;
          end;
         7:
          begin
           Author:='Nolan';
           flagVn:=true;
           clrscr;
          end;
         8:
          begin
           Author:='Cameron';
           flagVn:=true;
           clrscr;
          end;
         9:
          begin
           Author:='Richi';
           flagVn:=true;
           clrscr;
          end;
         10:
          begin
           clrscr;
            flag:=false;
            while flag=false do
             begin
              Write(' Автор: ');Readln(A);
              a:=trim(a);
              if (Length(A)<=15) and (length(a)<>0) then
               begin
                Author:=A;
                flag:=true;
                flagVn:=true;
               end
              else
               Writeln(' Проверьте правильность введенных данных!');
             end;
          end
          else
           begin
            clrscr;
            Writeln('Неккоректный выбор!.');
           end;
         end;
        end;
      end;
     4:
      begin
       clrscr;
       Tip:='SOFT';
       flagVn:=false;
       while flagVn = false do
        begin
         Writeln('Введите автора:');
         Writeln('1 - IBM.');
         Writeln('2 - Microsoft.');
         Writeln('3 - Oracle.');
         Writeln('4 - SAPAG.');
         Writeln('5 - Symantec.');
         Writeln('6 - TATA.');
         Writeln('7 - Nintendo.');
         Writeln('8 - Adobe.');
         Writeln('9 - Electronic Arts.');
         Writeln('10 - Другой вариант.');
         Readln(cmd1);
         case cmd1 of
         1:
          begin
           Author:='IBM';
           flagVn:=true;
           clrscr;
          end;
         2:
          begin
           Author:='Microsoft';
           flagVn:=true;
           clrscr;
          end;
         3:
          begin
           Author:='Oracle';
           flagVn:=true;
           clrscr;
          end;
         4:
          begin
           Author:='SAPAG';
           flagVn:=true;
           clrscr;
          end;
         5:
          begin
           Author:='Symantec';
           flagVn:=true;
           clrscr;
          end;
         6:
          begin
           Author:='TATA';
           flagVn:=true;
           clrscr;
          end;
         7:
          begin
           Author:='Nintendo';
           flagVn:=true;
           clrscr;
          end;
         8:
          begin
           Author:='Adobe';
           flagVn:=true;
           clrscr;
          end;
         9:
          begin
           Author:='EA';
           flagVn:=true;
           clrscr;
          end;
         10:
          begin
           clrscr;
            flag:=false;
            while flag=false do
             begin
              Write(' Автор: ');Readln(A);
              a:=trim(a);
              if (Length(A)<=15) and (length(a)<>0) then
               begin
                Author:=A;
                flag:=true;
                flagVn:=true;
               end
              else
               Writeln(' Проверьте правильность введенных данных!');
             end;
          end
          else
           begin
            clrscr;
            Writeln('Неккоректный выбор!.');
           end;
         end;
        end;
      end;
     5:
      begin
       clrscr;
       flag:=false;
       while flag=false do
        begin
         Write(' Тип хранимой информации: ');Readln(T);
         t:=trim(t);
         if (Length(T)<=16) and (length(T)<>0) then
          begin
           Tip:=T;
           flag:=true;
          end
         else
          Writeln(' Проверьте правильность введенных данных!');
        end;
       clrscr;
       flag:=false;
       while flag=false do
        begin
         Write(' Автор: ');Readln(A);
         a:=trim(a);
         if (Length(A)<=15) and (length(a)<>0) then
          begin
           Author:=A;
           flag:=true;
          end
         else
          Writeln(' Проверьте правильность введенных данных!');
        end;
      end;
     end;
     clrscr;
     flag:=false;
     while flag=false do
      begin
       Write(' Наименование: ');Readln(Na);
       na:=trim(na);
       if (Length(Na)<=22) and (Length(Na)<>0) then
        begin
         Name:=Na;
         flag:=true;
        end
       else
         Writeln(' Проверьте правильность введенных данных!');
      end;
     clrscr;
     flag:=false;
     while flag=false do
      begin
        Write(' Цена: ');Readln(cstr);
       if (Length(cstr)<=10) and (strToIntDef (cstr, 0) > 0) then
        begin
        //Val(cstr,c,error);
         Cost:=strToInt(cstr);
         flag:=true;
        end
       else
        Writeln(' Проверьте правильность введенных данных!');
      end;
     clrscr;
     flag:=false;
     while flag=false do
      begin
       Write(' Примечание: ');Readln(Pr);
       Pr:=trim(pr);
       if (Length(Pr)<=15) and (length(pr)<>0) then
        begin
         Notation:=Pr;
         flag:=true;
        end
       else
         Writeln(' Проверьте правильность введенных данных!');
      end;
     inc(id);
     id_tab:=id;
     clrscr;
     Write('Введенная запись : ');
     Writeln('|',Tip, '|',Name, '|',Author, '|',Cost, '|',Notation, '|',Id_tab, '|');
    end;
    for i:= 0 to stuffNumber do
     begin
       MDisk[i].maxId:=id;
     end;
    //seek(base,stuffnumber);
    //Write(base,stuff);
    //closefile(base);
    inc(stuffNumber);
    Writeln('--------------------------------------------------------------');
    Writeln(' Запись успешно добавлена.');
    Writeln('--------------------------------------------------------------');
    main;
  end;
procedure delete_from_list;
 var answ,key,cmd,i:integer;
     cost,id_tab,tip,name,author,notation:string;
 begin
  clrscr;
  if stuffNumber = 0 then
   begin
    Writeln(' Записей нет.');
    main;
   end;
  Writeln(' Введите id удаляемого элемента: ');
  Readln(key);
  QuickSortId(0,StuffNumber-1);
  answ:=SearchId(MDisk,key);
  if answ=-1 then
   begin
     clrscr;
     Writeln('Данная запись не найдена.Проверьте правильность введенных данных!');
     main;
   end
  else
     begin
      clrscr;
      Writeln('----------------------------------------------------------------------------------------------------------------');
      Writeln('|   Тип товара   |     Наименование     |     Автор     |   Цена   |           Примечание           |    ID    |');
      Writeln('----------------------------------------------------------------------------------------------------------------');
      Tip:=MDisk[answ].Tip;
      Name:=MDisk[answ].Name;
      Author:=MDisk[answ].Author;
      Cost:=IntToStr(MDisk[answ].Cost);
      Notation:=MDisk[answ].Notation;
      Id_tab:=IntToStr(MDisk[answ].id_tab);
      Writeln('|',Tip:16, '|',Name:22, '|',Author:15, '|',Cost:10, '|',Notation:32, '|',Id_tab:10, '|');
      Writeln('----------------------------------------------------------------------------------------------------------------');
     end;
   Writeln('Удалить данную запись?');
   Writeln('1 - Да.');
   Writeln('2 - Нет.');
   Readln(cmd);
   case cmd of
   1:
     begin
      MDisk[answ]:=MDisk[stuffNumber-1];
      dec(stuffNumber);
      clrscr;
      Writeln('Удаление успешно произведено!');
      main;
     end;
   2:
     begin
      clrscr;
      main;
     end;
   end;
 end;
procedure edit_list;
 var answ,key,cmd,i:integer;
     cost,id_tab,tip,name,author,notation,str:string;
     flag:boolean;
 begin
  clrscr;
  if stuffNumber = 0 then
   begin
    Writeln(' Записей нет.');
    main;
   end;
  Writeln(' Введите id изменяемого элемента: ');
  Readln(key);
  QuickSortId(0,StuffNumber-1);
  answ:=SearchId(MDisk,key);
  if answ=-1 then
    begin
     clrscr;
     Writeln('Данная запись не найдена.Проверьте правильность введенных данных!');
    end
  else
     begin
      clrscr;
      Writeln('----------------------------------------------------------------------------------------------------------------');
      Writeln('|   Тип товара   |     Наименование     |     Автор     |   Цена   |           Примечание           |    ID    |');
      Writeln('----------------------------------------------------------------------------------------------------------------');
      Tip:=MDisk[answ].Tip;
      Name:=MDisk[answ].Name;
      Author:=MDisk[answ].Author;
      Cost:=IntToStr(MDisk[answ].Cost);
      Notation:=MDisk[answ].Notation;
      Id_tab:=IntToStr(MDisk[answ].id_tab);
      Writeln('|',Tip:16, '|',Name:22, '|',Author:15, '|',Cost:10, '|',Notation:32, '|',Id_tab:10, '|');
      Writeln('----------------------------------------------------------------------------------------------------------------');
      flag:=false;
      Writeln;
      Writeln('Выберите изменяемое поле:');
      Writeln('1 - Тип товара.');
      Writeln('2 - Наименование.');
      Writeln('3 - Автор.');
      Writeln('4 - Цена.');
      Writeln('5 - Примечание.');
      Readln(cmd);
      case cmd of
      1:
       begin
        While flag = false do
         begin
          Write('Введите новое значение поля: ');
          Readln(str);
          if Length(str)<=16 then
           begin
            MDisk[answ].Tip:=str;
            flag:=true;
           end
          else Writeln(' Проверьте правильность введенных данных!Выход за допустимый диапазон ввода!');
         end;
       end;
      2:
       begin
        While flag = false do
         begin
          Write('Введите новое значение поля: ');
          Readln(str);
          if Length(str)<=22 then
           begin
            MDisk[answ].Name:=str;
            flag:=true;
           end
          else Writeln(' Проверьте правильность введенных данных!Выход за допустимый диапазон ввода!');
         end;
       end;
      3:
       begin
        While flag = false do
         begin
          Write('Введите новое значение поля: ');
          Readln(str);
          if Length(str)<=15 then
           begin
            MDisk[answ].Author:=str;
            flag:=true;
           end
          else Writeln(' Проверьте правильность введенных данных!Выход за допустимый диапазон ввода!');
         end;
       end;
      4:
       begin
        While flag = false do
         begin
          Write('Введите новое значение поля: ');
          Readln(str);
          if (Length(str)<=10) and (strToIntDef (str, 0) > 0) then
            begin
             MDisk[answ].Cost:=StrToInt(str);
             flag:=true;
            end
          else Writeln(' Проверьте правильность введенных данных!Выход за допустимый диапазон ввода!');
         end;
       end;
      5:
       begin
        While flag = false do
         begin
          Write('Введите новое значение поля: ');
          Readln(str);
          if Length(str)<=15 then
           begin
            MDisk[answ].Notation:=str;
            flag:=true;
           end
          else Writeln(' Проверьте правильность введенных данных!Выход за допустимый диапазон ввода!');
         end;
       end;
      end;
      clrscr;
      Writeln('Редактирование успешно завершено!Новое значение измененного элемента: ');
      Writeln('----------------------------------------------------------------------------------------------------------------');
      Writeln('|   Тип товара   |     Наименование     |     Автор     |   Цена   |           Примечание           |    ID    |');
      Writeln('----------------------------------------------------------------------------------------------------------------');
      Tip:=MDisk[answ].Tip;
      Name:=MDisk[answ].Name;
      Author:=MDisk[answ].Author;
      Cost:=IntToStr(MDisk[answ].Cost);
      Notation:=MDisk[answ].Notation;
      Id_tab:=IntToStr(MDisk[answ].id_tab);
      Writeln('|',Tip:16, '|',Name:22, '|',Author:15, '|',Cost:10, '|',Notation:32, '|',Id_tab:10, '|');
      Writeln('----------------------------------------------------------------------------------------------------------------');
     end;
  main;
 end;
function  SearchN(var MDisk;const key: string):integer;
var
  point1, point2, r,i: integer;
  flag:boolean;
begin
  Result:=-1;
  flag:=True;
  r:=trunc(sqrt(StuffNumber-1));
  point1:=r;
  point2:=StuffNumber-1;
  if (LowerCase(key)>LowerCase(TMDisk(MDisk)[StuffNumber-1].Name)) or (LowerCase(key)<LowerCase(TMDisk(MDisk)[0].Name)) then flag:=False;
  while flag=True do begin
    if point1>point2 then
     begin
       if point2<=point1-r then flag:=False
          else
           begin
            point1:=point1-r+1;
            r:=Trunc(sqrt(r));
           end;
     end
    else
     begin
      if LowerCase(key)>LowerCase(TMDisk(MDisk)[point1].Name) then point1:=point1+r;
      if LowerCase(key)=LowerCase(TMDisk(MDisk)[point1].Name) then
          begin
          Result:=point1;
          flag:=False;
          end;
      if LowerCase(key)<LowerCase(TMDisk(MDisk)[point1].Name) then
          begin
          point2:=point2-1;
          point1:=point1-r;
          r:=Trunc(sqrt(r));
          end;
     end;
  end;
end;
function  SearchA(var MDisk;const key: string):integer;
var
  point1, point2, r: integer;
  flag:boolean;
begin
  Result:=-1;
  flag:=True;
  r:=trunc(sqrt(StuffNumber-1));
  point1:=r;
  point2:=StuffNumber-1;
  if (LowerCase(key)>LowerCase(TMDisk(MDisk)[StuffNumber-1].Author)) or (LowerCase(key)<LowerCase(TMDisk(MDisk)[0].Author)) then flag:=False;
  while flag=True do begin
    if point1>point2 then
     begin
       if point2<=point1-r then flag:=False
          else
           begin
            point1:=point1-r+1;
            r:=Trunc(sqrt(r));
           end;
     end
    else
     begin
      if LowerCase(key)>LowerCase(TMDisk(MDisk)[point1].Author) then point1:=point1+r;
      if LowerCase(key)=LowerCase(TMDisk(MDisk)[point1].Author) then
          begin
          Result:=point1;
          flag:=False;
          end;
      if LowerCase(key)<LowerCase(TMDisk(MDisk)[point1].Author) then
          begin
          point2:=point2-1;
          point1:=point1-r;
          r:=Trunc(sqrt(r));
          end;
     end;
  end;
end;
function  SearchT(var MDisk;const key: string):integer;
var
  point1, point2, r: integer;
  flag:boolean;
begin
  Result:=-1;
  flag:=True;
  r:=trunc(sqrt(StuffNumber-1));
  point1:=r;
  point2:=StuffNumber-1;
  if (LowerCase(key)>LowerCase(TMDisk(MDisk)[StuffNumber-1].Tip)) or (LowerCase(key)<LowerCase(TMDisk(MDisk)[0].Tip)) then flag:=False;
  while flag=True do begin
    if point1>point2 then
     begin
       if point2<=point1-r then flag:=False
          else
           begin
            point1:=point1-r+1;
            r:=Trunc(sqrt(r));
           end;
     end
    else
     begin
      if LowerCase(key)>LowerCase(TMDisk(MDisk)[point1].Tip) then point1:=point1+r;
      if LowerCase(key)=LowerCase(TMDisk(MDisk)[point1].Tip) then
          begin
          Result:=point1;
          flag:=False;
          end;
      if LowerCase(key)<LowerCase(TMDisk(MDisk)[point1].Tip) then
          begin
          point2:=point2-1;
          point1:=point1-r;
          r:=Trunc(sqrt(r));
          end;
     end;
  end; //while
end;
function  SearchId(var MDisk;const key: integer):integer;
var
  point1, point2, r: integer;
  flag:boolean;
begin
  Result:=-1;
  flag:=True;
  r:=trunc(sqrt(StuffNumber-1));
  point1:=r;
  point2:=StuffNumber-1;
  if (key>TMDisk(MDisk)[StuffNumber-1].id_tab) or (key<TMDisk(MDisk)[0].id_tab) then flag:=False;
  while flag=True do begin
    if point1>point2 then
     begin
       if point2<=point1-r then flag:=False
          else
           begin
            point1:=point1-r+1;
            r:=Trunc(sqrt(r));
           end;
     end
    else
     begin
      if key>TMDisk(MDisk)[point1].id_tab then point1:=point1+r;
      if key=TMDisk(MDisk)[point1].id_tab then
          begin
          Result:=point1;
          flag:=False;
          end;
      if key<TMDisk(MDisk)[point1].id_tab then
          begin
          point2:=point1-1;
          point1:=point1-r;
          r:=Trunc(sqrt(r));
          end;
     end;
  end; //while
end;
procedure searchProc;
 var cmd,answ:integer;
     key,cost,id_tab,tip,name,author,notation:string;
 begin
  clrscr;
  if stuffNumber = 0 then
   begin
    Writeln(' Записей нет.');
    main;
   end;
  Writeln(' Выберите вариант поиска: ');
  Writeln(' 1 - по наименованию. ');
  Writeln(' 2 - по автору. ');
  Readln(cmd);
  case cmd of
   1:
    begin
     clrscr;
     Writeln('Введите необходимое наименование: ');
     Readln(key);
     QuickSortN(0,StuffNumber-1);
     answ:=SearchN(MDisk,LowerCase(key));
     new(findListHead);
     findListHead^.next:=nil;
     findPosition:=findListHead;
     if answ=-1 then
        Writeln('Данная запись не найдена.Проверьте правильность введенных данных!')
     else
        begin
         while ((answ-1)>=0) and (LowerCase(MDisk[answ-1].Name) = LowerCase(key)) do
          begin
            dec(answ);
         end;
        Writeln('----------------------------------------------------------------------------------------------------------------');
        Writeln('|   Тип товара   |     Наименование     |     Автор     |   Цена   |           Примечание           |    ID    |');
        Writeln('----------------------------------------------------------------------------------------------------------------');
         while (answ<=(stuffNumber-1)) and (LowerCase(MDisk[answ].Name) = LowerCase(key)) do
        begin
          new(findPosition^.Next);
          findPosition:=findPosition^.Next;
          findPosition^.Tip:=MDisk[answ].Tip;
          findPosition^.Name:=MDisk[answ].Name;
          findPosition^.Author:=MDisk[answ].Author;
          findPosition^.Cost:=MDisk[answ].Cost;
          findPosition^.Notation:=MDisk[answ].Notation;
          findPosition^.id_tab:=MDisk[answ].id_tab;
          findPosition^.Next:=nil;
          Writeln('|',findPosition^.Tip:16, '|',findPosition^.Name:22, '|',findPosition^.Author:15, '|',findPosition^.Cost:10, '|',findPosition^.Notation:32, '|',findPosition^.id_tab:10, '|');
          Writeln('----------------------------------------------------------------------------------------------------------------');
          inc(answ);
        end;
        findPosition:=findListHead^.Next;
        while findPosition^.Next <> nil do
         begin
           deletePosition:= findPosition;
           findPosition:=findPosition^.next;
           dispose(deletePosition);
         end;
        dispose(findPosition);
        dispose(findListHead);
       end;
    end;
   2:
     begin
     clrscr;
     Writeln('Введите необходимого автора: ');
     Readln(key);
     QuickSortA(0,StuffNumber-1);
     answ:=SearchA(MDisk,LowerCase(key));
     new(findListHead);
     findListHead^.next:=nil;
     findPosition:=findListHead;
     if answ=-1 then
        Writeln('Данная запись не найдена.Проверьте правильность введенных данных!')
     else
        begin
         while ((answ-1)>=0) and (LowerCase(MDisk[answ-1].Author) = LowerCase(key)) do
          begin
            dec(answ);
         end;
        Writeln('----------------------------------------------------------------------------------------------------------------');
        Writeln('|   Тип товара   |     Наименование     |     Автор     |   Цена   |           Примечание           |    ID    |');
        Writeln('----------------------------------------------------------------------------------------------------------------');
         while (answ<=(stuffNumber-1)) and (LowerCase(MDisk[answ].Author) = LowerCase(key)) do
        begin
          new(findPosition^.Next);
          findPosition:=findPosition^.Next;
          findPosition^.Tip:=MDisk[answ].Tip;
          findPosition^.Name:=MDisk[answ].Name;
          findPosition^.Author:=MDisk[answ].Author;
          findPosition^.Cost:=MDisk[answ].Cost;
          findPosition^.Notation:=MDisk[answ].Notation;
          findPosition^.id_tab:=MDisk[answ].id_tab;
          findPosition^.Next:=nil;
          Writeln('|',findPosition^.Tip:16, '|',findPosition^.Name:22, '|',findPosition^.Author:15, '|',findPosition^.Cost:10, '|',findPosition^.Notation:32, '|',findPosition^.id_tab:10, '|');
          Writeln('----------------------------------------------------------------------------------------------------------------');
          inc(answ);
        end;
        findPosition:=findListHead^.Next;
        while findPosition^.Next <> nil do
         begin
           deletePosition:= findPosition;
           findPosition:=findPosition^.next;
           dispose(deletePosition);
         end;
        dispose(findPosition);
        dispose(findListHead);
       end;
    end
  else
    begin
    clrscr;
    Writeln('Неккоректный ввод!');
    end;
  end;
  main;
 end;
procedure sort_list(Var MDisk:TMDisk;L,R:integer);
 var choise:integer;
  begin
  clrscr;
  Writeln('Выберите способ сортировки: ');
  Writeln('1 - по наименованию.');
  Writeln('2 - по автору.');
  Readln(choise);
  case choise of
  1:begin
     clrscr;
     QuickSortN(L,R);
     Writeln(' ------------------------------- ');
     Writeln(' |Записи успешно отсортированы.| ');
     Writeln(' ------------------------------- ');
    end;
  2:begin
     clrscr;
     QuickSortA(L,R);
     Writeln(' ------------------------------- ');
     Writeln(' |Записи успешно отсортированы.| ');
     Writeln(' ------------------------------- ');
    end
   else
    begin
    clrscr;
    Writeln('Неккоректный ввод!');
    end;
  end;
  main;
 end;
procedure sortByParam(var MDisk:TMDisk;L,R:integer);
procedure QuickSort(L,R:integer);
 var I,J,W,c:integer;
     X:string;
     z:real;
     y:info;
 begin
  I:=L;
  J:=R;
  case sortParam of
   1:begin
      x:=LowerCase(MDisk[(L+R) div 2].Name);
      repeat
       While LowerCase(MDisk[i].Name) < x  do Inc(i);
       While LowerCase(MDisk[j].Name) > x  do Dec(j);
       if i <= j then
        begin
         y:=MDisk[i];
         MDisk[i]:=MDisk[j];
         MDisk[j]:=y;
         inc(i);
         dec(j);
        end;
      until i>j;
     end;
   2:begin
      x:=LowerCase(MDisk[(L+R) div 2].Author);
      repeat
       While LowerCase(MDisk[i].Author) < x  do Inc(i);
       While LowerCase(MDisk[j].Author) > x  do Dec(j);
       if i <= j then
        begin
         y:=MDisk[i];
         MDisk[i]:=MDisk[j];
         MDisk[j]:=y;
         inc(i);
         dec(j);
        end;
      until i>j;
     end;
  end;
  if j>L then QuickSort(L,j);
  if i<R then QuickSort(i,R);
 end;
 begin
  QuickSort(l,R);
 end;
procedure sortProc(Var MDisk:TMDisk);
 var cmd,i,beginpos,endpos:integer;
     str:string;
     flag:boolean;
 begin
  if stuffNumber = 0 then
   begin
    Writeln(' Записей нет.');
    main;
   end;
  flag:=false;
  QuickSortT(0,StuffNumber-1);
  Writeln('Выберите сортируемое поле: ');
  Writeln('1 - Наименование.');
  Writeln('2 - Автор.');
  readln(sortParam);
  beginPos := 0;
  endPos := 0;
  for i := 0 to stuffNumber-1 do
    begin
     if (i = 0) and (LowerCase(MDisk[i].Tip) <> LowerCase(MDisk[i+1].Tip)) then
      beginPos := i + 1
     else
      if LowerCase(MDisk[i].Tip) = LowerCase(MDisk[i+1].Tip) then
       else
        if (LowerCase(MDisk[i].Tip) = LowerCase(MDisk[i-1].Tip)) and (LowerCase(MDisk[i].Tip) <> LowerCase(MDisk[i+1].Tip)) then
         begin
          endPos := i;
          sortByParam(MDisk, beginPos, endPos);
          beginPos := i + 1;
         end
        else
         if (LowerCase(MDisk[i].Tip) = LowerCase(MDisk[i-1].Tip)) and (i = stuffNumber-1) then
          begin
           endPos := i;
           sortByParam(MDisk, beginPos, endPos);
          end
         else
          if (LowerCase(MDisk[i].Tip) = LowerCase(MDisk[i-1].Tip)) and (i = stuffNumber-1) then
    end;
  main;
 end;
procedure exit_from_list;
var i:integer;
 begin
   assignfile(base,'base.txt');
   rewrite(base);
   for i:= 0 to stuffNumber-1 do
   begin
    Write(base,MDisk[i]);
   end;
   closefile(base);
 end;
Procedure main;
 var choise:integer;
 begin
  Writeln('--------------------- ');
  Writeln(' Выберите действие: |');
  Writeln('------------------------------------ ');
  Writeln('| 1 | - Просмотр списка.           |');
  Writeln('| 2 | - Добавление записи в список.|');
  Writeln('| 3 | - Удаление записи из списка. |');
  Writeln('| 4 | - Редактирование записи.     |');
  Writeln('| 5 | - Поиск.                     |');
  Writeln('| 6 | - Сортировки.                |');
  Writeln('| 7 | - Выход.                     |');
  Writeln('------------------------------------ ');
  Readln(choise);
  case choise of
  1:show_list;
  2:add_to_list;
  3:delete_from_list;
  4:edit_list;
  5:searchProc;
  6: begin
      clrscr;
      sortProc(MDisk);
     end;
  7: begin
      exit_from_list;
      clrscr;
      Writeln(' Данные успешно сохранены в файл.');
      Writeln(' Нажмите Enter для выхода.');
      exit;
     end{;
  8: begin
      clrscr;
      sort_list(MDisk, 0, StuffNumber-1);
     end}
  else
     begin
      clrscr;
      Writeln('Проверьте правильность ввода!');
     end;
  end;
  //main;
 end;
//-----------------------------------------------
begin
  setConsoleCp(1251);
  SetConsoleOutputCp(1251);
  assignfile(base,'base.txt');
  fileOpen;
  main;
  readln;
end.
//Поиск - блочный поиск .
{Задание 6. В магазине имеется список поступивших в продажу CD/DVD дисков
Каждая запись списка содержит:тип хранимой информации(фильм,музыка,СОФТ и т.п),
наименование,автора,цену и примечание.Требуется:
- сортировать внутри каждого типа информацию по наименованию либо по автору-----(++)
- осуществлять поиск диска по автору, по наименованию-------------------------- (++)
- осуществлять выбор информации по типу,по автору.------------------------------(++)}
