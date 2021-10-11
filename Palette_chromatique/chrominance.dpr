program chrominance;

//Le programme d'affichage de la palette chromatique
//Elle nécessite 16 écrans de 1000 par 1000 pixels.
//Ecrit par denis bertin le 17.9.2013
//C'est denis bertin qui a définit écrit et réalisé cette unité de dessin.
//Implémenter dans une seule unité le 17.09.2013
//Aujourd'hui mise en forme dans une unité de
//1773 lignes de programmation informatique le 17 septembre 2013.
//Ajout le 28.11.2013 de la gestion propre du message d'Adieux denis B.
//Ont viens encore d'avoir la preuve que c'est une salope.
///Et ce n'est toujours pas toi non plus la juge qui me l'a apris.
//Ce soir une des grandes Sapoles prétend que je l'ai dit après hors
//Mon Curriculum vitéa est précis il me semble écrit par denis Bertin le 28.11.2013.
//1988 lignes écrite par denis Bertin pour passer le programme chrominance en multi-coeur - denis B.


{$R chromin.res}

uses
  Classes,
  Windows,
  Contnrs,
  Messages,
  Graphics,
  sysutils,
  CommDlg,
  lec_color,
  SyncObjs,
  math;

const wm_quatre_couleur_fermer = $401;
      kpc_font_arial = 'arial';
      kpc_pourcent : pchar = '%';

var brush1_actif : tlogbrush=(lbstyle:bs_solid;lbcolor:$00c0c0c0;lbhatch:0);
    Bool_You_should_use_this_color : boolean = false;
    Color_use_this_color : tcolorRef;

var Global_Listwindow:Contnrs.TObjectList;

type pc100 = array[0..100] of char;

const

  pc_Chrominance = 'Chrominance';

  WM_USER_SETUPWINDOW = $401;
  wm_Status_point     = $402;

  RGB_Noir			  = $000000;
	RGB_gris_clair	= $c0c0c0;
	RGB_Gris			  = $808080;
	RGB_Rouge	  	  = $0000ff;
  RGB_Rouge_clair = $8080ff;

	RGB_Vert			  = $00ff00;
  RGB_Vert_foncer = $008000;
  RGB_Vert_clair  = $80ff80;
	RGB_Bleu			  = $ff0000;
	RGB_Jaune		    = $00FFFF;
	RGB_Blanc		    = $ffffff;

	RGB_Bleu_fonce          =$800000;
	RGB_Magenta             =$000080;
	RGB_Cyan                =$ffff00;
	RGB_Jaune_clair			    =$80FFFF;
	RGB_Jaune_tres_clair		=$dfffff;
  RGB_Jaune_foncer        =$2eb6c0;
	RGB_Magenta_clair			  =$000080;
	RGB_Magenta_tres_clair	=$4040b0;
	RGB_Orange					    =$099cfb;
	RGB_Rose						    =$6075f9;
	RGB_Violet              =$FF00FF;
	RGB_Rose_Chair          =$A0A0FF;
  RGB_claque              =$8009FA;
  RGB_Orange_clair			  =$79e5fe;
	RGB_Orange_tres_clair	  =$dcfaff;
	RGB_rose_saumon			    =$C6CFFC;
  RGB_bleu_tres_clair     =$FFBBBB;

  k_nb_color = 21;
  k_hauteur_element = 20;

const Number_of_process_unit = 31; {Denis Bertin frère de Colas auteur du dessin de Zoom}

type Tarray_name_color = record color:tcolorref; name:string; end;

  const
    array_name_color:array[0..k_nb_color] of Tarray_name_color =
    ((color:$000080; name:'Maroon'),
     (color:$008000; name:'Green'),
     (color:$008080; name:'Olive'),
     (color:$800000; name:'Navy'),
     (color:$800080; name:'Purple'),
     (color:$808000; name:'Teal'),
     (color:$808080; name:'Gray'),
     (color:$C0C0C0; name:'Silver'),
     (color:$0000FF; name:'Red'),
     (color:$00FF00; name:'Lime'),
     (color:$00FFFF; name:'Yellow'),
     (color:$FF0000; name:'Blue'),
     (color:$FF00FF; name:'Fuchsia'),
     (color:$FFFF00; name:'Aqua'),
     (color:$C0C0C0; name:'Gray'),
     (color:$808080; name:'DkGray'),
     (color:$FFFFFF; name:'White'),
     (color:$000000;name:'Black'),
     (color:$C0DCC0;name:'MoneyGreen'),
     (color:$F0CAA6;name:'SkyBlue'),
     (color:$F0FBFF;name:'Cream'),
     (color:$A4A0A0;name:'MedGray') );

type

  TWinbase = class(Classes.tcollectionitem)
    public
      hwindow:hwnd;
      parent:TWinbase; {denis}
      childlist:contnrs.TObjectList;
    constructor Create(un_parent:TWinbase); reintroduce;
    procedure  Setupwindow; virtual;
    function   GetItemHandle(DlgItemID: Integer): HWnd; virtual;
    destructor destroy; override;
    function   Getstyle:DWORD; virtual;
    function   Getexstyle:DWORD; virtual;
    function   GetClassName:PChar; virtual;
    procedure  WMSize(var Msg: TMessage); virtual;
    procedure  WMPaint(var Msg: TMessage); virtual;
    procedure  WMMousemove(var Msg: TMessage); virtual;
    procedure  WMLBUTTONDOWN(var Msg: TMessage); virtual;
    procedure  WMMBUTTONDOWN(var Msg: TMessage); virtual;
    procedure  WMRButtonDown(var Msg: TMessage); virtual;
    procedure  WMLBUTTONUP(var Msg: TMessage); virtual;
    procedure  WMRBUTTONUP(var Msg: TMessage); virtual;
    procedure  WMMBUTTONUP(var Msg: TMessage); virtual;
    procedure  WMERASEBKGND(var Msg: TMessage); virtual;
    procedure  Paint(PaintDC: HDC; var PaintInfo: TPaintStruct); virtual;
    procedure  WMUSER_SETUPWINDOW(var Msg: TMessage); virtual;
    procedure  WMStatus_point(var Msg: TMessage); virtual;
    procedure  WMSet_couleur(var Msg: TMessage); virtual;
    end;

  Twindow = class(TWinbase)
  	constructor create(un_parent:TWinbase; un_name:pchar;
			X,Y,W,H:integer;exstyle:boolean); reintroduce;
    procedure Paint(PaintDC: HDC; var PaintInfo: TPaintStruct); override;
    procedure WMMousemove(var msg:TMessage); override;
    procedure WMLButtonDown(var Msg: TMessage); override;
    procedure WMRButtonDown(var Msg: TMessage); override;
    procedure WMSize(var msg:TMessage); override;
    procedure WMStatus_point(var Msg: TMessage); override;
    procedure WMSet_couleur(var Msg: TMessage); override;
    function  Canclose:boolean; virtual;
  end;

  TWindow_Help_ColorPicker = class(Twindow)
    constructor Create(AParent:TWindow);
    function    Getstyle:DWORD; override;
    procedure Paint(PaintDC: HDC; var PaintInfo: TPaintStruct); override;
    end;

  TRectangleColorPicker = class(TWindow)
    constructor Create(AParent:TWindow);
    function    Getstyle:DWORD; override;
    function    Getexstyle:DWORD; override;
    destructor 	Destroy; override;
    procedure 	WMpaint(var msg:tmessage); override;
		procedure 	WMLButtonDown(var Msg: TMessage); override;
		procedure   WMLButtonUp(var Msg: TMessage); override;
		procedure   WMRButtonDown(var Msg: TMessage); override;
		procedure   WMMOUSEMOVE(var msg:tmessage); override;
		procedure   Afficher_quatre_case_varier(a_display_contexte:hdc);
		private
			Bouton_down:boolean;
			col_color:lec_color.T_Col_Named; {pour stocker les noms des couleurs-c'db}
			une_couleur_plus_clair,une_couleur_plus_foncer:tcolorref;
			une_couleur_encore_plus_clair,une_couleur_encore_plus_foncer:tcolorref;
			Rect_encore_plus_foncer,Rect_encore_plus_clair,Rect_plus_clair,Rect_plus_foncer:trect;
			rect_selectionner_le_seuil:trect;
			bool_selectionner_le_seuil:boolean;
			color_du_seuil:tcolorref;
			la_couleur_a_ete_initialiser:boolean;
			quelle_couleur:tcolorref;
			rect_reglage_du_seuil:trect;
			position_du_seuil:integer;
			rect_seuil_a_denis:trect;
      rect_bouton_information:trect;
			byte_effet_seuil_denis:byte;
		end;

  type

    // Objet de gestion des affinités processeur.
    TCPU = Class

    Protected
      FCPUMask  : Array[0..chrominance.Number_of_process_unit] Of Boolean ;    // Mapping physique des processeurs autorisés pour le processus courant.
      FCPUMap   : Array[0..chrominance.Number_of_process_unit] Of Cardinal ;   // Mapping logique des processeurs, contient un masque d'affinité.
      FCPUCount : Cardinal ;                   // Nombre de processeurs utilisables, conditionne la limite supérieure de CPUMap.

      // Accesseur "Count".
      Function GetCPUCount : Cardinal ;

    Public
      // Constructeur
      Constructor Create ;

      // Récupération du nombre de CPU / coeurs du système.
      // Les processeurs sont ensuite numérotés de 0 à (Count-1).
      Property Count : Cardinal Read GetCPUCount ;

      // Force le thread courant à basculer sur le processeur passé en paramètre.
      // Lève une exception en cas d'erreur.
      // Ne lève PAS d'erreur (mais ne fait rien non plus) en cas de numéro de CPU invalide.
      Procedure SwitchTo ( Const CPUIndex : Cardinal ) ;

    End Platform ;

  TSeulement_Wait = class(TThread)
    Constructor Create;
    protected procedure Execute; override;
    end;

  Thread_Chrominance = class(TThread)
    Constructor Create(un_index,a_int_begin,a_int_ending:integer; mon_memory_contexte:hdc);
    protected procedure Execute; override; {Méthode recouverte en Français écrit par denis Bertin}
		Procedure ThreadDone(Sender: TObject);
		Public
      index,commencement,finissement:integer; {Denis Bertin le 20.7.2013}
    private
      memdc:hdc;
    end;

  TFastBitmap2 = object
		public
		Bmp : Graphics.TBitMap;
		W,H,Scan0,MLS,BPP : integer;
		procedure Creer(x,y:integer);
		procedure Copy(iBmp : Graphics.tBitMap);
		procedure Init(iBmp : Graphics.tBitMap);
		procedure Determine;
		procedure Free;
    function  GetPixel_in_limite(X,Y : Integer) : tColor;
    procedure SetPixel_in_limite(x,y :integer; color : TColor);
		function  GetPixel(X,Y : Integer) : tColor;
		procedure SetPixel(x,y :integer; color : TColor);
    procedure RectangleFilling(color : TColor);
    end;


var Window_ColorPicker:TRectangleColorPicker=nil;
var Nombre_de_coeur:integer;
var ThreadsRunning:integer;
var Lock:SyncObjs.TCriticalSection;
var chrominance_mon_image:TFastBitmap2;

(* code C a partir d'une méthode découverte à la bibliothèque de la vilette by denis Bertin en toute honnêté*)
procedure HLS_to_RGB(h,l,s:real; var r,g,b:real);
	var v,m,sv,fract,vsf,mid1,mid2:real;
		 sextant:integer;
	begin
	if h=360 then h:=0 else	h:=h/360;
	if l<=0.5 then
		v:=l*(1.0+s)
	else
		v:=l+s-l*s;
	if v<=0.0 then
		begin
		r:=0.0; g:=0.0; b:=0.0;
		end
	else
		begin
		m:=l+l-v; sv:=(v-m)/v;
		h:=h*6.0;
		sextant:=trunc(h);
		fract:=h-sextant;
		vsf:=v*sv*fract;
		mid1:=m+vsf;
		mid2:=v-vsf;
		case sextant of
			0:begin r:=v;		  g:=mid1;	b:=m		end;
			1:begin r:=mid2;	g:=v;		  b:=m		end;
			2:begin r:=m;		  g:=v;		  b:=mid1	end;
			3:begin r:=m;		  g:=mid2;	b:=v		end;
			4:begin r:=mid1;	g:=m;		  b:=v		end;
			5:begin r:=v;		  g:=m;		  b:=mid2	end;
			end; {case sextant}
      end;
	end; {HLS_to_RGB}


{********************************** TRectangle Help on COLOR PICKER ***********}

constructor TWindow_Help_ColorPicker.Create(AParent:TWindow);
  begin
  inherited Create(AParent,'Utilisation de Chrominance',
    (getsystemmetrics(SM_CXFULLSCREEN)-790) div 2,
    (getsystemmetrics(SM_CXFULLSCREEN)-280) div 2,790,280,false);
  end;

function TWindow_Help_ColorPicker.Getstyle:DWORD;
  begin
  Getstyle:=WS_OVERLAPPEDWINDOW;
  end;

procedure TWindow_Help_ColorPicker.Paint(PaintDC: HDC; var PaintInfo: TPaintStruct);
  const s_mode_operatoire = 'Mode opératoire :';
      s_mode_pour_utiliser = 'Pour utiliser chrominance déplacer la souris sur sa fenêtre.'; {c'db}
      s_mode_alors_vous_allez = 'Alors vous allez voir le nom de la couleur affichée dans la ligne situé en bas à gauche de la fenêtre.'; {c'db}
      s_mode_ainsi_que_le_code_hexadecimal = 'Ainsi que le code hexadécimal affiché dans la ligne située en bas à droite de la fenêtre.'; {c'db}
      s_mode_la_case_a_cocher_Indiquer_un_seuil = 'La case à cocher "Indiquer un seuil" affiche quand elle est sélectionnée une zone inverse délimitée par la valeur du seuil.'; {c'db}
      s_de_mais_pour_cela_vous_aurais_a_priori_indiquer_la_position_de_la_souris_en_cliquant_sur_une_position_du_spectre_des_couleurs = 'Mais pour cela vous aurez à priori indiqué la position de la souris en cliquant sur une position de cette fenêtre.';
      s_mode_pour_affecter_une_valeur_differente_a_ce_seuil = 'Pour affecter une valeur différente à ce seuil cliquer sur le slider positionné en bas de l''écran.'; {c'db}
      s_mode_ou_glisser_et_relacher_la_souris_a_la_position_determiner = 'Ou glisser et relâcher la souris à la position à déterminer, la fenêtre s''actualise automatiquement.'; {c'db}
      s_mode_da_ailleurs_romain_ma_demander = 'D''ailleurs Romain m''a demandé si l''on voit 16 millions de couleurs je lui ai répondu qu''il faudrait 16 écrans de 1000 x 1000 pixels.';
      s_mode_un_petit_utilitaire_ecrit_par_denis_bertin = 'Un utilitaire écrit par denis Bertin';
      s_date_de_d_ecriture = 'Le 02.12.2013';
  var afont:hfont;
      size:tsize;
      arect:trect;
      uncpu:chrominance.TCPU;
      astring:string;
  begin
  getclientrect(self.hwindow,arect);
  rectangle(PaintDC,-1,-1,arect.Right,arect.bottom);
  afont:=selectobject(PaintDC,Createfont(16,0,0,0,0,0,0,0,0,0,0,0,0,'Arial'));
  GetTextExtentPoint(PaintDC,s_date_de_d_ecriture,strlen(s_date_de_d_ecriture),size);
  textout(PaintDC,arect.right-size.cx-2,5,s_date_de_d_ecriture,strlen(s_date_de_d_ecriture));
  textout(PaintDC,10,10,s_mode_operatoire,strlen(s_mode_operatoire));
  textout(PaintDC,24,42,s_mode_pour_utiliser,strlen(s_mode_pour_utiliser));
  textout(PaintDC,24,64,s_mode_alors_vous_allez,strlen(s_mode_alors_vous_allez));
  textout(PaintDC,24,86,s_mode_ainsi_que_le_code_hexadecimal,strlen(s_mode_ainsi_que_le_code_hexadecimal));
  textout(PaintDC,24,108,s_mode_la_case_a_cocher_Indiquer_un_seuil,strlen(s_mode_la_case_a_cocher_Indiquer_un_seuil));
  textout(PaintDC,24,130,s_de_mais_pour_cela_vous_aurais_a_priori_indiquer_la_position_de_la_souris_en_cliquant_sur_une_position_du_spectre_des_couleurs,
    strlen(s_de_mais_pour_cela_vous_aurais_a_priori_indiquer_la_position_de_la_souris_en_cliquant_sur_une_position_du_spectre_des_couleurs));
  textout(PaintDC,24,152,s_mode_pour_affecter_une_valeur_differente_a_ce_seuil,strlen(s_mode_pour_affecter_une_valeur_differente_a_ce_seuil));
  textout(PaintDC,24,174,s_mode_da_ailleurs_romain_ma_demander,strlen(s_mode_da_ailleurs_romain_ma_demander));
  textout(PaintDC,24,196,s_mode_ou_glisser_et_relacher_la_souris_a_la_position_determiner,strlen(s_mode_ou_glisser_et_relacher_la_souris_a_la_position_determiner));
  GetTextExtentPoint(PaintDC,pchar(s_mode_un_petit_utilitaire_ecrit_par_denis_bertin),strlen(pchar(s_mode_un_petit_utilitaire_ecrit_par_denis_bertin)),size);
  settextcolor(PaintDC,rgb_bleu);
  Textout(PaintDC,arect.right-size.cx-20,218,s_mode_un_petit_utilitaire_ecrit_par_denis_bertin,strlen(s_mode_un_petit_utilitaire_ecrit_par_denis_bertin));
  uncpu:=chrominance.TCPU.Create;
  nombre_de_coeur:=uncpu.Count;
  uncpu.Free;
  settextcolor(PaintDC,rgb_rose);
  astring:=inttostr(nombre_de_coeur);
  if nombre_de_coeur=1 then
    astring:=astring+' cœur de calcul'
  else
    astring:=astring+' cœurs de calculs';
  textout(PaintDC,2,arect.Bottom-20,pchar(astring),length(astring));
  deleteobject(selectobject(PaintDC,afont));
  end;


{********************************** TRectangle COLOR PICKER *******************}

procedure inttopchar(i:longint;apchar:pchar);
  var s:string;
  begin
  s:=inttostr(i);
	StrPCopy(apchar,S);
	end;

constructor TRectangleColorPicker.Create(AParent:TWindow);
  begin
  inherited Create(AParent,'Choisir une couleur',cw_usedefault,cw_usedefault,cw_usedefault,cw_usedefault,false);
  Self.Bouton_down:=False;
  Self.col_color:=lec_color.T_Col_Named.Create;
  if not self.col_color.Lecture_fichier_couleur then
    Self.col_color:=nil;
  SetRect(Self.Rect_encore_plus_foncer,-1,-1,-1,-1);
  SetRect(Self.Rect_encore_plus_clair,-1,-1,-1,-1);
  SetRect(Self.Rect_plus_clair,-1,-1,-1,-1);
  SetRect(Self.Rect_plus_foncer,-1,-1,-1,-1);
  self.bool_selectionner_le_seuil:=false;
  self.color_du_seuil:=maxint; {indéterminer}
  self.la_couleur_a_ete_initialiser:=false;
  self.position_du_seuil:=50;
  self.byte_effet_seuil_denis:=0;
  end;

destructor TRectangleColorPicker.Destroy;
	begin
	if Self.col_color<>nil then
		begin
		Self.col_color.Free;
		Self.col_color:=nil;
		end;
	inherited Destroy;
	end;

function TRectangleColorPicker.Getstyle:DWORD;
  begin
  result:=WS_OVERLAPPED or WS_BORDER
    or WS_SYSMENU or WS_SIZEBOX
    or WS_MAXIMIZE or WS_MAXIMIZEBOX
    or WS_MINIMIZEBOX;
  end;

function TRectangleColorPicker.getexstyle:DWORD;
  begin
  getexstyle:=WS_EX_PALETTEWINDOW;
  end; {TOutilWindow.getexstyle}

function rmax(a,b:real):real;
	begin
	if a>b then rmax:=a else rmax:=b;
	end;

function rmin(a,b:real):real;
	begin
	if a<b then rmin:=a else rmin:=b;
	end;

{r:0..1, g:0..1, b:0..1   ->  h:0..360, l:0..1, s:0..1}
procedure RGB_to_HLS(r,g,b:real; var h,l,s:real);
	var v,m,vm,r2,g2,b2:real;
	begin
	v:=rmax(rmax(r,g),b);
	m:=rmin(rmin(r,g),b);

	l:=(m+v) / 2.0; h:=0; s:=0;
	if l<=0 then
		begin
		l:=0;	
      exit;
		end;

   vm:=v-m;	s:=vm;
	if s>0.0 then
		begin
		if l<0.5 then
			s:=s/(v+m)
		else
			s:=s/(2.0-v-m);
		end
	else
		exit;
	r2:=(v-r)/vm;	g2:=(v-g)/vm;	b2:=(v-b)/vm;
	if r=v then
		begin
		if g=m then
			h:=5.0+b2
		else
      	h:=1.0-g2
		end
	else if g=v then
		begin
		if b=m then
			h:=1.0+r2
		else
      	h:=3.0-b2
		end
	else
		begin
		if r=m then
			h:=3.0+g2
		else
      	h:=5.0-r2
		end;

	h:=round(h*60) mod 360;
	{h:=h/6;
	h:=h*360;}
	end; {RGB_to_HLS}

procedure hls_to_tcolorref(h,l,s:real; var acolor:tcolorref);
	var r,g,b:real;
	begin
	if h>360 then h:=h-360;
	HLS_to_RGB(h,l,s,r,g,b);
	acolor:=RGB(round(R*255),round(G*255),round(B*255));
	end; {ihls_to_tcolorref}

procedure tcolorref_to_hls(acolor:tcolorref; var h,l,s:real);
	begin
	RGB_to_HLS(
		1.0*getrvalue(acolor)/255,
		1.0*getgvalue(acolor)/255,
		1.0*getbvalue(acolor)/255, h,l,s);
   end;

{Fonctionne sur une variation de 20 pixels - copyright Denis Bertin}
procedure Soft_rectangle(paintdc:hdc; x,y,xx,yy:integer; couleur:tcolorref);
	var i,max:integer;
      apencil:hpen;
      h,l,s:real;
      une_autre_couleur:tcolorref;

  procedure MoveTo(DC: HDC; X, Y: Integer);
    var apt:tpoint;
        pt:PPoint;
    begin
    pt:=@apt;
    Windows.MoveToEx(DC,X,Y,pt);
    end;

  begin
  {pour conserver sa teinte et changer sa luminosité}
  tcolorref_to_hls(couleur,h,l,s);
  max:=(yy+y) div 2;
  for i:=y to max do
    begin
    hls_to_tcolorref(h,1.0-math.max(0,(i-y)/(yy-y)),s,une_autre_couleur);
    apencil:=Selectobject(Paintdc,CreatePen(PS_SOLID,1,une_autre_couleur));
    moveto(paintdc,x,i);
    lineto(paintdc,xx,i);
    DeleteObject(Selectobject(Paintdc,apencil));
    end;
  for i:=max to yy do
    begin
    apencil:=Selectobject(Paintdc,CreatePen(PS_SOLID,1,couleur));
    moveto(paintdc,x,i);
    lineto(paintdc,xx,i);
    DeleteObject(Selectobject(Paintdc,apencil));
    end;
  end; {Soft_rectangle}

{Je me suis demandé comment Néochrome (1986) afficher sa palette vérifions-le}
{Mon intuition me dit de faire varier la teinte sur x, et la saturation ansi que la lumière sur y}

Procedure Fonction_de_dessin_de_ces_indices(memdc:hdc; arect:trect; i,j:integer);
  var une_couleur:tcolorref;
      ok_couleur:boolean;
      h1,l1,s1,h2,l2,s2:real;
      difference:integer;
  begin
  if true then
		begin
		hls_to_tcolorref(i*360/arect.Right,j*1.0/arect.Bottom,1.0,une_couleur);
		ok_couleur:=true;
		if chrominance.Window_ColorPicker.bool_selectionner_le_seuil then
			if Window_ColorPicker.color_du_seuil<>maxint then
				begin
				if Window_ColorPicker.byte_effet_seuil_denis=1 then
					begin
					tcolorref_to_hls(une_couleur,h1,l1,s1);
					tcolorref_to_hls(Window_ColorPicker.color_du_seuil,h2,l2,s2);
					if (abs(h1-h2)*abs(l1-l2))<Window_ColorPicker.position_du_seuil then
						begin
						ok_couleur:=false;
            chrominance.chrominance_mon_image.SetPixel_in_limite(i,j,une_couleur xor $ffffff);
						end;
					end
				else if Window_ColorPicker.byte_effet_seuil_denis=2 then
					begin
					tcolorref_to_hls(une_couleur,h1,l1,s1);
					tcolorref_to_hls(Window_ColorPicker.color_du_seuil,h2,l2,s2);
					if (abs((h1-h2))<Window_ColorPicker.position_du_seuil) and (abs((l1-l2))<0.12) then
						begin
						ok_couleur:=false;
            chrominance.chrominance_mon_image.SetPixel_in_limite(i,j,une_couleur xor $ffffff);
						end;
					end
				else
					begin
					difference:=
						(math.max (getrvalue(une_couleur),getrvalue(Window_ColorPicker.color_du_seuil)) - math.min (getrvalue(une_couleur),getrvalue(Window_ColorPicker.color_du_seuil)))
					+ (math.max (getgvalue(une_couleur),getgvalue(Window_ColorPicker.color_du_seuil)) - math.min (getgvalue(une_couleur),getgvalue(Window_ColorPicker.color_du_seuil)))
					+ (math.max (getbvalue(une_couleur),getbvalue(Window_ColorPicker.color_du_seuil)) - math.min (getbvalue(une_couleur),getbvalue(Window_ColorPicker.color_du_seuil)));
					if difference<Window_ColorPicker.position_du_seuil then
						begin
						ok_couleur:=false;
            chrominance.chrominance_mon_image.SetPixel_in_limite(i,j,une_couleur xor $ffffff);
						end;
					end
				end;
		if ok_couleur then
      chrominance.chrominance_mon_image.SetPixel_in_limite(i,j,une_couleur);
		end;
  end; {Fonction_de_dessin_de_ces_indices}
  
Constructor TSeulement_Wait.Create;
  begin
  inherited Create(False);
  self.Priority:=tpLowest;
  end;

procedure TSeulement_Wait.Execute;
  var lb_encore:boolean;
  begin
  lb_encore:=True;
	while lb_encore do
		begin
		chrominance.Lock.Enter;
		lb_encore:=chrominance.ThreadsRunning<>0;
		chrominance.Lock.Leave;
    end; {While encore}
  end; {écrit par denis Bertin}

Constructor Thread_Chrominance.Create(un_index,a_int_begin,a_int_ending:integer; mon_memory_contexte:hdc);
  begin
  inherited Create(false); {denis B}
  self.FreeOnTerminate:=True;
  self.index:=un_index; {denis B}
  self.commencement:=a_int_begin; {denis B}
  self.finissement:=a_int_ending; {denis B}
  self.memdc:=mon_memory_contexte; {denis B}
  end;

Procedure Thread_Chrominance.Execute;
  var i,j:integer;
      arect:trect;
  begin
  if true then
    begin
    getclientrect(chrominance.Window_ColorPicker.hwindow,arect);
    for i:=0 to pred(arect.Right) do
      begin
      for j:=0 to pred(arect.Bottom) do
        begin
        chrominance.Fonction_de_dessin_de_ces_indices(Self.memdc,arect,i,j);
        end;
      end;
    end;
  end; {Thread_Chrominance.Execute}

Procedure Thread_Chrominance.ThreadDone(Sender: TObject);
  begin
  chrominance.Lock.Enter;
  Dec(chrominance.ThreadsRunning);
  chrominance.Lock.Leave;
  end;

procedure TRectangleColorPicker.WMpaint(var msg:tmessage);
  const string_indiquer_un_seuil = 'Indiquer un seuil';
  var i,j:integer;
			arect:trect;
			paintdc,memdc,another_dc:hdc;
			PaintStruct:TPaintStruct;
			une_couleur:TColorRef;
			afont,another_font:hfont;
			abitmap:hbitmap;
			ok_couleur:boolean;
			apc_posit_seuil:pc100;
      uncpu:chrominance.TCPU;
      ithread,maximum,modulo:integer;
      posit_one,posit_two:integer;
      un_thread_wait:chrominance.TSeulement_Wait;
      une_image:Graphics.tBitMap;
      un_handle:hbitmap;
	begin
  if chrominance.Window_ColorPicker=nil then exit;
	paintdc:=windows.beginpaint(self.hwindow,PaintStruct);
	getclientrect(hwindow,arect);
	memdc:=CreateCompatibledc(paintdc);
  with arect do
    un_handle:=Createcompatiblebitmap(paintdc,right,bottom);
  abitmap:=SelectObject(memdc,un_handle);
	rectangle(memdc,-2,-2,arect.right+2,arect.bottom+2);
	dec(arect.Right,20);
	dec(arect.Bottom,12+24);
  uncpu:=chrominance.TCPU.create;
  nombre_de_coeur:=uncpu.Count;
  uncpu.Free;
  une_image:=Graphics.tBitMap.create; {denis B}
  une_image.Handle:=un_handle;
  chrominance.chrominance_mon_image.Copy(une_image);
  if (nombre_de_coeur=1) then
    Begin //Ecrit par Bertin
    for i:=0 to pred(arect.Right) do
      begin
      for j:=0 to pred(arect.Bottom) do
        begin
        chrominance.Fonction_de_dessin_de_ces_indices(memdc,arect,i,j);
        end;
      end;
    end
  else
    begin
    chrominance.Lock:=SyncObjs.TCriticalSection.Create;
    chrominance.ThreadsRunning:=chrominance.Nombre_de_coeur;
    //Pour synchroniser nos threads ce cycle d'attente vérifie la terminaison de ces cycles.
    un_thread_wait:=chrominance.TSeulement_Wait.Create;
    maximum:=pred(arect.Right);
    modulo:=maximum div nombre_de_coeur;
    for ithread:=1 to nombre_de_coeur do
      begin
			posit_one:=modulo*pred(ithread);
			posit_two:=pred(modulo*ithread);
			{Ajouter le relicat avec le reste de la division entière c'est denis Bertin}
			if ithread=nombre_de_coeur then
        posit_two:=maximum;
      with Thread_Chrominance.create(
        pred(ithread),posit_one,posit_two,memdc) do
          OnTerminate := ThreadDone;
      end; ///écrit par denis Bertin le 29.11.2013
    //Attendre la remise à zéro du nombre de thread RAZ-Reset.
    un_thread_wait.waitfor;
    un_thread_wait.Free;
    chrominance.Lock.Free;
    end;
  another_dc:=CreateCompatibledc(paintdc);
  selectObject(another_dc,une_image.Handle);
  bitblt(memdc,0,0,une_image.width-1,une_image.height-40,another_dc,0,0,SRCCOPY);
  if false then
    une_image.SaveToFile('c:\_\image_spectrometrique.bmp');
  DeleteDC(another_dc);
  une_image.Free;
	inc(arect.Right,20);
	inc(arect.Bottom,12+24);
	rectangle(memdc,0,arect.bottom-14-24,arect.Right,arect.bottom-24);
	rectangle(memdc,arect.Right-20,0,arect.Right,arect.bottom);
	{Indiquer si l'on veux exclure une couleur du seuil}
	getclientrect(hwindow,arect);
	setrect(rect_selectionner_le_seuil,6,arect.bottom-24+6,18,arect.bottom-6);
	with rect_selectionner_le_seuil do
		if self.bool_selectionner_le_seuil then
			if self.color_du_seuil<>maxint then
				Soft_rectangle(memdc,left,top,right,bottom,self.color_du_seuil)
			else
				Soft_rectangle(memdc,left,top,right,bottom,rgb_bleu)
		else
			rectangle(memdc,left,top,right,bottom);
	afont:=SelectObject(memdc,createfont(12,0,0,0, 0,0,0,0,0,0,0,0,0, kpc_font_arial));
	textout(memdc,22,arect.bottom-16,string_indiquer_un_seuil,strlen(string_indiquer_un_seuil));
	Afficher_quatre_case_varier(memdc);
	getclientrect(hwindow,arect);

  getclientrect(hwindow,rect_bouton_information);
  rect_bouton_information.top:=rect_bouton_information.bottom-32;
  rect_bouton_information.bottom:=rect_bouton_information.bottom-0;
  rect_bouton_information.left:=rect_bouton_information.right-20;
  with Rect_bouton_information do
    begin
    rectangle(memdc,left,top,right,bottom); {denis Bertin}
    another_font:=selectobject(memdc,createfont(24,0,0,0,0,0,0,0,0,0,0,0,0,'arial'));
    textout(memdc,left+3,top+3,'?',1);
    deleteobject(selectobject(memdc,another_font));
    end;

	if self.bool_selectionner_le_seuil then
		begin
		setrect(rect_reglage_du_seuil,100,arect.Bottom-18,arect.right-38,arect.Bottom-6);
		with rect_reglage_du_seuil do Soft_rectangle(memdc,left,top+2,right,bottom-2,rgb_bleu);
		with rect_reglage_du_seuil do Soft_rectangle(memdc,left+self.position_du_seuil-5,top,left+self.position_du_seuil+5,bottom,rgb_rouge);
		with arect do setrect(rect_seuil_a_denis,arect.Right-34,arect.bottom-24+6,arect.Right-22,arect.bottom-6);
		with rect_seuil_a_denis do
			if self.byte_effet_seuil_denis=1 then
				Soft_rectangle(memdc,left,top,right,bottom,rgb_vert)
			else if self.byte_effet_seuil_denis=2 then
				Soft_rectangle(memdc,left,top,right,bottom,rgb_cyan)
			else
				rectangle(memdc,left,top,right,bottom);

		if self.byte_effet_seuil_denis<>0 then
			inttopchar(round(self.position_du_seuil),apc_posit_seuil)
		else
			inttopchar(self.position_du_seuil,apc_posit_seuil);
		another_font:=SelectObject(memdc,createfont(8,0,0,0, 0,0,0,0,0,0,0,0,0, kpc_font_arial));
		settextcolor(memdc,RGB_Bleu);
		textout(memdc,100,arect.bottom-8,apc_posit_seuil,strlen(apc_posit_seuil));
		DeleteObject(SelectObject(memdc,another_font));
		end
	else
		begin
		setrect(rect_reglage_du_seuil,-100,-100,-100,-100);
		setrect(rect_seuil_a_denis,-100,-100,-100,-100);
		end;

	with arect do bitblt(paintdc,0,0,right,bottom,memdc,0,0,SRCCOPY);
	DeleteObject(SelectObject(memdc,afont));
	DeleteObject(SelectObject(memdc,abitmap));
	DeleteDC(memdc);
	windows.endpaint(self.hwindow,PaintStruct);
	end; {TRectangleColorPicker.WMpaint}

procedure TRectangleColorPicker.WMLButtonDown(var Msg: TMessage);
	var point_souris:tpoint;
			a_display_contexte:hdc;
			arect:trect;
	begin
	point_souris.x:=Smallint(loword(msg.lparam));
	point_souris.y:=Smallint(hiword(msg.lparam));
  if ptinrect(rect_bouton_information,point_souris) then
    postmessage(self.hwindow,wm_rbuttondown,0,0)
	else if ptinrect(rect_seuil_a_denis,point_souris) then
		begin
		inc(byte_effet_seuil_denis);
		byte_effet_seuil_denis:=byte_effet_seuil_denis mod 3;
		invalidaterect(self.hwindow,nil,false);
		end
	else if ptinrect(rect_reglage_du_seuil,point_souris) then
		begin
		Setcapture(self.hwindow);
		Bouton_down:=true;
		postmessage(self.hwindow,wm_mousemove,msg.wparam,msg.lparam);
		end
	else if ptinrect(rect_selectionner_le_seuil,point_souris) then
		begin
		bool_selectionner_le_seuil:=not bool_selectionner_le_seuil;
		invalidaterect(self.hwindow,nil,false);
		end
	else
		begin
		{Ceci pour colorier avec la couleur sélectionnée}
		InvalidateRect(self.hwindow,nil,false);
		UpdateWindow(self.hwindow);
		a_display_contexte:=getdc(self.hwindow);
		brush1_actif.lbcolor:=GetPixel(a_display_contexte,point_souris.x,point_souris.y);
		releasedc(self.hwindow,a_display_contexte);
		getclientrect(self.hwindow,arect);
		dec(arect.bottom,24+12);
		if bool_selectionner_le_seuil and ptinrect(arect,point_souris) then
			begin
			color_du_seuil:=brush1_actif.lbcolor;
			invalidaterect(self.hwindow,nil,false);
			end;
		setcapture(self.hwindow);
		Bouton_down:=true;
		end;
	self.WMMOUSEMOVE(msg);
	end; {TRectangleColorPicker.WMLButtonDown}

procedure TRectangleColorPicker.WMLButtonUp(var Msg: TMessage);
	begin
	releasecapture;
	Bouton_down:=False;
	end; {TRectangleColorPicker.WMLButtonUp}

procedure TRectangleColorPicker.WMRButtonDown(var Msg: TMessage);
	begin
  TWindow_Help_ColorPicker.create(Self);              
	end; {TRectangleColorPicker.WMRButtonDown}

const hexChars: array [0..$F] of Char='0123456789ABCDEF';

function Hexbyte(b:byte):string;
	begin
	hexbyte:=hexChars[b shr 4]+hexChars[b and $F];
	end;

function HexWord(w: Word):string;
	begin
	hexword:=hexbyte(hi(w))+hexbyte(lo(w));
	end;

function Hexlongint(long: longint):string;
	begin
	Hexlongint:=hexword(long shr 16)+hexword(long and $ffff)
	end;

procedure local_TcolorRef_to_text_html(color:tcolorref;Strbis:pchar; plus_blanc:boolean);
	var str_hex,str_hex_inv:string; PC_hex:pc100;
	begin
	str_hex:=Hexlongint(color);
	str_hex_inv:=str_hex[7]+str_hex[8]+str_hex[5]+str_hex[6]+str_hex[3]+str_hex[4];
	StrPCopy(PC_hex,str_hex_inv);
	strcat(strcopy(strbis,'#'),PC_hex);
	if plus_blanc then
		strcat(strbis,#32);
	end;

procedure DLL_TcolorRef_to_text_html(color:tcolorref;Strbis:pchar; plus_blanc:boolean);
	begin
	local_TcolorRef_to_text_html(color,Strbis,plus_blanc);
	end;

{Pour afficher le nom de la couleur envoyer celle ci à la fenêtre des status}
procedure TRectangleColorPicker.WMMOUSEMOVE(var msg:tmessage);
  var point_souris:tpoint;
      a_display_contexte:hdc;
      arect:trect;
      une_couleur:TColorRef;
      une_couleur_avec_son_nom:lec_color.T_color_name;
      afont:hfont;
      pc_color_html:pc100;
      size:tsize;
      apencil:hpen;
      abrush:hbrush;
      pourcent:real;
      pc_pourcent:pc100;

  procedure Afficher_la_couleur_denomer(avec_une_couleur:tcolorref);
    begin
    if (Self.Col_color<>nil) then
      begin
      Self.Col_color.Recheche_couleur_plus_proche(avec_une_couleur,une_couleur_avec_son_nom);
      if une_couleur_avec_son_nom<>nil then
        begin
        GetClientRect(self.hwindow,arect); dec(arect.Right,19); dec(arect.bottom,24);
        rectangle(a_display_contexte,0,arect.bottom-14,arect.Right,arect.bottom);
        SetBkMode(a_display_contexte,TRANSPARENT);
        afont:=selectobject(a_display_contexte,
          createfont(12,0,0,0, 0,0,0,0,0,0,0,0,0, kpc_font_arial));
        textout(a_display_contexte,14,arect.bottom-12,
          une_couleur_avec_son_nom.name,strlen(une_couleur_avec_son_nom.name));
        DLL_TcolorRef_to_text_html(avec_une_couleur,pc_color_html,true);
        GetTextExtentpoint(a_display_contexte,pc_color_html,strlen(pc_color_html),size);
        textout(a_display_contexte,arect.right-size.cx-6,arect.bottom-12,
          pc_color_html,strlen(pc_color_html));
        {Affichage de la luminosité du pixel en pourcentage}
        {((Red value X 299) + (Green value X 587) + (Blue value X 114)) / 1000}
        Pourcent:=(GetRvalue(avec_une_couleur)/255*299+GetGvalue(avec_une_couleur)/255*587+GetBvalue(avec_une_couleur)/255*114)/1000;
        Inttopchar(round(pourcent*100),pc_pourcent); strcat(pc_pourcent,kpc_pourcent);
        TextOut(a_display_contexte,124,arect.bottom-12,pc_pourcent,strlen(pc_pourcent));
        DeleteObject(selectobject(a_display_contexte,afont));
        {dessin de la pastille}
        apencil:=selectobject(a_display_contexte,Createpen(ps_solid,1,avec_une_couleur));
        abrush:=selectobject(a_display_contexte,Createsolidbrush(avec_une_couleur));
        Ellipse(a_display_contexte,2,arect.bottom-12,12,arect.bottom-2);
        deleteobject(selectobject(a_display_contexte,abrush));
        deleteobject(selectobject(a_display_contexte,apencil));
        end;
      end;
    end;

  begin
  a_display_contexte:=getdc(self.hwindow);
  getclientrect(self.hwindow,arect);
  point_souris.x:=Smallint(loword(msg.lparam));
  point_souris.y:=Smallint(hiword(msg.lparam));
  dec(arect.Bottom,38);
  dec(arect.Right,20+24);
  if ptinrect(arect,point_souris) then
    begin
    une_couleur:=GetPixel(a_display_contexte,point_souris.x,point_souris.y);
    Afficher_la_couleur_denomer(une_couleur);
    if self.Bouton_down then
      begin
      Bool_You_should_use_this_color:=true;
      Color_use_this_color:=GetPixel(a_display_contexte,point_souris.x,point_souris.y);
      Bool_You_should_use_this_color:=False;
      self.la_couleur_a_ete_initialiser:=true;
      self.quelle_couleur:=Color_use_this_color;
      Afficher_quatre_case_varier(a_display_contexte);
      end;
    end
  else
    begin {Sommes nous sur un des rectangles de la progression lumineuse.}
    if ptinrect(Self.Rect_encore_plus_foncer,point_souris) then
      begin
      Afficher_la_couleur_denomer(une_couleur_encore_plus_foncer);
      end
    else if ptinrect(Self.Rect_encore_plus_clair,point_souris) then
      begin
      Afficher_la_couleur_denomer(une_couleur_encore_plus_clair)
      end
    else if ptinrect(Self.Rect_plus_clair,point_souris) then
      begin
      Afficher_la_couleur_denomer(une_couleur_plus_clair);
      end
    else if ptinrect(Self.Rect_plus_foncer,point_souris) then
      begin
      Afficher_la_couleur_denomer(une_couleur_plus_foncer);
      end
		else if ptinrect(rect_reglage_du_seuil,point_souris)
    and Bouton_down then
      begin
      self.position_du_seuil:=(point_souris.x-rect_reglage_du_seuil.left);
      Invalidaterect(self.hwindow,nil,false);
      end;
    end;
  Releasedc(self.hwindow,a_display_contexte);
  end; {TRectangleColorPicker.WMMOUSEMOVE}

procedure TRectangleColorPicker.Afficher_quatre_case_varier(a_display_contexte:hdc);
  var abrush:hbrush;
      apencil:hpen;
      hue,lum,sat:real;
      arect:trect;
  
  Function REAL_min(a,b:real):real;
	  begin
	if a<b then
		REAL_min:=a
	else
		REAL_min:=b
	end;

Function REAL_max(a,b:real):real;
	begin
	if a>b then
		REAL_max:=a
	else
		REAL_max:=b
	end;

  begin
  if not la_couleur_a_ete_initialiser then exit;
  {Si le bouton est appuyé, Afficher une variation de sa luminosité}
  tcolorref_to_hls(quelle_couleur,hue,lum,sat);
  hls_to_tcolorref(hue,REAL_min(1.0,lum+0.5),sat,self.une_couleur_encore_plus_clair);
  hls_to_tcolorref(hue,REAL_min(1.0,lum+0.25),sat,self.une_couleur_plus_clair);
  hls_to_tcolorref(hue,REAL_max(0.0,lum-0.25),sat,self.une_couleur_plus_foncer);
  hls_to_tcolorref(hue,REAL_max(0.0,lum-0.5),sat,self.une_couleur_encore_plus_foncer);
  {Il y a la place pour quatre couleurs variés}

  getclientrect(self.hwindow,arect); dec(arect.Right,20); dec(arect.Bottom,12);
  apencil:=selectobject(a_display_contexte,Createpen(ps_solid,1,rgb_noir));
  abrush:=selectobject(a_display_contexte,Createsolidbrush(self.une_couleur_encore_plus_clair));
  with arect do Setrect(Rect_encore_plus_clair,right+2,top+10,right+18,top+10+16);
  with Rect_encore_plus_clair do RoundRect(a_display_contexte,left,top,right,bottom,4,4);
  deleteobject(selectobject(a_display_contexte,abrush));
  deleteobject(selectobject(a_display_contexte,apencil));

  apencil:=selectobject(a_display_contexte,Createpen(ps_solid,1,rgb_noir));
  abrush:=selectobject(a_display_contexte,Createsolidbrush(self.une_couleur_plus_clair));
  with arect do setrect(Rect_plus_clair,right+2,top+30,right+18,top+30+16);
  with Rect_plus_clair do RoundRect(a_display_contexte,left,top,right,bottom,4,4);
  deleteobject(selectobject(a_display_contexte,abrush));
  deleteobject(selectobject(a_display_contexte,apencil));

  apencil:=selectobject(a_display_contexte,Createpen(ps_solid,1,rgb_noir));
  abrush:=selectobject(a_display_contexte,Createsolidbrush(self.une_couleur_plus_foncer));
  with arect do SetRect(Rect_plus_foncer,right+2,top+50,right+18,top+50+16);
  with Rect_plus_foncer do RoundRect(a_display_contexte,left,top,right,bottom,4,4);
  deleteobject(selectobject(a_display_contexte,abrush));
  deleteobject(selectobject(a_display_contexte,apencil));

  apencil:=selectobject(a_display_contexte,Createpen(ps_solid,1,rgb_noir));
  abrush:=selectobject(a_display_contexte,Createsolidbrush(self.une_couleur_encore_plus_foncer));
  with arect do SetRect(Rect_encore_plus_foncer,right+2,top+70,right+18,top+70+16);
  with Rect_encore_plus_foncer do RoundRect(a_display_contexte,left,top,right,bottom,4,4);
  deleteobject(selectobject(a_display_contexte,abrush));
  deleteobject(selectobject(a_display_contexte,apencil));
  end;

var cache_window:TWinbase=nil;

procedure MoveTo(DC: HDC; X, Y: Integer);
  var apt:tpoint;
      pt:PPoint;
  begin
  pt:=@apt;
  Windows.MoveToEx(DC,X,Y,pt);
  end;

function distance(a,b,x,y:integer): real;
	var da,db: real;
	begin
	da:=longint(a)-longint(x);
	db:=longint(b)-longint(y);
	distance:=sqrt(da*da+db*db);
	end;

function distance_2pt(apt,bpt:tpoint):real;
  begin
	distance_2pt:=distance(apt.x,apt.y,bpt.x,bpt.y);
	end;

procedure MakeDefaultFont(var alogfont:tlogFont; asize:integer);
	begin
	FillChar(ALogFont, SizeOf(TLogFont), #0);
	with ALogFont do
		begin
		lfHeight        := asize; 	{40 dans isaplan } { Taille en unite logique ou metre dans ver2}
		lfWeight        := 400;    {Indicate a Normal attribute Bold=700}
		lfItalic        := 0;      {Non-zero value indicates italic   }
		lfUnderline     := 0;      {Non-zero value indicates underline}
		lfOutPrecision  := Out_Stroke_Precis;
		lfClipPrecision := Clip_Stroke_Precis;
		lfQuality       := Default_Quality;
		lfPitchAndFamily:= Variable_Pitch;
		StrCopy(lfFaceName, 'Arial');
		end; {with}
	end; {MakeDefaultFont}

Function Get_MakeDefaultFont(asize:integer):Hfont;
	var alogfont:tlogFont;
	begin
	MakeDefaultFont(alogfont,asize);
	Get_MakeDefaultFont:=CreateFontIndirect(alogfont);
	end; {Get_MakeDefaultFont}

function Affiche_le_dialogue_des_couleur_window(awindow:windows.hwnd; var result_color:tcolorref):boolean;
  var ChooseColor:CommDlg.TChooseColor;
  var tab_16_color:array[0..15] of TCOLORREF;
  begin
  Fillchar(ChooseColor,sizeof(ChooseColor),#0);
  ChooseColor.lStructSize:=sizeof(ChooseColor);
  ChooseColor.hwndOwner:=awindow;
  ChooseColor.Flags:=CC_FULLOPEN;
  ChooseColor.lpCustColors:=@tab_16_color;
  result:=CommDlg.ChooseColor(ChooseColor);
  result_color:=ChooseColor.rgbResult;
  end;

function FindWindow(Wnd:hwnd):TWinbase;
  var i,n:integer;
      awindow:TWinbase;
      apc:pchar;
  begin
  result:=nil;
  {ajouter la recherche dans le cache ici}
  apc:=pchar(Global_ListWindow);
  if apc<>nil then
    begin
    if (cache_window<>nil) and (cache_window.hwindow=wnd) then
      result:=cache_window
    else
      begin
      n:=pred(Global_ListWindow.Count);
      for i:=0 to n do
        begin
        awindow:=TWinbase(Global_ListWindow.items[i]);
        if awindow.hwindow=Wnd then
          begin
          result:=awindow;
          {ajouter au cache ici}
          cache_window:=awindow;
          exit;
          end;
        end;
      end; {for}
    end;
  end; {FindWindow}


function WndProc_Redib(Wnd : HWND; cmd : UINT; wParam : Integer; lParam: Integer) : Integer; stdcall;
  var awindow:TWinbase;
      ok:boolean;
      msg:Messages.TMessage;
 begin
  result := 0;
  awindow:=FindWindow(Wnd);
  if awindow<>nil then
    begin
    ok:=true;
    msg.msg:=cmd;
    msg.wParam:=wParam;
    msg.lParam:=lParam;
    case cmd of
      WM_CLOSE:
        if Wnd=Window_ColorPicker.hwindow then
          PostQuitMessage(-1)
        else
          closewindow(Wnd);
      WM_SIZE:
        awindow.wmsize(msg);
      WM_PAINT:
        awindow.wmpaint(msg);
      WM_DESTROY:
        begin
        if awindow<>nil then
          awindow.Free;
        end;
      WM_MOUSEMOVE:
        awindow.wmmousemove(msg);
			WM_LBUTTONDOWN:
        awindow.WMLBUTTONDOWN(msg);
			WM_MBUTTONDOWN:
        awindow.WMMBUTTONDOWN(msg);
      WM_RBUTTONDOWN:
        awindow.WMRBUTTONDOWN(msg);
			WM_LBUTTONUP:
        awindow.WMLBUTTONUP(msg);
			WM_RBUTTONUP:
        awindow.WMRBUTTONUP(msg);
      WM_ERASEBKGND:
        awindow.WMERASEBKGND(Msg);
      WM_USER_SETUPWINDOW:
        awindow.Setupwindow;
      WM_Status_point:
        awindow.WMStatus_point(msg);
    else
        begin
        ok:=false;
        result := DefWindowProc(Wnd, cmd, wParam, lParam);
        end;
      end; {case}
    if ok then
      begin
      result:=msg.result;
      end;
    end
  else
    begin
    result := DefWindowProc(Wnd, cmd, wParam, lParam);
		end;
	end; {WndProc_Redib}


type

TCSD = (TCSD_Arrow,TCSD_line,TCSD_rectangle,TCSD_round,TCSD_circle,TCSD_ellipse,TCSD_polygon);

TPalette_des_couleurs = class(Twindow)
  procedure  Setupwindow; override;
  procedure  Paint(PaintDC: HDC; var PaintInfo: TPaintStruct); override;
  function 	GetClassName: PChar; override;
	function 	Getstyle:DWORD; override;
  procedure WMMousemove(var msg:TMessage); override;
  procedure WMLButtonDown(var Msg: TMessage); override;
  procedure WMRButtonDown(var Msg: TMessage); override;
  function  Canclose:boolean; override;
  public
    une_couleur:tcolorref;
    le_cas_pastelle:boolean;
  end;

var

  Window_chrominance : TRectangleColorPicker;

  local_a_cette_unite_canclose : boolean = false; //true;

constructor TWinbase.create(un_parent:TWinbase);
  begin
  self.parent:=un_parent;
  self.hwindow:=0;
  self.childlist:=contnrs.TObjectList.Create;
  end;

destructor TWinbase.Destroy;
  var position:integer;
  begin
  try
    {vider le cache}
    cache_window:=nil;
    if false then Self.childlist.OwnsObjects:=false;
    Self.childlist.Free;
    if self.parent<>nil then
      begin
      position:=self.parent.childlist.IndexOf(self);
      if position<>-1 then
        begin
        self.parent.childlist.OwnsObjects:=false;
        self.parent.childlist.remove(self);
        self.parent.childlist.OwnsObjects:=true;
        end;
      end;
    position:=Global_Listwindow.IndexOf(self);
    if position<>-1 then
      begin
			//if false then
			Global_Listwindow.OwnsObjects:=false;
			Global_Listwindow.remove(self);
			//if false then
			Global_Listwindow.OwnsObjects:=true;
      end;
    inherited destroy;
  except
    end;
  end; {TWinbase.Destroy}

function TWinbase.Getstyle:DWORD;
  begin
  result:=WS_OVERLAPPED;
  end;

function TWinbase.getexstyle:DWORD;
  begin
  getexstyle:=0;
  end; {TWinbase.getexstyle}

function TWinbase.GetClassName:PChar;
  const class_name_unknow:pchar='Premier_Paint';
	begin
	GetClassName:=class_name_unknow;
	end;

procedure TWinbase.wmsize(var msg:TMessage);
  begin
  end;

procedure TWinbase.wmpaint(var msg:TMessage);
  var PaintDC:HDC;
      PaintInfo: TPaintStruct;
  begin
  PaintDC:=BeginPaint(self.hwindow,PaintInfo);
  self.paint(PaintDC,PaintInfo);
  Windows.EndPaint(self.hwindow,PaintInfo);
  end;

procedure TWinbase.WMMousemove(var Msg: TMessage); begin end;
procedure TWinbase.WMLBUTTONDOWN(var Msg: TMessage); begin end;
procedure TWinbase.WMMBUTTONDOWN(var Msg: TMessage); begin end;
procedure TWinbase.WMRButtonDown(var Msg: TMessage); begin end;
procedure TWinbase.WMLBUTTONUP(var Msg: TMessage); begin end;
procedure TWinbase.WMRBUTTONUP(var Msg: TMessage); begin end;
procedure TWinbase.WMMBUTTONUP(var Msg: TMessage); begin end;
procedure TWinbase.WMERASEBKGND(var Msg: TMessage); begin msg.Result:=-1; end;

procedure TWinbase.Paint(PaintDC: HDC; var PaintInfo: TPaintStruct);
  begin
  end;

procedure TWinbase.WMUSER_SETUPWINDOW(var Msg: TMessage);
  begin
  self.Setupwindow;
  end;

procedure TWinbase.WMStatus_point(var Msg: TMessage);
  begin
  end;

procedure TWinbase.WMSet_couleur(var Msg: TMessage);
  begin
  end;

procedure TWinbase.Setupwindow;
  begin
  end;

function TWinbase.GetItemHandle(DlgItemID: Integer): HWnd;
  begin
  GetItemHandle:=GetDlgItem(HWindow, DlgItemID);
  end;

procedure Twindow.Paint(PaintDC: HDC; var PaintInfo: TPaintStruct); begin end;
procedure Twindow.WMMousemove(var msg:TMessage); begin end;
procedure Twindow.WMLButtonDown(var Msg: TMessage); begin end;
procedure Twindow.WMRButtonDown(var Msg: TMessage); begin end;
procedure Twindow.WMSize(var msg:TMessage); begin end;
procedure Twindow.WMStatus_point(var Msg: TMessage); begin end;
procedure Twindow.WMSet_couleur(var Msg: TMessage); begin end;
function  Twindow.Canclose:boolean; begin Canclose:=true; end;

(*****************************************************************************)

function Get_HLS_RGB(h,l,s:real):TColorref;
	var r,g,b:real;
	begin
	while h>360 do h:=h-360;
	HLS_to_RGB(h,l,s,r,g,b);
	Get_HLS_RGB:=RGB(round(R*255),round(G*255),round(B*255));
	end;

(*****************************************************************************)

function TPalette_des_couleurs.Canclose:boolean;
  begin
  result:=local_a_cette_unite_canclose;
  end;

procedure TPalette_des_couleurs.Setupwindow;
  begin
  inherited Setupwindow;
  self.une_couleur:=RGB_BLanc;
  self.le_cas_pastelle:=false;
  end;

procedure TPalette_des_couleurs.Paint(PaintDC: HDC; var PaintInfo: TPaintStruct);
  var i,j:integer;
      arect:trect;
  begin
  getclientrect(self.hwindow,arect);
  for i:=0 to arect.Right do for j:=0 to arect.Bottom do
    begin
    if not le_cas_pastelle then
      setpixel(paintdc,i,j,Get_HLS_RGB(360*i/arect.right,j/arect.bottom,1))
    else
      setpixel(paintdc,i,j,Get_HLS_RGB(360*i/arect.right,j/arect.bottom,0.5));
    end;
  end;

function TPalette_des_couleurs.GetClassName: PChar;
  begin
  result:=pc_Chrominance;
  end;

function TPalette_des_couleurs.Getstyle:DWORD;
  begin
  result:=ws_popupwindow or ws_border;
  end;

procedure TPalette_des_couleurs.WMMousemove(var msg:TMessage);
  begin
  end;

procedure TPalette_des_couleurs.WMLButtonDown(var Msg: TMessage);
  var apoint:tpoint;
      arect:trect;
  begin
  getclientrect(self.hwindow,arect);
  apoint.x:=Smallint(loword(msg.lparam));
	apoint.y:=Smallint(hiword(msg.lparam));
  if not le_cas_pastelle then
    with apoint do une_couleur:=Get_HLS_RGB(360*x/arect.right,y/arect.bottom,1.0)
  else
    with apoint do une_couleur:=Get_HLS_RGB(360*x/arect.right,y/arect.bottom,0.5);
  end;

procedure TPalette_des_couleurs.WMRButtonDown(var Msg: TMessage);
  begin
  le_cas_pastelle:=not le_cas_pastelle;
  invalidaterect(self.hwindow,nil,false);
  end;

{==============================================================================}


{******************************************************************************}

constructor Twindow.Create(
    un_parent:TWinbase; un_name:pchar; X,Y,W,H:integer; exstyle:boolean);
	var local_wndClass : TWndClass;
			parent_hwindow:hwnd;
	begin
	inherited Create(un_parent);

	local_wndClass.style          := CS_HREDRAW or CS_VREDRAW or CS_DBLCLKS;
	local_wndClass.lpfnWndProc    := @WndProc_Redib;
	local_wndClass.cbClsExtra     := 0;
	local_wndClass.cbWndExtra     := 0;
	local_wndClass.hInstance      := hInstance;
	local_wndClass.hIcon          := LoadIcon(hinstance,'MAINICON');
	local_wndClass.hCursor        := LoadCursor(0, IDC_ARROW); {CURSEUR_POINT}
	local_wndClass.hbrBackground  := HBRUSH(GetStockObject(WHITE_BRUSH));
	local_wndClass.lpszMenuName   := nil;
	local_wndClass.lpszClassName  := GetClassName;

	windows.RegisterClass(local_wndClass);

	if un_parent=nil then
		parent_hwindow:=0
	else
		parent_hwindow:=parent.hwindow;

	if not exstyle then
		begin
		self.hwindow := windows.CreateWindow(
			GetClassName,       // window class name
			un_name,            // window caption
			self.getstyle,    // window style
			X, //Integer(CW_USEDEFAULT), // initial x position
			Y, //Integer(CW_USEDEFAULT), // initial y position
			W, //Integer(CW_USEDEFAULT), // initial x size
			H, //Integer(CW_USEDEFAULT), // initial y size
			parent_hwindow,              // parent window handle
			0,                      // window menu handle
			hInstance,              // program instance handle
			self);                   // creation parameters
		end
	else
		begin
		self.hwindow := CreateWindowex(
		self.getexstyle,   // extended window style WS_EX_PALETTEWINDOW
		GetClassName,      // window class name
		un_name,           // window caption
		self.getstyle,     // window style
		X,                 // horizontal position of window
		Y,	               // vertical position of window
		W,	               // window width
		H,                 // window height
		parent_hwindow,    // handle to parent or owner window
		0,	               // handle to menu, or child-window identifier
		hInstance,  	     // handle to application instance
		self);             // pointer to window-creation data
		end;
	{ajouter la fenêtre à la liste pour la gestion des messages}
	Global_Listwindow.Add(self);
  SendMessage(hwindow,WM_USER_SETUPWINDOW,hwindow,0);
  ShowWindow(hwindow, SW_SHOW);
  UpDateWindow(hwindow);
	end;

procedure Full_Screen_Initialisation(parent:Twindow);
  const k_hauteur_status = 40;
        k_largeur_des_outils = 80;
  var arect:trect;
  begin
  local_a_cette_unite_canclose := True;
  Window_ColorPicker:=TRectangleColorPicker.create(nil);
  end; {Full_Screen_Initialisation}


{ Cette classe TCPU importé depuis internet le saviez-vous ?}

constructor TCPU.Create;
begin
     // Initialisation des structures d'affinité processeur.
     FCPUCount:=0;
     FillChar(FCPUMask,SizeOf(FCPUMask),0);
     FillChar(FCPUMap,SizeOf(FCPUMap),0);
     // Calcul direct du nombre de CPU.
     GetCPUCount;
end;

Function TCPU.GetCPUCount : Cardinal ;
Var
   I, ProcessMask, SystemMask : Cardinal ;
Begin
     // Inutile de tout déclencher si on a déjà le nombre de CPU...
     If (FCPUCount=0) Then
        Begin
        // On va récupérer le nombre de CPU.
        FCPUCount:=0 ;
        // On compte les bits d'affinité.
        Win32Check(GetProcessAffinityMask(GetCurrentProcess,ProcessMask,SystemMask));
        // Bon, on a le masque : on va calculer sa taille.
        For I:=0 To pred(Number_of_process_unit) Do
            Begin
            // Explosage du masque binaire vers un tableau de booléens.
            FCPUMask[I]:=(ProcessMask And (1 Shl I))<>0 ;
            // On compte les CPU utilisables, et on crée la map d'assignation.
            // Le contenu de CPUMap, à l'indice donné, est donc le masque d'affinité à utiliser.
            If FCPUMask[I] Then
               Begin
               FCPUMap[FCPUCount]:=(1 Shl I) ;
               Inc(FCPUCount);
               End;
            End;
        End;
     // Le nombre de CPU est correct quel que soit le cas, on renvoie donc le résultat.
     Result:=FCPUCount ;
End;

Procedure TCPU.SwitchTo ( Const CPUIndex : Cardinal ) ;
Begin
     If (CPUIndex<FCPUCount) Then
        If (SetThreadAffinityMask(GetCurrentThread,FCPUMap[CPUIndex])=0) Then
           RaiseLastOSError ;
End ;


{--------------------------- TFastBitmap2 -------------------------------------}       
{Amélioration des fonctions Get/SET BitMap en utilisant le langage d'assemblage}

procedure TFastBitmap2.creer(x,y:integer);
	begin
	Bmp:=Graphics.tBitMap.create;
	Bmp.width:=x;
	Bmp.height:=y;
	Self.determine;
	end;

procedure TFastBitmap2.Copy(iBmp : Graphics.tBitMap);
	begin
	Bmp:=iBmp;
	Self.determine;
	end;

procedure TFastBitmap2.Init(iBmp : Graphics.tBitMap);
	begin
	Bmp:=Graphics.tBitMap.create;
	Bmp.Assign(iBmp);
	Self.determine;
	end;

procedure TFastBitmap2.determine;
	begin
	if Bmp.PixelFormat<>pf24bit then
		Bmp.PixelFormat:=pf24bit;
	Scan0:=Integer(BMP.ScanLine[0]);
  MLS  :=Integer(BMP.ScanLine[1]) - Scan0;
	BPP  := 3; // pour pf24bit
  W:=Bmp.width;
  H:=Bmp.Height;
  end;

procedure TFastBitmap2.free;
  begin
  Bmp.free;
  end;

(*
function tFastBitmap2.GetPixel(X,Y : Integer) : tColor; {Fonctionne}
var      Scan : integer; {$IFOPT O-} pRGB3 : pRGBTriple; {$ENDIF}
begin    Scan:=Scan0 + Y*MLS + X*BPP;
         {$IFOPT O+}
         asm
         mov eax,Scan; //Obtenir l'adresse
         mov ebx,[eax]; //Lire le mot dans EBX
         mov eax,ebx; //Déplacer ce mot dans EAX
         mov ecx,ebx; //Déplacer ce mot dans ECX
         shr eax,$10; //tourner de 16 bits
         and eax,$ff;
         and ebx,$ff00
         or  ebx,eax;
         shl ecx,$10;
         and ecx,$ff0000;
         or  ebx,ecx;
         end; {asm}
         {$ELSE}
         pRGB3 := pRGBTriple(Scan);
         with pRGB3^ do Result:=RGB(rgbtRed,rgbtGreen,rgbtBlue);
         {$ENDIF}
end;
*)

(*
function tFastBitmap2.GetPixel(X,Y : Integer) : tColor; {Fonctionne}
var      Scan : integer; {$IFOPT O-} pRGB3 : pRGBTriple; {$ENDIF}
begin    Scan:=Scan0 + Y*MLS + X*BPP;
         {$IFOPT O+}
         asm
         mov eax,Scan; //Obtenir l'adresse
         mov bx,[eax]; //Lire le mot dans EBX
         mov cl,[eax+2];
         mov al,bl;
         shl eax,$10;
         and ebx,$0000ff00;
         add ebx,eax;
         add ebx,ecx;
         end; {asm}
         {$ELSE}
         pRGB3 := pRGBTriple(Scan);
         with pRGB3^ do Result:=RGB(rgbtRed,rgbtGreen,rgbtBlue);
         {$ENDIF}
end;
*)

(*
function tFastBitmap2.GetPixel(X,Y : Integer) : tColor; {Fonctionne}
var      Scan : integer; {$IFOPT O-} pRGB3 : pRGBTriple; {$ENDIF}
begin    Scan:=Scan0 + Y*MLS + X*BPP;
         {$IFOPT O+}
         asm
            mov eax,Scan;
            mov cl,[eax];
            mov dl,[eax+$01];
            mov al,[eax+$02];
            and eax,$000000ff;
            and edx,$000000ff;
            shl edx,$08;
            or eax,edx;
            xor edx,edx;
            mov dl,cl;
            shl edx,$10;
            or eax,edx;
            mov ebx,eax;
         end; {asm}
         {$ELSE}
         pRGB3 := pRGBTriple(Scan);
         with pRGB3^ do Result:=RGB(rgbtRed,rgbtGreen,rgbtBlue);
         {$ENDIF}
end;
*)

procedure tFastBitmap2.SetPixel_in_limite(x,y :integer; color : TColor);
  begin
  with pRGBTriple(Scan0 + Y*MLS + X*BPP)^ do
    begin
    rgbtRed  :=color and $ff;
    rgbtGreen:=(color shr 8) and $ff;
    rgbtBlue :=(color shr 16) and $ff;
    (*
		rgbtRed  :=GetRValue(color);
		rgbtGreen:=GetGValue(color);
		rgbtBlue :=GetBValue(color);
    *)
		end;
  end;

function tFastBitmap2.GetPixel_in_limite(X,Y : Integer) : tColor;
  begin
  with pRGBTriple(Scan0 + Y*MLS + X*BPP)^ do Result:=RGB(rgbtRed,rgbtGreen,rgbtBlue);
  end;

function tFastBitmap2.GetPixel(X,Y : Integer) : tColor;
	begin
	if (x>=0) and (y>=0) and (x<self.W) and (y<self.H) then
		begin
		with pRGBTriple(Scan0 + Y*MLS + X*BPP)^ do Result:=RGB(rgbtRed,rgbtGreen,rgbtBlue);
		end
	else
		GetPixel:=rgb_blanc;
  end;

procedure tFastBitmap2.SetPixel(x,y :integer; color : TColor);
  {$IFOPT O+}
  var scan:integer;
  {$ENDIF}
  begin
  if (x>=0) and (y>=0) and (x<self.W) and (y<self.H) then
		begin
    if false then
      begin
      {$IFOPT O+}
      Scan:=Scan0 + Y*MLS + X*BPP;
      {$ENDIF}
      if false then
						begin
						{$IFOPT O+}
						asm
						mov ebx,Scan;
						add ebx,2;
						mov eax,color;
						mov [ebx],al;
						dec ebx;
						shr eax,$08;
						mov [ebx],al;
						dec ebx;
						shr eax,$08;
						mov [ebx],al;
						end; {asm}
						{$ELSE}
						{$ENDIF}
					end
      end
		else
			begin
			with pRGBTriple(Scan0 + Y*MLS + X*BPP)^ do
				begin
        rgbtRed  :=color and $ff;
        rgbtGreen:=(color shr 8) and $ff;
        rgbtBlue :=(color shr 16) and $ff;
        (*
				rgbtRed  :=GetRValue(color);
				rgbtGreen:=GetGValue(color);
				rgbtBlue :=GetBValue(color);
        *)
				end;
			end;
		end
  end;

(*
procedure tFastBitmap2.SetPixel(x,y :integer; color : TColor);
var       Scan : integer;
begin
          Scan:=Scan0 + Y*MLS + X*BPP;
            with pRGBTriple(Scan)^ do begin
                 rgbtRed  :=GetRValue(color);
                 rgbtGreen:=GetGValue(color);
                 rgbtBlue :=GetBValue(color);
            end;
end;
*)

procedure tFastBitmap2.RectangleFilling(color : TColor);
var       y,x, ScanY,ScanYX : integer; R,G,B : byte;
begin     R:=GetRValue(color);
          G:=GetGValue(color);
          B:=GetBValue(color);
          for y:=0 to pred(H) do begin
              ScanY:=Scan0 + Y*MLS;
              for x:=0 to pred(W) do begin
                  ScanYX:=ScanY + X*BPP;
                  with pRGBTriple(ScanYX)^ do begin
                       rgbtRed  :=R;
                       rgbtGreen:=G;
                       rgbtBlue :=B;
                  end;
              end;
          end;
end;


var message:tmsg;

begin
Global_ListWindow:=Contnrs.TObjectList.Create;
Full_Screen_Initialisation(nil);
while Getmessage(message,0,0,0) do 
	begin
  translatemessage(message);
	dispatchmessage(message);
  end;
end.


