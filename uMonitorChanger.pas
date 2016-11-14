unit uMonitorChanger;

interface

uses
  Vcl.Forms, System.Generics.Collections, System.JSON,
  System.IniFiles, Winapi.Windows, System.Classes, System.SysUtils;
type

TFormInfo = record
  Name: string;
  Handle: HWND;
  Rect: TRect;
end;

TMonitorChangerAction = (PlaceForms, ReturnForms, Initialize);

TMonitorChanger = class
private
  FScreen: TScreen;
  FFilePath: string;
  FLastAction: TMonitorChangerAction;
  FStartForms: TList<TFormInfo>;
  FMovedForms: TList<TFormInfo>;
  function FormsFromProcess: TArray<TFormInfo>;
  function GetScreenWidth: Integer;
  function FormsToJsonArray(const AName: string; const AForms: TList<TFormInfo>): string;
  function JsonArrayToForms(const AJsonArray: TJSONArray): TList<TFormInfo>;
  function FormByHandle(const AList: TList<TFormInfo>; const AHandle: Integer; out AFormInfo: TFormInfo): Boolean;
  function OnWhichMonitor(const AFormInfo: TFormInfo): Integer;
  function NextMonitor(const AMonitorIndex: Integer): Integer;
  procedure FillListByArray(const AList: TList<TFormInfo>; const AArray: TArray<TFormInfo>);
protected
  property ScreenWidth: Integer read GetScreenWidth;
public
  procedure PlaceForms;
  procedure ReturnForms;
  function Logic: TMonitorChangerAction;
  constructor Create(AScreen: TScreen);
  destructor Destroy; override;
end;

implementation

uses
  Math;

{ TMonitorChanger }

constructor TMonitorChanger.Create(AScreen: TScreen);
begin
  FScreen := AScreen;
  FLastAction := Initialize;
  FStartForms := TList<TFormInfo>.Create;
  FMovedForms := TList<TFormInfo>.Create;
end;

destructor TMonitorChanger.Destroy;
begin
  FStartForms.Free;
  FMovedForms.Free;
end;

function TMonitorChanger.FormsToJsonArray(const AName: string; const AForms: TList<TFormInfo>): string;
var
  i: Integer;
  vS: string;
begin
   vS := '"' + AName + '":[';
   for i := 0 to AForms.Count - 1 do
   begin
     vS := vS + '{';
     vS := vS + '"Handle": "' + Integer.ToString(AForms[i].Handle) + '",';
     vS := vS + '"Name": "' +  StringReplace(AForms[i].Name, '"', '\"', [rfReplaceAll, rfIgnoreCase]) + '",';
     vS := vS + '"Top": ' + IntToStr(AForms[i].Rect.Top) + ',';
     vS := vS + '"Left": ' + IntToStr(AForms[i].Rect.Left) + ',';
     vS := vS + '"Width": ' + IntToStr(AForms[i].Rect.Width) + ',';
     vS := vS + '"Height": ' + IntToStr(AForms[i].Rect.Height);
     vS := vS + '}';
     if i <> AForms.Count - 1  then
       vS := vS + ',';
   end;
   vS := vS + ']';

 (*  Objects with Handle as key

  for i := 0 to FForms.Count - 1 do
   begin
     vS := vS + '"' + Integer.ToString(FForms[i].Handle) + '":{';
     vS := vS + '"Name": "' + FForms[i].Name + '",';
     vS := vS + '"Top": ' + IntToStr(FForms[i].Rect.Top) + ',';
     vS := vS + '"Left": ' + IntToStr(FForms[i].Rect.Left) + ',';
     vS := vS + '"Width": ' + IntToStr(FForms[i].Rect.Width) + ',';
     vS := vS + '"Height": ' + IntToStr(FForms[i].Rect.Height);
     vS := vS + '}';
     if i <> FForms.Count - 1  then
       vS := vS + ',';
   end;
   vS := vS + '}';   *)
   Result := vS;
end;

function TMonitorChanger.GetScreenWidth: Integer;
var
  i, vRes: Integer;
begin
  vRes := 0;
  for i := 0 to FScreen.MonitorCount - 1 do
  begin
    vRes := vRes + FScreen.Monitors[i].Width;
  end;
  Result := vRes;
end;

function TMonitorChanger.JsonArrayToForms(
  const AJsonArray: TJSONArray): TList<TFormInfo>;
var
  vInfo: TFormInfo;
  vItem: TJSONValue;
begin
  Result := TList<TFormInfo>.Create;
  for vItem in AJsonArray do
  begin
    vInfo.Handle := vItem.GetValue<Integer>('Handle');
    vInfo.Name := vItem.GetValue<String>('Name');
    vInfo.Rect.Top := vItem.GetValue<Integer>('Top');
    vInfo.Rect.Left := vItem.GetValue<Integer>('Left');
    vInfo.Rect.Width := vItem.GetValue<Integer>('Width');
    vInfo.Rect.Height := vItem.GetValue<Integer>('Height');
    Result.Add(vInfo);
  end;
end;

function TMonitorChanger.Logic: TMonitorChangerAction;
var
  vAction: string;
begin
  if FLastAction = TMonitorChangerAction.PlaceForms then
  begin
    ReturnForms;
    FLastAction := TMonitorChangerAction.PlaceForms;
    Exit;
  end;

  if (FLastAction = TMonitorChangerAction.ReturnForms) or (FLastAction = TMonitorChangerAction.Initialize) then
  begin
    PlaceForms;
    FLastAction := TMonitorChangerAction.ReturnForms;
  end;
 { FFilePath :=  GetEnvironmentVariable('TEMP') + 'ScreenChanger.txt';
  FIniFile := TIniFile.Create(FFilePath);

  if CreateIniFile then
    Exit(TMonitorChangerAction.Initialize);

  vAction := FIniFile.ReadString('Settings', 'Action', 'Initialize');

  if (vAction = 'Initialize') or (vAction = 'ReturnForms')  then
  begin
    PlaceForms;
    Exit(TMonitorChangerAction.PlaceForms);
  end;

  if (vAction = 'PlaceForms')  then
  begin

    try
      ReturnForms;
    except
//      CreateIniFileHard;
//      Exit(TMonitorChangerAction.Initialize);
    end;

    Exit(TMonitorChangerAction.ReturnForms);
  end;
     }
end;

function TMonitorChanger.NextMonitor(const AMonitorIndex: Integer): Integer;
begin
  if AMonitorIndex < FScreen.MonitorCount - 1 then
    Result := AMonitorIndex + 1
  else
    Result := 0;
end;

function TMonitorChanger.OnWhichMonitor(const AFormInfo: TFormInfo): Integer;
var
  i: Integer;
begin
  for i := 0 to FScreen.MonitorCount - 1 do
  begin
    if (AFormInfo.Rect.Left >= FScreen.Monitors[i].Left) and
       (AFormInfo.Rect.Left <= FScreen.Monitors[i].Left + FScreen.Monitors[i].Width) then
      Exit(i);
  end;
  Result := 0;
end;

procedure TMonitorChanger.PlaceForms;
var
  vItem: TFormInfo;

  vWidth: Integer;
  vS: string;
  vNext, i: Integer;
  vForms: TArray<TFormInfo>;
begin
   vWidth := ScreenWidth;

   vForms := FormsFromProcess;
   FillListByArray(FStartForms, vForms);

   for vItem in FStartForms do
   begin
     vNext := NextMonitor(OnWhichMonitor(vItem));
     SetWindowPos(vItem.Handle, 0, Screen.Monitors[vNext].Left{ - vItem.Rect.Width div 2}, vItem.Rect.Top, vItem.Rect.Width, vItem.Rect.Height,
      SWP_NOZORDER + SWP_NOACTIVATE);
   end;

   vForms := FormsFromProcess;
   FillListByArray(FMovedForms, vForms);
end;

procedure TMonitorChanger.FillListByArray(const AList: TList<TFormInfo>; const AArray: TArray<TFormInfo>);
var
  i: Integer;
begin
  AList.Clear;
   for i := 0 to High(AArray) do
     AList.Add(AArray[i]);
end;

function TMonitorChanger.FormByHandle(const AList: TList<TFormInfo>;
  const AHandle: Integer; out AFormInfo: TFormInfo): Boolean;
var
  i: Integer;
begin
  for i := 0 to AList.Count - 1 do
    if AList[i].Handle = AHandle then
    begin
      AFormInfo := AList[i];
      Exit(True);
    end;

  Result := False;
end;

function TMonitorChanger.FormsFromProcess: TArray<TFormInfo>;
var
  buff: array [0..127] of char;
  vHandle: HWND;
  vFormInfo: TFormInfo;
  vRes: TArray<TFormInfo>;
  vN: Integer;
begin
  vN := 0;
  vHandle := GetWindow(Application.Handle, gw_hwndfirst);
  While vHandle <> 0 do
  begin // Не показываем:
      if (vHandle <> Application.Handle) // Собственное окно
      and  IsWindowVisible(vHandle) // Невидимые окна
      and (GetWindow(vHandle, gw_owner) = 0) // Дочерние окна
      and (GetWindowText(vHandle, buff, SizeOf(buff)) <> 0) then
    begin
      if vN > 1000 then Continue;
      
      GetWindowText(vHandle, buff, SizeOf(buff));
      vFormInfo.Name := StrPas(buff);
      vFormInfo.Handle := vHandle;
      GetWindowRect(vHandle, vFormInfo.Rect);
      SetLength(vRes, vN + 1);
      vRes[vN] := vFormInfo;
      vN := vN + 1;
    end;
    vHandle := GetWindow(vHandle, gw_hwndnext);
  end;

//  SetLength(vRes, vN);
  Result := vRes;
end;

procedure TMonitorChanger.ReturnForms;
var
  vJson: TJSONObject;
  vArr: TJSONArray;
  vS: string;
//  vStartForms, vMovedForms: TList<TFormInfo>;
  i: Integer;
  vFormInfo, vStartFormInfo: TFormInfo;
  vWidth: Integer;
  vCurForms: TArray<TFormInfo>;
begin
  vCurForms := FormsFromProcess;

//  vN := Math.Min(vMovedForms.Count, vCurForms.Count);
   vWidth := ScreenWidth;
  for i := 0 to Length(vCurForms) - 1 do
  begin
    if FormByHandle(FMovedForms, vCurForms[i].Handle, vFormInfo) then
      if vFormInfo.Rect = vCurForms[i].Rect then
        if FormByHandle(FStartForms, vCurForms[i].Handle, vStartFormInfo) then
        begin
          SetWindowPos(vCurForms[i].Handle, 0,
            vStartFormInfo.Rect.Left, vStartFormInfo.Rect.Top,
            vStartFormInfo.Rect.Width, vStartFormInfo.Rect.Height, SWP_NOZORDER + SWP_NOACTIVATE);
        end;
  end;


end;

end.

