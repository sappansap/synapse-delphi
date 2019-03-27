unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, httpsend, ssl_openssl, Buttons;

type
  TWhoisForm = class(TForm)
    Memo1:   TMemo;
    Edit1:   TEdit;
    Label1:  TLabel;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WhoisForm: TWhoisForm;

implementation

{$R *.dfm}

function Clearhtml(s:string):string;
begin
  s := StringReplace(s, '&nbsp;', ' ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, '<br>', '', [rfReplaceAll, rfIgnoreCase]);
  //А теперь русификация:)
  s := StringReplace(s, 'domain:', 'Домен:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'type:', 'Тип:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'nserver:', 'Сервер имён:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'state:', 'Состояние:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'org:', 'Организация:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'phone:', 'Телефон:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'fax-no:', 'Факс:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'e-mail:', 'Электронный адрес:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'registrar:', 'Регистратор:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'created:', 'Зарегистрирован:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'paid-till:', 'Дествителен до:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'source:', 'Источник:', [rfReplaceAll, rfIgnoreCase]);
  result := s;
end;

procedure TWhoisForm.SpeedButton1Click(Sender: TObject);
var
  sl: TStringList;
  s, d:  string;
  k:integer;
begin
  sl := TStringList.Create;
  try
    if not HttpGetText('https://www.nic.ru/whois/?query=' + edit1.Text, sl) then
    begin
      ShowMessage('Не удалось загрузить страницу');
      exit;
    end;
    s := sl.Text;
  finally
    sl.Free;
  end;
  k := pos('domain:',s);
  if k = 0 then
  begin
    ShowMessage('Нет информации об этом домене');
    exit;
  end;
  repeat
  delete(s, 1, k - 1);
  k := pos('<br>'#13#10'<br>',s);
  d := copy(s,1, k + 3);
  delete(s,1,k+ 3);
  Memo1.Lines.Add(Clearhtml(d));
  k := pos('domain:',s);
  if k<>0 then
    Memo1.Lines.Add('-------------------------');
  until  k = 0;
end;

end.
