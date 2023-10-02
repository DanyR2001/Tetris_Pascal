program Test_Tetris;
uses Crt,keyboard,sysutils,strutils,math;


const numRow=20;
const numRowReal=18;
const numCol=10;

(* start defination cell *)

type
   Cell = object
   private
      uno, due: char;

   public  
      procedure setFull;
      procedure setEmpty;
      procedure setChar(c1,c2:char);
      function printCell:string;
      function isFull:boolean;

end;

procedure Cell.setFull;
begin
   uno := '[';
   due := ']';
end;

procedure Cell.setEmpty;
begin
  uno := ' ';
  due := '.';
end;

function Cell.isFull:boolean;
var first:LongInt;
begin
	first:=CompareStr(uno+due,' .');
	if first=0 then
		begin
			(*writeln(uno,due,'cazzo');*)
			isFull:=false;
		end
	else 
		begin
		(*writeln(uno,due,'merda');*)
		isFull:=true;
		end;
end;

function Cell.printCell:string;
begin
  printCell:=  Concat(uno,due);
end;

procedure Cell.setChar(c1,c2:char);
begin
	uno :=c1;
	due := c2;
end;


(* end defination cell *)
(* start defination point *)
type 
	Point =object
	
	private 
		x, y: integer;

	public
		procedure setCoordinate(uno,due:Integer);
		function getX:Integer;
		function getY:Integer;
end;

procedure Point.setCoordinate(uno,due:Integer);
begin
	x:=uno;
	y:=due;
end;

function Point.getX:Integer;
begin
	getX:=x;
end;
function Point.getY:Integer;
begin
	getY:=y;
end;

(* end defination point *)
(* start defination tetraminoTraker *)

type TDynInts = array of Point;


type Tracker=object

private
	punti:array[0..3] of Point;
	nome:string;
	rotation:Integer;

	
public
	procedure setCoordinateTetramino(x1,y1,x2,y2,x3,y3,x4,y4:Integer);
	procedure setIpoint(i:integer;p:Point);
	procedure setName(c1:string);
	function getCoordinateTetramino:string;
	function getName:string;
	function getArray():TDynInts;
	function getArrayForCheck(str:string):TDynInts;
	(*allora controllando il pezzo e la rotazione e la direzione verso dove volgiamo effettuare lo shift restituiamo solo i blocchhi sui quali bisogna fare il conrtollo 
	* 	1
	* 2 3 4
	* e voglio andare a sinistra devo restituire solo 1 e 2
	* *)
	function getMinY:integer;
	function getMinX:integer;
	function getMaxY:integer;
	function getMaxX:integer;
	function getMinXforIrow(i:integer):integer;
	function getMaxXforIrow(i:integer):integer;
	function getRotation:INTEGER;
	procedure rotate;
	procedure goDown;
	procedure goRight;
	procedure goLeft;

end;

procedure Tracker.setIpoint(i:integer;p:Point);
begin
	punti[i]:=p;
end;

procedure Tracker.setCoordinateTetramino(x1,y1,x2,y2,x3,y3,x4,y4:Integer);
begin
	punti[0].setCoordinate(x1,y1);
	punti[1].setCoordinate(x2,y2);
	punti[2].setCoordinate(x3,y3);
	punti[3].setCoordinate(x4,y4);
end;

procedure Tracker.setName(c1:string);
begin
	nome:=c1;
	rotation:=0;
end;

procedure Tracker.rotate;
begin
	if rotation = 270 then
		rotation:= 0
	else
		rotation:=rotation+90;
end;

function Tracker.getRotation:Integer;
begin
	getRotation:=rotation;
end;

function Tracker.getName:string;
begin
	getName:=nome;
end;

function Tracker.getMinY:integer;
var i,min:integer;
begin
	min:=numRow;
	for i:=0 to 3 do
		if punti[i].getY<=min then
			min:=punti[i].getY;
	getMinY:=min;
end;

function Tracker.getMinX:integer;
var i,min:integer;
begin
	min:=numRow;
	for i:=0 to 3 do
		if punti[i].getX<=min then
			min:=punti[i].getX;
	getMinX:=min;
end;

function Tracker.getMaxY:integer;
var i,max:integer;
begin
	max:=0;
	for i:=0 to 3 do
		if punti[i].getY>max then
			max:=punti[i].getY;
	getMaxY:=max;
end;

function Tracker.getMaxX:integer;
var i,max:integer;
begin
	max:=0;
	for i:=0 to 3 do
		if punti[i].getX>max then
			max:=punti[i].getX;
	getMaxX:=max;
end;

function Tracker.getMinXforIrow(i:integer):integer;
var j,min:integer;
begin
	min:=numRow;
	for j:=0 to 3 do
		if (punti[j].getX<min) and (punti[j].getY=i) then
			min:=punti[j].getX;
	getMinXforIrow:=min;
end;

function Tracker.getMaxXforIrow(i:integer):integer;
var j,max:integer;
begin
	max:=0;
	for j:=0 to 3 do
		if (punti[j].getX>max) and (punti[j].getY=i) then
			max:=punti[j].getX;
	getMaxXforIrow:=max;
end;

function Tracker.getCoordinateTetramino:string;
begin
	getCoordinateTetramino:='('+IntToStr(punti[0].getX)+','+IntToStr(punti[0].getY)+');'+'('+IntToStr(punti[1].getX)+','+IntToStr(punti[1].getY)+');'+'('+IntToStr(punti[2].getX)+','+IntToStr(punti[2].getY)+');'+'('+IntToStr(punti[3].getX)+','+IntToStr(punti[3].getY)+');';
end;

procedure Tracker.goDown;
var i:integer;
begin
for i:=0 to 3 do
	punti[i].setCoordinate(punti[i].getX,punti[i].getY+1);
end;

procedure Tracker.goLeft;
var i:integer;
begin
for i:=0 to 3 do
	punti[i].setCoordinate(punti[i].getX-1,punti[i].getY);
end;

procedure Tracker.goRight;
var i:integer;
begin
for i:=0 to 3 do
	punti[i].setCoordinate(punti[i].getX+1,punti[i].getY);
end;

function Tracker.getArrayForCheck(str:string):TDynInts;
var Result:array of Point;
begin
	if nome='t' then
		begin
		if str ='left' then
			begin
		   (*0°				90°			180°			270°
		    * 
			* 	0			1			3 2 1 				3
			* 1 2 3   		2 0			  0				  0 2
			* 				3								1
			*)
			if rotation =0 then
				begin
				SetLength(Result,2);
				Result[0]:=punti[0];
				Result[1]:=punti[1];
				getArrayForCheck:=Result;
				end
			else if rotation = 90 then
				begin
				SetLength(Result,3);
				Result[0]:=punti[1];
				Result[1]:=punti[2];
				Result[2]:=punti[3];
				getArrayForCheck:=Result;
				end
			else if rotation = 180 then
				begin
				SetLength(Result,2);
				Result[0]:=punti[3];
				Result[1]:=punti[0];
				getArrayForCheck:=Result;
				end
			else if rotation = 270 then
				begin
				SetLength(Result,3);
				Result[0]:=punti[3];
				Result[1]:=punti[0];
				Result[2]:=punti[1];
				getArrayForCheck:=Result;
				end
			end
		else if str ='right' then
			begin
			if rotation =0 then
				begin
				SetLength(Result,2);
				Result[0]:=punti[0];
				Result[1]:=punti[3];
				getArrayForCheck:=Result;
				end
			else if rotation = 90 then
				begin
				SetLength(Result,3);
				Result[0]:=punti[1];
				Result[1]:=punti[0];
				Result[2]:=punti[3];
				getArrayForCheck:=Result;
				end
			else if rotation = 180 then
				begin
				SetLength(Result,2);
				Result[0]:=punti[1];
				Result[1]:=punti[0];
				getArrayForCheck:=Result;
				end
			else if rotation = 270 then
				begin
				SetLength(Result,3);
				Result[0]:=punti[3];
				Result[1]:=punti[2];
				Result[2]:=punti[1];
				getArrayForCheck:=Result;
				end
			end;
		end
	else if nome='i' then
		begin
		      (* 0°		90°			180°		270°
			* 		0 					3			
			*   	1		0 1 2 3     2		3 2 1 0 
			*   	2 					1
			*   	3					0
			*)
			if str='left' then
				begin
					if rotation = 0 then
						begin
							SetLength(Result,4);
							Result[0]:=punti[0];
							Result[1]:=punti[1];
							Result[2]:=punti[2];
							Result[3]:=punti[3];
							getArrayForCheck:=Result;
						end
					else if rotation=90 then
						begin
							SetLength(Result,1);
							Result[0]:=punti[0];
							getArrayForCheck:=Result;
						end
					else if rotation=180 then
						begin
							SetLength(Result,4);
							Result[0]:=punti[0];
							Result[1]:=punti[1];
							Result[2]:=punti[2];
							Result[3]:=punti[3];
							getArrayForCheck:=Result;
						end
					else if rotation=270 then
						begin
							SetLength(Result,1);
							Result[0]:=punti[3];
							getArrayForCheck:=Result;
						end
				end 
			else 
				begin
					if rotation = 0 then
						begin
							SetLength(Result,4);
							Result[0]:=punti[0];
							Result[1]:=punti[1];
							Result[2]:=punti[2];
							Result[3]:=punti[3];
							getArrayForCheck:=Result;
						end
					else if rotation=90 then
						begin
							SetLength(Result,1);
							Result[0]:=punti[3];
							getArrayForCheck:=Result;
						end
					else if rotation=180 then
						begin
							SetLength(Result,4);
							Result[0]:=punti[0];
							Result[1]:=punti[1];
							Result[2]:=punti[2];
							Result[3]:=punti[3];
							getArrayForCheck:=Result;
						end
					else if rotation=270 then
						begin
							SetLength(Result,1);
							Result[0]:=punti[0];
							getArrayForCheck:=Result;
						end
				end
		end
	else if nome='l' then
		begin
			if str='left' then
			(*  0°			90°			180°		270°
			* 
		    *   0 			  3		  3 2		2 1 0
			*   1		0  1  2		    1		3
			*   2 3						0
			*)
				begin
					if rotation=0 then
						begin
							SetLength(Result,3);
							Result[0]:=punti[0];
							Result[1]:=punti[1];
							Result[2]:=punti[2];
							getArrayForCheck:=Result;
						end
					else if rotation=90 then
						begin
							SetLength(Result,2);
							Result[0]:=punti[0];
							Result[1]:=punti[3];
							getArrayForCheck:=Result;
						end
					else if rotation=180 then
						begin
							SetLength(Result,3);
							Result[0]:=punti[0];
							Result[1]:=punti[1];
							Result[2]:=punti[3];
							getArrayForCheck:=Result;
						end
					else if rotation=270 then
						begin
							SetLength(Result,2);
							Result[0]:=punti[2];
							Result[1]:=punti[3];
							getArrayForCheck:=Result;
						end
					end
			else 
				begin
					if rotation=0 then
						begin
							SetLength(Result,3);
							Result[0]:=punti[0];
							Result[1]:=punti[1];
							Result[2]:=punti[3];
							getArrayForCheck:=Result;
						end
					else if rotation=90 then
						begin
							SetLength(Result,2);
							Result[0]:=punti[2];
							Result[1]:=punti[3];
							getArrayForCheck:=Result;
						end
					else if rotation=180 then
						begin
							SetLength(Result,3);
							Result[0]:=punti[0];
							Result[1]:=punti[1];
							Result[2]:=punti[2];
							getArrayForCheck:=Result;
						end
					else if rotation=270 then
						begin
							SetLength(Result,2);
							Result[0]:=punti[0];
							Result[1]:=punti[3];
							getArrayForCheck:=Result;
						end
					end
		end
	else if nome='lrev' then
	(* 0°		90°			180°		270°
    * 
	*  	  0 		2			3 2		0 1 2
	*     1			3 1 0		1			3
	*   2 3 					0
			*)
		begin
			if str='left' then
				begin
					if rotation =0 then
						begin
							SetLength(Result,3);
							Result[0]:=punti[0];
							Result[1]:=punti[1];
							Result[2]:=punti[2];
							getArrayForCheck:=Result;
						end
					else if rotation=90 then
						begin
							SetLength(Result,2);
							Result[0]:=punti[2];
							Result[1]:=punti[3];
							getArrayForCheck:=Result;
						end
					else if rotation=180 then
						begin
							SetLength(Result,3);
							Result[0]:=punti[0];
							Result[1]:=punti[1];
							Result[2]:=punti[3];
							getArrayForCheck:=Result;
						end
					else if rotation=270 then
						begin
						SetLength(Result,2);
							Result[0]:=punti[0];
							Result[1]:=punti[3];
							getArrayForCheck:=Result;
						end
				end
			else
				begin
					if rotation =0 then
						begin
							SetLength(Result,3);
							Result[0]:=punti[0];
							Result[1]:=punti[1];
							Result[2]:=punti[3];
							getArrayForCheck:=Result;
						end
					else if rotation=90 then
						begin
							SetLength(Result,2);
							Result[0]:=punti[2];
							Result[1]:=punti[0];
							getArrayForCheck:=Result;
						end
					else if rotation=180 then
						begin
							SetLength(Result,3);
							Result[0]:=punti[0];
							Result[1]:=punti[1];
							Result[2]:=punti[2];
							getArrayForCheck:=Result;
						end
					else if rotation=270 then
						begin
							SetLength(Result,2);
							Result[0]:=punti[2];
							Result[1]:=punti[3];
							getArrayForCheck:=Result;
						end
				end
		end
	else if nome='cube' then
	(*0-90-180-270°
			* 
			* 	  0 1
			*     2 3 
			*)
		begin
			if str='left' then
				begin
					SetLength(Result,2);
					Result[0]:=punti[0];
					Result[1]:=punti[2];
					getArrayForCheck:=Result;
				end
			else
				begin
					SetLength(Result,2);
					Result[0]:=punti[1];
					Result[1]:=punti[2];
					getArrayForCheck:=Result;
				end
		end
	else if nome='z' then
			(* 0°		90°			180°	 	  270°
		    * 
			* 	0 1 		  0			3 2				3
			*     2 3 		2 1			  1 0		  1 2
			* 				3						  0
			*)
		begin
			if str='left' then
				begin
					if rotation=0 then
						begin
							SetLength(Result,2);
							Result[0]:=punti[0];
							Result[1]:=punti[2];
							getArrayForCheck:=Result;
						end
					else if rotation=90 then
						begin
							SetLength(Result,3);
							Result[0]:=punti[0];
							Result[1]:=punti[2];
							Result[2]:=punti[3];
							getArrayForCheck:=Result;
						end
					else if rotation=180 then
						begin
							SetLength(Result,2);
							Result[0]:=punti[3];
							Result[1]:=punti[1];
							getArrayForCheck:=Result;
						end
					else if rotation=270 then
						begin
							SetLength(Result,3);
							Result[0]:=punti[0];
							Result[1]:=punti[1];
							Result[2]:=punti[3];
							getArrayForCheck:=Result;
						end
				end
			else 
				begin
				if rotation=0 then
						begin
							SetLength(Result,2);
							Result[0]:=punti[3];
							Result[1]:=punti[1];
							getArrayForCheck:=Result;
						end
					else if rotation=90 then
						begin
							SetLength(Result,3);
							Result[0]:=punti[0];
							Result[1]:=punti[1];
							Result[2]:=punti[3];
							getArrayForCheck:=Result;
						end
					else if rotation=180 then
						begin
							SetLength(Result,2);
							Result[0]:=punti[0];
							Result[1]:=punti[2];
							getArrayForCheck:=Result;
						end
					else if rotation=270 then
						begin
							SetLength(Result,3);
							Result[0]:=punti[0];
							Result[1]:=punti[2];
							Result[2]:=punti[3];
							getArrayForCheck:=Result;
						end
				end
		end
	else if nome='zrev' then
			(*0°				90°		180°		270°
		    * 
			* 	    1 0 	3		  2 3		0
			*     3 2 		2 1		0 1			1 2
			*				  0					  3
			*)
		begin
			if str='left' then
				begin
					if rotation=0 then
						begin
							SetLength(Result,2);
							Result[0]:=punti[1];
							Result[1]:=punti[3];
							getArrayForCheck:=Result;
						end
					else if rotation =90 then
						begin
							SetLength(Result,3);
							Result[0]:=punti[2];
							Result[1]:=punti[3];
							Result[2]:=punti[0];
							getArrayForCheck:=Result;
						end
					else if rotation = 180 then
						begin
							SetLength(Result,2);
							Result[0]:=punti[2];
							Result[1]:=punti[0];
							getArrayForCheck:=Result;
						end
					else if rotation = 270 then
						begin
							SetLength(Result,3);
							Result[0]:=punti[1];
							Result[1]:=punti[3];
							Result[2]:=punti[0];
							getArrayForCheck:=Result;
						end
				end
			else
				begin
					if rotation=0 then
						begin
							SetLength(Result,2);
							Result[0]:=punti[2];
							Result[1]:=punti[0];
							getArrayForCheck:=Result;
						end
					else if rotation =90 then
						begin
							SetLength(Result,3);
							Result[0]:=punti[1];
							Result[1]:=punti[3];
							Result[2]:=punti[0];
							getArrayForCheck:=Result;
						end
					else if rotation = 180 then
						begin
							SetLength(Result,2);
							Result[0]:=punti[1];
							Result[1]:=punti[3];
							getArrayForCheck:=Result;
						end
					else if rotation = 270 then
						begin
							SetLength(Result,3);
							Result[0]:=punti[2];
							Result[1]:=punti[3];
							Result[2]:=punti[0];
							getArrayForCheck:=Result;
						end
				end
		end;
end;

function Tracker.getArray:TDynInts;
var i:integer;
var Result:array of Point;
begin
	SetLength(Result,4);
	for i:=0 to 3 do
		Result[i]:=punti[i];
	getArray:=Result;
end;

(* end defination tetraminoTraker *)
(* start defination row *)


type
   Row = object
	
   private
     riga:array[0..9] of Cell;

   public 
      procedure setFull;
      procedure setIfull(i:Integer);
      procedure setIempty(i:Integer);
      procedure setEmpty;
      procedure setRow(c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20:char);
      function getJcell(j:integer):Cell;
      procedure setJcell(j:integer;pro:Cell);
      procedure printRow;
      procedure shiftLeftRow(i:integer;tr:Tracker);
      procedure shiftRightRow(j:integer;tr:Tracker);
      function isRowFull:boolean;

end;

function Row.isRowFull:boolean;
begin
	isRowFull:=(riga[0].isFull) and(riga[1].isFull) and(riga[2].isFull) and(riga[3].isFull) and(riga[4].isFull) and(riga[5].isFull) and(riga[6].isFull) and(riga[7].isFull) and(riga[8].isFull) and(riga[9].isFull);
end;

function Row.getJcell(j:integer):Cell;
begin
	getJcell:=riga[j];
end;

procedure Row.setJcell(j:integer;pro:Cell);
begin
	riga[j]:=pro;
end;

procedure Row.setFull;
var i:Integer;
begin
	for i:=0 to 10 do
		riga[i].setFull;
end;

procedure Row.setEmpty;
var i:Integer;
begin
	for i:=0 to 10 do
		riga[i].setEmpty;
end;

procedure Row.setIfull(i:Integer);
begin
	riga[i].setFull;
end;

procedure Row.setIempty(i:Integer);
begin
	riga[i].setEmpty;
end;

procedure Row.printRow;
begin
	writeln('<!',riga[0].printCell,riga[1].printCell,riga[2].printCell,riga[3].printCell,riga[4].printCell,riga[5].printCell,riga[6].printCell,riga[7].printCell,riga[8].printCell,riga[9].printCell,'!>');
end;

procedure Row.setRow(c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20:char);
begin
	riga[0].setChar(c1,c2);
	riga[1].setChar(c3,c4);
	riga[2].setChar(c5,c6);
	riga[3].setChar(c7,c8);
	riga[4].setChar(c9,c10);
	riga[5].setChar(c11,c12);
	riga[6].setChar(c13,c14);
	riga[7].setChar(c15,c16);
	riga[8].setChar(c17,c18);
	riga[9].setChar(c19,c20);
end;

procedure Row.shiftLeftRow(i:integer;tr:Tracker);
var j:Integer;
begin
	(*writeln('min',tr.getMinXforIrow(i),' max',tr.getMaxXforIrow(i) );*)
	for j:=tr.getMinXforIrow(i) to tr.getMaxXforIrow(i)+1 do
		begin
		(*writeln('riga[',j-1,']=? riga[',j,']');*)
		if (riga[j-1].isFull) and (riga[j].isFull=false) and (j=tr.getMinXforIrow(i)) then else
			riga[j-1]:=riga[j];
		end;
	riga[tr.getMaxX].setEmpty;
end;

procedure Row.shiftRightRow(j:integer;tr:Tracker);
var i:Integer;
begin
(*writeln('min',tr.getMinX,' max',tr.getMaxX );*)
	for i:=tr.getMaxXforIrow(j)+1 downto tr.getMinXforIrow(j) do
		begin
			if (riga[j].isFull) and (riga[j-1].isFull=false) and (j=tr.getMinXforIrow(i)) then else
				riga[i]:=riga[i-1];
		end;
	riga[tr.getMinX].setEmpty;
end;

(* end defination row *)
(* start defination Table *)


type
   Table = object
   private
      tabella: array[0..20] of Row;
      wall:array of Point;
      punteggio:integer;
      procedure addCube;
      procedure addShape1;
      procedure addShape2;
      procedure addShape3;
      procedure addShape4;
      procedure addShape5;
      procedure addShape6;
      procedure setIcellFull(i,j:integer);
      procedure setIcellEmpty(i,j:integer);
      function getIJcell(i,j:integer):Cell;
      procedure newWall;



   public  
	  procedure inizializable;
      procedure setFullTable;
      procedure setEmptyTabel;
      procedure printTable;
      function addTetramino:Tracker;
      function shiftDown(tr:Tracker):Tracker;
      function shiftLeft(tr:Tracker):Tracker;
      function shiftRight(tr:Tracker):Tracker;
      function rotate(tr:Tracker):Tracker;
      function checkIfCanGoDown(tr:Tracker):boolean;
      procedure cleanFullRow;
      function isAlive:boolean;

end;

procedure Table.inizializable;
var i:Integer;
begin
	punteggio:=0;
	for i:=0 to numRowReal do
		tabella[i].setEmpty;
	SetLength(wall,10);
	for i:=0 to Length(wall)-1 do
		wall[i].setCoordinate(i,19);
	tabella[19].setRow('=','=','=','=','=','=','=','=','=','=','=','=','=','=','=','=','=','=','=','=');
	tabella[20].setRow('\','/','\','/','\','/','\','/','\','/','\','/','\','/','\','/','\','/','\','/');
end;

function Table.getIJcell(i,j:integer):Cell;
begin
	getIJcell:=tabella[i].getJcell(j);
end;

procedure Table.setFullTable;
var i:Integer;
begin
	for i:=0 to numRowReal do
		tabella[i].setFull;
end;

procedure Table.setEmptyTabel;
var i:Integer;
begin
	for i:=0 to numRowReal do
		tabella[i].setEmpty;
end;

procedure Table.printTable;
var i:Integer;
begin
	for i:=0 to numRow do
		tabella[i].printRow;
end;

function Table.addTetramino:Tracker;
var num:Integer;
var tr:Tracker;
begin
	Randomize;
	num := random(7)+1;
	if num=1 then 
		begin
			addCube;
			(*0-90-180-270°
			* 
			* 	  1 2
			*     3 4 
			*)
			tr.setCoordinateTetramino(4,0,5,0,4,1,5,1);
			tr.setName('cube');
			addTetramino:=tr;
		end;
	if num=2 then 
		begin
		   (*0°				90°		180°		270°
		    * 
			* 	    2 1 	4		  3 4		1
			*     4 3 		3 2		1 2			2 3
			*				  1					  4
			*)
			addShape1;
			tr.setCoordinateTetramino(6,0,5,0,5,1,4,1);
			tr.setName('zrev');
			addTetramino:=tr;
		end;
	if num=3 then 
		begin
		   (* 0°		90°			180°	 	  270°
		    * 
			* 	1 2 		  1			4 3				4
			*     3 4 		3 2			  2 1		  2 3
			* 				4						  1
			*)
			addShape2;
			tr.setCoordinateTetramino(4,0,5,0,5,1,6,1);
			tr.setName('z');
			addTetramino:=tr;
		end;
	if num=4 then 
		begin
		   (* 0°		90°			180°		270°
		    * 
			*  	  1 		3			4 3		1 2 3
			*     2			4 2 1		2			4
			*   3 4 					1
			*)
			addShape3;
			tr.setName('lrev');
			tr.setCoordinateTetramino(5,0,5,1,4,2,5,2);
			addTetramino:=tr;
		end;
	if num=5 then 
		begin
		(*  0°			90°			180°		270°
		 * 	    1 			  4		  4 3		3 2 1
			*   2		1  2  3		    2		4
			*   3 4						1
			*)
			addShape4;
			tr.setName('l');
			tr.setCoordinateTetramino(4,0,4,1,4,2,5,2);
			addTetramino:=tr;
		end;
	if num=6 then 
		begin
			(* 0°		90°			180°		270°
			* 		1 					4			
			*   	2		1 2 3 4     3		4 3 2 1 
			*   	3 					2
			*   	4					1
			*)
			addShape5;
			tr.setName('i');
			tr.setCoordinateTetramino(4,0,4,1,4,2,4,3);
			addTetramino:=tr;
		end;
	if num=7 then 
		begin
		   (*0°				90°			180°			270°
			* 	1			2			4 3 2 				4
			* 2 3 4   		3 1			  1				  1 3
			* 				4								2
			*)
			addShape6;
			tr.setName('t');
			tr.setCoordinateTetramino(4,0,3,1,4,1,5,1);
			addTetramino:=tr;
		end;
end;


(*vanno aggiunti i controlli se posso girare*)
function Table.rotate(tr:Tracker):Tracker;
var nome:string;
var rotation,offset,offsetY:Integer;
var arrays:array of Point;
var trk:Tracker;
begin
	nome:=tr.getName;
	rotation:=tr.getRotation;
	arrays:=tr.getArray;
	offset:=0;
	offsetY:=0;
	if tr.getMinX = 0 then
				offset:=1
			else if tr.getMaxX = 9 then
				offset:=-1;
	if nome='t' then
		begin
		   (*0°				90°			180°			270°
			* 	0			1			3 2 1 				3
			* 1 2 3   		2 0			  0				  0 2
			* 				3								1
			*)
			(*writeln(tr.getName);*)
			if tr.getMaxY=18 then
					offsetY:=1;
			if rotation =0 then
				begin
				 (*writeln('1');*)
					setIcellEmpty(arrays[1].getY,arrays[1].getX);
					setIcellEmpty(arrays[0].getY,arrays[0].getX);
					setIcellEmpty(arrays[2].getY,arrays[2].getX);
					setIcellEmpty(arrays[3].getY,arrays[3].getX);
					setIcellFull(arrays[1].getY+1-offsetY,arrays[2].getX);
					setIcellFull(arrays[2].getY-offsetY,arrays[2].getX);
					setIcellFull(arrays[3].getY-offsetY,arrays[3].getX);
					setIcellFull(arrays[0].getY-offsetY,arrays[0].getX);
					trk.setCoordinateTetramino(arrays[3].getX,arrays[3].getY-offsetY,arrays[0].getX,arrays[0].getY-offsetY,arrays[2].getX,arrays[2].getY-offsetY,arrays[2].getX,arrays[2].getY+1-offsetY);
					trk.setName(nome);
					trk.rotate;
					rotate := trk;
				end
			else if rotation = 90 then
				begin
					(*writeln('2');*)
					if offset=1 then
						begin
						setIcellEmpty(arrays[1].getY,arrays[1].getX);
						setIcellEmpty(arrays[3].getY,arrays[3].getX);
						setIcellFull(arrays[0].getY,arrays[0].getX+1);
						setIcellFull(arrays[0].getY+1,arrays[0].getX);
						trk.setCoordinateTetramino(arrays[0].getX,arrays[0].getY+1,arrays[0].getX+1,arrays[0].getY,arrays[0].getX,arrays[0].getY,arrays[2].getX,arrays[2].getY);
						end
					else 
						begin
						setIcellEmpty(arrays[1].getY,arrays[1].getX);
						setIcellFull(arrays[2].getY,arrays[2].getX-1);
						trk.setCoordinateTetramino(arrays[3].getX,arrays[3].getY,arrays[0].getX,arrays[0].getY,arrays[2].getX,arrays[2].getY,arrays[2].getX-1,arrays[2].getY);
						end;
					trk.setName(nome);
					trk.rotate;
					trk.rotate;
					rotate := trk;
				end
			else if rotation = 180 then
				begin
					(*writeln('3');*)
					setIcellEmpty(arrays[3].getY,arrays[3].getX);
					setIcellEmpty(arrays[1].getY,arrays[1].getX);
					setIcellEmpty(arrays[0].getY,arrays[0].getX);
					setIcellEmpty(arrays[2].getY,arrays[2].getX);
					setIcellFull(arrays[0].getY-offsetY,arrays[0].getX-1);
					setIcellFull(arrays[0].getY+1-offsetY,arrays[0].getX);
					setIcellFull(arrays[0].getY-offsetY,arrays[0].getX);
					setIcellFull(arrays[2].getY-offsetY,arrays[2].getX);
					trk.setCoordinateTetramino(arrays[0].getX-1,arrays[0].getY-offsetY,arrays[0].getX,arrays[0].getY+1-offsetY,arrays[0].getX,arrays[0].getY-offsetY,arrays[2].getX,arrays[2].getY-offsetY);
					trk.setName(nome);
					trk.rotate;
					trk.rotate;
					trk.rotate;
					rotate := trk;
				end
			else if rotation = 270 then
				begin
					(*writeln('4');*)
					if offset= -1 then
						begin
						setIcellEmpty(arrays[3].getY,arrays[3].getX);
						setIcellEmpty(arrays[1].getY,arrays[1].getX);
						setIcellFull(arrays[0].getY,arrays[0].getX-1);
						setIcellFull(arrays[0].getY-1,arrays[0].getX);
						trk.setCoordinateTetramino(arrays[0].getX,arrays[0].getY-1,arrays[0].getX-1,arrays[0].getY,arrays[0].getX,arrays[0].getY,arrays[2].getX,arrays[2].getY);
						end
					else 
						begin
						setIcellEmpty(arrays[1].getY,arrays[1].getX);
						setIcellFull(arrays[2].getY,arrays[2].getX+1);
						trk.setCoordinateTetramino(arrays[3].getX,arrays[3].getY,arrays[0].getX,arrays[0].getY,arrays[2].getX,arrays[2].getY,arrays[2].getX+1,arrays[2].getY);
						end;
					trk.setName(nome);
					trk.rotate;
					trk.rotate;
					trk.rotate;
					trk.rotate;
					rotate := trk;
				end
		end
	else if nome='i' then
		begin
			(*writeln(tr.getName);*)
		      (* 0°		90°			180°		270°
			* 		0 					3			
			*   	1		0 1 2 3     2		3 2 1 0 
			*   	2 					1
			*   	3					0
			*)
					if tr.getMaxX+1=9 then
								offset:=-1;
					if tr.getMaxY=17 then
						offsetY:=1
					else if tr.getMaxY= 18 then
						offsetY :=2;
					if rotation = 0 then
						begin
							(*writeln('offset ',offset);*)
							if offset = 0 then
								begin
								setIcellEmpty(arrays[0].getY,arrays[0].getX);
								setIcellEmpty(arrays[2].getY,arrays[2].getX);
								setIcellEmpty(arrays[3].getY,arrays[3].getX);
								setIcellFull(arrays[1].getY,arrays[1].getX-1);
								setIcellFull(arrays[1].getY,arrays[1].getX+1);
								setIcellFull(arrays[1].getY,arrays[1].getX+2);
								trk.setCoordinateTetramino(arrays[1].getX-1,arrays[1].getY,arrays[1].getX,arrays[1].getY,arrays[1].getX+1,arrays[1].getY,arrays[1].getX+2,arrays[1].getY);
								end
							else if offset=1 then
								begin
								setIcellEmpty(arrays[0].getY,arrays[0].getX);
								setIcellEmpty(arrays[2].getY,arrays[2].getX);
								setIcellEmpty(arrays[3].getY,arrays[3].getX);
								setIcellFull(arrays[1].getY,arrays[1].getX+1);
								setIcellFull(arrays[1].getY,arrays[1].getX+2);
								setIcellFull(arrays[1].getY,arrays[1].getX+3);
								trk.setCoordinateTetramino(arrays[1].getX,arrays[1].getY,arrays[1].getX+1,arrays[1].getY,arrays[1].getX+2,arrays[1].getY,arrays[1].getX+3,arrays[1].getY);
								end
							else if offset=-1 then
								begin
								setIcellEmpty(arrays[0].getY,arrays[0].getX);
								setIcellEmpty(arrays[2].getY,arrays[2].getX);
								setIcellEmpty(arrays[3].getY,arrays[3].getX);
								setIcellFull(arrays[1].getY,arrays[1].getX-1);
								setIcellFull(arrays[1].getY,arrays[1].getX-2);
								setIcellFull(arrays[1].getY,arrays[1].getX-3);
								trk.setCoordinateTetramino(arrays[1].getX-3,arrays[1].getY,arrays[1].getX-2,arrays[1].getY,arrays[1].getX-1,arrays[1].getY,arrays[1].getX,arrays[1].getY);
								end;
							trk.setName(nome);
							trk.rotate;
							rotate := trk;
						end
					else if rotation=90 then
						begin
							setIcellEmpty(arrays[0].getY,arrays[0].getX);
							setIcellEmpty(arrays[1].getY,arrays[1].getX);
							setIcellEmpty(arrays[3].getY,arrays[3].getX);
							setIcellEmpty(arrays[2].getY,arrays[2].getX);
							setIcellFull(arrays[2].getY-1-offsetY,arrays[2].getX);
							setIcellFull(arrays[2].getY+1-offsetY,arrays[2].getX);
							setIcellFull(arrays[2].getY+2-offsetY,arrays[2].getX);
							setIcellFull(arrays[2].getY-offsetY,arrays[2].getX);
							trk.setCoordinateTetramino(arrays[2].getX,arrays[2].getY+2-offsetY,arrays[2].getX,arrays[2].getY+1-offsetY,arrays[2].getX,arrays[2].getY-offsetY,arrays[2].getX,arrays[2].getY-1-offsetY);
							trk.setName(nome);
							trk.rotate;
							trk.rotate;
							rotate := trk;
						end
					else if rotation=180 then
						begin
							if offset = 0 then
								begin
								setIcellEmpty(arrays[0].getY,arrays[0].getX);
								setIcellEmpty(arrays[1].getY,arrays[1].getX);
								setIcellEmpty(arrays[3].getY,arrays[3].getX);
								setIcellFull(arrays[2].getY,arrays[2].getX-1);
								setIcellFull(arrays[2].getY,arrays[2].getX+1);
								setIcellFull(arrays[2].getY,arrays[2].getX+2);
								trk.setCoordinateTetramino(arrays[2].getX+2,arrays[2].getY,arrays[2].getX+1,arrays[2].getY,arrays[2].getX,arrays[2].getY,arrays[2].getX-1,arrays[2].getY);
								end
							else if offset = 1 then					
								begin
								setIcellEmpty(arrays[0].getY,arrays[0].getX);
								setIcellEmpty(arrays[1].getY,arrays[1].getX);
								setIcellEmpty(arrays[3].getY,arrays[3].getX);
								setIcellFull(arrays[2].getY,arrays[2].getX-1);
								setIcellFull(arrays[2].getY,arrays[2].getX+1);
								setIcellFull(arrays[2].getY,arrays[2].getX+2);
								trk.setCoordinateTetramino(arrays[2].getX+2,arrays[2].getY,arrays[2].getX+1,arrays[2].getY,arrays[2].getX,arrays[2].getY,arrays[2].getX-1,arrays[2].getY);
								end
							else if offset = -1 then
								begin
								setIcellEmpty(arrays[0].getY,arrays[0].getX);
								setIcellEmpty(arrays[1].getY,arrays[1].getX);
								setIcellEmpty(arrays[3].getY,arrays[3].getX);
								setIcellFull(arrays[2].getY,arrays[2].getX-1);
								setIcellFull(arrays[2].getY,arrays[2].getX-2);
								setIcellFull(arrays[2].getY,arrays[2].getX-3);
								trk.setCoordinateTetramino(arrays[2].getX,arrays[2].getY,arrays[2].getX-1,arrays[2].getY,arrays[2].getX-2,arrays[2].getY,arrays[2].getX-3,arrays[2].getY);
								end;
							trk.setName(nome);
							trk.rotate;
							trk.rotate;
							trk.rotate;
							rotate := trk;
						end
					else if rotation=270 then
						begin
							setIcellEmpty(arrays[0].getY,arrays[0].getX);
							setIcellEmpty(arrays[2].getY,arrays[2].getX);
							setIcellEmpty(arrays[3].getY,arrays[3].getX);
							setIcellEmpty(arrays[2].getY,arrays[2].getX);
							setIcellFull(arrays[1].getY-1-offsetY,arrays[1].getX);
							setIcellFull(arrays[1].getY+1-offsetY,arrays[1].getX);
							setIcellFull(arrays[1].getY+2-offsetY,arrays[1].getX);
							setIcellFull(arrays[1].getY-offsetY,arrays[1].getX);
							trk.setCoordinateTetramino(arrays[1].getX,arrays[1].getY-1-offsetY,arrays[1].getX,arrays[1].getY-offsetY,arrays[1].getX,arrays[1].getY+1-offsetY,arrays[1].getX,arrays[1].getY+2-offsetY);
							trk.setName(nome);
							trk.rotate;
							trk.rotate;
							trk.rotate;
							trk.rotate;
							rotate := trk;
						end
		end
	else if nome='l' then
		begin
			(*writeln(tr.getName);*)
			(*  0°			90°			180°		270°
			* 
		    *   0 			  3		  3 2		2 1 0
			*   1		0  1  2		    1		3
			*   2 3						0
			*)
			if tr.getMaxY=18 then
					offsetY:=1;
					if rotation=0 then
						begin
							setIcellEmpty(arrays[0].getY,arrays[0].getX);
							setIcellEmpty(arrays[1].getY,arrays[1].getX);
							setIcellEmpty(arrays[2].getY,arrays[2].getX);
							setIcellEmpty(arrays[3].getY,arrays[3].getX);
							setIcellFull(arrays[2].getY,arrays[2].getX+offset);
							setIcellFull(arrays[3].getY,arrays[3].getX+offset);
							setIcellFull(arrays[3].getY-1,arrays[3].getX+offset);
							setIcellFull(arrays[2].getY,arrays[2].getX-1+offset);
							trk.setCoordinateTetramino(arrays[2].getX-1+offset,arrays[2].getY,arrays[2].getX+offset,arrays[2].getY,arrays[3].getX+offset,arrays[3].getY,arrays[3].getX+offset,arrays[3].getY-1);
							trk.setName(nome);
							trk.rotate;
							rotate := trk;
						end
					else if rotation=90 then
						begin
							setIcellEmpty(arrays[0].getY,arrays[0].getX);
							setIcellEmpty(arrays[1].getY,arrays[1].getX);
							setIcellEmpty(arrays[2].getY,arrays[2].getX);
							setIcellEmpty(arrays[3].getY,arrays[3].getX);
							setIcellFull(arrays[3].getY-offsetY,arrays[3].getX);
							setIcellFull(arrays[2].getY-offsetY,arrays[2].getX);
							setIcellFull(arrays[3].getY-offsetY,arrays[3].getX-1);
							setIcellFull(arrays[2].getY+1-offsetY,arrays[2].getX);
							trk.setCoordinateTetramino(arrays[2].getX,arrays[2].getY+1-offsetY,arrays[2].getX,arrays[2].getY-offsetY,arrays[3].getX,arrays[3].getY-offsetY,arrays[3].getX-1,arrays[3].getY-offsetY);
							trk.setName(nome);
							trk.rotate;
							trk.rotate;
							rotate := trk;
						end
					else if rotation=180 then
						begin
							if offset=-1 then
								begin
								setIcellEmpty(arrays[0].getY,arrays[0].getX);
								setIcellEmpty(arrays[1].getY,arrays[1].getX);
								setIcellFull(arrays[3].getY+1,arrays[3].getX-1);
								setIcellFull(arrays[3].getY,arrays[3].getX-1);
								trk.setCoordinateTetramino(arrays[2].getX,arrays[2].getY,arrays[3].getX,arrays[3].getY,arrays[3].getX-1,arrays[3].getY,arrays[3].getX-1,arrays[3].getY+1);
								end
							else
								begin
								setIcellEmpty(arrays[0].getY,arrays[0].getX);
								setIcellEmpty(arrays[1].getY,arrays[1].getX);
								setIcellFull(arrays[3].getY+1,arrays[3].getX);
								setIcellFull(arrays[2].getY,arrays[2].getX+1);
								trk.setCoordinateTetramino(arrays[2].getX+1,arrays[2].getY,arrays[2].getX,arrays[2].getY,arrays[3].getX,arrays[3].getY,arrays[3].getX,arrays[3].getY+1);
								end;
							trk.setName(nome);
							trk.rotate;
							trk.rotate;
							trk.rotate;
							rotate := trk;
						end
					else if rotation=270 then
						begin
							setIcellEmpty(arrays[0].getY,arrays[0].getX);
							setIcellEmpty(arrays[1].getY,arrays[1].getX);
							setIcellFull(arrays[3].getY,arrays[3].getX+1);
							setIcellFull(arrays[2].getY-1,arrays[2].getX);
							trk.setCoordinateTetramino(arrays[2].getX,arrays[2].getY-1,arrays[2].getX,arrays[2].getY,arrays[3].getX,arrays[3].getY,arrays[3].getX+1,arrays[3].getY);
							trk.setName(nome);
							trk.rotate;
							trk.rotate;
							trk.rotate;
							trk.rotate;
							rotate := trk;
						end
		end
	else if nome='lrev' then
	(* 0°		90°			180°		270°
    * 
	*  	  0 		2			3 2		0 1 3
	*     1			3 1 0		1			2
	*   2 3 					0
	* 
			*)
		begin
		(*writeln(tr.getName);*)
		if tr.getMaxY=18 then
			offsetY:=1;
					if rotation =0 then
						begin
							if offset=-1 then
								begin
								setIcellEmpty(arrays[0].getY,arrays[0].getX);
								setIcellEmpty(arrays[1].getY,arrays[1].getX);
								setIcellEmpty(arrays[2].getY,arrays[2].getX);
								setIcellEmpty(arrays[3].getY,arrays[3].getX);
								setIcellFull(arrays[2].getY,arrays[2].getX+offset);
								setIcellFull(arrays[3].getY,arrays[3].getX+offset);
								setIcellFull(arrays[3].getY,arrays[3].getX+1+offset);
								setIcellFull(arrays[2].getY-1,arrays[2].getX+offset);
								trk.setCoordinateTetramino(arrays[3].getX+1+offset,arrays[3].getY,arrays[3].getX+offset,arrays[3].getY,arrays[2].getX+offset,arrays[2].getY-1,arrays[2].getX+offset,arrays[2].getY);
								end
							else
								begin
								setIcellEmpty(arrays[0].getY,arrays[0].getX);
								setIcellEmpty(arrays[1].getY,arrays[1].getX);
								setIcellFull(arrays[3].getY,arrays[3].getX+1);
								setIcellFull(arrays[2].getY-1,arrays[2].getX);
								trk.setCoordinateTetramino(arrays[3].getX+1,arrays[3].getY,arrays[3].getX,arrays[3].getY,arrays[2].getX,arrays[2].getY-1,arrays[2].getX,arrays[2].getY);
								end;
							trk.setName(nome);
							trk.rotate;
							rotate := trk;
						end
					else if rotation=90 then
						begin
							setIcellEmpty(arrays[0].getY,arrays[0].getX);
							setIcellEmpty(arrays[1].getY,arrays[1].getX);
							setIcellEmpty(arrays[2].getY,arrays[2].getX);
							setIcellEmpty(arrays[3].getY,arrays[3].getX);
							setIcellFull(arrays[2].getY-offsetY,arrays[2].getX);
							setIcellFull(arrays[3].getY-offsetY,arrays[3].getX);
							setIcellFull(arrays[3].getY+1-offsetY,arrays[3].getX);
							setIcellFull(arrays[2].getY-offsetY,arrays[2].getX+1);
							trk.setCoordinateTetramino(arrays[3].getX,arrays[3].getY+1-offsetY,arrays[3].getX,arrays[3].getY-offsetY,arrays[2].getX+1,arrays[2].getY-offsetY,arrays[2].getX,arrays[2].getY-offsetY);
							trk.setName(nome);
							trk.rotate;
							trk.rotate;
							rotate := trk;
						end
					else if rotation=180 then
						begin
							if offset = 1 then
								begin
								setIcellEmpty(arrays[0].getY,arrays[0].getX);
								setIcellEmpty(arrays[1].getY,arrays[1].getX);
								setIcellEmpty(arrays[2].getY,arrays[2].getX);
								setIcellEmpty(arrays[3].getY,arrays[3].getX);
								setIcellFull(arrays[2].getY,arrays[2].getX+offset);
								setIcellFull(arrays[3].getY,arrays[3].getX+offset);
								setIcellFull(arrays[3].getY,arrays[3].getX-1+offset);
								setIcellFull(arrays[2].getY+1,arrays[2].getX+offset);
								trk.setCoordinateTetramino(arrays[3].getX-1+offset,arrays[3].getY,arrays[3].getX+offset,arrays[3].getY,arrays[2].getX+offset,arrays[2].getY+1,arrays[2].getX+offset,arrays[2].getY);
								end
							else
								begin
								setIcellEmpty(arrays[0].getY,arrays[0].getX);
								setIcellEmpty(arrays[1].getY,arrays[1].getX);
								setIcellFull(arrays[3].getY,arrays[3].getX-1);
								setIcellFull(arrays[2].getY+1,arrays[2].getX);
								trk.setCoordinateTetramino(arrays[3].getX-1,arrays[3].getY,arrays[3].getX,arrays[3].getY,arrays[2].getX,arrays[2].getY+1,arrays[2].getX,arrays[2].getY);
								end;
							trk.setName(nome);
							trk.rotate;
							trk.rotate;
							trk.rotate;
							rotate := trk;
						end
					else if rotation=270 then
						begin
							setIcellEmpty(arrays[0].getY,arrays[0].getX);
							setIcellEmpty(arrays[1].getY,arrays[1].getX);
							setIcellFull(arrays[3].getY-1,arrays[3].getX);
							setIcellFull(arrays[2].getY,arrays[2].getX-1);
							trk.setCoordinateTetramino(arrays[3].getX,arrays[3].getY-1,arrays[3].getX,arrays[3].getY,arrays[2].getX-1,arrays[2].getY,arrays[2].getX,arrays[2].getY);
							trk.setName(nome);
							trk.rotate;
							trk.rotate;
							trk.rotate;
							trk.rotate;
							rotate := trk;
						end
		end
	else if nome='cube' then
	(*0-90-180-270°
			* 
			* 	  0 1
			*     2 3 
			*)
		begin
			writeln(tr.getName);
			tr.rotate;
			rotate := tr;
		end
	else if nome='z' then
			(* 0°		90°			180°	 	  270°
		    * 
			* 	0 1 		  0			3 2				3
			*     2 3 		2 1			  1 0		  1 2
			* 				3						  0
			*)
		begin
		writeln(tr.getName);
		if tr.getMaxY=18 then
			offsetY:=1;
					if rotation=0 then
						begin
							setIcellEmpty(arrays[0].getY,arrays[0].getX);
							setIcellEmpty(arrays[1].getY,arrays[1].getX);
							setIcellEmpty(arrays[2].getY,arrays[2].getX);
							setIcellEmpty(arrays[3].getY,arrays[3].getX);
							setIcellFull(arrays[2].getY-offsetY,arrays[2].getX);
							setIcellFull(arrays[3].getY-offsetY,arrays[3].getX);
							setIcellFull(arrays[3].getY-1-offsetY,arrays[3].getX);
							setIcellFull(arrays[2].getY+1-offsetY,arrays[2].getX);
							trk.setCoordinateTetramino(arrays[3].getX,arrays[3].getY-1-offsetY,arrays[3].getX,arrays[3].getY-offsetY,arrays[2].getX,arrays[2].getY-offsetY,arrays[2].getX,arrays[2].getY+1-offsetY);
							trk.setName(nome);
							trk.rotate;
							rotate := trk;
						end
					else if rotation=90 then
						begin
							setIcellEmpty(arrays[0].getY,arrays[0].getX);
							setIcellEmpty(arrays[1].getY,arrays[1].getX);
							setIcellEmpty(arrays[2].getY,arrays[2].getX);
							setIcellEmpty(arrays[3].getY,arrays[3].getX);
							setIcellFull(arrays[3].getY,arrays[3].getX+1+offset);
							setIcellFull(arrays[2].getY,arrays[2].getX-1+offset);
							setIcellFull(arrays[2].getY,arrays[2].getX+offset);
							setIcellFull(arrays[3].getY,arrays[3].getX+offset);
							trk.setCoordinateTetramino(arrays[3].getX+1+offset,arrays[3].getY,arrays[3].getX+offset,arrays[3].getY,arrays[2].getX+offset,arrays[2].getY,arrays[2].getX-1+offset,arrays[2].getY);
							trk.setName(nome);
							trk.rotate;
							trk.rotate;
							rotate := trk;
						end
					else if rotation=180 then
						begin
							
							setIcellEmpty(arrays[2].getY,arrays[2].getX);
							setIcellEmpty(arrays[3].getY,arrays[3].getX);
							setIcellEmpty(arrays[1].getY,arrays[1].getX);
							setIcellEmpty(arrays[0].getY,arrays[0].getX);
							setIcellFull(arrays[1].getY+1-offsetY,arrays[1].getX);
							setIcellFull(arrays[1].getY-offsetY,arrays[1].getX);
							setIcellFull(arrays[0].getY-offsetY,arrays[0].getX);
							setIcellFull(arrays[0].getY-1-offsetY,arrays[0].getX);
							trk.setCoordinateTetramino(arrays[1].getX,arrays[1].getY+1-offsetY,arrays[1].getX,arrays[1].getY-offsetY,arrays[0].getX,arrays[0].getY-offsetY,arrays[0].getX,arrays[0].getY-1-offsetY);
							trk.setName(nome);
							trk.rotate;
							trk.rotate;
							trk.rotate;
							rotate := trk;
						end
					else if rotation=270 then
						begin
							setIcellEmpty(arrays[0].getY,arrays[0].getX);
							setIcellEmpty(arrays[1].getY,arrays[1].getX);
							setIcellEmpty(arrays[2].getY,arrays[2].getX);
							setIcellEmpty(arrays[3].getY,arrays[3].getX);
							setIcellFull(arrays[3].getY,arrays[3].getX-1+offset);
							setIcellFull(arrays[2].getY,arrays[2].getX+1+offset);
							setIcellFull(arrays[2].getY,arrays[2].getX+offset);
							setIcellFull(arrays[3].getY,arrays[3].getX+offset);
							trk.setCoordinateTetramino(arrays[3].getX-1+offset,arrays[3].getY,arrays[3].getX+offset,arrays[3].getY,arrays[2].getX+offset,arrays[2].getY,arrays[2].getX+1+offset,arrays[2].getY);
							trk.setName(nome);
							trk.rotate;
							trk.rotate;
							trk.rotate;
							trk.rotate;
							rotate := trk;
						end
		end
	else if nome='zrev' then
			(*0°				90°		180°		270°
		    * 
			* 	    1 0 	3		  2 3		0
			*     3 2 		2 1		0 1			1 2
			*				  0					  3
			*)
				begin
				if tr.getMaxY=18 then
					offsetY:=1;
				writeln(tr.getName);
					if rotation=0 then
						begin
							setIcellEmpty(arrays[0].getY,arrays[0].getX);
							setIcellEmpty(arrays[1].getY,arrays[1].getX);
							setIcellEmpty(arrays[2].getY,arrays[2].getX);
							setIcellEmpty(arrays[3].getY,arrays[3].getX);
							setIcellFull(arrays[3].getY-1-offsetY,arrays[3].getX);
							setIcellFull(arrays[2].getY+1-offsetY,arrays[2].getX);
							setIcellFull(arrays[2].getY-offsetY,arrays[2].getX);
							setIcellFull(arrays[3].getY-offsetY,arrays[3].getX);
							trk.setCoordinateTetramino(arrays[3].getX,arrays[3].getY-1-offsetY,arrays[3].getX,arrays[3].getY-offsetY,arrays[2].getX,arrays[2].getY-offsetY,arrays[2].getX,arrays[2].getY+1-offsetY);
							trk.setName(nome);
							trk.rotate;
							rotate := trk;
						end
					else if rotation =90 then
						begin
							setIcellEmpty(arrays[0].getY,arrays[0].getX);
							setIcellEmpty(arrays[1].getY,arrays[1].getX);
							setIcellEmpty(arrays[2].getY,arrays[2].getX);
							setIcellEmpty(arrays[3].getY,arrays[3].getX);
							setIcellFull(arrays[3].getY,arrays[3].getX+offset);
							setIcellFull(arrays[2].getY,arrays[2].getX+offset);
							setIcellFull(arrays[3].getY,arrays[3].getX+1+offset);
							setIcellFull(arrays[2].getY,arrays[2].getX-1+offset);
							trk.setCoordinateTetramino(arrays[3].getX+1+offset,arrays[3].getY,arrays[3].getX+offset,arrays[3].getY,arrays[2].getX+offset,arrays[2].getY,arrays[2].getX-1+offset,arrays[2].getY);
							trk.setName(nome);
							trk.rotate;
							trk.rotate;
							rotate := trk;
						end
					else if rotation = 180 then
						begin
							setIcellEmpty(arrays[0].getY,arrays[0].getX);
							setIcellEmpty(arrays[1].getY,arrays[1].getX);
							setIcellFull(arrays[3].getY+1,arrays[3].getX);
							setIcellFull(arrays[2].getY-1,arrays[2].getX);
							trk.setCoordinateTetramino(arrays[3].getX,arrays[3].getY+1,arrays[3].getX,arrays[3].getY,arrays[2].getX,arrays[2].getY,arrays[2].getX,arrays[2].getY-1);
							trk.setName(nome);
							trk.rotate;
							trk.rotate;
							trk.rotate;
							rotate := trk;
						end
					else if rotation = 270 then
						begin
							setIcellEmpty(arrays[0].getY,arrays[0].getX);
							setIcellEmpty(arrays[1].getY,arrays[1].getX);
							setIcellEmpty(arrays[2].getY,arrays[2].getX);
							setIcellEmpty(arrays[3].getY,arrays[3].getX);
							setIcellFull(arrays[3].getY,arrays[3].getX-1+offset);
							setIcellFull(arrays[2].getY,arrays[2].getX+1+offset);
							setIcellFull(arrays[2].getY,arrays[2].getX+offset);
							setIcellFull(arrays[3].getY,arrays[3].getX+offset);
							trk.setCoordinateTetramino(arrays[3].getX-1+offset,arrays[3].getY,arrays[3].getX+offset,arrays[3].getY,arrays[2].getX+offset,arrays[2].getY,arrays[2].getX+1+offset,arrays[2].getY);
							trk.setName(nome);
							trk.rotate;
							trk.rotate;
							trk.rotate;
							trk.rotate;
							rotate := trk;
						end
		end;
end;


procedure Table.setIcellFull(i,j:Integer);
begin
	tabella[i].setIfull(j);
end;

procedure Table.setIcellEmpty(i,j:Integer);
begin
	tabella[i].setIempty(j);
end;

procedure Table.addCube;
begin
	setIcellFull(0,4);
	setIcellFull(0,5);
	setIcellFull(1,4);
	setIcellFull(1,5);
end;

procedure Table.addShape1;
begin
	setIcellFull(0,6);
	setIcellFull(0,5);
	setIcellFull(1,4);
	setIcellFull(1,5);
end;

procedure Table.addShape2;
begin
	setIcellFull(0,4);
	setIcellFull(0,5);
	setIcellFull(1,6);
	setIcellFull(1,5);
end;

procedure Table.addShape3;
begin
	setIcellFull(0,5);
	setIcellFull(1,5);
	setIcellFull(2,5);
	setIcellFull(2,4);
end;

procedure Table.addShape4;
begin
	setIcellFull(0,4);
	setIcellFull(1,4);
	setIcellFull(2,4);
	setIcellFull(2,5);
end;

procedure Table.addShape5;
begin
	setIcellFull(0,4);
	setIcellFull(1,4);
	setIcellFull(2,4);
	setIcellFull(3,4);
end;

procedure Table.addShape6;
begin
	setIcellFull(0,4);
	setIcellFull(1,4);
	setIcellFull(1,3);
	setIcellFull(1,5);
end;

function Table.shiftDown(tr:Tracker):Tracker;
var i,j: Integer;
begin 
	(*writeln(tr.getMaxY+1,tr.getMinY, Min(tr.getMinY,18) );*)
	for i:=Min(tr.getMaxY+1,18) downto tr.getMinY do
	begin 
		if i=0 then
			tabella[i].setEmpty;
		if i>0 then
			begin
				(*tabella[i]:=tabella[i-1];*)
				for j:=tr.getMinX to tr.getMaxX do
					if i=Min(tr.getMaxY+1,18) then
						begin
							if tabella[i].getJcell(j).isFull=false then
								tabella[i].setJcell(j,tabella[i-1].getJcell(j))
						end
					else
						tabella[i].setJcell(j,tabella[i-1].getJcell(j));
			end;
	end; 
	tr.goDown;
	shiftDown:=tr;
end;


function Table.checkIfCanGoDown(tr:Tracker):boolean;
var i,j,lun:integer;
var tmp:array of Point;
var flag:boolean;
var minimo:array[0..9] of Integer;
begin
	for j:=0 to 9 do
		minimo[j]:=19;
	for i:=0 to Length(wall)-1 do 
		begin
		for j:=tr.getMinX to tr.getMaxX do
		begin
		(*writeln('i:',i,'{x:',wall[i].getX,',y:',wall[i].getY,'}');*)
			begin
				if (j=wall[i].getX) and (minimo[j]>wall[i].getY) then
					begin
					(*writeln('minimo[',wall[i].getX,']=',wall[i].getY);*)
					minimo[wall[i].getX]:=wall[i].getY;
					end;
				end;
			end;
		end;
	
	flag:=true;
	tmp:=tr.getArray;
	for i:=0 to Length(tmp)-1 do
	begin
		(*writeln('controllo tmp[',i,']= x:',tmp[i].getX,'; y:',tmp[i].getY,'; minimo[',tmp[i].getX,']=',minimo[tmp[i].getX]);*)
		if tmp[i].getY+1>=minimo[tmp[i].getX] then
			begin
			(*writeln('dentro');*)
			flag:=false;
			end;
	end;
	if flag then
		checkIfCanGoDown:=true
	else
		begin
			lun:=Length(wall);
			SetLength(wall,lun+4);
			(*writeln(lun,Length(wall));*)
			j:=0;
			tmp:=tr.getArray;
			for i:=lun to Length(wall)-1 do
				begin
					(*writeln('wall[',i,']=temp[',j,']');*)
					wall[i]:=tmp[j];
					j:=j+1;
				end;
			checkIfCanGoDown:=false;
		end;
		
end;


function Table.shiftLeft(tr:Tracker):Tracker;
var i: Integer;
var bool:boolean;
var arr:array of Point;
begin 
	arr:=tr.getArrayForCheck('left');
	bool:=true;
	for i:=0 to Length(arr)-1 do
	begin
		if arr[i].getX-1>=0 then
			begin
			if getIJcell(arr[i].getX-1,arr[i].getY).isFull = true then
				begin
					bool:=false;
				end;
			end
		else
			bool:=false;
	end;
	if bool=true then
		begin
		for i:=tr.getMinY to tr.getMaxY do
			tabella[i].shiftLeftRow(i,tr);
		tr.goLeft;
		end;
	shiftLeft:=tr;
		
end;


function Table.shiftRight(tr:Tracker):Tracker;
var i: Integer;
var bool:boolean;
var arr:array of Point;
begin 
	arr:=tr.getArrayForCheck('right');
	(*writeln('primo',arr[0].getX,arr[0].getY,' rotation ',tr.getRotation);*)
	bool:=true;
	for i:=0 to Length(arr)-1 do
	begin
		(*writeln(arr[i].getX+1);*)
		if arr[i].getX+1<=9 then
			begin
			(*writeln(arr[i].getX+1,arr[i].getY);*)
			if getIJcell(arr[i].getX+1,arr[i].getY).isFull = true then
				begin
					bool:=false;
				end;
			end
		else
			bool:=false;
	end;
	if bool=true then
		begin
		for i:=tr.getMinY to tr.getMaxY do
			tabella[i].shiftRightRow(i,tr);
		tr.goRight;
		end;
	shiftRight:=tr;
end;

procedure Table.newWall;
var return:array of Point;
var j,i,len:integer;
var tmp:array[0..200] of Point;
begin
	len:=0;
	for i:=19 downto 0 do
		for j:=0 to 9 do
			if tabella[i].getJcell(j).isFull then
				begin
					SetLength(return,len+1);
					tmp[len].setCoordinate(j,i);
					return[len]:=tmp[len];
					len:=len+1;
				end;
	wall:=return;	
end;

procedure Table.cleanFullRow();
var i,j,count,offset:Integer;
var row:array of Integer;
begin
	count:=0;
	for i:=18 downto 0 do
		if tabella[i].isRowFull then
			begin
			SetLength(row,count+1);
			row[count]:=i;
			(*writeln('row[',count,']=',row[count]);*)
			count:=count+1;
			end;
	(*writeln('count ',count);*)
	if count>0 then
		begin
			table.printTable;
			for i:=0 to count-1 do
				begin
				offset:=0;
				while tabella[row[i]-offset].isRowFull do
							offset:=offset+1;
				for j:=row[i] downto offset+1 do
					begin
						(*writeln('row[',i,']=',row[i],'  j=',j,' offset=',offset);
						writeln('tabella[',j,']= tabella[',j-offset,']');*)
						tabella[j]:=tabella[j-offset];
					end;
				end;
			printTable;
			newWall;	
			punteggio:=punteggio+(count*100);	
		end;
end;

function Table.isAlive:Boolean;
var i,j:integer;
var flag:boolean;
begin
	flag:=true;
	for j:=0 to 1 do
		for i:=0 to 9 do
			begin
			(*writeln('y:',j,' x:',i);*)
			if tabella[j].getJcell(i).isFull then	
				begin
					(*writeln('fine dei giochi');*)
					flag:=false;
				end;
			end;
	isAlive:=flag;
end;


(* end defination Table *)
(*main*)

var ele:Table;
var alive:boolean;
var   K : TKeyEvent;
var tr:Tracker;
var i:LongInt;


BEGIN
  InitKeyBoard;
    InitKeyBoard;
	ele.inizializable;
	ele.printTable;
	tr:=ele.addTetramino;
	alive:=true;
	while alive do
		begin
			Delay(100);
			for i:=0 to 40 do
				begin
				Delay(10);
				ele.printTable;
				K:=PollKeyEvent;
				(*writeln(tr.getCoordinateTetramino);*)
				If k<>0 then
					begin
					K:=GetKeyEvent;
					K:=TranslateKeyEvent(K);
					if GetKeyEventChar(K)='a' then
						begin
						tr:=ele.shiftLeft(tr);
						end
					else if GetKeyEventChar(K)='d' then
						begin
						tr:=ele.shiftRight(tr);
						end
					else if GetKeyEventChar(K)='w' then
						begin
						tr:=ele.rotate(tr);
						end
					else if GetKeyEventChar(K)='s' then
						begin
							while ele.checkIfCanGoDown(tr) do
								Begin
								(*writeln('prova');*)
								tr:=ele.shiftDown(tr)
								end;
						end; 
					end
				end;
			if ele.checkIfCanGoDown(tr) then
				Begin
					(*writeln('vero');*)
					tr:=ele.shiftDown(tr);
				end
			else
				begin
					(*writeln('false');*)
					ele.cleanFullRow;
					alive:=ele.isAlive;
					if alive then
						tr:=ele.addTetramino;
					(*writeln(alive);*)
				end;
		end;
	writeln('Fine del gioco');
	writeln('Punteggio : ',ele.punteggio);
END.
