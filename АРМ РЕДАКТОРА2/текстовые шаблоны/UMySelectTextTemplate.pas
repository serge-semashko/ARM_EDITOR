unit UMySelectTextTemplate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls;

type
  TfrMySelectTextTemplate = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure MyListBoxClick(Sender: TObject);
    function MyListCreate : string;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ReplaceTable(count : integer);
    function myfindcomponent(name : string) : integer;
    function ExistsListBoxName(Name : string) : boolean;
  end;

var
  frMySelectTextTemplate: TfrMySelectTextTemplate;
  mylistbox : tlistbox;
  mylabel : tlabel;
  nom : integer = 0;
  CountCol : integer =1;
  LabelHeight : integer = 20;
  LabelName : string = '';

function SetMyTextTemplate(src : string) : string;

implementation

uses umytexttemplate;

{$R *.dfm}

function TfrMySelectTextTemplate.ExistsListBoxName(Name : string) : boolean;
var i : integer;
begin
  result := false;
  for i:=0 to frMySelectTextTemplate.ComponentCount-1 do begin
    if lowercase(frMySelectTextTemplate.Components[i].ClassName)='tlistbox' then begin
      if lowercase(frMySelectTextTemplate.Components[i].Name)=lowercase(name) then begin
        result:=true;
        exit;
      end;
    end;
  end;
end;

Procedure EraseMyLists;
var i, nl, cmp : integer;
    s : string;
begin
  for i:=frMySelectTextTemplate.ComponentCount-1 downto 0
    do if (lowercase(frMySelectTextTemplate.Components[i].ClassName)='tlistbox') or
       (lowercase(frMySelectTextTemplate.Components[i].ClassName)='tlabel')
         then frMySelectTextTemplate.Components[i].Free;
  nom:=0;
end;

procedure TfrMySelectTextTemplate.MyListBoxClick(Sender: TObject);
var i, j, nl : integer;
begin
  for j:=0 to frMySelectTextTemplate.ComponentCount-1 do begin
    if lowercase(frMySelectTextTemplate.Components[j].ClassName)='tlistbox' then begin
      nl := myfindcomponent('lb' + trim((frMySelectTextTemplate.Components[j] as TListBox).Name));
      (frMySelectTextTemplate.Components[nl] as TLabel).Font.Color:=clSilver;
      (frMySelectTextTemplate.Components[nl] as TLabel).Font.Style:=(frMySelectTextTemplate.Components[nl] as TLabel).Font.Style - [fsBold];
      //(frMySelectTextTemplate.Components[j] as TListBox).Repaint;
    end;
  end;
  LabelName := (Sender as tlistbox).Name;
  nl := myfindcomponent('lb' + trim((Sender as tlistbox).Name));
  (frMySelectTextTemplate.Components[nl] as TLabel).Font.Color:=clWhite;
  (frMySelectTextTemplate.Components[nl] as TLabel).Font.Style:=(frMySelectTextTemplate.Components[nl] as TLabel).Font.Style + [fsBold];
  for i:=0 to (Sender as tlistbox).Count-1 do begin
    if (Sender as tlistbox).Selected[i] then begin
      if trim(Edit1.Text)=''
        then Edit1.Text := (Sender as tlistbox).Items[i]
        else Edit1.Text := Edit1.Text + ', ' + (Sender as tlistbox).Items[i];
      (Sender as tlistbox).Selected[i] := false;
    end;
  end;
end;

function TfrMySelectTextTemplate.myfindcomponent(name : string) : integer;
var i : integer;
begin
  result := -1;
  for i:=0 to frMySelectTextTemplate.ComponentCount-1 do begin
    if lowercase(frMySelectTextTemplate.Components[i].Name)=lowercase(name) then begin
      result:=i;
      exit;
    end;
  end;
end;

procedure TfrMySelectTextTemplate.ReplaceTable(count : integer);
var i, j, lft, tp, wdth, hgh1, hgh2, rw, cl, cnt, nlabel : integer;
    s : string;
begin
   wdth:=Panel2.Width div count;
   lft := 0;
   tp := 0;
   rw := nom div count;
   cnt := nom mod count;

   if cnt<>0 then begin
     hgh1 := Panel2.Height div (rw + 1);
     if rw=0 then hgh2 := Panel2.Height else hgh2 := Panel2.Height div (rw);
   end else begin
     if rw=0 then hgh1 := Panel2.Height else hgh1 := Panel2.Height div (rw);
     if rw=0 then hgh2 := Panel2.Height else hgh2 := Panel2.Height div (rw);
   end;
   j:=0;
   for i:=0 to frMySelectTextTemplate.ComponentCount-1 do begin
     if lowercase(frMySelectTextTemplate.Components[i].ClassName)='tlistbox' then begin
       s := 'lb' + trim(frMySelectTextTemplate.Components[i].Name);
       j:=j+1;
       rw:=j div count;
       cl:=j mod count;
       if cl=0 then begin
         rw:=rw-1;
         cl:=count;
       end;
       (frMySelectTextTemplate.Components[i] as TListBox).Left:=wdth * (cl-1);
       (frMySelectTextTemplate.Components[i] as TListBox).Width:=wdth;
       if cnt<>0 then begin
         if cl<=cnt then begin
           (frMySelectTextTemplate.Components[i] as TListBox).Top:=hgh1 * (rw) + LabelHeight;
           (frMySelectTextTemplate.Components[i] as TListBox).Height:=hgh1  - LabelHeight;
         end else begin
           (frMySelectTextTemplate.Components[i] as TListBox).Top:=hgh2 * (rw) + LabelHeight;
           (frMySelectTextTemplate.Components[i] as TListBox).Height:=hgh2 - LabelHeight;
         end;
       end else begin
         (frMySelectTextTemplate.Components[i] as TListBox).Top:=hgh2 * (rw) + LabelHeight;
         (frMySelectTextTemplate.Components[i] as TListBox).Height:=hgh2 - LabelHeight;
       end;
       nlabel := myfindcomponent(s);
       if nlabel<>-1 then begin
         //(frMySelectTextTemplate.Components[nlabel] as TLabel).Layout:=tlBottom;
         (frMySelectTextTemplate.Components[nlabel] as TLabel).Top:=(frMySelectTextTemplate.Components[i] as TListBox).Top - LabelHeight;
         (frMySelectTextTemplate.Components[nlabel] as TLabel).Left:=(frMySelectTextTemplate.Components[i] as TListBox).Left;
         (frMySelectTextTemplate.Components[nlabel] as TLabel).Width:=(frMySelectTextTemplate.Components[i] as TListBox).Width;
       end;
     end;
   end;
end;

function TfrMySelectTextTemplate.MyListCreate : string;
var i, nm : integer;
    snm : string;
begin
  mylabel:=tlabel.Create(frMySelectTextTemplate);
  mylabel.Parent:=Panel2;
  mylabel.AutoSize:=false;
  mylabel.Height:=LabelHeight;
  mylabel.Font.Color:=clSilver;
  mylabel.Color:=clBlack;
  mylabel.Alignment:=taCenter;
  mylabel.Layout:=tlCenter;
  mylabel.Font.Size:=11;
  mylistbox:=tlistbox.Create(frMySelectTextTemplate);
  mylistbox.Parent:=Panel2;
  nom:=nom + 1;
  //Label3.Caption:=inttostr(nom);
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
  //mylistbox.OnDblClick := MyListBoxDblClick;
  ReplaceTable(CountCol);
  result:=mylistbox.Name;
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

procedure LoadTextTemplateFromFile(FName : string);
var Stream : TFileStream;
    nm, cph, nnm, renm, FileName : string;
    i, j, nl, cnt, cntlst, cntcol : integer;
begin
  //FileName:=PathClips + '\' + FName + '.TMPT';
  //FileName:=PathClips + '\' + ClipName + '.Clip';
  if not FileExists(FName) then exit;
  Stream := TFileStream.Create(FName, fmOpenReadWrite or fmShareDenyNone);
  try
    Stream.ReadBuffer(cntlst, SizeOf(cntlst));
    //nom:=cntlst;
    Stream.ReadBuffer(countcol, SizeOf(countcol));

    for i:=0 to cntlst-1 do begin
      ReadBufferStr(Stream,nm);
      ReadBufferStr(Stream,cph);

      nnm := frMySelectTextTemplate.MyListCreate;
      j := frMySelectTextTemplate.myfindcomponent(trim(nnm));
      nl := frMySelectTextTemplate.myfindcomponent('lb' + trim(nnm));
      (frMySelectTextTemplate.Components[j] as TListBox).Name := nm;
      (frMySelectTextTemplate.Components[nl] as TLabel).Name := 'lb' + trim(nm);
      (frMySelectTextTemplate.Components[nl] as TLabel).Caption := cph;
      Stream.ReadBuffer(cnt, SizeOf(cnt));
      (frMySelectTextTemplate.Components[j] as TListBox).Clear;
      for nl:=0 to cnt-1 do begin
        ReadBufferStr(Stream,nm);
        (frMySelectTextTemplate.Components[j] as TListBox).Items.Add(nm);
      end;
    end;
  finally
    FreeAndNil(Stream);
  end;
end;

function SetMyTextTemplate(src : string) : string;
begin
  result:=src;
  frMySelectTextTemplate.Edit1.Text:=src;
  EraseMyLists;
  LoadTextTemplateFromFile('Sample.tmpt');
  frMySelectTextTemplate.ShowModal;
  if frMySelectTextTemplate.ModalResult = mrOk then begin
    result := frMySelectTextTemplate.Edit1.Text;
  end;
end;

procedure TfrMySelectTextTemplate.SpeedButton1Click(Sender: TObject);
begin
  ModalResult:=mrok;
end;

procedure TfrMySelectTextTemplate.SpeedButton2Click(Sender: TObject);
begin
  modalresult:=mrcancel;
end;

procedure TfrMySelectTextTemplate.SpeedButton3Click(Sender: TObject);
begin
  Edit1.Text:='';
end;

end.
