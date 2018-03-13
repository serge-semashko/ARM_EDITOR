unit UPortOptions;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
    Vcl.ExtCtrls,
    Math, FastDIB, FastFX, FastSize, FastFiles, FConvert, FastBlend, Utils,
    StrUtils,
    Vcl.Buttons;

type
    TOneOption = class
        Name: string;
        RTN: trect;
        Text: string;
        VarText: string;
        RTT: trect;
        EditType: integer;
        select: boolean;
        constructor create(SName, SText, SVarText: string);
        destructor destroy;
    end;

    TProgOptions = class
        Count: integer;
        Options: array of TOneOption;
        procedure draw(cv: tcanvas; HeightRow: integer);
        procedure MouseMove(cv: tcanvas; X, Y: integer);
        function ClickMouse(cv: tcanvas; X, Y: integer): integer;
        function Add(Name, Text, VarText: string): integer;
        function Get(Name: string): string;
        procedure LoadData;
        procedure SaveData;
        procedure clear;
        Constructor create;
        Destructor destroy;
    end;

    TfrOptions = class(TForm)
        Panel1: TPanel;
        Panel2: TPanel;
        ImgOptions: TImage;
        Edit1: TEdit;
        ComboBox1: TComboBox;
        SpeedButton1: TSpeedButton;
        SpeedButton2: TSpeedButton;
        procedure ImgOptionsMouseMove(Sender: TObject; Shift: TShiftState;
          X, Y: integer);
        procedure ImgOptionsMouseUp(Sender: TObject; Button: TMouseButton;
          Shift: TShiftState; X, Y: integer);
        procedure Edit1Change(Sender: TObject);
        procedure Edit1KeyDown(Sender: TObject; var Key: Word;
          Shift: TShiftState);
        procedure Edit1KeyPress(Sender: TObject; var Key: Char);
        procedure ComboBox1Change(Sender: TObject);
        procedure SpeedButton2Click(Sender: TObject);
        procedure SpeedButton1Click(Sender: TObject);
        procedure FormCreate(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    frOptions: TfrOptions;
    ProgOptions: TProgOptions;
    indxoption: integer = -1;

procedure setoptions;

implementation

uses mainunit, ucommon, comportunit, umyinitfile;

{$R *.dfm}

procedure setoptions;
begin
    if ProgOptions = nil then
        ProgOptions := TProgOptions.create;
    ProgOptions.LoadData;
    frOptions.ComboBox1.clear;
    frOptions.Edit1.Height := frOptions.ComboBox1.Height;
    ProgOptions.draw(frOptions.ImgOptions.Canvas, frOptions.ComboBox1.Height);
    frOptions.ImgOptions.Repaint;
    frOptions.Show;
    // if frOptions.ModalResult=mrOk then begin
    //
    // end;
end;

procedure GetListParam(SrcStr: string; lst: tstrings);
var
    ssrc, sstr, stmp, ssc, ss1, ss2: string;
    i, pss, pse, ps1, ps2: integer;
begin
    lst.clear;
    pss := 1;
    pse := posex('|', SrcStr, pss);
    while pse <> 0 do
    begin
        stmp := copy(SrcStr, pss, pse - pss);
        stmp := StringReplace(stmp, '|', '', [rfReplaceAll, rfIgnoreCase]);
        if trim(stmp) <> '' then
        begin
            ps1 := posex('[', stmp, 1);
            ps2 := posex(']', stmp, ps1);
            if (ps1 <> 0) and (ps2 <> 0) then
            begin
                ssc := copy(stmp, 1, ps1 - 1);
                ss1 := copy(stmp, ps1 + 1, ps2 - ps1 - 1);
                ps1 := posex('..', ss1, 1);
                if ps1 <> 0 then
                begin
                    ss2 := copy(ss1, ps1 + 2, length(ss1));
                    ss1 := copy(ss1, 1, ps1 - 1);
                    for i := strtoint(ss1) to strtoint(ss2) do
                        lst.Add(ssc + inttostr(i));
                end
                else
                    lst.Add(stmp);
            end
            else
                lst.Add(stmp);
        end;
        pss := pse + 1;
        pse := posex('|', SrcStr, pss);
    end;
    stmp := copy(SrcStr, pss, length(SrcStr));
    stmp := StringReplace(stmp, '|', '', [rfReplaceAll, rfIgnoreCase]);
    if trim(stmp) <> '' then
    begin
        ps1 := posex('[', stmp, 1);
        ps2 := posex(']', stmp, ps1);
        if (ps1 <> 0) and (ps2 <> 0) then
        begin
            ssc := copy(stmp, 1, ps1 - 1);
            ss1 := copy(stmp, ps1 + 1, ps2 - ps1 - 1);
            ps1 := posex('..', ss1, 1);
            if ps1 <> 0 then
            begin
                ss2 := copy(ss1, ps1 + 2, length(ss1));
                ss1 := copy(ss1, 1, ps1 - 1);
                for i := strtoint(ss1) to strtoint(ss2) do
                    lst.Add(ssc + inttostr(i));
            end
            else
                lst.Add(stmp);
        end
        else
            lst.Add(stmp);
    end;
end;

Constructor TProgOptions.create;
begin
    Count := 0;
end;

procedure TProgOptions.clear;
var
    i: integer;
begin
    for i := Count - 1 downto 0 do
    begin
        Options[Count - 1].FreeInstance;
        Count := Count - 1;
        setlength(Options, Count);
    end;
    Count := 0;
end;

Destructor TProgOptions.destroy;
begin
    clear;
    freemem(@Count);
    freemem(@Options);
end;

procedure TProgOptions.draw(cv: tcanvas; HeightRow: integer);
var
    tmp: tfastdib;
    i, wdth, hght, rowhght, top, ps: integer;
begin
    // init(cv);
    tmp := tfastdib.create;
    try
        wdth := cv.ClipRect.Right - cv.ClipRect.Left;
        hght := cv.ClipRect.Bottom - cv.ClipRect.top;
        tmp.SetSize(wdth, hght, 32);
        tmp.clear(TColorToTfcolor(ProgrammColor));
        tmp.SetBrush(bs_solid, 0, colortorgb(ProgrammColor));
        tmp.FillRect(Rect(0, 0, tmp.Width, tmp.Height));
        tmp.SetTransparent(true);
        tmp.SetPen(ps_Solid, 1, colortorgb(ProgrammFontColor));
        tmp.SetTextColor(colortorgb(ProgrammFontColor));
        tmp.SetFont(ProgrammFontName, MTFontSize);
        top := 10;
        ps := (wdth - 10) div 2;
        for i := 0 to Count - 1 do
        begin
            Options[i].RTN.Left := 5;
            Options[i].RTN.Right := Options[i].RTN.Left + ps - 5;
            Options[i].RTN.top := top;
            top := top + HeightRow;
            Options[i].RTN.Bottom := top;
            Options[i].RTT.Left := Options[i].RTN.Right + 5;
            Options[i].RTT.Right := wdth - 5;
            Options[i].RTT.top := Options[i].RTN.top;
            Options[i].RTT.Bottom := Options[i].RTN.Bottom;

            if Options[i].select then
            begin
                tmp.Rectangle(Options[i].RTT.Left, Options[i].RTT.top,
                  Options[i].RTT.Right, Options[i].RTT.Bottom);
            end;
            tmp.DrawText(Options[i].Name, Options[i].RTN,
              DT_VCENTER or DT_SINGLELINE);
            tmp.DrawText(Options[i].Text, Options[i].RTT,
              DT_VCENTER or DT_SINGLELINE);
        end;
        tmp.SetTransparent(false);
        tmp.DrawRect(cv.Handle, cv.ClipRect.Left, cv.ClipRect.top,
          cv.ClipRect.Right, cv.ClipRect.Bottom, 0, 0);
        cv.Refresh;
    finally
        tmp.Free;
        tmp := nil;
    end;
end;

procedure TProgOptions.MouseMove(cv: tcanvas; X, Y: integer);
var
    i: integer;
begin
    for i := 0 to Count - 1 do
        Options[i].select := false;
    for i := 1 to Count - 1 do
    begin
        if (X > Options[i].RTT.Left) and (X < Options[i].RTT.Right) and
          (Y > Options[i].RTT.top) and (Y < Options[i].RTT.Bottom) then
        begin
            Options[i].select := true;
            exit;
        end;
    end;
end;

function TProgOptions.ClickMouse(cv: tcanvas; X, Y: integer): integer;
var
    i: integer;
begin
    result := -1;
    for i := 0 to Count - 1 do
        Options[i].select := false;
    for i := 1 to Count - 1 do
    begin
        if (X > Options[i].RTT.Left) and (X < Options[i].RTT.Right) and
          (Y > Options[i].RTT.top) and (Y < Options[i].RTT.Bottom) then
        begin
            result := i;
            // Options[i].select:=true;
            exit;
        end;
    end;
end;

function TProgOptions.Add(Name, Text, VarText: string): integer;
begin
    Count := Count + 1;
    setlength(Options, Count);
    Options[Count - 1] := TOneOption.create(Name, Text, VarText);
    result := Count - 1;
end;

function TProgOptions.Get(Name: string): string;
var
    i: integer;
begin
    for i := 0 to Count - 1 do
    begin
        if ansilowercase(trim(Options[i].Name)) = ansilowercase(trim(Name)) then
        begin
            result := Options[i].Text;
            exit;
        end;
    end;
end;

procedure TProgOptions.LoadData;
Var
    ss: string;
begin
    clear;
    Add('Серейный номер:', SerialNumber, ''); // : string = 'DM000001';
    Add('Номер устройства:', inttostr(ManagerNumber), '');
    Options[Count - 1].EditType := 0; // : integer = 0;
    if Port422select then
        ss := 'RS232/422'
    else
        ss := 'IP Адрес';
    Add('Порт передачи данных:', ss, 'RS232/422|IP Адрес');
    ss := trim(GetSerialPortNames(ListComports));
    ss := StringReplace(ss, ',', '|', [rfReplaceAll, rfIgnoreCase]);
    Add('Последовательный порт:', Port422Name, ss); // : string ='';
    // Add('',Port422Number,''); //: integer = 0;
    Add('Скорость порта (бит/сек):', Port422Speed,
      '1200|2400|4800|9600|14400|19200|38400|57600|115200');
    // : string = '38400';
    Add('Количество бит:', Port422Bits, '8|7|6|5'); // : string = '8';
    Add('Четность:', Port422Parity, 'нет|чет|нечет|маркер|пробел');
    // : string = 'нечет';
    Add('Количество стоп бит:', Port422Stop, '1|1.5|2'); // : string = '1';
    Add('Управление потоком:', Port422Flow, 'нет|аппаратный|XOn/XOff');
    // : string = 'нет';
    Add('IP Адрес:', IPAdress, '');
    Options[Count - 1].EditType := 1; // : string = '192.168.000.010';
    Add('IP Порт', IPPort, '');
    Options[Count - 1].EditType := 0; // : string = '9009';
    Add('IP Абонент:', IPLogin, ''); // : string = '';
    Add('IP Пароль:', IPPassword, ''); // : string = '';
    Add('URL Управляющего WEB сервера:', URLServer, '');
    // : string = 'http://localhost:9090/GET_TLEDITOR';
    if AutoStart then
        ss := 'Да'
    else
        ss := 'Нет';
    Add('Авто запуск программы:', ss, 'Да|Нет'); // : boolean = false;
    if MakeLogging then
        ss := 'Да'
    else
        ss := 'Нет';
    Add('Выполнять логирование:', ss, 'Да|Нет'); // : boolean = true;
    Add('Высота шрифта:', inttostr(MTFontSize), '');
    Options[Count - 1].EditType := 0;
end;

procedure TProgOptions.SaveData;
Var
    ss: string;
begin
    ss := Get('Номер устройства:');
    if trim(ss) = '' then
        ManagerNumber := 0
    else
        ManagerNumber := strtoint(ss);
    ss := Get('Порт передачи данных:');
    if trim(ss) = 'RS232/422' then
        Port422select := true
    else
        Port422select := false;

    Port422Name := trim(Get('Последовательный порт:'));

    if trim(Port422Name) = '' then
        Port422Number := -1
    else
        Port422Number := ListComports.IndexOf(Port422Name);

    Port422Speed := Get('Скорость порта (бит/сек):');
    Port422Bits := Get('Количество бит:');
    Port422Parity := Get('Четность:');
    Port422Stop := Get('Количество стоп бит:');
    Port422Flow := Get('Управление потоком:');

    IPAdress := Get('IP Адрес:');
    IPPort := Get('IP Порт');
    IPLogin := Get('IP Абонент:');
    IPPassword := Get('IP Пароль:');
    URLServer := Get('URL Управляющего WEB сервера:');

    ss := Get('Авто запуск программы:');
    if ansilowercase(trim(ss)) = 'да' then
        AutoStart := true
    else
        AutoStart := false;

    ss := Get('Выполнять логирование:');
    if ansilowercase(trim(ss)) = 'да' then
        MakeLogging := true
    else
        MakeLogging := false;

    ss := Get('Высота шрифта:');
    if trim(ss) = '' then
        MTFontSize := MTFontSize
    else
        MTFontSize := strtoint(ss);
end;

constructor TOneOption.create(SName, SText, SVarText: string);
begin
    initrect(RTN);
    Name := SName;
    initrect(RTT);
    Text := SText;
    VarText := SVarText;
    EditType := -1;
    select := false;
end;

destructor TOneOption.destroy;
begin
    freemem(@RTN);
    freemem(@Name);
    freemem(@RTT);
    freemem(@Text);
    freemem(@EditType);
    freemem(@select);
end;

procedure TfrOptions.ComboBox1Change(Sender: TObject);
begin
    if indxoption = -1 then
        exit;
    ProgOptions.Options[indxoption].Text := ComboBox1.Items.Strings
      [ComboBox1.ItemIndex];
    ProgOptions.draw(ImgOptions.Canvas, ComboBox1.Height);
    ImgOptions.Repaint;
end;

procedure TfrOptions.Edit1Change(Sender: TObject);
var
    s: string;
    indx: integer;
begin
    if indxoption = -1 then
        exit;
    if ProgOptions.Options[indxoption].EditType = 1 then
    begin
        s := trim(Edit1.Text);
        if length(s) > 15 then
            s := copy(s, 1, 15);
        Edit1.Text := s;
    end;
    ProgOptions.Options[indxoption].Text := Edit1.Text;
    ProgOptions.draw(ImgOptions.Canvas, ComboBox1.Height);
    ImgOptions.Repaint;
end;

procedure TfrOptions.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if indxoption = -1 then
        exit;
    if ProgOptions.Options[indxoption].EditType >= 0 then
        if Key = 46 then
            Key := 0;
end;

procedure TfrOptions.Edit1KeyPress(Sender: TObject; var Key: Char);
var
    s: string;
    i, p1, p2, p3: integer;
begin
    if ProgOptions.Options[indxoption].EditType = 1 then
    begin
        if not(Key in ['0' .. '9', #8]) then
        begin
            Key := #0;
            exit;
        end;
        s := Edit1.Text;
        p2 := Edit1.SelStart;
        Case Key of
            #8:
                begin
                    if Edit1.SelLength = 0 then
                    begin
                        if (p2 <> 4) and (p2 <> 8) and (p2 <> 12) then
                        begin
                            s[p2] := '0';
                            Edit1.Text := s;
                            Key := #0;
                            if p2 > 0 then
                                Edit1.SelStart := p2 - 1;
                        end
                        else
                        begin
                            s[p2] := '.';
                            Edit1.Text := s;
                            Key := #0;
                            if p2 > 0 then
                                Edit1.SelStart := p2 - 1;
                        end;
                    end
                    else
                    begin
                        for i := p2 + 1 to p2 + Edit1.SelLength do
                        begin
                            if (i <> 4) and (i <> 8) and (i <> 12) then
                                s[i] := '0';
                        end;
                        Edit1.SelLength := 0;
                        Edit1.Text := s;
                        if (p2 = 3) or (p2 = 7) or (p2 = 12) then
                            Edit1.SelStart := p2 + 1;
                        if p2 > 0 then
                            Key := s[p2 - 1];
                    end;
                end;
            '0' .. '9':
                begin
                    if (p2 = 3) or (p2 = 7) or (p2 = 11) then
                        p2 := p2 + 1;
                    if (p2 <> 3) and (p2 <> 7) and (p2 <> 11) then
                    begin
                        if p2 < 15 then
                            p2 := p2 + 1
                        else
                            p2 := 16;
                        s[p2] := Key;
                        Edit1.Text := s;
                        Key := #0;
                        if p2 <= 15 then
                        begin
                            if (p2 = 3) or (p2 = 7) or (p2 = 11) then
                                Edit1.SelStart := p2 + 1
                            else
                                Edit1.SelStart := p2;
                        end;
                    end;
                end;
        End;
        exit;
    end;
    if ProgOptions.Options[indxoption].EditType = 0 then
    begin
        if not(Key in ['0' .. '9', #8]) then
        begin
            Key := #0;
            exit;
        end;
    end;
end;

procedure TfrOptions.FormCreate(Sender: TObject);
begin
    frOptions.Color := ProgrammColor;
    frOptions.Font.Name := ProgrammFontName;
    frOptions.Font.Size := ProgrammFontSize;
    frOptions.Font.Color := ProgrammFontColor;

    Panel1.Color := ProgrammColor;
    Panel1.Font.Name := ProgrammFontName;
    Panel1.Font.Size := ProgrammFontSize;
    Panel1.Font.Color := ProgrammFontColor;

    Edit1.Color := ProgrammEditColor;
    Edit1.Font.Name := ProgrammEditFontName;
    Edit1.Font.Size := ProgrammEditFontSize;
    Edit1.Font.Color := ProgrammEditFontColor;

    ComboBox1.Color := ProgrammEditColor;
    ComboBox1.Font.Name := ProgrammEditFontName;
    ComboBox1.Font.Size := ProgrammEditFontSize;
    ComboBox1.Font.Color := ProgrammEditFontColor;
end;

procedure TfrOptions.ImgOptionsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
    ProgOptions.MouseMove(ImgOptions.Canvas, X, Y);
    ProgOptions.draw(ImgOptions.Canvas, ComboBox1.Height);
    ImgOptions.Repaint;
    // if Edit1.Visible then Edit1.Visible := false;
    if ComboBox1.Visible then
        ComboBox1.Visible := false;
end;

procedure TfrOptions.ImgOptionsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
    indxoption := ProgOptions.ClickMouse(ImgOptions.Canvas, X, Y);
    Edit1.Visible := false;
    ComboBox1.Visible := false;
    if indxoption <> -1 then
    begin
        if trim(ProgOptions.Options[indxoption].VarText) = '' then
        begin
            Edit1.Left := ProgOptions.Options[indxoption].RTT.Left;
            Edit1.top := ProgOptions.Options[indxoption].RTT.top;
            Edit1.Width := ProgOptions.Options[indxoption].RTT.Right -
              ProgOptions.Options[indxoption].RTT.Left;
            Edit1.Text := ProgOptions.Options[indxoption].Text;
            Edit1.Visible := true;
        end
        else
        begin
            ComboBox1.Left := ProgOptions.Options[indxoption].RTT.Left;
            ComboBox1.top := ProgOptions.Options[indxoption].RTT.top;
            ComboBox1.Width := ProgOptions.Options[indxoption].RTT.Right -
              ProgOptions.Options[indxoption].RTT.Left;
            ComboBox1.clear;
            GetListParam(ProgOptions.Options[indxoption].VarText,
              ComboBox1.Items);
            ComboBox1.ItemIndex := ComboBox1.Items.IndexOf
              (ProgOptions.Options[indxoption].Text);
            ComboBox1.Visible := true;
        end;
    end;
    ProgOptions.draw(ImgOptions.Canvas, ComboBox1.Height);
    ImgOptions.Repaint;
end;

procedure TfrOptions.SpeedButton1Click(Sender: TObject);
begin
    ProgOptions.SaveData;
    if Port422select then
    begin
        fmMain.Timer1.Enabled := false;
        StopService;
        fmMain.ComportInit;
        fmMain.Timer1.Enabled := true;
    end;
    Edit1.Visible := false;
    ComboBox1.Visible := false;
    SetIconApplication(fmMain.image1, ManagerNumber);
    ProgOptions.draw(ImgOptions.Canvas, ComboBox1.Height);
    ImgOptions.Repaint;
    if AutoStart then
        AutoStartEnable
    else
        AutoStartDisable;

    // close;
end;

procedure TfrOptions.SpeedButton2Click(Sender: TObject);
begin
    Close;
end;

end.
