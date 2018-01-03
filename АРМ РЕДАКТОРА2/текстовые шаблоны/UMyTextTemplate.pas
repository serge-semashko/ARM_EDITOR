unit UMyTextTemplate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, CheckLst, Spin;

type
  TfrMyTextTemplate = class(TForm)
    Panel3: TPanel;
    Panel4: TPanel;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    Label3: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Label4: TLabel;
    ComboBox1: TComboBox;
    Bevel1: TBevel;
    Label5: TLabel;
    SpeedButton4: TSpeedButton;
    Panel1: TPanel;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    Edit1: TEdit;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    procedure MyListBoxClick(Sender: TObject);
    procedure MyListBoxDblClick(Sender: TObject);
    function MyListCreate : string;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpinEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ReplaceTable(count : integer);
    function ExistsListBoxName(Name : string) : boolean;
    function myfindcomponent(name : string) : integer;
    procedure SelectListsName;
    function SelectList(cph : string) : integer;
  end;

var
  frMyTextTemplate: TfrMyTextTemplate;
  mylistbox : tlistbox;
  mylabel : tlabel;
  nom : integer = 0;
  LabelHeight : integer = 20;

Procedure MyTextTemplateOptions;

implementation
uses umynewlist;

{$R *.dfm}

function TfrMyTextTemplate.SelectList(cph : string) : integer;
var i, j, nl : integer;
begin
  result:=-1;
  for i:=0 to frMyTextTemplate.ComponentCount-1 do begin
    if lowercase(frMyTextTemplate.Components[i].ClassName)='tlistbox' then begin
      nl := myfindcomponent('lb' + trim((frMyTextTemplate.Components[i] as TListBox).Name));
      if lowercase(trim((frMyTextTemplate.Components[nl] as TLabel).Caption))=lowercase(trim(cph)) then begin
        (frMyTextTemplate.Components[nl] as TLabel).Font.Color:=clWhite;
        (frMyTextTemplate.Components[nl] as TLabel).Font.Style:=(frMyTextTemplate.Components[nl] as TLabel).Font.Style + [fsBold];
        result := i;
      end else begin
        (frMyTextTemplate.Components[nl] as TLabel).Font.Color:=clSilver;
        (frMyTextTemplate.Components[nl] as TLabel).Font.Style:=(frMyTextTemplate.Components[nl] as TLabel).Font.Style - [fsBold];
      end;
    end;
  end;
end;

procedure TfrMyTextTemplate.SelectListsName;
var i, j, nl : integer;
begin
  ComboBox1.Clear;
  for i:=0 to frMyTextTemplate.ComponentCount-1 do begin
    if lowercase(frMyTextTemplate.Components[i].ClassName)='tlistbox' then begin
      nl := myfindcomponent('lb' + trim((frMyTextTemplate.Components[i] as TListBox).Name));
      ComboBox1.Items.Add((frMyTextTemplate.Components[nl] as TLabel).Caption);
    end;
  end;
end;

procedure TfrMyTextTemplate.MyListBoxClick(Sender: TObject);
var i, j, nl : integer;
begin
  if Panel3.Visible then exit;
  for j:=0 to frMyTextTemplate.ComponentCount-1 do begin
    if lowercase(frMyTextTemplate.Components[j].ClassName)='tlistbox' then begin
      nl := myfindcomponent('lb' + trim((frMyTextTemplate.Components[j] as TListBox).Name));
      (frMyTextTemplate.Components[nl] as TLabel).Font.Color:=clSilver;
      (frMyTextTemplate.Components[nl] as TLabel).Font.Style:=(frMyTextTemplate.Components[nl] as TLabel).Font.Style - [fsBold];
      //(frMyTextTemplate.Components[j] as TListBox).Repaint;
    end;
  end;
  label1.Caption := (Sender as tlistbox).Name;
  nl := myfindcomponent('lb' + trim((Sender as tlistbox).Name));
  (frMyTextTemplate.Components[nl] as TLabel).Font.Color:=clWhite;
  (frMyTextTemplate.Components[nl] as TLabel).Font.Style:=(frMyTextTemplate.Components[nl] as TLabel).Font.Style + [fsBold];
  for i:=0 to (Sender as tlistbox).Count-1 do begin
    if (Sender as tlistbox).Selected[i] then begin
      if trim(Edit1.Text)=''
        then Edit1.Text := (Sender as tlistbox).Items[i]
        else Edit1.Text := Edit1.Text + ', ' + (Sender as tlistbox).Items[i];

      (Sender as tlistbox).Selected[i] := false;
    end;
  end;
end;

procedure TfrMyTextTemplate.MyListBoxDblClick(Sender: TObject);
var i, j, nl : integer;
begin
  if Panel1.Visible then exit;
  for j:=0 to frMyTextTemplate.ComponentCount-1 do begin
    if lowercase(frMyTextTemplate.Components[j].ClassName)='tlistbox' then begin
      nl := myfindcomponent('lb' + trim((frMyTextTemplate.Components[j] as TListBox).Name));
      (frMyTextTemplate.Components[nl] as TLabel).Font.Color:=clSilver;
      (frMyTextTemplate.Components[nl] as TLabel).Font.Style:=(frMyTextTemplate.Components[nl] as TLabel).Font.Style - [fsBold];
      //(frMyTextTemplate.Components[j] as TListBox).Repaint;
    end;
  end;
  label1.Caption := (Sender as tlistbox).Name;
  nl := myfindcomponent('lb' + trim((Sender as tlistbox).Name));
  (frMyTextTemplate.Components[nl] as TLabel).Font.Color:=clWhite;
  (frMyTextTemplate.Components[nl] as TLabel).Font.Style:=(frMyTextTemplate.Components[nl] as TLabel).Font.Style + [fsBold];
  ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(trim((frMyTextTemplate.Components[nl] as TLabel).Caption));
  label1.Caption := (Sender as tlistbox).Name;
  i := myfindcomponent(label1.Caption);
  EditMyListTemplate(i);
end;

function TfrMyTextTemplate.myfindcomponent(name : string) : integer;
var i : integer;
begin
  result := -1;
  for i:=0 to frMyTextTemplate.ComponentCount-1 do begin
    if lowercase(frMyTextTemplate.Components[i].Name)=lowercase(name) then begin
      result:=i;
      exit;
    end;
  end;
end;

procedure TfrMyTextTemplate.ReplaceTable(count : integer);
var i, j, lft, tp, wdth, hgh1, hgh2, rw, cl, cnt, nlabel : integer;
    s : string;
begin
   wdth:=Panel4.Width div count;
   lft := 0;
   tp := 0;
   rw := nom div count;
   cnt := nom mod count;

   if cnt<>0 then begin
     hgh1 := Panel4.Height div (rw + 1);
     if rw=0 then hgh2 := Panel4.Height else hgh2 := Panel4.Height div (rw);
   end else begin
     if rw=0 then hgh1 := Panel4.Height else hgh1 := Panel4.Height div (rw);
     if rw=0 then hgh2 := Panel4.Height else hgh2 := Panel4.Height div (rw);
   end;
   j:=0;
   for i:=0 to frMyTextTemplate.ComponentCount-1 do begin
     if lowercase(frMyTextTemplate.Components[i].ClassName)='tlistbox' then begin
       s := 'lb' + trim(frMyTextTemplate.Components[i].Name);
       j:=j+1;
       rw:=j div count;
       cl:=j mod count;
       if cl=0 then begin
         rw:=rw-1;
         cl:=count;
       end;
       (frMyTextTemplate.Components[i] as TListBox).Left:=wdth * (cl-1);
       (frMyTextTemplate.Components[i] as TListBox).Width:=wdth;
       if cnt<>0 then begin
         if cl<=cnt then begin
           (frMyTextTemplate.Components[i] as TListBox).Top:=hgh1 * (rw) + LabelHeight;
           (frMyTextTemplate.Components[i] as TListBox).Height:=hgh1  - LabelHeight;
         end else begin
           (frMyTextTemplate.Components[i] as TListBox).Top:=hgh2 * (rw) + LabelHeight;
           (frMyTextTemplate.Components[i] as TListBox).Height:=hgh2 - LabelHeight;
         end;
       end else begin
         (frMyTextTemplate.Components[i] as TListBox).Top:=hgh2 * (rw) + LabelHeight;
         (frMyTextTemplate.Components[i] as TListBox).Height:=hgh2 - LabelHeight;
       end;
       nlabel := myfindcomponent(s);
       if nlabel<>-1 then begin
         //(frMyTextTemplate.Components[nlabel] as TLabel).Layout:=tlBottom;
         (frMyTextTemplate.Components[nlabel] as TLabel).Top:=(frMyTextTemplate.Components[i] as TListBox).Top - LabelHeight;
         (frMyTextTemplate.Components[nlabel] as TLabel).Left:=(frMyTextTemplate.Components[i] as TListBox).Left;
         (frMyTextTemplate.Components[nlabel] as TLabel).Width:=(frMyTextTemplate.Components[i] as TListBox).Width;
       end;
     end;
   end;
end;

function TfrMyTextTemplate.ExistsListBoxName(Name : string) : boolean;
var i : integer;
begin
  result := false;
  for i:=0 to frMyTextTemplate.ComponentCount-1 do begin
    if lowercase(frMyTextTemplate.Components[i].ClassName)='tlistbox' then begin
      if lowercase(frMyTextTemplate.Components[i].Name)=lowercase(name) then begin
        result:=true;
        exit;
      end;
    end;
  end;
end;

function TfrMyTextTemplate.MyListCreate : string;
var i, nm : integer;
    snm : string;
begin
  mylabel:=tlabel.Create(frMyTextTemplate);
  mylabel.Parent:=Panel4;
  mylabel.AutoSize:=false;
  mylabel.Height:=LabelHeight;
  mylabel.Font.Color:=clSilver;
  mylabel.Color:=clBlack;
  mylabel.Alignment:=taCenter;
  mylabel.Layout:=tlCenter;
  mylabel.Font.Size:=11;
  mylistbox:=tlistbox.Create(frMyTextTemplate);
  mylistbox.Parent:=Panel4;
  nom:=nom + 1;
  Label3.Caption:=inttostr(nom);
  nm:=nom;
  repeat
    snm := 'mylistbox' + inttostr(nm);
    nm:=nm+1;
  until not ExistsListBoxName(snm);
  mylabel.Name:='lb' + snm;
  mylabel.Caption:=snm;
  mylistbox.Name:=snm;
  for i:=0 to 10 do mylistbox.Items.Add(mylistbox.Name + '-' + inttostr(i));
  mylistbox.Ctl3D:=false;
  mylistbox.Font.Size:=11;
  mylistbox.Font.Color:=clWhite;
  mylistbox.Color:=clblack;
  mylistbox.ItemHeight:=2 * mylistbox.Font.Size;
  mylistbox.Style:=lbOwnerDrawFixed;
  mylistbox.OnClick := MyListBoxClick;
  mylistbox.OnDblClick := MyListBoxDblClick;
  ReplaceTable(SpinEdit1.Value);
  result:=mylistbox.Name;
end;


procedure TfrMyTextTemplate.SpeedButton1Click(Sender: TObject);
var i, nm : integer;
    snm : string;
begin
  EditMyListTemplate(-1);
  ComboBox1.ItemIndex := ComboBox1.Items.Count-1;
  SelectList(ComboBox1.Text);
end;

procedure TfrMyTextTemplate.SpinEdit1KeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then Key:=#0;
end;

procedure TfrMyTextTemplate.SpinEdit1Change(Sender: TObject);
var i, j, lft, tp, wdth, hgh1, hgh2, rw, cl, cnt : integer;
    s : string;
begin
  ReplaceTable(SpinEdit1.Value);
end;

procedure TfrMyTextTemplate.SpinEdit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if trim(SpinEdit1.Text)='' then SpinEdit1.Text:='1';
  if SpinEdit1.Value > SpinEdit1.MaxValue then SpinEdit1.Value := SpinEdit1.MaxValue;
end;

procedure TfrMyTextTemplate.SpeedButton2Click(Sender: TObject);
var i, nl, cmp : integer;
    s : string;
begin
  nl:=-1;
  s:='';
  if nom <= 0 then exit;
  cmp := SelectList(ComboBox1.Text);
  if cmp=-1 then exit;
  s:=frMyTextTemplate.Components[cmp].Name;
  frMyTextTemplate.Components[cmp].Free;
  //frMyTextTemplate.Components[cmp].Destroy;
  nom := nom - 1;
  Label1.Caption:='';
  if s<>'' then begin
    nl := myfindcomponent('lb'+trim(s));
    frMyTextTemplate.Components[nl].Free;
    //frMyTextTemplate.Components[nl].Destroy;
  end;
  Label3.Caption:=inttostr(nom);
  ReplaceTable(SpinEdit1.Value);
  SelectListsName;
  ComboBox1.ItemIndex:=ComboBox1.Items.Count-1;
  SelectList(ComboBox1.Text);
end;

procedure WriteBufferStr(F : tStream; astr : widestring);
var Len : longint;
begin
  len:=length(astr);
  F.WriteBuffer(Len, SizeOf(Len));
  if Len > 0 then F.WriteBuffer(astr[1],Length(astr)*SizeOf(astr[1]));
end;

Procedure ReadBufferStr(F : tStream; out astr : String);
var len : longint;
    ws : widestring;
begin
    F.ReadBuffer(len,sizeof(len));
    Setlength(ws,len);
    if len > 0 then F.ReadBuffer(ws[1],length(ws)*sizeof(ws[1]));
    astr:=ws;
end;

procedure SaveTextTemplateToFile(FName : string);
var Stream : TFileStream;
    nm, cph, renm, FileName : string;
    i, j, nl, cnt, cntlst, cntcol : integer;
begin
  //FileName:=PathClips + '\' + FName + '.TMPT';
  if FileExists(FName) then begin
    renm := ExtractFilePath(FName) + 'Temp.tmpt';
    RenameFile(FName,renm);
    DeleteFile(renm);
  end;
  cntlst := nom;
  cntcol := frMyTextTemplate.SpinEdit1.Value;
  Stream := TFileStream.Create(FName, fmCreate or fmShareDenyNone);
  try
    Stream.WriteBuffer(cntlst, SizeOf(cntlst));
    Stream.WriteBuffer(cntcol, SizeOf(cntcol));
    for i:=0 to frMyTextTemplate.ComponentCount-1 do begin
      if lowercase(frMyTextTemplate.Components[i].ClassName)='tlistbox' then begin
        nm := (frMyTextTemplate.Components[i] as TListBox).Name;
        nl := frMyTextTemplate.myfindcomponent('lb' + trim(nm));
        cph := (frMyTextTemplate.Components[nl] as TLabel).Caption;
        WriteBufferStr(Stream,nm);
        WriteBufferStr(Stream,cph);
        cnt := (frMyTextTemplate.Components[i] as TListBox).Count;
        Stream.WriteBuffer(cnt, SizeOf(cnt));
        for j:=0 to cnt-1 do WriteBufferStr(Stream,(frMyTextTemplate.Components[i] as TListBox).Items.Strings[j]);
      end;
    end;
  finally
    FreeAndNil(Stream);
  end;
end;

procedure LoadTextTemplateFromFile(FName : string);
var Stream : TFileStream;
    nm, cph, nnm, renm, FileName : string;
    i, j, nl, cnt, cntlst, cntcol : integer;
begin
  //FileName:=PathClips + '\' + FName + '.TMPT';
  //FileName:=PathClips + '\' + ClipName + '.Clip';
  if not FileExists(FName) then exit;
  Stream := TFileStream.Create(FName, fmOpenReadWrite or fmShareDenyNone);
  //cntlst := nom;
  //cntcol := frMyTextTemplate.SpinEdit1.Value;
  //Stream := TFileStream.Create(FName, fmCreate or fmShareDenyNone);
  try
    Stream.ReadBuffer(cntlst, SizeOf(cntlst));
    //nom:=cntlst;
    Stream.ReadBuffer(cntcol, SizeOf(cntcol));
    frMyTextTemplate.SpinEdit1.Value := cntcol;

    for i:=0 to cntlst-1 do begin
      ReadBufferStr(Stream,nm);
      ReadBufferStr(Stream,cph);
      nnm := frMyTextTemplate.MyListCreate;
      j := frMyTextTemplate.myfindcomponent(trim(nnm));
      nl := frMyTextTemplate.myfindcomponent('lb' + trim(nnm));
      (frMyTextTemplate.Components[j] as TListBox).Name := nm;
      (frMyTextTemplate.Components[nl] as TLabel).Name := 'lb' + trim(nm);
      (frMyTextTemplate.Components[nl] as TLabel).Caption := cph;
      Stream.ReadBuffer(cnt, SizeOf(cnt));
      (frMyTextTemplate.Components[j] as TListBox).Clear;
      for nl:=0 to cnt-1 do begin
        ReadBufferStr(Stream,nm);
        (frMyTextTemplate.Components[j] as TListBox).Items.Add(nm);
      end;
    end;
  finally
    FreeAndNil(Stream);
  end;
end;

procedure TfrMyTextTemplate.FormCreate(Sender: TObject);
begin
  if fileexists('Sample.tmpt') then begin
    LoadTextTemplateFromFile('Sample.tmpt');
    SelectListsName;
    ComboBox1.ItemIndex:=0;
    SelectList(ComboBox1.Text);
  end;
end;

procedure TfrMyTextTemplate.SpeedButton3Click(Sender: TObject);
var cmp : integer;
begin
  cmp := SelectList(ComboBox1.Text);
  if cmp<>-1 then EditMyListTemplate(cmp);
end;

procedure TfrMyTextTemplate.ComboBox1Change(Sender: TObject);
begin
  SelectList(ComboBox1.Text);
end;

procedure TfrMyTextTemplate.SpeedButton4Click(Sender: TObject);
begin
  if not Panel1.Visible then begin
    Panel1.Visible:=true;
    Panel3.Visible:=false;
  end;
//  SaveTextTemplateToFile('Sample.tmpt');
//  SetMyTextTemplate('');
end;

procedure TfrMyTextTemplate.SpeedButton5Click(Sender: TObject);
begin
  if Panel1.Visible then begin
    Panel1.Visible:=false;
    Panel3.Visible:=true;
  end;
end;

procedure TfrMyTextTemplate.SpeedButton6Click(Sender: TObject);
begin
  SaveTextTemplateToFile('Sample.tmpt');
  Close;
  ModalResult:=mrOk;
end;

procedure TfrMyTextTemplate.SpeedButton7Click(Sender: TObject);
begin
  Close;
  ModalResult:=mrCancel;
end;

procedure TfrMyTextTemplate.SpeedButton8Click(Sender: TObject);
begin
  SaveTextTemplateToFile('Sample.tmpt');
  Close;
  ModalResult:=mrOk;
end;

procedure TfrMyTextTemplate.SpeedButton9Click(Sender: TObject);
begin
  Close;
  ModalResult:=mrCancel;
end;

Procedure MyTextTemplateOptions;
begin
  with frMyTextTemplate do begin
    Panel3.Visible := true;
    Panel1.Visible := false;
    ShowModal;
    if ModalResult=mrOk then SaveTextTemplateToFile('Sample.tmpt');
  end;
end;

function MySetTextTemplate(src : string) : string;
begin
  result:=src;
  with frMyTextTemplate do begin
    Panel3.Visible := true;
    Panel1.Visible := false;
    Edit1.Text := src;
    ShowModal;
    if ModalResult=mrOk then result := trim(Edit1.Text);
  end;
end;

end.
