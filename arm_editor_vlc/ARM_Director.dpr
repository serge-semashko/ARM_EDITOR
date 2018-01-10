program ARM_Director;

uses
  Forms,
  UMain in 'UMain.pas' {Form1},
  UCommon in 'UCommon.pas',
  UGrid in 'UGrid.pas',
  UProject in 'UProject.pas' {FNewProject},
  UIMGButtons in 'UIMGButtons.pas',
  UPlayLists in 'UPlayLists.pas' {FPlayLists},
  UDelGridRow in 'UDelGridRow.pas' {FDelGridRow},
  UTimeline in 'UTimeline.pas' {FEditTimeline},
  UButtonOptions in 'UButtonOptions.pas' {FButtonOptions},
  UDrawTimelines in 'UDrawTimelines.pas',
  UInitForms in 'UInitForms.pas',
  UImportFiles in 'UImportFiles.pas' {FImportFiles},
  UPlayer in 'UPlayer.pas',
  UActPlayList in 'UActPlayList.pas',
  UGRTimelines in 'UGRTimelines.pas',
  UMyEvents in 'UMyEvents.pas',
  UHRTimer in 'UHRTimer.pas',
  UWaiting in 'UWaiting.pas' {FWaiting},
  UMyFiles in 'UMyFiles.pas',
  UTextTemplate in 'UTextTemplate.pas' {FTextTemplate},
  UMyMessage in 'UMyMessage.pas' {FMyMessage},
  UImageTemplate in 'UImageTemplate.pas' {FGRTemplate},
  UAirDraw in 'UAirDraw.pas',
  USubtitrs in 'USubtitrs.pas',
  USetTemplate in 'USetTemplate.pas' {FrSetTemplate},
  UMyLists in 'UMyLists.pas',
  USetEventData in 'USetEventData.pas' {frSetEventData},
  UGridSort in 'UGridSort.pas' {FrSortGrid},
  uwebserv in 'uwebserv.pas' {HTTPSRVForm},
  uLkJSON in 'uLkJSON.pas',
  PasLibVlcUnit in 'PasLibVlcUnit.pas',
  PasLibVlcClassUnit in 'PasLibVlcClassUnit.pas',
  vlcpl in 'vlcpl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFNewProject, FNewProject);
  Application.CreateForm(TFPlayLists, FPlayLists);
  Application.CreateForm(TFDelGridRow, FDelGridRow);
  Application.CreateForm(TFEditTimeline, FEditTimeline);
  Application.CreateForm(TFButtonOptions, FButtonOptions);
  Application.CreateForm(TFImportFiles, FImportFiles);
  Application.CreateForm(TFTextTemplate, FTextTemplate);
  Application.CreateForm(TFMyMessage, FMyMessage);
  Application.CreateForm(TFGRTemplate, FGRTemplate);
  Application.CreateForm(TFrSetTemplate, FrSetTemplate);
  Application.CreateForm(TfrSetEventData, frSetEventData);
  Application.CreateForm(TFrSortGrid, FrSortGrid);
  Application.CreateForm(THTTPSRVForm, HTTPSRVForm);
  Application.Run;
end.
