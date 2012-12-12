unit udiagram2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, diagram;

type

  { TDiagram2 }

  TDiagram2 = class(TForm)
    pDiagram: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure UpdateLimitsY(ydiagrammax: Integer);
    procedure UpdateLimitsX(currentx: Integer);
    procedure UpdateRange(maxrange: Integer);
  private
    { private declarations }
  public
    { public declarations }
    diagramView: TDiagramView;
    diagramData: TDiagramDataListModel;
  end;

var
  Diagram2: TDiagram2;

implementation

var
  range: Integer;

{ TDiagram2 }

procedure TDiagram2.FormCreate(Sender: TObject);
begin
  diagramData := TDiagramDataListModel.create;
  diagramView := TDiagramView.create(pDiagram);
  diagramView.Parent := pDiagram;
  diagramView.Align := alClient;
  diagramView.SetModel(diagramData,true);
  diagramView.Drawer.PointStyle := psNone;
  diagramView.Drawer.FillStyle := fsNone;
  diagramView.Drawer.AutoSetRangeX := false;
  diagramView.Drawer.AutoSetRangeY := false;
  diagramView.Drawer.BottomAxis.Visible := false;
  diagramView.Drawer.LeftAxis.Visible := false;
  diagramView.Drawer.HorzMidAxis.Visible := true;
  diagramView.Drawer.RightAxis.Visible := true;
  diagramView.Drawer.RightAxis.gridLinePen.Style := psSolid;
  diagramView.Drawer.RightAxis.gridLinePen.Color := clGray;
  diagramView.Drawer.RangeMaxY := 2000;
  diagramView.Drawer.RangeMinY := -2000;

  diagramData.setDataRows(3);
  diagramData.lists[0].Title := 'X Achse';
  diagramData.lists[1].Title := 'Y Achse';
  diagramData.lists[2].Title := 'Z Achse';
end;

procedure TDiagram2.UpdateLimitsY(ydiagrammax: Integer);
begin
  diagramView.Drawer.RangeMaxY := ydiagrammax;
  diagramView.Drawer.RangeMinY := -ydiagrammax;
end;

procedure TDiagram2.UpdateRange(maxrange: Integer);
begin
  range := maxrange;
end;

procedure TDiagram2.UpdateLimitsX(currentx: Integer);
begin
  if currentx < range then
  begin
    diagramView.Drawer.RangeMaxX := range;
    diagramView.Drawer.RangeMinX := 0;
  end
  else
  begin
    diagramView.Drawer.RangeMaxX := currentx;
    diagramView.Drawer.RangeMinX := currentx - range;;
  end;
end;

{$R *.lfm}

end.

