unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBGrids, Buttons, StdCtrls, ExtCtrls, shellapi,
  Menus;

type
  TfoMain = class(TForm)
    ADOConnection1: TADOConnection;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    Panel1: TPanel;
    Panel2: TPanel;
    Edit1: TEdit;
    TrayIcon1: TTrayIcon;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N1Click(Sender: TObject);
    procedure TrayIcon1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrayIcon1Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  foMain: TfoMain;

implementation

{$R *.dfm}

procedure TfoMain.DBGrid1DblClick(Sender: TObject);
begin
  ShellExecute (0,'open', pchar('mailto:'+DBGrid1.Fields[1].AsString), pchar(''),nil, SW_show);
end;

procedure TfoMain.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_RETURN then
 if Length(edit1.text)>1 then
   begin
    try
      ADOQuery1.Close;
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add('select CN, mail, sAMAccountName, telephoneNumber from '); 
      ADOQuery1.SQL.Add('+#39+'LDAP://OU=Пользователи,DC=domain,DC=local'+#39);
      ADOQuery1.SQL.Add('WHERE objectcategory = '+#39+'Person'+#39+' AND objectclass = '+#39+'User'+#39);
      ADOQuery1.SQL.Add(' and CN = '+#39+'*'+edit1.text+'*'+#39+' order by CN');
      ADOQuery1.open;
    except on E: Exception do
      showmessage('Ошибка: '+e.Message);
    end;
   end;

end;

procedure TfoMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Application.Minimize;
     hide;
     Action:=caNone;
end;

procedure TfoMain.FormShow(Sender: TObject);
begin
  Edit1.SetFocus;
end;

procedure TfoMain.N1Click(Sender: TObject);
begin
  halt;
end;

procedure TfoMain.Timer1Timer(Sender: TObject);
begin
  timer1.Enabled:=false;
  close;

end;

procedure TfoMain.TrayIcon1Click(Sender: TObject);
begin
    Visible:=true;
    application.Restore;
    WindowState := wsNormal;
    Application.BringToFront();
end;

procedure TfoMain.TrayIcon1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

 if Button=mbRight then
  begin
    PopupMenu1.Popup(Mouse.CursorPos.X, Mouse.CursorPos.y);
  end;
end;

end.
