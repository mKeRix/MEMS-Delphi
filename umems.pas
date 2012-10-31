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
    ePort: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label0: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lD1: TLabel;
    lD10: TLabel;
    lD11: TLabel;
    lD12: TLabel;
    lD0: TLabel;
    lD2: TLabel;
    lD3: TLabel;
    lD4: TLabel;
    lD5: TLabel;
    lD6: TLabel;
    lD7: TLabel;
    lD8: TLabel;
    lD9: TLabel;
    tDataRead: TTimer;
    procedure bConnectClick(Sender: TObject);
    procedure bOffClick(Sender: TObject);
    procedure bOnClick(Sender: TObject);
    procedure bStartClick(Sender: TObject);
    procedure bStopClick(Sender: TObject);
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
  data: String;
  datalist: TStringList;
  number: Integer;
  accx, accy, accz, gyrox, gyroy, gyroz, temp1, magnetox, magnetoy, magnetoz, air, temp2: Double;

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
begin
  serial := TBlockSerial.Create;
  datalist := TStringList.Create;

  FormatSettings.DecimalSeparator := '.';
end;

procedure TMEMS.tDataReadTimer(Sender: TObject);
begin
  //read data every 100ms
  data := serial.RecvPacket(10);
  datalist := Split(data,';');

  if datalist.Count > 11 then
  begin
    lD0.Caption := datalist[0];
    lD1.Caption := datalist[1];
    lD2.Caption := datalist[2];
    lD3.Caption := datalist[3];
    lD4.Caption := datalist[4];
    lD5.Caption := datalist[5];
    lD6.Caption := datalist[6];
    lD7.Caption := datalist[7];
    lD8.Caption := datalist[8];
    lD9.Caption := datalist[9];
    lD10.Caption := datalist[10];
    lD11.Caption := datalist[11];
    lD12.Caption := datalist[12];

    //really early version of saving the data as float variables for later calculations - see Github
    number := StrToInt(datalist[0]);
    accx := StrToFloat(datalist[1], FormatSettings);
    accy := StrToFloat(datalist[2], FormatSettings);
    accz := StrToFloat(datalist[3], FormatSettings);
    gyrox := StrToFloat(datalist[4], FormatSettings);
    gyroy := StrToFloat(datalist[5], FormatSettings);
    gyroz := StrToFloat(datalist[6], FormatSettings);
    temp1 := StrToFloat(datalist[7], FormatSettings);
    magnetox := StrToFloat(datalist[8], FormatSettings);
    magnetoy := StrToFloat(datalist[9], FormatSettings);
    magnetoz := StrToFloat(datalist[10], FormatSettings);
    air := StrToFloat(datalist[11], FormatSettings);
    temp2 := StrToFloat(datalist[12], FormatSettings);
  end;

  tDataRead.Enabled := false;
  tDataRead.Enabled := true;
end;

procedure TMEMS.bConnectClick(Sender: TObject);
begin
  //connect via synaser
  serial.Connect(ePort.Text);
  serial.config(115200, 7, 'N', SB1, False, False);

  bConnect.Enabled := false;
  ePort.Enabled := false;
  bStart.Enabled := true;
  bOn.Enabled := true;
  bOff.Enabled := true;
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

end.

