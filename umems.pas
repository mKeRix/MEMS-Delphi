unit uMEMS;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Synaser;

type

  { TMEMS }

  TMEMS = class(TForm)
    bConnect: TButton;
    bStart: TButton;
    bOn: TButton;
    bOff: TButton;
    bStop: TButton;
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
    lD12: TLabel;
    lD0: TLabel;
    lD2: TLabel;
    lD3: TLabel;
    lD4: TLabel;
    lD5: TLabel;
    lD6: TLabel;
    lD7: TLabel;
    lD8: TLabel;
    tDataRead: TTimer;
    procedure bConnectClick(Sender: TObject);
    procedure bOffClick(Sender: TObject);
    procedure bOnClick(Sender: TObject);
    procedure bStartClick(Sender: TObject);
    procedure bStopClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tDataReadTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MEMS: TMEMS;

implementation
var
  FormatSettings: TFormatSettings;
  serial: TBlockSerial;
  connected: Boolean;
  data: String;
  datalist: TStringList;
  number: Integer;
  accx, accy, accz, gyrox, gyroy, gyroz, magnetox, magnetoy, magnetoz, air, temp: Double;

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

procedure TMEMS.FormCreate(Sender: TObject);
var
  i: Integer;
  ports: TStringList;
begin
  serial := TBlockSerial.Create;
  datalist := TStringList.Create;

  connected := false;

  FormatSettings.DecimalSeparator := '.';

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

procedure TMEMS.tDataReadTimer(Sender: TObject);
begin
  //read data every 100ms
  data := serial.RecvPacket(10);
  datalist := Split(data,';');

  if datalist.Count > 1 then
  begin
    lD0.Caption := datalist[0];
    lD1.Caption := datalist[1];
    lD2.Caption := datalist[2];
    lD3.Caption := datalist[3];
    lD4.Caption := datalist[4];
    lD5.Caption := datalist[5];
    lD6.Caption := datalist[6];
    lD7.Caption := datalist[7];
    lD7.Caption := datalist[8];
    lD8.Caption := datalist[9];
    lD9.Caption := datalist[10];
    lD10.Caption := datalist[11];

    //really early version of saving the data as float variables for later calculations - see Github
    {number := StrToInt(datalist[0]);
    accx := StrToFloat(datalist[1], FormatSettings);
    accy := StrToFloat(datalist[2], FormatSettings);
    accz := StrToFloat(datalist[3], FormatSettings);
    gyrox := StrToFloat(datalist[4], FormatSettings);
    gyroy := StrToFloat(datalist[5], FormatSettings);
    gyroz := StrToFloat(datalist[6], FormatSettings);
    magnetox := StrToFloat(datalist[7], FormatSettings);
    magnetoy := StrToFloat(datalist[8], FormatSettings);
    magnetoz := StrToFloat(datalist[9], FormatSettings);
    air := StrToFloat(datalist[10], FormatSettings);
    temp := StrToFloat(datalist[11], FormatSettings); }
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

    COMBox.Enabled := false;
    bStart.Enabled := true;
    bOn.Enabled := true;
    bOff.Enabled := true;

    bConnect.Caption := 'Disconnect';

    connected := true;
  end
  else
  begin
    serial.CloseSocket;

    COMBox.Enabled := true;
    bStart.Enabled := false;
    bStop.Enabled := false;
    bOn.Enabled := false;
    bOff.Enabled := false;

    bConnect.Caption := 'Connect to';

    connected := false;
  end;
end;

procedure TMEMS.bOffClick(Sender: TObject);
begin
  serial.SendString('I');
end;

procedure TMEMS.bOnClick(Sender: TObject);
begin
  serial.SendString('i');
end;

procedure TMEMS.bStartClick(Sender: TObject);
begin
  tDataRead.Enabled := true;

  bStart.Enabled := false;
  bStop.Enabled := true;
end;

procedure TMEMS.bStopClick(Sender: TObject);
begin
  tDataRead.Enabled := false;

  bStart.Enabled := true;
  bStop.Enabled := false;
end;

procedure TMEMS.Button1Click(Sender: TObject);
begin
  showmessage(GetSerialPortNames);
end;

end.

