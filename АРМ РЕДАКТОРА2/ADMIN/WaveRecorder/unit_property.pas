unit unit_property;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, MMSystem;

type
TModeDescr=record
   Channels: integer;
   Rate: integer;
   Bits: integer;
   mode: DWORD;          // код режима работы
   descr: string[32];    // словесное описание
end;

  TformProperty = class(TForm)
    bitbtnOk: TBitBtn;
    ListBox: TListBox;
    ComboBox: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure bitbtnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowInfo;
  end;

var
  formProperty: TformProperty;

implementation
uses unit_main;
{$R *.DFM}

const
// массив содержит сопоставления режима работы и словесного описания
   modes: array [1..12] of TModeDescr=((Channels: 1; Rate: 11025; Bits: 8; mode: WAVE_FORMAT_1M08; descr:'11.025 kHz, mono, 8-bit'),
                                       (Channels: 1; Rate: 11025; Bits: 16; mode: WAVE_FORMAT_1M16; descr:'11.025 kHz, mono, 16-bit'),
                                       (Channels: 2; Rate: 11025; Bits: 8; mode: WAVE_FORMAT_1S08; descr:'11.025 kHz, stereo, 8-bit'),
                                       (Channels: 2; Rate: 11025; Bits: 16; mode: WAVE_FORMAT_1S16; descr:'11.025 kHz, stereo, 16-bit'),
                                       (Channels: 1; Rate: 22050; Bits: 8; mode: WAVE_FORMAT_2M08; descr:'22.05 kHz, mono, 8-bit'),
                                       (Channels: 1; Rate: 22050; Bits: 16; mode: WAVE_FORMAT_2M16; descr:'22.05 kHz, mono, 16-bit'),
                                       (Channels: 2; Rate: 22050; Bits: 8; mode: WAVE_FORMAT_2S08; descr:'22.05 kHz, stereo, 8-bit'),
                                       (Channels: 2; Rate: 22050; Bits: 16; mode: WAVE_FORMAT_2S16; descr:'22.05 kHz, stereo, 16-bit'),
                                       (Channels: 1; Rate: 44100; Bits: 8; mode: WAVE_FORMAT_4M08; descr:'44.1 kHz, mono, 8-bit'),
                                       (Channels: 1; Rate: 44100; Bits: 16; mode: WAVE_FORMAT_4M16; descr:'44.1 kHz, mono, 16-bit'),
                                       (Channels: 2; Rate: 44100; Bits: 8; mode: WAVE_FORMAT_4S08; descr:'44.1 kHz, stereo, 8-bit'),
                                       (Channels: 2; Rate: 44100; Bits: 16; mode: WAVE_FORMAT_4S16; descr:'44.1 kHz, stereo, 16-bit'));
procedure TformProperty.ShowInfo;
var
   WaveNums, i: integer;
   WaveInCaps: TWaveInCaps;   // структура в которую помещается информация об устройстве
begin
   WaveNums:=waveInGetNumDevs;
   if WaveNums>0 then         // если в системе есть устройства аудиоввода,то
   begin
      for i:=0 to WaveNums-1 do  // получаем характеристики всех имеющихся устройств
      begin
         waveInGetDevCaps(i,@WaveInCaps,sizeof(TWaveInCaps));
	 // добавляем наименование устройства
         ComboBox.Items.Add(PChar(@WaveInCaps.szPname));
      end;
      ComboBox.ItemIndex:=0;
      ComboBox.OnChange(self);
   end;
end;



procedure TformProperty.FormCreate(Sender: TObject);
begin
   ShowInfo;
end;

procedure TformProperty.ComboBoxChange(Sender: TObject);
var
   i: integer;
   WaveInCaps: TWaveInCaps;   // структура в которую помещается информация об устройстве
begin
   ListBox.Clear;
   for i:=1 to High(modes) do
   begin
     waveInGetDevCaps(ComboBox.ItemIndex,@WaveInCaps,sizeof(TWaveInCaps));
     // выводим поддерживаемые устройством режимы работы
     if (modes[i].mode and WaveInCaps.dwFormats)=modes[i].mode then
        ListBox.Items.Add(modes[i].descr);
   end;
end;

procedure TformProperty.bitbtnOkClick(Sender: TObject);
begin
   formMain.Channels:=modes[ListBox.ItemIndex+1].Channels;
   formMain.Rate:=modes[ListBox.ItemIndex+1].Rate;
   formMain.BitsPerSample:=modes[ListBox.ItemIndex+1].Bits;
   formMain.Device:=ComboBox.ItemIndex;
   // размер буфера для хранения 1/2 сек записи
   formMain.WaveDataLength:=formMain.Rate*formMain.Channels*
                            formMain.BitsPerSample div 8;
   formMain.WaveDataLength:=formMain.WaveDataLength div 2;

   formMain.spbtnRecord.Enabled:=True;
end;

end.
