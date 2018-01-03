unit UNewUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Grids;

type
  TfrNewUser = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edFamily: TEdit;
    edName: TEdit;
    edSubname: TEdit;
    edShortName: TEdit;
    edLogin: TEdit;
    edPassword: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frNewUser: TfrNewUser;

  Procedure EditUser(ARow : integer);
  Procedure ReadUsersFromFile(FileName : string; Grid : tstringgrid);
  Procedure WriteUsersToFile(FileName : String; Grid : tstringgrid);

implementation
uses umain, ucommon, ugrid;

{$R *.dfm}

Procedure EditUser(ARow : integer);
var rw : integer;
    s : string;
begin
  if ARow=-1 then begin
    frNewUser.edFamily.Text    := '';
    frNewUser.edName.Text      := '';
    frNewUser.edSubName.Text   := '';
    frNewUser.edShortName.Text := '';
    frNewUser.edLogin.Text     := '';
    frNewUser.edPassword.Text  := '';
  end else begin
    if not (Form1.StringGrid1.Objects[0,ARow] is TGridRows) then begin
      Form1.StringGrid1.Objects[0,ARow] := TGridRows.Create;
      (Form1.StringGrid1.Objects[0,ARow] as TGridRows).Assign(RowGridUsers);
    end;
    frNewUser.edFamily.Text    := (Form1.StringGrid1.Objects[0,ARow] as TGridRows).MyCells[0].ReadPhrase('Family');
    frNewUser.edName.Text      := (Form1.StringGrid1.Objects[0,ARow] as TGridRows).MyCells[0].ReadPhrase('Name');
    frNewUser.edSubName.Text   := (Form1.StringGrid1.Objects[0,ARow] as TGridRows).MyCells[0].ReadPhrase('SubName');
    frNewUser.edShortName.Text := (Form1.StringGrid1.Objects[0,ARow] as TGridRows).MyCells[0].ReadPhrase('ShortName');
    frNewUser.edLogin.Text     := (Form1.StringGrid1.Objects[0,ARow] as TGridRows).MyCells[0].ReadPhrase('Login');
    frNewUser.edPassword.Text  := (Form1.StringGrid1.Objects[0,ARow] as TGridRows).MyCells[0].ReadPhrase('Password');
  end;
  frNewUser.ShowModal;
  if frNewUser.ModalResult = mrOk then begin
    rw := ARow;
    if rw=-1 then begin
      if Form1.StringGrid1.RowCount=2 then begin
        if not (Form1.StringGrid1.Objects[0,1] is TGridRows) then begin
          Form1.StringGrid1.Objects[0,1] := TGridRows.Create;
          (Form1.StringGrid1.Objects[0,1] as TGridRows).Assign(RowGridUsers);
        end;
        s := (Form1.StringGrid1.Objects[0,1] as TGridRows).MyCells[0].ReadPhrase('LoginTxt');
        if Trim(s)='' then rw:=1
        else begin
          Form1.StringGrid1.RowCount := Form1.StringGrid1.RowCount + 1;
          Form1.StringGrid1.Objects[0,Form1.StringGrid1.RowCount-1] := TGridRows.Create;
          (Form1.StringGrid1.Objects[0,Form1.StringGrid1.RowCount-1] as TGridRows).Assign(RowGridUsers);
          rw:=Form1.StringGrid1.RowCount-1;
        end;
      end else begin
        Form1.StringGrid1.RowCount := Form1.StringGrid1.RowCount + 1;
        Form1.StringGrid1.Objects[0,Form1.StringGrid1.RowCount-1] := TGridRows.Create;
        (Form1.StringGrid1.Objects[0,Form1.StringGrid1.RowCount-1] as TGridRows).Assign(RowGridUsers);
        rw:=Form1.StringGrid1.RowCount-1;
      end;
    end;
    (Form1.StringGrid1.Objects[0,rw] as TGridRows).ID:=1;
    (Form1.StringGrid1.Objects[0,rw] as TGridRows).MyCells[0].UpdatePhrase('Family', frNewUser.edFamily.Text);
    (Form1.StringGrid1.Objects[0,rw] as TGridRows).MyCells[0].UpdatePhrase('Name', frNewUser.edName.Text);
    (Form1.StringGrid1.Objects[0,rw] as TGridRows).MyCells[0].UpdatePhrase('SubName', frNewUser.edSubName.Text);
    (Form1.StringGrid1.Objects[0,rw] as TGridRows).MyCells[0].UpdatePhrase('ShortNameTxt', 'Коротокое имя:');
    (Form1.StringGrid1.Objects[0,rw] as TGridRows).MyCells[0].UpdatePhrase('ShortName', frNewUser.edShortName.Text);
    (Form1.StringGrid1.Objects[0,rw] as TGridRows).MyCells[0].UpdatePhrase('LoginTxt', 'Логин:');
    (Form1.StringGrid1.Objects[0,rw] as TGridRows).MyCells[0].UpdatePhrase('Login', frNewUser.edLogin.Text);
    (Form1.StringGrid1.Objects[0,rw] as TGridRows).MyCells[0].UpdatePhrase('Password', frNewUser.edPassword.Text);
    WriteUsersToFile('workingdata.dll',Form1.Stringgrid1);
  end;

end;

procedure TfrNewUser.SpeedButton1Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TfrNewUser.SpeedButton2Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

function MyEncodeString(Step : integer; Src : String) : string;
var i : integer;
    s : string;
begin
  s := '';
  for i:=0 to length(Src) do s := s + chr(ord(Src[i])-Step);
  result := s;
end;

function MyDecodeString(Step : integer; Src : String) : string;
var i : integer;
    s : string;
begin
  s := '';
  for i := 0 to length(Src) do s:=s + chr(ord(Src[i])+Step);
  result := Trim(s);
end;

procedure WriteBufferStr(F : tStream; astr : widestring);
var Len : longint;
begin
  len:=length(astr);
  F.WriteBuffer(Len, SizeOf(Len));
  if Len > 0 then F.WriteBuffer(astr[1],Length(astr)*SizeOf(astr[1]));
end;

Procedure ReadBufferStr(F : tStream; out astr : String); overload;
var len : longint;
    ws : widestring;
begin
    F.ReadBuffer(len,sizeof(len));
    Setlength(ws,len);
    if len > 0 then F.ReadBuffer(ws[1],length(ws)*sizeof(ws[1]));
    astr:=ws;
end;

Procedure ReadBufferStr(F : tStream; out astr : tfontname); overload;
var len : longint;
    ws : widestring;
begin
    F.ReadBuffer(len,sizeof(len));
    Setlength(ws,len);
    if len > 0 then F.ReadBuffer(ws[1],length(ws)*sizeof(ws[1]));
    astr:=ws;
end;

Procedure ReadBufferStr(F : tStream; out astr : widestring); overload;
var len : longint;
    ws : widestring;
begin
    F.ReadBuffer(len,sizeof(len));
    Setlength(ws,len);
    if len > 0 then F.ReadBuffer(ws[1],length(ws)*sizeof(ws[1]));
    astr:=ws;
end;

Procedure WriteUserToStream(F : tStream; Grid : tstringgrid; ARow : integer);
begin
  with (Grid.Objects[0,ARow] as TGridRows).MyCells[0] do begin
    WriteBufferStr(F, MyEncodeString(StepCoding,ReadPhrase('Name')));
    WriteBufferStr(F, MyEncodeString(StepCoding,ReadPhrase('SubName')));
    WriteBufferStr(F, MyEncodeString(StepCoding,ReadPhrase('Family')));
    WriteBufferStr(F, MyEncodeString(StepCoding,ReadPhrase('ShortName')));
    WriteBufferStr(F, MyEncodeString(StepCoding,ReadPhrase('Login')));
    WriteBufferStr(F, MyEncodeString(StepCoding,ReadPhrase('Password')));
  end;
end;

Procedure ReadUserFromStream(F : tStream; Grid : tstringgrid; ARow : integer);
var s, s1 : string;
begin
  (Grid.Objects[0,ARow] as TGridRows).ID := 1;
  with (Grid.Objects[0,ARow] as TGridRows).MyCells[0] do begin
    ReadBufferStr(F, s);
    s1:= MyDecodeString(StepCoding,s);
    UpdatePhrase('Name',s1);
    SetPhraseColor('Name',GridFontColor);

    ReadBufferStr(F, s);
    s1 := MyDecodeString(StepCoding,s);
    UpdatePhrase('SubName',s1);

    ReadBufferStr(F, s);
    s1 := MyDecodeString(StepCoding,s);
    UpdatePhrase('Family',s1);

    ReadBufferStr(F, s);
    s1 := MyDecodeString(StepCoding,s);
    UpdatePhrase('ShortName',s1);

    UpdatePhrase('ShortNameTxt','Кортокое имя:');

    ReadBufferStr(F, s);
    s1 := MyDecodeString(StepCoding,s);
    UpdatePhrase('Login',s1);

    UpdatePhrase('loginTxt','Логин:');

    ReadBufferStr(F, s);
    s1 := MyDecodeString(StepCoding,s);
    UpdatePhrase('Password',s1);
  end;
end;

Procedure WriteUsersToFile(FileName : String; Grid : tstringgrid);
var Stream : TFileStream;
    i : integer;
    renm : string;
begin
  try
  if FileExists(FileName) then begin
    renm := ExtractFilePath(FileName) + 'Temp.Save';
    RenameFile(FileName,renm);
    DeleteFile(renm);
  end;
  Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
  try
    Stream.WriteBuffer(Grid.RowCount, SizeOf(Grid.RowCount));
    for i:=1 to Grid.RowCount-1 do WriteUserToStream(Stream, Grid, i);;
  finally
    FreeAndNil(Stream);
  end;
  except
  end;
end;

Procedure ReadUsersFromFile(FileName : string; Grid : tstringgrid);
var Stream : TFileStream;
    i, apos, cnt: integer;
begin
  if not FileExists(FileName) then exit;
  Stream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
  try
  For i:=0 to Grid.RowCount-1 do Grid.Objects[0,i] := nil;
  Stream.ReadBuffer(cnt, SizeOf(Grid.RowCount));
  if cnt < 2 then begin
    initgrid(Grid, RowGridUsers, Form1.Width - Form1.Panel3.Width);
  end else begin
    Grid.RowCount:=cnt;
    Grid.Objects[0,0] := TGridRows.Create;
    (Grid.Objects[0,0] as TGridRows).Assign(RowGridUsers);
    for i:=1 to Grid.RowCount-1 do begin
      Grid.Objects[0,i] := TGridRows.Create;
      (Grid.Objects[0,i] as TGridRows).Assign(RowGridUsers);
      ReadUserFromStream(Stream, Grid, i);
    end;
  end;
  finally
    FreeAndNil(Stream);
  end;
end;





end.
