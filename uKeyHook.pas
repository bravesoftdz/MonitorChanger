unit uKeyHook;

interface

uses
  Windows, Messages, SysUtils, System.Classes;

type

  TKeyCon = record
    shift, ctrl, alt: boolean;
    key: integer;
  end;

  TKeyboardHook = class
  private
    FPressedKeyChanged: TNotifyEvent;
  public

    procedure InstallHook;
    procedure RemoveHook;
    property PressedKeyChanged: TNotifyEvent read FPressedKeyChanged write FPressedKeyChanged;
    procedure RaisePressedKeyChanged;
  end;



var
  hHook: THandle;
  VKey: integer;
  KeyCon: array [0..255] of boolean;


implementation

uses
  uMain;

{ TKEyboardHook }

function LowLevelKeyboardProc(nCode: Integer; WParam: WPARAM; LParam: LPARAM): LRESULT; stdcall;
  type
  PKbdDllHookStrukt = ^TKbdDllHookStrukt;
  _KBDLLHOOKSTRUCT = record
    vkCode: DWORD;
    scanCode: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: PDWORD;
  end;
  TKbdDllHookStrukt = _KBDLLHOOKSTRUCT;

const
 RPT_WPARAM_DATA = '%s';
 RPT_LPARAM_DATA = '%d';

var
 StrResult: string;
 x: string;
 updown: byte;
begin
  updown:=0;
  StrResult:='';
  Result := 0;
  if nCode=HC_ACTION then
    Result := CallNextHookEx(hHook, nCode, WParam, LParam);

  case WParam of
    WM_KEYDOWN:
    begin
      StrResult:=Format(RPT_WPARAM_DATA, ['']); x:='down';
      upDown:=1;
    end;

    WM_KEYUP:
    begin
      StrResult:=Format(RPT_WPARAM_DATA, ['']); x:='up';
      upDown:=2;
    end;
    WM_SYSKEYDOWN:
    begin
      StrResult:=Format(RPT_WPARAM_DATA, ['']); x:='downsys';
      upDown:=1;
    end;
    WM_SYSKEYUP:
    begin
      StrResult:=Format(RPT_WPARAM_DATA, ['']); x:='upsys';
      upDown:=2;
    end;
  end;

  StrResult:=Format(RPT_LPARAM_DATA, [PKbdDllHookStrukt(LParam)^.vkCode]);

   vKey:=strtoint(strresult);

  case upDown of
    1:  keycon[vKey] := true;
    2:  keycon[vKey] := false;
  end;

   MainForm.FKeyHook.RaisePressedKeyChanged
end;

procedure TKEyboardHook.InstallHook;
const
  WH_KEYBOARD_LL = 13;
begin
  hHook := SetWindowsHookEx(WH_KEYBOARD_LL, LowLevelKeyboardProc, hInstance, 0);
  if hHook=0 then
    RaiseLastOSError;
end;

procedure TKEyboardHook.RaisePressedKeyChanged;
begin
  if Assigned(FPressedKeyChanged) then
    FPressedKeyChanged(Self);
end;

procedure TKEyboardHook.RemoveHook;
begin
  if not UnhookWindowsHookEx(hHook) then
    RaiseLastOSError;
end;

end.




