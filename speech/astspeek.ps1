function astSpeak([string]$inputString, [int]$speed = -2, 
         [int]$engine = 0, [switch]$file,
         [switch]$list, [switch]$buffer,
         [int]$volume = 85)
{
  # ������� ������
  $oVoice = New-Object -com "SAPI.spvoice"
    Write-Output "������������� � ������� ������: "
  # ���� ��������� ������� ������ �������
  if($list)
  {
    Write-Output "������������� � ������� ������: "
    $i = 0
    Foreach ($Token in $oVoice.getvoices())
    {
      Write-Host $i - $Token.getdescription()
      $i++
    }    
  }
  # ���� ��������� �����������
  else
  {
    # �������� ����� �� �����, ���� ����� �������������
    if($file){ $toSpeechText = Get-Content $inputString}
    # ������������� ����� �� ������ ������ (������� ������ sta)
    elseif($buffer){
     $null = [reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
     $toSpeechText = [Windows.Forms.Clipboard]::GetText() }
    # ���������� ���������� ������, ���� ������������� �� �����
    else{ $toSpeechText = $inputString}
    
    # �������������
    $oVoice.rate = $speed
    $oVoice.volume = $volume
    $oVoice.voice = $oVoice.getvoices().item($engine)    
    $oVoice.Speak($toSpeechText)
  }
}