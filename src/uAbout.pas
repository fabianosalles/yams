unit uAbout;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ShellAPI;

type
  TfrmAbout = class(TForm)
    Panel1: TPanel;
    OKButton: TButton;
    Panel2: TPanel;
    Version: TLabel;
    ProductName: TLabel;
    ProgramIcon: TImage;
    Copyright: TLabel;
    Bevel1: TBevel;
    Memo1: TMemo;
    Label2: TLabel;
    procedure Label1Click(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmAbout := nil;
end;

procedure TfrmAbout.Label1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'mailto:fabianosales@hotmail.com', nil, nil, CmdShow);
end;

procedure TfrmAbout.OKButtonClick(Sender: TObject);
begin
  Close();
end;

end.

