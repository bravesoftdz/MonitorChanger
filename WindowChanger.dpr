program WindowChanger;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {MainForm},
  uMonitorChanger in 'uMonitorChanger.pas',
  uKeyHook in 'uKeyHook.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
