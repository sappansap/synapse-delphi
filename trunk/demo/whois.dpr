program whois;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {WhoisForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TWhoisForm, WhoisForm);
  Application.Run;
end.
