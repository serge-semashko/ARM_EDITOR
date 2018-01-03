{
(c) Alexander Galilov, 2000
galilov@mail.ru
}
unit unit_main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MMSystem, ExtCtrls, Buttons;

type
// Заголовок Wave-файла
TWaveHeader = record
   Marker1:        Array[0..3] of Char;
   BytesFollowing: LongInt;
   Marker2:        Array[0..3] of Char;
   Marker3:        Array[0..3] of Char;
   Fixed1:         LongInt;
   FormatTag:      Word;
   Channels:       Word;
   SampleRate:     LongInt;
   BytesPerSecond: LongInt;
   BytesPerSample: Word;
   BitsPerSample:  Word;
   Marker4:        Array[0..3] of Char;
   DataBytes:      LongInt;
end;


  TformMain = class(TForm)
    Label1: TLabel;
    Bevel1: TBevel;
    panelToolBar: TPanel;
    spbtnRecord: TSpeedButton;
    spbtnStop: TSpeedButton;
    savedlgSave: TSaveDialog;
    spbtnProperty: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure spbtnPropertyClick(Sender: TObject);
    procedure spbtnRecordClick(Sender: TObject);
    procedure spbtnStopClick(Sender: TObject);
  private
    { Private declarations }
    WaveHeader: TWaveHeader;
    fOut: file of byte;
    n:        integer;
    WaveData1:PChar;
    WaveData2:PChar;
    wfx:      TWaveFormatEx;
    wh1,wh2:  TWaveHdr;
    hwi:      HWAVEIN;
    address:  pWaveHdr;
    stop:     boolean;
    procedure MMProcOpen(var Message: TMessage); message MM_WIM_OPEN;
    procedure MMProcClose(var Message: TMessage); message MM_WIM_CLOSE;
    procedure MMProcData(var Message: TMessage); message MM_WIM_DATA;
    procedure MakeHeader;
  public
    { Public declarations }
    Channels,BitsPerSample,Rate,WaveDataLength,device: integer;
    function StartLoader(fname:string): MMResult;
    function StopLoader: MMResult;
  end;

var
  formMain: TformMain;

implementation

uses unit_property;
{$R *.DFM}
//--------------------------------------------------------------------
// обработчик открытия устройства
// ничего не делает!!!
procedure TformMain.MMProcOpen(var Message: TMessage);
begin
   Exit;
end;
//--------------------------------------------------------------------
// обработчик закрытия
procedure TformMain.MMProcClose(var Message: TMessage);
begin
// создаем заголовок wave-файла
   MakeHeader;
   CloseFile(fOut);
   GlobalFree(integer(WaveData1));
   GlobalFree(integer(WaveData2));
end;
//--------------------------------------------------------------------
// обработчик "данные готовы"
procedure TformMain.MMProcData(var Message: TMessage);
var
   temp: pWaveHdr;
   recorded: integer;
begin
   temp:=address;
   if address=@wh1 then address:=@wh2 else address:=@wh1;
// если не остановлено, ставим в очередь
   if not stop then
        waveInAddBuffer(hwi,address,sizeof(TWaveHdr));
   recorded:=address.dwBytesRecorded;
// записываем блок
   BlockWrite(fOut,(temp.lpData)^,recorded);
   n:=n+recorded;
   formMain.Label1.Caption:=IntToStr(n);
end;
//--------------------------------------------------------------------
function TformMain.StartLoader(fname:string): MMResult;
begin
   n:=0;
   stop:=false;

   WaveData1:=PChar(
               GlobalAlloc(GMEM_FIXED or GMEM_NOCOMPACT or GMEM_NODISCARD,
               WaveDataLength));
   WaveData2:=PChar(
               GlobalAlloc(GMEM_FIXED or GMEM_NOCOMPACT or GMEM_NODISCARD,
               WaveDataLength));
   AssignFile(fOut,fname);
   ReWrite(fOut);
   // резервируем в файле место под заголовок
   BlockWrite(fOut,WaveHeader,sizeof(TWaveHeader));
   // инициализация структуры данных
   wfx.nChannels:=       Channels;       // один канал - МОНО, 2- СТЕРЕО
   wfx.wFormatTag:=      WAVE_FORMAT_PCM;// формат данных - PCM
   wfx.nSamplesPerSec:=  Rate;           // sample rate, Hz
   wfx.wBitsPerSample:=  BitsPerSample;  // бит/выборку
   wfx.nBlockAlign:=     wfx.nChannels*wfx.wBitsPerSample div 8;
   wfx.nAvgBytesPerSec:= RATE*wfx.nChannels*wfx.wBitsPerSample div 8;
   wfx.cbSize:=          0;              // в данном случае - игнорируется
   Result:=waveInOpen(@hwi,device,@wfx,self.Handle,
                     0,CALLBACK_WINDOW);
   if Result<>MMSYSERR_NOERROR then Exit;
// готовим заголовки для двух буферов
   wh1.lpData:=WaveData1;
   wh1.dwBufferLength:=WaveDataLength*sizeof(byte);
   wh1.dwUser:=0;
   wh1.dwFlags:=0;

   wh2.lpData:=WaveData2;
   wh2.dwBufferLength:=WaveDataLength*sizeof(byte);
   wh2.dwUser:=0;
   wh2.dwFlags:=0;

   address:=@wh1;

   Result:=waveInPrepareHeader(hwi,@wh1,sizeof(TWaveHdr));
   if Result<>MMSYSERR_NOERROR then Exit;

   Result:=waveInPrepareHeader(hwi,@wh2,sizeof(TWaveHdr));
   if Result<>MMSYSERR_NOERROR then Exit;

// ставим первый буфер в очередь на загрузку
   Result:=waveInAddBuffer(hwi,@wh1,sizeof(TWaveHdr));
   if Result<>MMSYSERR_NOERROR then Exit;
// запускае оцифровку
   Result:=waveInStart(hwi);
   if Result<>MMSYSERR_NOERROR then Exit;
end;
//--------------------------------------------------------------------
function TformMain.StopLoader: MMResult;
begin
   stop:=true;  // флаг остановки
   Result:=waveInReset(hwi);
   Result:=Result or waveInClose(hwi);
end;
//--------------------------------------------------------------------
procedure TformMain.MakeHeader;
begin
   with WaveHeader do
   begin
      Marker1 := 'RIFF';
      BytesFollowing := n + 36;
      Marker2 := 'WAVE';
      Marker3 := 'fmt ';
      Fixed1 := 16;
      FormatTag := 1;
      SampleRate := Rate;
      Channels := self.Channels;
      BytesPerSecond := Channels;
      BytesPerSecond := WaveHeader.BytesPerSecond * Rate;
      BytesPerSecond := WaveHeader.BytesPerSecond * self.BitsPerSample;
      BytesPerSecond := WaveHeader.BytesPerSecond div 8;
      BytesPerSample := Channels * self.BitsPerSample div 8;
      BitsPerSample := self.BitsPerSample;
      Marker4 := 'data';
      DataBytes := self.n;
   end;
   Reset(fOut);
   BlockWrite(fOut,WaveHeader,sizeof(TWaveHeader));
end;

//--------------------------------------------------------------------
procedure TformMain.FormCreate(Sender: TObject);
begin
   device:=0;
   Rate:=0;
   WaveDataLength:=0;
   Channels:=0;
   BitsPerSample:=0;
end;
//--------------------------------------------------------------------
procedure TformMain.spbtnPropertyClick(Sender: TObject);
begin
   formProperty.ShowModal;
end;
//--------------------------------------------------------------------
procedure TformMain.spbtnRecordClick(Sender: TObject);
var
   filename: string;
   res: MMResult;
   msg: array [0..255] of char;
begin
   if savedlgSave.Execute then
   begin
      spbtnRecord.Enabled:=false;
      filename:=savedlgSave.FileName;
      spbtnStop.Enabled:=True;
      res:=StartLoader(filename);
      if res<>MMSYSERR_NOERROR then
      begin
         waveInGetErrorText(res,msg,256);
         MessageBox(Handle,msg,'ОШИБКА!',MB_OK or MB_ICONSTOP);
         Application.Terminate;
      end;
   end;
end;
//--------------------------------------------------------------------
procedure TformMain.spbtnStopClick(Sender: TObject);
begin
   StopLoader;
   spbtnRecord.Enabled:=true;
   spbtnStop.Enabled:=false;
end;
//--------------------------------------------------------------------
end.
