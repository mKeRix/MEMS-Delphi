unit udiagram4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, diagram;

type

  { TDiagram4 }

  TDiagram4 = class(TForm)
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
  Diagram4: TDiagram4;

implementation

var
  range: Integer;

{$R *.lfm}

{ TDiagram4 }

procedure TDiagram4.FormCreate(Sender: TObject);
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
  diagramView.Drawer.RangeMaxY := 1200;
  diagramView.Drawer.RangeMinY := 800;
  diagramView.Drawer.legend.visible := false;

  diagramData.setDataRows(1);
end;

procedure TDiagram4.UpdateLimitsY(ydiagrammax: Integer);
begin
  diagramView.Drawer.RangeMaxY := 1000+ydiagrammax;
  diagramView.Drawer.RangeMinY := 1000-ydiagrammax;
end;

procedure TDiagram4.UpdateRange(maxrange: Integer);
begin
  range := maxrange;
end;

procedure TDiagram4.UpdateLimitsX(currentx: Integer);
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

end.

