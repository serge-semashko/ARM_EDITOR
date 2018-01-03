unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus;

const
  WM_MYICONNOTIFY = WM_USER + 123;

type
  TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    RestoreItem: TMenuItem;
    N1: TMenuItem;
    FileExitItem1: TMenuItem;
    HideItem: TMenuItem;
    //PopupMenu1: TPopupMenu;
    //RestoreItem: TMenuItem;
    //N1: TMenuItem;
    //FileExitItem1: TMenuItem;
    //HideItem: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RestoreItemClick(Sender: TObject);
    procedure HideItemClick(Sender: TObject);
    procedure FileExitItem1Click(Sender: TObject);
  private
    { Private declarations }
    ShownOnce: Boolean;
  public
    { Public declarations }
    procedure WMICON(var msg: TMessage); message WM_MYICONNOTIFY;
    procedure WMSYSCOMMAND(var msg: TMessage); message WM_SYSCOMMAND;
    procedure RestoreMainForm;
    procedure HideMainForm;
    procedure CreateTrayIcon(n: Integer);
    procedure DeleteTrayIcon(n: Integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses ShellApi, shlobj, registry;

procedure TForm1.WMICON(var msg: TMessage);
var
  P: TPoint;
begin
  case msg.LParam of // ????????? ???????? ?????????
    WM_LBUTTONUP: //?? ??????? ????? ???????, WM_RBUTTONUP ?? ??????
      begin
        GetCursorPos(p);
        SetForegroundWindow(Application.MainForm.Handle);
        PopupMenu1.Popup(P.X, P.Y);
      end;
    WM_LBUTTONDBLCLK: RestoreItemClick(Self); //??? Default
  end;
end;

procedure TForm1.WMSYSCOMMAND(var msg: TMessage);
begin
  inherited; //????????? ?????????????? ????, ?? ????????????? ? ??????????
  if (Msg.wParam = SC_MINIMIZE) then
    HideItemClick(Self);
end;

procedure TForm1.HideMainForm;
begin
  //??? ???????? ????
  Application.ShowMainForm := False;
  ShowWindow(Application.Handle, SW_HIDE);
  ShowWindow(Application.MainForm.Handle, SW_HIDE);
end;

procedure TForm1.RestoreMainForm;
var
  i, j: Integer;
begin
  Application.ShowMainForm := True;
  ShowWindow(Application.Handle, SW_RESTORE);
  ShowWindow(Application.MainForm.Handle, SW_RESTORE);
  if not ShownOnce then
  begin
    for I := 0 to Application.MainForm.ComponentCount - 1 do
      if Application.MainForm.Components[I] is TWinControl then
        with Application.MainForm.Components[I] as TWinControl do
          if Visible then
          begin
            ShowWindow(Handle, SW_SHOWDEFAULT);
            for J := 0 to ComponentCount - 1 do
              if Components[J] is TWinControl then
                ShowWindow((Components[J] as TWinControl).Handle,
                  SW_SHOWDEFAULT);
          end;
    ShownOnce := True;
  end;

end;

procedure TForm1.CreateTrayIcon(n: Integer);
var
  nidata: TNotifyIconData;
begin
  with nidata do
  begin
    cbSize := SizeOf(TNotifyIconData);
    Wnd := Self.Handle; //HWND ?????? ???? (???? ???????????? ???????? ?????????)
    uID := 1; // ????? ??????
    uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP; //?????????????? ?????
    uCallBackMessage := WM_MYICONNOTIFY;
    hIcon := Application.Icon.Handle;
      // ?? ?????? ???????????? ?????? ??? ????? ???? ? ImageList ? ?.?.
    StrPCopy(szTip, Application.Title);
      // ??????????? ??????, ????? ???? ????? string ??????? ? ??????? ??????????
  end;
  Shell_NotifyIcon(NIM_ADD, @nidata); // ?????????? ??????
end;

procedure TForm1.DeleteTrayIcon(n: Integer);
var
  nidata: TNotifyIconData;
begin
  with nidata do
  begin
    cbSize := SizeOf(TNotifyIconData);
    Wnd := Self.Handle;
    uID := 1;
  end;
  Shell_NotifyIcon(NIM_DELETE, @nidata); // ???????? ??????
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ShownOnce := False;
  CreateTrayIcon(1);
  //HideItemClick(nil);
  HideItem.Enabled := False;
  Form1.WindowState:=wsMinimized;
  Application.ShowMainForm := False;
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  DeleteTrayIcon(1);
end;

procedure TForm1.RestoreItemClick(Sender: TObject);
begin
  RestoreMainForm;
  //???? ?????? ??????? ?? ??? ??????????? ????????? ???? ?????? ????????
  //DeleteTrayIcon(1);
  RestoreItem.Enabled := False;
  HideItem.Enabled := True;
end;

procedure TForm1.HideItemClick(Sender: TObject);
begin
  HideMainForm;
  CreateTrayIcon(1);
  HideItem.Enabled := False;
  RestoreItem.Enabled := True;
end;

procedure TForm1.FileExitItem1Click(Sender: TObject);
begin
  Close;
end;

end.

