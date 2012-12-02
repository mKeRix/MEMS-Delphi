unit usettings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls;

type

  { TSettings }

  TSettings = class(TForm)
    AccelBox: TComboBox;
    bOK: TButton;
    bAbort: TButton;
    FrequencyBox: TEdit;
    GyroBox: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Settings: TSettings;

implementation

{$R *.lfm}

end.

