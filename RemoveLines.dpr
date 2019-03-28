program RemoveLines;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SearchDir,
  SysUtils, Classes;

var
  buffer, lines : TStringList;
  file_in, file_out : TextFile;

procedure pop(const ALine:string);
begin
  lines.Add(buffer.Text);
  if ALine <> '' then lines.Add(ALine);
  buffer.Clear;
end;

procedure process_file(const AFilename:string);
var
  i: Integer;
  line : string;
begin
  WriteLn(AFilename);

  buffer.Clear;
  lines.Clear;

  AssignFile(file_in, AFilename);
  Reset(file_in);
  SetTextCodePage(file_in, 65001);
  while not Eof(file_in) do begin
      ReadLn(file_in, line);

      if (Pos(':', line) > 0) and (Pos('-->', line) > 0) then pop(line)
      else if Trim(line) <> '' then buffer.Add( Trim(line) );
  end;
  CloseFile(file_in);

  pop('');

  AssignFile(file_out, AFilename);
  Rewrite(file_out);
  SetTextCodePage(file_out, 65001);
  for i := 0 to lines.Count-1 do WriteLn(file_out, lines[i]);
  CloseFile(file_out);
end;

begin
  buffer := TStringList.Create;
  lines := TStringList.Create;

  SearchFiles('.\', true,
    procedure(Path:string; SearchRec:TSearchRec; var NeedStop:boolean)
    begin
      if LowerCase(ExtractFileExt(SearchRec.Name)) = '.vtt' then process_file(Path + SearchRec.Name);
    end
  );
end.

00:00:01.000 --> 00:00:08.594
