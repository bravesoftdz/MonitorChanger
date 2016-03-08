program WindowChanger;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {MainForm},
  uMonitorChanger in 'uMonitorChanger.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
