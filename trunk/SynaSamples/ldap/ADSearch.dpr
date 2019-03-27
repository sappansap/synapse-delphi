program ADSearch;

uses
  Forms,
  uMain in 'uMain.pas' {foMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfoMain, foMain);
  Application.Run;
end.
