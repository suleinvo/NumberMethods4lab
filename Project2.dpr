program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;
  type tmas = array [0..100000] of real;

  var a, b, c, Tmax: real; N, K: integer; xi, xi1: tmas;

  procedure readfile ();   // считывание заданной информации из файла
  var f: text;
  begin
    assign (f, 'input.txt');
    reset (f);
    readln (f, c);
    readln (f, a);
    readln (f, b);
    readln (f, Tmax);
    readln (f, N);
    readln (f, K);
    close (f);
  end;

  function u(x, t: real): real;    // искомая функция
  begin
    result:=x; //*x+t*t;
  end;

  function f(x, t: real): real;   // функция f(x,t)
  begin
    result:=0; //2*t-4;
  end;

  function e1(t: real): real;
  begin
    result:=0; //t*t;
  end;

  function e2(t: real): real;
  begin
    result:=1; //t*t+1;
  end;

  procedure FF();
  var i: integer;
  begin
    xi[0]:=a;
    for i:= 1 to N do
    xi[i]:= i*(b-a)/N; //sqr(i*(b-a)/N);
  end;

  procedure FF1(t, h, q: real);
  var i: integer; x: real;
  begin
    xi1[0]:=e1(t);
    x:=a+h;
    for i:=1 to N-1 do
    begin
      xi1[i]:=xi[i]+c*q/(h*h)*(xi[i-1]-2*xi[i]+xi[i+1])+q*f(x,t);
      x:=x+h;
    end;
    xi1[N]:=e2(t);
  end;

  procedure count();
  var x, t, h, q, max1, max2: real; f: text; i, j: integer;
  begin
    readfile();
    assign (f, 'output.txt');
    rewrite (f);
    writeln (f, 'с^2 = ', c);
    writeln (f, 'Границы отрезка по х [', a, ', ', b, ']');
    writeln (f, 'T = ', Tmax);
    writeln (f, 'Количество отрезков разбиения по x, t ', N, ', ', K);
    h:=(b-a)/N;
    q:=Tmax/K;
    t:=0;
    max1:=0;
    max2:=0;
    FF();
    writeln (f, 'i    t                     xi                      uij                   utjxi                   rij');
    for i:=0 to N do
    begin
      x:=a+(b-a)*i/N;
      writeln (f, 0, x, u(x,t), xi[i], '    ', 0);
    end;
    writeln (f, 'Максимальная погрешность равна ', 0);
    max2:=0;
    for j:=1 to K do
    begin
      x:=a;
      t:=t+q;
      FF1(t, h, q);
      max1:=0;
      for i:=0 to N do
      begin
        x:=a+(b-a)*i/N;
        writeln (f, j, t, x, u(x,t), xi1[i], abs(u(x,t)-xi1[i]));
        if (abs(u(x,t)-xi1[i])>max1)
        then max1:=abs(u(x,t)-xi1[i]);
      end;
      writeln (f, 'Максимальная погрешность на слое равна ', max1);
      if max1>max2
      then max2:=max1;
      for i:=0 to N do
      xi[i]:=xi1[i];
    end;
    writeln (f, 'Максимальная погрешность равна ', max2);
    close(f);
    writeln ('ready');
  end;

begin
  { TODO -oUser -cConsole Main : Insert code here }
count();
readln;
end.
