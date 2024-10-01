unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms,
  Dialogs, Menus, ExtCtrls, ImgList, Graphics, GraphUtil, StdCtrls, Buttons,
  System.ImageList;

const
  CELL_H = 16;
  CELL_W = 16;

type
  TFieldCell = record
    HasBomb: boolean;
    Marked: boolean;
    NearBombs: byte;
    Revealed : boolean;
  end;

type
  TArrayOfPoints = array of TPoint;
  TFieldCellsArray = array of array of TFieldCell;
  TGameState = (gsStoped, gsPlaying, gsGameFinished, gsGameOver);
  TSmileSprite = array[0..3]of TBitmap;

type
  TField = class
  private
    FOffScreen : TBitmap;
    FWidth: integer;
    FCells: TFieldCellsArray;
    FHeight: integer;
    FBombs: integer;
    FImages: TImageList;
    FActualMouseDown, FExplosionAt : TPoint;
    FDiscoveredBombs: integer;
    FFlags: integer;
    FGameTime: integer;
    FGameState : TGameState;
    FSmileSprite: TSmileSprite;
    procedure SetSmileSprite(const Value: TSmileSprite);
    procedure SetGameTime(const Value: integer);
    procedure SetFlags(const Value: integer);
    procedure SetDiscoveredBombs(const Value: integer);
    procedure SetImages(const Value: TImageList);
    procedure SetCells(const Value: TFieldCellsArray);
    procedure SetHeight(const Value: integer);
    procedure SetWidth(const Value: integer);
    procedure MakeRandomMap( Bombs: integer );
    procedure ClearField;
    procedure CalculateNearBombs( X, Y: integer );
    procedure PaintCell( Canvas: TCanvas; X, Y: integer; Rect: TRect );
    procedure DrawBorder(Canvas: TCanvas; Cell: TFieldCell; Rect: TRect);
    procedure DrawBeveledBorder(Canvas: TCanvas; Cell: TFieldCell; Rect: TRect;
                               Inverse: boolean=false);
    procedure RevealAdjacents( X, Y: integer );
    function  AdjacentsOf( X, Y: integer; Cross: boolean=false ) : TArrayOfPoints;
    function  InBounds( p : Tpoint ) : boolean;
  public
    constructor Create( Lines: byte=16; Columns: byte=16; Bombs: integer=40 );
    procedure NewGame( Lines: byte=16; Columns: byte=16; Bombs: integer=40 );
    procedure RevealAllBombs;
    procedure RevealAllCells;
    procedure SaveToFile( const FileName : string );
    procedure PaintTo( Canvas : TCanvas );
    property Width  : integer read FWidth write SetWidth;
    property Height : integer read FHeight write SetHeight;
    property Cells  : TFieldCellsArray read FCells write SetCells;
    property Images : TImageList read FImages write SetImages;
    property DiscoveredBombs : integer read FDiscoveredBombs write SetDiscoveredBombs;
    property Bombs : integer read FBombs;
    property Flags : integer read FFlags write SetFlags;
    property GameTime: integer read FGameTime write SetGameTime;
    property GameState: TGameState read FGameState;
    property SmileSprite : TSmileSprite read FSmileSprite write SetSmileSprite;
  end;


type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    Game1: TMenuItem;
    New1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    PaintBox1: TPaintBox;
    Panel1: TPanel;
    ImgList: TImageList;
    Debug1: TMenuItem;
    SaveToFile1: TMenuItem;
    RevealAll1: TMenuItem;
    RevealBombs1: TMenuItem;
    lblBombs: TStaticText;
    lblTime: TStaticText;
    Timer1: TTimer;
    btnNew: TSpeedButton;
    Difficulty1: TMenuItem;
    Begginer1: TMenuItem;
    Medium1: TMenuItem;
    Hard1: TMenuItem;
    ExtraHard1: TMenuItem;
    Image1: TImage;
    Image2: TImage;
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure ExtraHard1Click(Sender: TObject);
    procedure Hard1Click(Sender: TObject);
    procedure Medium1Click(Sender: TObject);
    procedure Begginer1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure RevealAll1Click(Sender: TObject);
    procedure RevealBombs1Click(Sender: TObject);
    procedure SaveToFile1Click(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure New1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure doDificultyMenuClick(Sender: TObject);
  private
    { Private declarations }
    FFiled : TField;
    function CellAt( X, Y : integer ): TPoint;
    procedure AdjustLabels;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses uAbout;

{$R *.dfm}

{ TField }


function TField.AdjacentsOf(X, Y: integer; Cross: boolean=false): TArrayOfPoints;

  procedure AddToResult( p: TPoint; var Result : TArrayOfPoints);
  begin
    SetLength(Result, Length(Result)+1);
    Result[High(Result)] := p;
  end;

var
  p : TPoint;
begin
(*
  [X-1, Y-1][X, Y-1][X+1, Y-1]
  [X-1, Y  ][X, Y  ][X+1, Y  ]
  [X-1, Y+1][X, Y+1][X+1, Y+1]
*)
  if not(Cross) then
    begin
      p.X := X-1;
      p.Y := Y-1;
      if InBounds(p) then
         AddToResult(p, Result);
    end;


  p.X := X-1;
  p.Y := Y;
  if InBounds(p) then
     AddToResult(p, Result);

  if not(Cross) then
    begin
      p.X := X-1;
      p.Y := Y+1;
      if InBounds(p) then
         AddToResult(p, Result);
    end;

  p.X := X;
  p.Y := Y-1;
  if InBounds(p) then
     AddToResult(p, Result);

  p.X := X;
  p.Y := Y+1;
  if InBounds(p) then
     AddToResult(p, Result);

  if not(Cross) then
    begin
      p.X := X+1;
      p.Y := Y-1;
      if InBounds(p) then
         AddToResult(p, Result);
    end;

  p.X := X+1;
  p.Y := Y;
  if InBounds(p) then
     AddToResult(p, Result);

  if not(Cross) then
    begin
      p.X := X+1;
      p.Y := Y+1;
      if InBounds(p) then
         AddToResult(p, Result);
    end;
end;

procedure TField.CalculateNearBombs(X, Y: integer);

  function HaveBomb( p: TPoint ):boolean;
    begin
      result := ( (p.X>=0) and (p.X<High(FCells)) and
                  (p.Y>=0) and (p.Y<High(FCells)) and
                  (FCells[p.X, p.Y].HasBomb) );
    end;

var
  i : byte;
  adj : TArrayOfPoints;
begin
  FCells[X,Y].NearBombs := 0;
  adj := AdjacentsOf(X,Y);

  for i:=Low(adj) to High(adj) do
    begin
      if HaveBomb(adj[i]) then
         Inc(FCells[X,Y].NearBombs);
    end;

end;

procedure TField.ClearField;
var
  i, j : byte;
begin
  for i := Low(FCells) to High(FCells) do
    for j := Low(FCells) to High(FCells) do
      begin
        FCells[i,j].HasBomb   := false;
        FCells[i,j].Marked    := false;
        FCells[i,j].NearBombs := 0;
        FCells[i,j].Revealed  := false;
      end;
end;

constructor TField.Create(Lines: byte=16; Columns: byte=16; Bombs: integer=40);
begin
  Self.NewGame(Lines, Columns, Bombs);  
end;

procedure TField.DrawBeveledBorder(Canvas: TCanvas; Cell: TFieldCell;
  Rect: TRect; Inverse: boolean=false);
begin
  with Canvas do
    begin
      //Draws the lower right border...
      Pen.Width := 2;
      if (Inverse) then
        Pen.Color := clBtnHighlight
      else
        Pen.Color := clBtnShadow;

      MoveTo(Rect.Left,  Rect.Bottom);
      LineTo(Rect.Right, Rect.Bottom);
      LineTo(Rect.Right, Rect.Top);

      //Draws the upper left border...
      Pen.Width := 1;
      if (Inverse) then
        Pen.Color := clBtnShadow
      else
        Pen.Color := clBtnHighlight;
      MoveTo(Rect.Left, Rect.Bottom-1);
      LineTo(Rect.Left, Rect.Top);
      LineTo(Rect.Right-1,Rect.Top);
    end;
end;

procedure TField.DrawBorder(Canvas: TCanvas; Cell: TFieldCell; Rect: TRect);
begin
  with Canvas do
    begin
      Brush.Color := clBtnFace;
      Pen.Color := clBtnShadow;
      Pen.Width := 1;
      Pen.Style := psSolid;
      MoveTo(Rect.Left, Rect.Top);
      LineTo(Rect.Right, Rect.Top);
      MoveTo(Rect.Left, Rect.Top);
      LineTo(Rect.Left, Rect.Bottom);
   end;
end;

function TField.InBounds(p: Tpoint): boolean;
begin
  result := (
              (p.X>=0) and (p.X<=High(FCells)) and
              (p.Y>=0) and (p.Y<=High(FCells))
            );
end;

procedure TField.MakeRandomMap(Bombs: integer);
var
  i, j : byte;
  t : integer;
begin
  ClearField();
  Randomize();
  //placing the bombs
  t := 0;
  while (t < Bombs) do
    begin
      i := Random(High(FCells));
      j := Random(High(FCells));
      if (not(FCells[i,j].HasBomb)) then
        begin
          FCells[i,j].HasBomb := True;
          t := t+1;
        end;
    end;

  //calculating adjacent bombs to each cell
  for i := Low(FCells) to High(FCells) do
    for j := Low(FCells) to High(FCells) do
        CalculateNearBombs(i, j);
end;

procedure TField.NewGame(Lines: byte=16; Columns: byte=16; Bombs: integer=40);
begin
  if not(Assigned(FOffScreen)) then
     FOffScreen := TBitmap.Create();
  Width := (Lines * CELL_W);
  Height := (Columns * CELL_H);
  FExplosionAt.X := -1;
  FExplosionAt.Y := -1;
  FBombs := Bombs;
  FFlags := FBombs;
  FDiscoveredBombs := 0;
  FGameTime := 0;
  FGameState := gsStoped;

  FOffScreen.Width := Width;
  FOffScreen.Height:= Height;
  FActualMouseDown.X := -10;
  FActualMouseDown.Y := -10;
  SetLength(FCells, Lines, Columns);
  MakeRandomMap(Bombs);
end;

procedure TField.PaintCell(Canvas: TCanvas; X,Y: integer; Rect: TRect);
var
  DrawInverse: boolean;
  Cell : TFieldCell;
begin
  Cell := FCells[X,Y];
  DrawBorder(Canvas, Cell, Rect);
  with Canvas do
    begin
      Font.Name := 'Courrier New';
      Font.Size := 10;
      Font.Style:= [fsBold];
      if (Cell.Marked ) then
        begin
          Images.Draw(Canvas, Rect.Left, Rect.Top, 1);
        end
      else
        if (Cell.Revealed) then
          begin
            if Cell.HasBomb then
              begin
                if (FExplosionAt.X=X) and (FExplosionAt.Y=Y) then
                  begin
                    Canvas.Brush.Color := clRed;
                    Canvas.FillRect(Rect);
                  end;
                  Images.Draw(Canvas, Rect.Left+1, Rect.Top, 0);
                  DrawBorder(Canvas, Cell, Rect);
              end
            else
              if (Cell.NearBombs > 0) then
                begin
                  case Cell.NearBombs of
                    1 : Font.Color:= clBlue;
                    2 : Font.Color:= clGreen;
                    3 : Font.Color:= clRed;
                    4 : Font.Color:= clNavy;
                    5 : Font.Color:= clNavy;
                    6 : Font.Color:= clNavy;
                    7 : Font.Color:= clNavy;
                    8 : Font.Color:= clNavy;
                  end;
                  TextOut(Rect.Left+5, Rect.Top, IntToStr(Cell.NearBombs));
                  DrawBorder(Canvas, Cell, Rect);
                end;
        end
      else
        begin
          DrawInverse := ((FActualMouseDown.X=X) and (FActualMouseDown.Y=Y));
          DrawBeveledBorder(Canvas, Cell, Rect, DrawInverse);
        end;
    end;
end;

procedure TField.PaintTo(Canvas: TCanvas);
var
  r, r1 : TRect;
  i, j : byte;
begin
  r1 := Rect( 0, 0, FWidth, FHeight );
  with FOffScreen.Canvas do
    begin
      Brush.Color := clBtnFace;
      Pen.Color := clBtnShadow;
      Pen.Width := 1;
      Rectangle( r1 );
    end;

  for i := Low(FCells) to High(FCells) do
    for j := Low(FCells) to High(FCells) do
      begin
        r.Left   := i*CELL_W;
        r.Right  := r.Left + CELL_W;
        r.Top    := j*CELL_H;
        r.Bottom := r.Top + CELL_H;
        PaintCell(FOffScreen.Canvas, i, j, r);
      end;
  Canvas.CopyRect(Canvas.ClipRect, FOffScreen.Canvas, FOffScreen.Canvas.ClipRect);
end;

procedure TField.RevealAdjacents(X, Y: integer);

   function FreeAdjCells( p: TPoint ): TArrayOfPoints;
   var
     i,j : integer;
     adj : TArrayOfPoints;
     tmp : TArrayOfPoints;
   begin
     adj := AdjacentsOf(p.X, p.Y);
     for i:= Low(adj) to High(adj) do
       begin
         if ( (InBounds(adj[i])) and
              (FCells[adj[i].X, adj[i].Y].Revealed=false) and
              (FCells[adj[i].X, adj[i].Y].NearBombs<=0) )then
            begin
              FCells[adj[i].X, adj[i].Y].Revealed := True;
              SetLength(result, Length(Result)+1);
              result[High(Result)] := adj[i];
              tmp := FreeAdjCells(adj[i]);
              for j:= Low(tmp) to High(tmp) do
                begin
                  SetLength(result, Length(Result)+1);
                  result[High(Result)] := tmp[j];
                end;
            end;
       end;                       
   end;

var
  i, j: integer;
  p: TPoint;
  l, t: TArrayOfPoints;
begin
{
  1. Descobrir a lista de células livres adjacentes
  2. Abrir, para cada célula da lista, todos os seus adjacentes não livres
}
  p.X := X;
  p.Y := Y;
  l := FreeAdjCells(p);

  if (Length(l)=0) then
    begin
      t := AdjacentsOf(p.X, p.Y);
      for i:= Low(t) to High(t) do
        FCells[t[i].X, t[i].Y].Revealed := True;
    end
  else
    for i:= Low(l) to High(l) do
      begin
        t := AdjacentsOf(l[i].X, l[i].Y);
        for j:= Low(t) to High(t) do
          begin
            if (InBounds(t[j]))  then
               FCells[t[j].X, t[j].Y].Revealed := True;
          end;
      end;

end;

procedure TField.RevealAllBombs;
var
  i, j : Word;
begin
  for i:= Low(FCells) to High(FCells) do
    begin
      for j:= Low(FCells) to High(FCells) do
        begin
          if FCells[i, j].HasBomb then
             FCells[i, j].Revealed := True;
        end;
    end;
end;

procedure TField.RevealAllCells;
var
  i, j : Word;
begin
  for i:= Low(FCells) to High(FCells) do
    for j:= Low(FCells) to High(FCells) do
        FCells[i, j].Revealed := True;
end;

procedure TField.SaveToFile(const FileName: string);
var
  x, y : integer;
  s : string;
  f : TextFile;
begin
  if FileExists(FileName) then
    if MessageDlg(Format('O arquivo %s já existe.'#13#10'Deseja sobrescrevê-lo?', [FileName]),
                 mtConfirmation, [mbYes, mbNo], 0)= mrNo then
       Exit;

  AssignFile(f, FileName);
  Rewrite(f);
  s := '';
  for y := Low(FCells) to High(FCells) do
    begin
      for x := Low(FCells) to High(FCells) do
        begin
          if FCells[x,y].HasBomb then
             s := s + '*'
          else
             if FCells[x,y].NearBombs > 0 then
                s := s + IntToStr(FCells[x,y].NearBombs);
          s := s + ',';
        end;
        Writeln(f, s);
        s := '';
    end;
  CloseFile(f);
end;

procedure TField.SetCells(const Value: TFieldCellsArray);
begin
  FCells := Value;
end;

procedure TField.SetDiscoveredBombs(const Value: integer);
begin
  FDiscoveredBombs := Value;
end;

procedure TField.SetFlags(const Value: integer);
begin
  FFlags := Value;
end;

procedure TField.SetGameTime(const Value: integer);
begin
  FGameTime := Value;
end;

procedure TField.SetHeight(const Value: integer);
begin
  FHeight := Value;
end;

procedure TField.SetImages(const Value: TImageList);
begin
  FImages := Value;
end;

procedure TField.SetSmileSprite(const Value: TSmileSprite);
begin
  FSmileSprite := Value;
end;

procedure TField.SetWidth(const Value: integer);
begin
  FWidth := Value;
end;

procedure TfrmMain.Begginer1Click(Sender: TObject);
begin
   doDificultyMenuClick(Sender);
end;

function TfrmMain.CellAt(X, Y: integer): TPoint;
begin
   Result.X := X div (High(FFiled.Cells)+1);
   Result.Y := Y div (High(FFiled.Cells)+1);
end;

procedure TfrmMain.About1Click(Sender: TObject);
begin
  if not(Assigned(frmAbout)) or (frmAbout=nil) then
    begin
      frmAbout := TfrmAbout.Create(self);
      frmAbout.ShowModal;
    end;  
end;

procedure TfrmMain.AdjustLabels;
begin
  lblBombs.Caption := FormatFloat('000', FFiled.Flags);
  lblTime.Caption  := FormatFloat('000', FFiled.GameTime);
end;

procedure TfrmMain.doDificultyMenuClick(Sender: TObject);
begin
   Begginer1.Checked  := ((Sender as TMenuItem).Name = Begginer1.Name);
   Medium1.Checked    := ((Sender as TMenuItem).Name = Medium1.Name);
   Hard1.Checked      := ((Sender as TMenuItem).Name = Hard1.Name);
   ExtraHard1.Checked := ((Sender as TMenuItem).Name = ExtraHard1.Name);
   New1Click(nil);
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  Close();
end;

procedure TfrmMain.ExtraHard1Click(Sender: TObject);
begin
  doDificultyMenuClick(Sender);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FFiled.Free();
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i: integer;
begin
  FFiled := TField.Create();
  FFiled.Images := ImgList;
  for i := 0 to 3 do
    begin
      FFiled.FSmileSprite[i] := TBitmap.Create();
      ImgList.GetBitmap(
      i+2, FFiled.SmileSprite[i]);
    end;
  New1Click(nil);
end;

procedure TfrmMain.FormPaint(Sender: TObject);
begin
  if Assigned(FFiled) then
     FFiled.PaintTo(PaintBox1.Canvas);
end;

procedure TfrmMain.Hard1Click(Sender: TObject);
begin
  doDificultyMenuClick(Sender);
end;

procedure TfrmMain.Medium1Click(Sender: TObject);
begin
  doDificultyMenuClick(Sender);
end;

procedure TfrmMain.New1Click(Sender: TObject);
var
  bombs: integer;
begin
  Timer1.Enabled := False;
  lblTime.Caption := '000';

  if Begginer1.Checked then
     bombs := 20
  else
    if Medium1.Checked then
      bombs := 30
    else
      if Hard1.Checked then
         bombs := 40
      else
        if ExtraHard1.Checked then
          bombs := 55
        else
          begin
            Medium1.Checked := True;
            New1Click(nil);
          end;

  FFiled.NewGame(16,16, bombs);
  FFiled.PaintTo(PaintBox1.Canvas);
  btnNew.Glyph.Assign(FFiled.SmileSprite[0]);
  AdjustLabels();
end;

procedure TfrmMain.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
  c : TFieldCell;
  r : TRect;

begin
  p := CellAt(X,Y);

  if (FFiled.GameState<>gsGameOver) and (FFiled.GameState<>gsGameFinished)then
    begin
      btnNew.Glyph.Assign(FFiled.SmileSprite[1]);

      case Button of
        mbLeft:
          begin
            FFiled.FActualMouseDown := p;
            c := FFiled.Cells[p.X, p.Y];
            if not(c.Revealed) then
              begin
                r.Left   := p.X * CELL_W;
                r.Right  := r.Left + CELL_W;
                r.Top    := p.Y * CELL_H;
                r.Bottom := r.Top + CELL_W;
                if FFiled.Cells[p.X, p.Y].HasBomb then
                   FFiled.FExplosionAt := p;
                FFiled.DrawBeveledBorder(FFiled.FOffScreen.Canvas, c, r, True);
                FFiled.PaintTo(PaintBox1.Canvas);
              end;
          end;

        mbRight: ;

        mbMiddle: ;

      end;

  end;

end;

procedure TfrmMain.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  p : TPoint;
  c : TFieldCell;
begin
  p := CellAt(X,Y);
  c := FFiled.Cells[p.X, p.Y];

  if GetKeyState(VK_LBUTTON)< 0 then
    begin
      FFiled.FActualMouseDown := p;
      if not(c.Revealed) then
        begin
          FFiled.PaintTo(PaintBox1.Canvas);
        end;
    end;

end;

procedure TfrmMain.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
begin
  p := CellAt(X,Y);
  
  case FFiled.FGameState of
    gsStoped :
       begin
        FFiled.FGameState := gsPlaying;
        Timer1.Enabled := True;
        btnNew.Glyph.Assign(FFiled.SmileSprite[0]);
       end;
    gsPlaying :
      begin
         btnNew.Glyph.Assign(FFiled.SmileSprite[0]);
      end;

    gsGameFinished :
      begin
         btnNew.Glyph.Assign(FFiled.SmileSprite[3]);
         exit;
      end;

    gsGameOver :
      begin
        btnNew.Glyph.Assign(FFiled.SmileSprite[2]);
        exit;
      end;
  end;

  case Button of
    mbLeft:
      begin
        if not(FFiled.Cells[p.X, p.Y].Marked) then
          begin
            FFiled.Cells[p.X, p.Y].Revealed := True;
            if (FFiled.Cells[p.X, p.Y].HasBomb) then
              begin
                 //the player loses
                 Timer1.Enabled := False;
                 FFiled.FGameState := gsGameOver;
                 FFiled.RevealAllBombs;
                 btnNew.Glyph.Assign(FFiled.SmileSprite[2]);
              end
            else
              if(FFiled.Cells[p.X, p.Y].NearBombs <= 0) then
                begin
                   FFiled.RevealAdjacents(p.X, p.Y);
                end;
          end;
      end;

    mbRight:
      begin
        if not(FFiled.Cells[p.X, p.Y].Revealed) then
          begin
           if (FFiled.Cells[p.X, p.Y].Marked) then
             begin
               FFiled.Cells[p.X, p.Y].Marked := false;
               FFiled.Flags := FFiled.Flags+1;
               if FFiled.Cells[p.X, p.Y].HasBomb then
                  FFiled.DiscoveredBombs := FFiled.DiscoveredBombs-1;
             end
           else
             begin
               if (FFiled.Flags>0) then
                 begin
                   FFiled.Cells[p.X, p.Y].Marked := true;
                   FFiled.Flags := FFiled.Flags-1;
                   if FFiled.Cells[p.X, p.Y].HasBomb then
                      FFiled.DiscoveredBombs := FFiled.DiscoveredBombs+1;
                 end;
             end;

           if (FFiled.DiscoveredBombs >= FFiled.Bombs) then
             begin
               FFiled.FGameState := gsGameFinished;
               btnNew.Glyph.Assign(FFiled.SmileSprite[3]);
             end;

          end;
      end;

    mbMiddle:
      begin
      end;
  end;
  FFiled.PaintTo(PaintBox1.Canvas);

  //the user win the game...
  if (FFiled.FDiscoveredBombs =  FFiled.Bombs) then
    begin
       FFiled.FGameState := gsGameFinished;
       Timer1.Enabled := false;
       //ShowMessage('Congratullations!!!'#13#10'You discovered all the bombs.');
       FFiled.RevealAllCells;
    end;

end;

procedure TfrmMain.RevealAll1Click(Sender: TObject);
begin
  FFiled.RevealAllCells;
  FFiled.PaintTo(PaintBox1.Canvas);
end;

procedure TfrmMain.RevealBombs1Click(Sender: TObject);
begin
  FFiled.RevealAllBombs;
  FFiled.PaintTo(PaintBox1.Canvas);
end;

procedure TfrmMain.SaveToFile1Click(Sender: TObject);
begin
  FFiled.SaveToFile(InputBox('', 'Insira o caminho para salvar o arquivo', 'c:\field.csv'));
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  FFiled.GameTime := FFiled.GameTime+1;
  AdjustLabels();
end;

end.
