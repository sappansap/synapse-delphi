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
  //� ������ �����������:)
  s := StringReplace(s, 'domain:', '�����:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'type:', '���:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'nserver:', '������ ���:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'state:', '���������:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'org:', '�����������:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'phone:', '�������:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'fax-no:', '����:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'e-mail:', '����������� �����:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'registrar:', '�����������:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'created:', '���������������:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'paid-till:', '����������� ��:', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, 'source:', '��������:', [rfReplaceAll, rfIgnoreCase]);
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
      ShowMessage('�� ������� ��������� ��������');
      exit;
    end;
    s := sl.Text;
  finally
    sl.Free;
  end;
  k := pos('domain:',s);
  if k = 0 then
  begin
    ShowMessage('��� ���������� �� ���� ������');
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
