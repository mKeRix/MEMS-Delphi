unit udiagram6;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, diagram;

type

  { TDiagram6 }

  TDiagram6 = class(TForm)
    pDiagram: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure UpdateLimitsY(ydiagrammin,ydiagrammax: Integer);
    procedure UpdateRange(maxrange: Integer);
    procedure UpdateLimitsX(currentx: Integer);
  private
    { private declarations }
  public
    { public declarations }
    diagramView: TDiagramView;
    diagramData: TDiagramDataListModel;
  end;

var
  Diagram6: TDiagram6;

implementation

var
  range: Integer;

{$R *.lfm}

{ TDiagram6 }

procedure TDiagram6.FormCreate(Sender: TObject);
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
  diagramView.Drawer.LeftAxis.Visible := false;
  diagramView.Drawer.RightAxis.Visible := true;
  diagramView.Drawer.RightAxis.gridLinePen.Style := psSolid;
  diagramView.Drawer.RightAxis.gridLinePen.Color := clGray;
  diagramView.Drawer.RangeMaxY := 50;
  diagramView.Drawer.RangeMinY := 0;
  diagramView.Drawer.legend.visible := false;

  diagramData.setDataRows(1);
end;

procedure TDiagram6.UpdateLimitsY(ydiagrammin,ydiagrammax: Integer);
begin
  diagramView.Drawer.RangeMaxY := ydiagrammax;
  diagramView.Drawer.RangeMinY := ydiagrammin;
end;

procedure TDiagram6.UpdateRange(maxrange: Integer);
begin
  range := maxrange;
end;

procedure TDiagram6.UpdateLimitsX(currentx: Integer);
begin
  if currentx < range then
  begin
    diagramView.Drawer.RangeMaxX := range;
    diagramView.Drawer.RangeMinX := 0;
  end
  else
  begin
    diagramView.Drawer.RangeMaxX := currentx;
    diagramView.Drawer.RangeMinX := currentx - range;
  end;
end;

end.

