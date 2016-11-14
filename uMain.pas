unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.IniFiles, uMonitorChanger, uKeyHook;

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
    procedure FormDestroy(Sender: TObject);
    procedure OnPressedKeyHookChanged(Sender: TObject);
  private
    TrayIconData: TNotifyIconData;
    FAction: TMonitorChangerAction;
  public
    FKeyHook: TKeyboardHook;
  end;

const
  WM_ICONTRAY = WM_USER + 1;

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

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
  FKeyHook.RemoveHook;
  FKeyHook.Free;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  MonitorChanger := TMonitorChanger.Create(Screen);

  FKeyHook := TKeyboardHook.Create;
  FKeyHook.InstallHook;
  FKeyHook.PressedKeyChanged := OnPressedKeyHookChanged;
{  FAction := MonitorChanger.Logic;
  if FAction <> TMonitorChangerAction.Initialize then
  begin
    PostMessage(Handle, WM_CLOSE, 0, 0);
  end; }
end;

procedure TMainForm.GotItBtnClick(Sender: TObject);
begin

 with TrayIconData do
  begin
    cbSize:= TrayIconData.SizeOf;
    Wnd:= Handle;
    uID:= 0;
    uFlags:= NIF_MESSAGE + NIF_ICON + NIF_TIP;
    uCallbackMessage:= WM_ICONTRAY;
    hIcon:= Application.Icon.Handle;
    szTip:= 'Допустим, название Вашего приложения';
  end;
  Shell_NotifyIcon(NIM_ADD, @TrayIconData);
//  Close;
end;

procedure TMainForm.OnPressedKeyHookChanged(Sender: TObject);
var
  a: Integer;
  i: Integer;
begin
  Caption := '';
  for i := 0 to 255 do
    if KeyCon[i] then
      Caption := Caption + IntToStr(I);

  if (KeyCon[9] and KeyCon[160] and KeyCon[162]) then
    MonitorChanger.Logic;
  //if KeyCon[32] then

//    ShowMessage('1');
end;

end.
