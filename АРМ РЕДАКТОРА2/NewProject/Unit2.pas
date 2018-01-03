unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TForm2 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure WMSize(var Msg: TWMSIZE); message WM_SIZE;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.WMSize(var Msg: TWMSize);
 begin
   if Msg.SizeType = SIZE_MINIMIZED then
     ShowWindow(Handle, SW_HIDE);
 end;

end.
 