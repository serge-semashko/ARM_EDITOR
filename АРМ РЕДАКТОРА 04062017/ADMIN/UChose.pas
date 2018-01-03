unit UChose;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, Grids, Vcl.StdCtrls;

  procedure BTNSPNUSERS(Res : integer);
  procedure BTNSPNMENU(res : integer);

implementation
uses umain, ucommon, unewuser, ugrid, uinitforms;

procedure BTNSPNUSERS(Res : integer);
var i :integer;
Begin
  with form1 do begin
       case res of
  0 : EditUser(-1);
  1 : if (GridUsers.Row > 0) and (GridUsers.Row < GridUsers.RowCount) then EditUser(GridUsers.Row);
  2 : begin
        if GridUsers.RowCount=2 then begin
            (GridUsers.Objects[0,1] as TGridRows).Assign(RowGridUsers);
        end else begin
          for i:=GridUsers.Row to GridUsers.RowCount-2 do begin
            (GridUsers.Objects[0,i] as TGridRows).Assign((GridUsers.Objects[0,i+1] as TGridRows));
          end;
          GridUsers.Objects[0,GridUsers.RowCount-1] := nil;
          GridUsers.RowCount := GridUsers.RowCount - 1;
        end;
      end;
       end;
    WriteUsersToFile('workingdata.dll',GridUsers);
    GridUsers.Repaint;
  end;
End;

procedure BTNSPNMENU(res : integer);
begin
  with form1 do begin
    panelusers.Visible := false;
    panelprog.Visible := false;
       case res of
  0 : begin
        panelusers.Visible := true;
        InitUsersPanel;
      end;
  1 : begin
        panelprog.Visible := true;
        initPanelProg;
      end;

       end;
  end;
end;

end.
