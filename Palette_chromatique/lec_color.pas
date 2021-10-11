unit lec_color;

(* Ce Module pour lire un fichier des couleurs avec le nom correspondant écrit par denis Bertin*)
(* Le fichier se nomme ansicoul.txt et doit se trouver dans le répertoire de l'application *)
(* Rewrite for Delphi by denis Bertin le 9 septembre le l'an de grace 2009 Après~JC *)
(* Visualiser par marc machin, dénommé l'identification des couleurs par IBM & et reconnaissance par HAL *)

{Article premier, comme d'une part il est admis que mon cerveau humain à écrit 16 millions de caractère}
{Article deuxième, comme de toute évidance nous somme quelque un à le comprendre, ainsi}
{Article troisième que ce n'est pas le cas de tout le monde et vus les égards ainsi rencontré}
{Article quatrième par nos concitoyens que faudrait-il faire pour qu'ils les assimilent!}

interface

uses Classes,Windows,contnrs,sysutils;

const kpc_diese:pchar='#';
      kpc_equal:pchar='=';

var sDecimal:array[0..10] of char;
var sThousand:array[0..10] of char;

type

  pc20 = array[0..20] of char;
  pc50 = array[0..50] of char;
  pc100 = array[0..100] of char;
  pc255 = array[0..255] of char;
  pc1024 = array[0..1024] of char;

  node=class(Classes.Tcollectionitem)
    constructor	Create; reintroduce;
    end;

  TO_COL = class(contnrs.TObjectList)
    function at(index:integer):pointer;
    procedure insert(AObject: TObject); overload;
    procedure Freeall;
    end;

  {P_color_name = ^T_color_name;}
	T_color_name = class(lec_color.node)
    public
		name:pc50;
		color:TColorRef;
		constructor Create(un_nom_couleur:pchar; une_numeric_couleur:tcolorref);
		end; {T_color_name}


  T_Col_Named = class(TO_COL)
    function Lecture_fichier_couleur:boolean;
    procedure Recheche_couleur_plus_proche(find_this_color:TColorRef; var result_named_color:T_color_name);
    end;

  procedure remplace_pt_decimale_pt_window(apc:pchar);  {1.00 -> 1,00}
  procedure remplace_pt_window_pt_decimal(apc:pchar); overload; {1,00 -> 1.00}
  procedure remplace_pt_window_pt_decimal(var str:string); overload;

implementation

function get_exe_path(path_exe:pchar):pchar;
	var p:pchar;
	begin
	strpcopy(path_exe,paramstr(0));
	P := StrRScan(path_exe, '\');
	inc(p); p^:=#0;
	get_exe_path:=path_exe;
	end;

function file_existe(filename:pchar):boolean;
	begin
  file_existe:=FileExists(strpas(filename));
	end;

function Power(a:real;b:integer):real;
	var i:integer;
		 n:real;
	begin
	n:=1.0;
	for i:=1 to b do
		n:=n*a;
	power:=n;
	end;

procedure remplace_pt_decimale_pt_window(apc:pchar);  {1.00 -> 1,00}
	var pc:pchar;
	begin
	if sDecimal[0]='.' then exit;
	pc:=strpos(apc,'.');
	if pc<>nil then
		pc^:=sDecimal[0];
	end;

procedure remplace_pt_window_pt_decimal(apc:pchar); {1,00 -> 1.00}
	var pc:pchar;
	begin
	if sDecimal[0]='.' then exit;
  repeat
	  pc:=strpos(apc,sDecimal);
	  if pc<>nil then pc^:='.';
    pc:=strpos(apc,sDecimal);
  until pc=nil;
	end;

procedure remplace_pt_window_pt_decimal(var str:string);
  var apc:pc1024; {Must be enought}
  begin
  strpcopy(apc,str);
  remplace_pt_window_pt_decimal(apc);
  str:=strpas(apc);
  end;

procedure pchar_to_real(apc:pchar; var areal:real);
	var astring:string;
   	 code:integer;
	begin
	remplace_pt_window_pt_decimal(apc);
	astring:=strpas(apc);
	system.val(astring,areal,code);
	if code<>0 then
   	areal:=0.0;
	end;

function Hexvalue(hex:string):longint;
	var i:integer;
		 val:longint;
		 c:char;
	begin
	val:=0;
	for i:=length(hex) downto 1 do
		begin
		c:=upcase(hex[i]);
		case c of
			'0'..'9': val := round( val + ( ord(c) - ord('0') ) * power(16,length(hex)-i));
			'A'..'F': val := round( val + ( ord(c) - ord('A') + 10 ) * power(16,length(hex)-i));
			end;
		end;
	HexValue := val;
	end;

{==============================================================================}

function TO_COL.at(index:integer):pointer;
  begin
  try
    if (index<count) and (index>=0) then
      at:=Self.items[index]
    else
      at:=nil;
  except
    on EAccessViolation do
      begin
      at:=nil;
      end;
    end;
  end;

procedure TO_COL.insert(AObject: TObject);
  begin
  self.add(AObject);
  end;

procedure TO_COL.Freeall;
  var i:integer;
      un:node;
  begin
  for i:=pred(Count) downto 0 do
    begin
    un:=node(Items[i]);
    if un<>nil then
      remove(un);
    end;
	self.Clear;
  end;

{==============================================================================}

constructor	node.Create;
  begin
  end;

constructor T_color_name.Create(un_nom_couleur:pchar; une_numeric_couleur:tcolorref);
	begin
	inherited Create;
	strcopy(Self.name,un_nom_couleur);
	self.color:=une_numeric_couleur;
	end; {T_color_name.Create}

function T_Col_Named.Lecture_fichier_couleur:boolean;
	var pc_file_name:pc255;
		 pc_input:pc100;
		 num_buf:pc20;
		 F{,G}:Text;
		 P,Q,R:pchar;
		 un_color_name:T_color_name;
		 index:integer;
		 un_composant_de_couleur:real;
		 Couleur_courant:array[0..3] of real;
		 str,strR,strV,strB:string;
	begin
	Lecture_fichier_couleur:=FALSE;
	strcat(get_exe_path(pc_file_name),'ansicoul.txt'); {colors.inc}
	if file_existe(pc_file_name) then
		begin
		System.Assign(F, pc_file_name);
		{FileMode := 0;  {Set file access to read only}
		Reset(F);
		{Assign(G,'c:\list\fcouleur.pov');
		ReWrite(G);}
		While Not(EOF(F)) do
			begin
			readln(F,pc_input);
			P:=Strpos(pc_input,kpc_diese);
			if p<>nil then
				begin
				q:=p;
				dec(q);
				q^:=#0;
				inc(p);
				str:=strpas(p);
				strR:=str[1]+str[2];
				strV:=str[3]+str[4];
				strB:=str[5]+str[6];
        un_color_name:=T_color_name.Create(
          pc_input,RGB(Hexvalue(strR),Hexvalue(strV),Hexvalue(strB)));
				insert(un_color_name);
				{export des couleurs aux persistence-of-vision
				writeln(G,'#declare ',utile.dtrim_tab(strpas(pc_input)),chr(9)+chr(9)+chr(9),'= rgb <',
					wutil.Hexvalue(strR)/255:2:4,',',wutil.Hexvalue(strV)/255:2:4,',',wutil.Hexvalue(strB)/255:2:4,'>;');}
				end
			else
			 begin
			 P:=Strpos(pc_input,kpc_equal);
			 if P<>nil then
				begin
				Q:=P;
				dec(P);
				inc(Q);
				P^:=#0;
				R:=@num_buf;
				index:=0;
				while (Q^<>chr(0)) do
					begin
					inc(Q);
					if Q^ in ['0'..'9','.'] then
						begin
						R^:=Q^;
						inc(R);
						end
					else if R<>@num_buf then
						begin
						R^:=#0;
						pchar_to_real(num_buf,un_composant_de_couleur);
						if index<3 then
							Couleur_courant[index]:=un_composant_de_couleur;
						inc(index);
						R:=@num_buf;
						end;
					end; {while}
        un_color_name:=T_color_name.Create(pc_input,
          RGB(
						round(Couleur_courant[0]*255),
						round(Couleur_courant[1]*255),
						round(Couleur_courant[2]*255)));
				insert(un_color_name);
				end;
			end;
		 end;
		{Close(G);}
		Close(F);
		Lecture_fichier_couleur:=TRUE;
		end;
	end; {T_Col_Named.Extrated_Lecture_fichier_couleur}

procedure T_Col_Named.recheche_couleur_plus_proche(find_this_color:TColorRef; var result_named_color:T_color_name);
	var i:integer;
      distance_maxi:longint;
      une_couleur:lec_color.T_color_name;

	{Parcours l'intégralité du tableau, trouve la couleur la plus proche (c) dB}
	procedure first_name_color(named_color:T_color_name);
			var distance_local:longint;
			begin
      {la différence des composants (rouge vert bleu)}
			distance_local:=(abs(GetRvalue(find_this_color)-GetRvalue(named_color.color)))
								+(abs(GetGvalue(find_this_color)-GetGvalue(named_color.color)))
								+(abs(GetBvalue(find_this_color)-GetBvalue(named_color.color)));
      {et telle la plus proche ?}
			if distance_local<distance_maxi then
				begin
				distance_maxi:=distance_local;
        {On prend cette couleur}
				result_named_color:=named_color;
				end;
			end; {first_name_color}

	begin {recheche_couleur_plus_proche}
  {Un nombre très grand}
	distance_maxi:=$ffffff;
  {Je n'est pas trouvé de couleur}
	result_named_color:=nil;
  {Je parcours la collection}
  for i:=0 to pred(self.Count) do
    begin
    une_couleur:=self.at(i);
    {Est-ce que cette couleur correspond?}
    if une_couleur<>nil then
      first_name_color(une_couleur);
    end; {for i}
	end;  {T_Col_Named.recheche_couleur_plus_proche}

procedure init_internationnale;
	var apc: pc100;
	begin
	GetProfileString('intl', 'sDecimal', '.', apc, Sizeof(apc));
	strcopy(sDecimal,apc);
	GetProfileString('intl', 'sThousand',' ', apc, Sizeof(apc));
	strcopy(sThousand,apc);
	end; {init_internationnale}

begin
init_internationnale;
end.
