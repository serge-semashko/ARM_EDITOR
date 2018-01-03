//Two versions :
//MediaInfo_* : Unicode
//MediaInfoA_* : Ansi
//If you prefer Ansi version (PChar instead of PWideChar), replace MediaInfo_ by MediaInfoA_

unit HowToUse_Dll_;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MediaInfoDll, Buttons;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure GetMediaInfo(FileName : string);
var
  vl, Handle: Cardinal;
  To_Display: WideString;
  CR: WideString;
  FL : PWideChar;
  S: AnsiString;
 W: WideString;
 P: PWideChar;
//begin
// S := "Hello, World!";
// W := S;
// P := PWideChar(W);
begin
  CR:=Chr(13) + Chr(10);

  To_Display := MediaInfo_Option (0, 'Info_Version', '');

  To_Display := To_Display + CR + CR + 'Info_Parameters' + CR;
  To_Display := To_Display + MediaInfo_Option (0, 'Info_Parameters', '');

//  To_Display := To_Display + CR + CR + 'Info_Capacities' + CR;
//  To_Display := To_Display + MediaInfo_Option (0, 'Info_Capacities', '');

//  To_Display := To_Display + CR + CR + 'Info_Codecs' + CR;
//  To_Display := To_Display + MediaInfo_Option (0, 'Info_Codecs', '');

  Handle := MediaInfo_New();

  To_Display := To_Display + CR + CR + 'Open' + CR;
  W:=FileName;
  FL := PWideChar(W);
  vl := MediaInfo_Open(Handle, FL);
  To_Display := To_Display + inttostr(vl);//'FileName >>>>> ' + format('%d', [MediaInfo_Open(Handle, PWideChar(FileName))]);

  To_Display := To_Display + CR + CR + 'Inform with Complete=false' + CR;
  MediaInfo_Option (2, 'Complete', '0');
  To_Display := To_Display + MediaInfo_Inform(Handle, 0);

  To_Display := To_Display + CR + CR + 'Inform with Complete=true' + CR;
  MediaInfo_Option (2, 'Complete', '1');
  To_Display := To_Display + MediaInfo_Inform(Handle, 0);

  To_Display := To_Display + CR + CR + 'Inform VideoAudio' + CR;
  MediaInfo_Option (0, 'VideoAudio', '');
  To_Display := To_Display + MediaInfo_Inform(Handle, 0);

  To_Display := To_Display + CR + CR + 'Custom Inform' + CR;
  MediaInfo_Option (0, 'Inform', 'General;Example : FileSize=%FileSize%');
  To_Display := To_Display + MediaInfo_Inform(Handle, 0);

  To_Display := To_Display + CR + CR + 'Custom Inform' + CR;
  MediaInfo_Option (0, 'Inform', 'General;Example : Audio=%Audio_Format_List%');
  To_Display := To_Display + MediaInfo_Inform(Handle, 0);

  To_Display := To_Display + CR + CR + 'Custom Inform' + CR;
  MediaInfo_Option (0, 'Inform', 'Video;Example : AspectRatio=%DisplayAspectRatio/String%');
  To_Display := To_Display + MediaInfo_Inform(Handle, 0);

  To_Display := To_Display + CR + CR + 'Custom Inform' + CR;
  MediaInfo_Option (0, 'Inform', 'Video;Width=%Width%');
  To_Display := To_Display + MediaInfo_Inform(Handle, 0);

  To_Display := To_Display + CR + CR + 'Custom Inform' + CR;
  MediaInfo_Option (0, 'Inform', 'Video;Height=%Height%');
  To_Display := To_Display + MediaInfo_Inform(Handle, 0);

  To_Display := To_Display + CR + CR + 'Custom Inform' + CR;
  MediaInfo_Option (0, 'Inform', 'Video;Format=%Format%');
  To_Display := To_Display + MediaInfo_Inform(Handle, 0);

  To_Display := To_Display + CR + CR + 'Custom Inform' + CR;
  MediaInfo_Option (0, 'Inform', 'Video;Format_Commercial=%Format_Commercial%');
  To_Display := To_Display + MediaInfo_Inform(Handle, 0);

  To_Display := To_Display + CR + CR + 'GetI with Stream=General and Parameter:=17' + CR;
  To_Display := To_Display + MediaInfo_GetI(Handle, Stream_General, 0, 17, Info_Text);

  To_Display := To_Display + CR + CR + 'Count_Get with StreamKind=Stream_Audio' + CR;
  To_Display := To_Display + format('%d', [MediaInfo_Count_Get(Handle, Stream_Audio, -1)]);

  To_Display := To_Display + CR + CR + 'Get with Stream:=General and Parameter=^AudioCount^' + CR;
  To_Display := To_Display + MediaInfo_Get(Handle, Stream_General, 0, 'AudioCount', Info_Text, Info_Name);

  To_Display := To_Display + CR + CR + 'Get with Stream:=Audio and Parameter=^StreamCount^' + CR;
  To_Display := To_Display + MediaInfo_Get(Handle, Stream_Audio, 0, 'StreamCount', Info_Text, Info_Name);

  To_Display := To_Display + CR + CR + 'Get with Stream:=General and Parameter=^FileSize^' + CR;
  To_Display := To_Display + MediaInfo_Get(Handle, Stream_General, 0, 'FileSize', Info_Text, Info_Name);

  To_Display := To_Display + CR + CR + 'Close' + CR;
  MediaInfo_Close(Handle);

  Form1.Memo1.Text := To_Display;
end;

procedure TForm1.FormCreate(Sender: TObject);
//var
//  Handle: Cardinal;
//  To_Display: WideString;
//  CR: WideString;
begin


  if fileexists('MediaInfo.dll') then showmessage('found') else showmessage('do not found');

  if (MediaInfoDLL_Load('MediaInfo.dll')=false) then
  begin
      Memo1.Text := 'Error while loading MediaInfo.dll';
      exit;
  end;

  GetMediaInfo('Example.ogg');

end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if opendialog1.Execute then begin
    memo1.Clear;
    GetMediaInfo(opendialog1.FileName);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Clear;
end;

end.
