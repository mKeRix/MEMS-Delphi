program pMEMS;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uMEMS, laz_synapse, usettings, udiagram1, udiagram2, udiagram3, 
udiagram4, udiagram5
  { you can add units after this };

{$R *.res}

begin
  Application.Title:='MEMS';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TMEMS, MEMS);
  Application.CreateForm(TSettings, Settings);
  Application.CreateForm(TDiagram1, Diagram1);
  Application.CreateForm(TDiagram2, Diagram2);
  Application.CreateForm(TDiagram3, Diagram3);
  Application.CreateForm(TDiagram4, Diagram4);
  Application.CreateForm(TDiagram5, Diagram5);
  Application.Run;
end.

