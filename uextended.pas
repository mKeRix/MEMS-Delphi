unit uextended;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, udiagram6;

type

  { TExtendedMeasures }

  TExtendedMeasures = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    lAccel: TLabel;
    rAccelSelect: TCheckGroup;
    procedure Update(ax,ay,az: Extended; currentx: Integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ExtendedMeasures: TExtendedMeasures;

implementation

{$R *.lfm}

{ TExtendedMeasures }

procedure TExtendedMeasures.Update(ax,ay,az: Extended; currentx: Integer);
var
  selected:Integer;
begin
  //count how many boxes are checked
  selected := 0;
  if rAccelSelect.Checked[0] then
    inc(selected);
  if rAccelSelect.Checked[1] then
    inc(selected);
  if rAccelSelect.Checked[2] then
    inc(selected);

  //convert data accordingly
  if selected = 0 then
    begin
      lAccel.Caption := '0';
    end
  else if selected = 1 then
    begin
      if rAccelSelect.Checked[0] then
        lAccel.Caption := FloatToStr(abs(ax*9.81))
      else if rAccelSelect.Checked[1] then
        lAccel.Caption := FloatToStr(abs(ay*9.81))
      else if rAccelSelect.Checked[2] then
        lAccel.Caption := FloatToStr(abs(az*9.81));
    end
  else if selected > 1 then
    begin
      if rAccelSelect.Checked[0] and rAccelSelect.Checked[1] and rAccelSelect.Checked[2] then
        lAccel.Caption := FloatToStr(sqrt(abs(sqr(ax*9.81)+sqr(ay*9.81)+sqr(az*9.81))))
      else if rAccelSelect.Checked[0] and rAccelSelect.Checked[1] then
        lAccel.Caption := FloatToStr(sqrt(abs(sqr(ax*9.81)+sqr(ay*9.81))))
      else if rAccelSelect.Checked[0] and rAccelSelect.Checked[2] then
        lAccel.Caption := FloatToStr(sqrt(abs(sqr(ax*9.81)+sqr(az*9.81))))
      else if rAccelSelect.Checked[1] and rAccelSelect.Checked[2] then
        lAccel.Caption := FloatToStr(sqrt(abs(sqr(ay*9.81)+sqr(az*9.81))));
    end;

  Diagram6.diagramData.lists[0].addPoint(currentx,StrToFloat(lAccel.Caption));
  Diagram6.UpdateLimitsX(currentx);
end;

end.

