unit uTopScores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TScroreInfo = record
    PlayerName : string[60];
    PlayedTime : integer;
    PlayerRank : integer;
  end;

type
  TScoreFile = File of TScroreInfo;
  TScoreArray = array[0..9] of TScroreInfo;

type
  TfrmTopScores = class(TForm)
    PanelInsertName: TPanel;
    edtPlayerName: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    lbl1: TStaticText;
    Panel2: TPanel;
    lbl2: TStaticText;
    Panel3: TPanel;
    lbl3: TStaticText;
    Panel4: TPanel;
    lbl4: TStaticText;
    Panel5: TPanel;
    lbl5: TStaticText;
    Panel6: TPanel;
    lbl6: TStaticText;
    Panel7: TPanel;
    lbl7: TStaticText;
    Panel8: TPanel;
    lbl8: TStaticText;
    Panel9: TPanel;
    lbl9: TStaticText;
    Panel10: TPanel;
    lbl10: TStaticText;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    const
      ScoreFileName:string = 'score.dat';
    var
      ScoreFilePath: string;
      ScoreArray : TScoreArray;

    function ReadScoreArrayFromDisk : boolean;
    function SaveScoreArrayToDisk : boolean;
    procedure ClearScoreArray;
  public
    { Public declarations }
  end;

var
  frmTopScores: TfrmTopScores;

implementation

{$R *.dfm}

{ TfrmTopScores }


procedure TfrmTopScores.ClearScoreArray;
var
  i : byte;
begin
  for i := 0 to 9 do
    begin
      ScoreArray[i].PlayerName := '';
      ScoreArray[i].PlayedTime := -1;
      ScoreArray[i].PlayerRank := -1;
    end;
end;

function TfrmTopScores.ReadScoreArrayFromDisk: boolean;
var
  f  : TScoreFile;
  si : TScroreInfo;
  i  : integer;
begin
  Result := FileExists(ScoreFilePath);
  if Result then
    try
      AssignFile(f, ScoreFilePath);
      Reset(f);
      i := 0;
      ClearScoreArray();
      while not(Eof(f)) do
        begin
          Read(f, si);
          if (i>=0) and (i<=10) then
            begin
              ScoreArray[i]:= si;
            end;
        end;
    finally
      CloseFile(f);
    end;
end;

function TfrmTopScores.SaveScoreArrayToDisk: boolean;
var
  f  : TScoreFile;
  si : TScroreInfo;
  i  : integer;
begin
  Result := True;
  try
    try
      AssignFile(f, ScoreFilePath);
      Rewrite(f);
    except
      Result:= false;
    end;
  finally
    CloseFile(f);
  end;
end;

procedure TfrmTopScores.FormCreate(Sender: TObject);
begin
  ScoreFilePath := ExtractFilePath(Application.ExeName) + ScoreFileName;
end;


end.
