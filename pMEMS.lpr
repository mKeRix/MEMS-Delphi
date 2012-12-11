program pMEMS;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uMEMS, laz_synapse, usettings, udiagram1
  { you can add units after this };

{$R *.res}

begin
  Application.Title:='MEMS';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TMEMS, MEMS);
  Application.CreateForm(TSettings, Settings);
  Application.CreateForm(TDiagram1, Diagram1);
  Application.Run;
end.

