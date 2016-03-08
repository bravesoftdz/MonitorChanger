unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.IniFiles, uMonitorChanger;

type
  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    DesctiptionMemo: TMemo;
    HowToUse: TMemo;
    GotItBtn: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure GotItBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FAction: TMonitorChangerAction;
  public

  end;

var
  MainForm: TMainForm;
  IniFile: TIniFile;
  MonitorChanger: TMonitorChanger;

implementation

{$R *.dfm}

procedure TMainForm.Button1Click(Sender: TObject);
begin
  MonitorChanger.PlaceForms;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  MonitorChanger := TMonitorChanger.Create(Screen);
  MonitorChanger.ReturnForms;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  MonitorChanger := TMonitorChanger.Create(Screen);
  FAction := MonitorChanger.Logic;
  if FAction <> TMonitorChangerAction.Initialize then
  begin
    PostMessage(Handle, WM_CLOSE, 0, 0);
  end;
end;

procedure TMainForm.GotItBtnClick(Sender: TObject);
begin
  Close;
end;

end.
