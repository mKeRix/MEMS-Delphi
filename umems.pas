unit uMEMS;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Synaser;

type

  { TMEMS }

  TMEMS = class(TForm)
    bConnect: TButton;
    bRead: TButton;
    procedure bConnectClick(Sender: TObject);
    procedure bReadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MEMS: TMEMS;

implementation
var
  serial: TBlockSerial;
  data: String;

{$R *.lfm}

{ TMEMS }

procedure TMEMS.FormCreate(Sender: TObject);
begin
  //placeholder (or is it?)
  serial := TBlockSerial.Create;
end;

procedure TMEMS.bConnectClick(Sender: TObject);
begin
  //connect via synaser
  serial.Connect('COM3');
  serial.config(115200, 7, 'N', SB1, False, False);

  ShowMessage('Connected!');
  bConnect.Enabled := false;
end;

procedure TMEMS.bReadClick(Sender: TObject);
begin
  data := serial.RecvPacket(10);
  ShowMessage(data);
end;

end.

