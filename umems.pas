unit uMEMS;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus, Buttons, Synaser, usettings, udiagram1, udiagram2, udiagram3,
  udiagram4, udiagram5;

type

  { TMEMS }

  TMEMS = class(TForm)
    bConnect: TButton;
    bRefresh: TBitBtn;
    COMBox: TComboBox;
    Label1: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label0: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lD1: TLabel;
    lD9: TLabel;
    lD10: TLabel;
    lD11: TLabel;
    lD0: TLabel;
    lD2: TLabel;
    lD3: TLabel;
    lD4: TLabel;
    lD5: TLabel;
    lD6: TLabel;
    lD7: TLabel;
    lD8: TLabel;
    MainMenu: TMainMenu;
    mClose: TMenuItem;
    mDiagram: TMenuItem;
    mDiagram1: TMenuItem;
    mDiagram2: TMenuItem;
    mDiagram3: TMenuItem;
    mDiagram4: TMenuItem;
    mDiagram5: TMenuItem;
    mDiagramSettings: TMenuItem;
    mView: TMenuItem;
    mOff: TMenuItem;
    mOn: TMenuItem;
    mControls: TMenuItem;
    mSeperator1: TMenuItem;
    mFile: TMenuItem;
    mSensor: TMenuItem;
    mSettings: TMenuItem;
    mSave: TMenuItem;
    mOpen: TMenuItem;
    Open: TOpenDialog;
    Save: TSaveDialog;
    tDataRead: TTimer;
    procedure bConnectClick(Sender: TObject);
    procedure bRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mCloseClick(Sender: TObject);
    procedure mDiagram1Click(Sender: TObject);
    procedure mDiagram2Click(Sender: TObject);
    procedure mDiagram3Click(Sender: TObject);
    procedure mDiagram4Click(Sender: TObject);
    procedure mDiagram5Click(Sender: TObject);
    procedure mDiagramSettingsClick(Sender: TObject);
    procedure mOffClick(Sender: TObject);
    procedure mOnClick(Sender: TObject);
    procedure mOpenClick(Sender: TObject);
    procedure mSaveClick(Sender: TObject);
    procedure mSettingsClick(Sender: TObject);
    procedure tDataReadTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MEMS: TMEMS;

implementation

type values=Record
                 number: Integer;
                 accx, accy, accz, gyrox, gyroy, gyroz, magnetox, magnetoy, magnetoz, air, temp: Double;
               end;

               measuredvalues = Array of values;

var
  FormatSettings: TFormatSettings;
  serial: TBlockSerial;
  connected: Boolean;
  data: String;
  datalist: TStringList;
  meval:measuredvalues;
  filename:String[120];
  frequency,accelmax,gyromax:Integer;

{$R *.lfm}

{ TMEMS }

function Split(const fText: String; const fSep: Char; fTrim: Boolean=false; fQuotes: Boolean=false):TStringList;
var vI: Integer;
    vBuffer: String;
    vOn: Boolean;
begin
  Result:=TStringList.Create;
  vBuffer:='';
  vOn:=true;
  for vI:=1 to Length(fText) do
  begin
    if (fQuotes and(fText[vI]=fSep)and vOn)or(Not(fQuotes) and (fText[vI]=fSep)) then
    begin
      if fTrim then vBuffer:=Trim(vBuffer);
      if vBuffer='' then vBuffer:=fSep;
      if vBuffer[1]=fSep then
        vBuffer:=Copy(vBuffer,2,Length(vBuffer));
      Result.Add(vBuffer);
      vBuffer:='';
    end;
    if fQuotes then
    begin
      if fText[vI]='"' then
      begin
        vOn:=Not(vOn);
        Continue;
      end;
      if (fText[vI]<>fSep)or((fText[vI]=fSep)and(vOn=false)) then
        vBuffer:=vBuffer+fText[vI];
    end else
      if fText[vI]<>fSep then
        vBuffer:=vBuffer+fText[vI];
  end;
  if vBuffer<>'' then
  begin
    if fTrim then vBuffer:=Trim(vBuffer);
    Result.Add(vBuffer);
  end;
end;

function StringReverse(S:String):String;
var
  i: Integer;
begin
  Result:='';
  for i:=Length(S) downto 1 do
  Begin
    Result:=Result+Copy(S,i,1);
  end;
end;

function LastPos(const SubStr: String; const S: String): Integer;
begin
   result := Pos(StringReverse(SubStr), StringReverse(S)) ;

   if (result <> 0) then
     result := ((Length(S) - Length(SubStr)) + 1) - result + 1;
end;

procedure TMEMS.FormCreate(Sender: TObject);
var
  i: Integer;
  ports: TStringList;
begin
  serial := TBlockSerial.Create;
  datalist := TStringList.Create;

  connected := false;

  FormatSettings.DecimalSeparator := '.';

  COMBox.Clear;
  ports := Split(GetSerialPortNames,',');

  if ports.Count > 0 then
  begin
    for i := 0 to ports.Count - 1 do
    begin
      //COMBox.Items[i] := ports[i];
      COMBox.AddItem(ports[i], TObject(i));
    end;
    COMBox.Text := ports[0];
  end;
end;

procedure TMEMS.mCloseClick(Sender: TObject);
begin
  close
end;

procedure TMEMS.mDiagram1Click(Sender: TObject);
begin
  //Acceleration
  Diagram1.Show;
end;

procedure TMEMS.mDiagram2Click(Sender: TObject);
begin
  //Gyroscope
  Diagram2.Show;
end;

procedure TMEMS.mDiagram3Click(Sender: TObject);
begin
  //Magneto
  Diagram3.Show;
end;

procedure TMEMS.mDiagram4Click(Sender: TObject);
begin
  //air pressure
  Diagram4.Show;
end;

procedure TMEMS.mDiagram5Click(Sender: TObject);
begin
  //temprature
  Diagram5.Show;
end;

procedure TMEMS.mDiagramSettingsClick(Sender: TObject);
begin
  //to be added
end;

procedure TMEMS.mOffClick(Sender: TObject);
var
  i: Integer;
begin
  serial.SendString('stop'+Char(13));

  //cheat to let missing data "disappear" -> needs to be looked into, but for now it should work okay like this
  for i:=1 to Length(meval) do
  begin
    if meval[i].number = 0 then
    begin
      meval[i] := meval[i-1];
      meval[i].number := meval[i-1].number+1;
    end;
  end;
end;

procedure TMEMS.mOnClick(Sender: TObject);
begin
  serial.SendString('start'+Char(13));
end;

procedure TMEMS.mOpenClick(Sender: TObject);
var
  valuefile: Text;
  line: String;
  i: Integer;
begin
  Open.InitialDir:='';
  if(Open.Execute)
  then
  begin
    filename:=Open.FileName;
    i := 0;
    AssignFile(valuefile, Open.FileName);
    Reset(valuefile);
    while not eof(valuefile) do
    begin
      ReadLn(valuefile, line);
      datalist := Split(line,';');
      SetLength(meval, i+1);

      meval[i].number := StrToInt(datalist[0]);
      meval[i].accx := StrToFloat(datalist[1]);
      meval[i].accy := StrToFloat(datalist[2]);
      meval[i].accz := StrToFloat(datalist[3]);
      meval[i].gyrox := StrToFloat(datalist[4]);
      meval[i].gyroy := StrToFloat(datalist[5]);
      meval[i].gyroz := StrToFloat(datalist[6]);
      meval[i].magnetox := StrToFloat(datalist[7]);
      meval[i].magnetoy := StrToFloat(datalist[8]);
      meval[i].magnetoz := StrToFloat(datalist[9]);
      meval[i].air := StrToFloat(datalist[10]);
      meval[i].temp := StrToFloat(datalist[11]);

      inc(i);
    end;
    CloseFile(valuefile);
  end;
end;

procedure TMEMS.mSaveClick(Sender: TObject);
var i:Integer;
    valuefile:Text;
    line:String;
begin
  Save.InitialDir:='';
  if(Save.execute)
  then
  begin
    filename:=Save.FileName;
    AssignFile(valuefile, Save.FileName);
    Rewrite(valuefile);
    for i:=1 to High(meval) do
    begin
      //bring it in a normal .csv format
      line := IntToStr(meval[i].number)+';'+FloatToStr(meval[i].accx)+';'+FloatToStr(meval[i].accy)+';'+FloatToStr(meval[i].accz)+';'+FloatToStr(meval[i].gyrox)+';'+FloatToStr(meval[i].gyroy)+';'+FloatToStr(meval[i].gyroz)+';'+FloatToStr(meval[i].magnetox)+';'+FloatToStr(meval[i].magnetoy)+';'+FloatToStr(meval[i].magnetoz)+';'+FloatToStr(meval[i].air)+';'+FloatToStr(meval[i].temp);
      WriteLn(valuefile,line);
    end;
    CloseFile(valuefile);
  end;
end;

procedure TMEMS.mSettingsClick(Sender: TObject);
begin
  if Settings.ShowModal= mrOK then
  begin
    if StrToInt(Settings.FrequencyBox.Text) > 1000 then
    begin
      Settings.FrequencyBox.Text := '1000';
    end
    else if StrToInt(Settings.FrequencyBox.Text) < 10 then
    begin
      Settings.FrequencyBox.Text := '10';
    end;

    serial.SendString('accel_fs '+Settings.AccelBox.Text+Char(13));
    Sleep(33);
    serial.SendString('gyro_fs '+Settings.GyroBox.Text+Char(13));
    Sleep(33);
    serial.SendString('refresh '+Settings.FrequencyBox.Text+Char(13));
    Sleep(33);

    accelmax := StrToInt(Settings.AccelBox.Text);
    gyromax := StrToInt(Settings.GyroBox.Text);
    frequency := StrToInt(Settings.FrequencyBox.Text);

    Diagram1.UpdateLimitsY(accelmax);
    Diagram1.UpdateRange(frequency*10);
    Diagram2.UpdateLimitsY(gyromax);
    Diagram2.UpdateRange(frequency*10);
    Diagram3.UpdateRange(frequency*10);
    Diagram4.UpdateRange(frequency*10);
    Diagram5.UpdateRange(frequency*10);

    tDataRead.Enabled := false;
    tDataRead.Interval := 1000 * 1 div StrToInt(Settings.FrequencyBox.Text);
    tDataRead.Enabled := true;
  end;
end;

procedure TMEMS.tDataReadTimer(Sender: TObject);
var
  currentnumber,dataamount,i: Integer;
  data: String;
begin
  data := serial.RecvPacket(10);
  data := Copy(data, 1, LastPos(Char(13), data) -1);
  datalist := Split(data,';');
  dataamount := datalist.Count div 12;

  if datalist.Count mod 12 = 0 then
  begin
    for i:=0 to dataamount-1 do
    begin
      datalist[0+i*12] := StringReplace(datalist[0+i*12], Char(13)+Char(10), '', [rfReplaceAll]);
      //datalist[0+i*12] := Copy(datalist[0+i*12], Pos(Char(13), datalist[0+i*12]), Length(datalist[0+i*12]));

      //output data in the form
      lD0.Caption := datalist[0+i*12];
      lD1.Caption := datalist[1+i*12];
      lD2.Caption := datalist[2+i*12];
      lD3.Caption := datalist[3+i*12];
      lD4.Caption := datalist[4+i*12];
      lD5.Caption := datalist[5+i*12];
      lD6.Caption := datalist[6+i*12];
      lD7.Caption := datalist[7+i*12];
      lD8.Caption := datalist[8+i*12];
      lD9.Caption := datalist[9+i*12];
      lD10.Caption := datalist[10+i*12];
      lD11.Caption := datalist[11+i*12];

      //saving data into the dataset array
      currentnumber := StrToInt(datalist[0+i*12]);
      SetLength(meval, currentnumber + 1);
      meval[currentnumber].number := currentnumber;
      meval[currentnumber].accx := StrToFloat(datalist[1+i*12], FormatSettings);
      meval[currentnumber].accy := StrToFloat(datalist[2+i*12], FormatSettings);
      meval[currentnumber].accz := StrToFloat(datalist[3+i*12], FormatSettings);
      meval[currentnumber].gyrox := StrToFloat(datalist[4+i*12], FormatSettings);
      meval[currentnumber].gyroy := StrToFloat(datalist[5+i*12], FormatSettings);
      meval[currentnumber].gyroz := StrToFloat(datalist[6+i*12], FormatSettings);
      meval[currentnumber].magnetox := StrToFloat(datalist[7+i*12], FormatSettings);
      meval[currentnumber].magnetoy := StrToFloat(datalist[8+i*12], FormatSettings);
      meval[currentnumber].magnetoz := StrToFloat(datalist[9+i*12], FormatSettings);
      meval[currentnumber].air := StrToFloat(datalist[10+i*12], FormatSettings);
      meval[currentnumber].temp := StrToFloat(datalist[11+i*12], FormatSettings);

      //clear diagrams if needed
      if Diagram1.diagramData.lists[0].count > currentnumber then
      begin
        Diagram1.diagramData.lists[0].clear;
        Diagram1.diagramData.lists[1].clear;
        Diagram1.diagramData.lists[2].clear;
        Diagram2.diagramData.lists[0].clear;
        Diagram2.diagramData.lists[1].clear;
        Diagram2.diagramData.lists[2].clear;
        Diagram3.diagramData.lists[0].clear;
        Diagram3.diagramData.lists[1].clear;
        Diagram3.diagramData.lists[2].clear;
        Diagram4.diagramData.lists[0].clear;
        Diagram5.diagramData.lists[0].clear;
      end;

      //give data to the diagram handlers
      Diagram1.diagramData.lists[0].addPoint(currentnumber,meval[currentnumber].accx);
      Diagram1.diagramData.lists[1].addPoint(currentnumber,meval[currentnumber].accy);
      Diagram1.diagramData.lists[2].addPoint(currentnumber,meval[currentnumber].accz);
      Diagram1.UpdateLimitsX(currentnumber);
      Diagram2.diagramData.lists[0].addPoint(currentnumber,meval[currentnumber].gyrox);
      Diagram2.diagramData.lists[1].addPoint(currentnumber,meval[currentnumber].gyroy);
      Diagram2.diagramData.lists[2].addPoint(currentnumber,meval[currentnumber].gyroz);
      Diagram2.UpdateLimitsX(currentnumber);
      Diagram3.diagramData.lists[0].addPoint(currentnumber,meval[currentnumber].magnetox);
      Diagram3.diagramData.lists[1].addPoint(currentnumber,meval[currentnumber].magnetoy);
      Diagram3.diagramData.lists[2].addPoint(currentnumber,meval[currentnumber].magnetoz);
      Diagram3.UpdateLimitsX(currentnumber);
      Diagram4.diagramData.lists[0].addPoint(currentnumber,meval[currentnumber].air);
      Diagram4.UpdateLimitsX(currentnumber);
      Diagram5.diagramData.lists[0].addPoint(currentnumber,meval[currentnumber].temp);
      Diagram5.UpdateLimitsX(currentnumber);
    end;
  end;

  tDataRead.Enabled := false;
  tDataRead.Enabled := true;
end;

procedure TMEMS.bConnectClick(Sender: TObject);
begin
  if connected = false then
  begin
    //connect via synaser
    serial.Connect(COMBox.Text);
    serial.config(115200, 8, 'N', SB1, False, False);

    if serial.InstanceActive then
    begin
      //reset settings on start (until settings can be read by the program)
      serial.SendString('default'+Char(13));
      frequency := 10;
      accelmax := 4;
      gyromax := 2000;
      Diagram1.UpdateLimitsY(accelmax);
      Diagram1.UpdateRange(frequency*10);
      Diagram2.UpdateLimitsY(gyromax);
      Diagram2.UpdateRange(frequency*10);
      Diagram3.UpdateRange(frequency*10);
      Diagram4.UpdateRange(frequency*10);
      Diagram5.UpdateRange(frequency*10);

      COMBox.Enabled := false;
      bRefresh.Enabled := false;
      mSensor.Enabled := true;
      tDataRead.Enabled := true;

      bConnect.Caption := 'Trennen';

      connected := true;
    end
    else
    begin
      ShowMessage('Verbindung gescheitert!');
    end;
  end
  else
  begin
    serial.CloseSocket;

    COMBox.Enabled := true;
    bRefresh.Enabled := true;
    mSensor.Enabled := false;
    tDataRead.Enabled := false;

    bConnect.Caption := 'Verbinden mit';

    connected := false;
  end;
end;


procedure TMEMS.bRefreshClick(Sender: TObject);
var
  i: Integer;
  ports: TStringList;
begin
  COMBox.Clear;
  ports := Split(GetSerialPortNames,',');

  if ports.Count > 0 then
  begin
    for i := 0 to ports.Count - 1 do
    begin
      //COMBox.Items[i] := ports[i];
      COMBox.AddItem(ports[i], TObject(i));
    end;
    COMBox.Text := ports[0];
  end;
end;

end.

