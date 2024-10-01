program YAMS;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  uTopScores in 'uTopScores.pas' {frmTopScores},
  uAbout in 'uAbout.pas' {frmAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'YAMS';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
