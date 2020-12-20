program digitalriver.keyissuance.yourapp;

{$APPTYPE CONSOLE}
{$R *.res}

uses System.SysUtils,
  Classes,
  IniFiles,
  Vcl.Onguard,
  Vcl.OgUtil;

const
  ERC_SUCCESS = 00;
  ERC_SUCCESS_BIN = 01;
  ERC_ERROR = 10;
  ERC_MEMORY = 11;
  ERC_FILE_IO = 12;
  ERC_BAD_ARGS = 13;
  ERC_BAD_INPUT = 14;
  ERC_EXPIRED = 15;
  ERC_INTERNAL = 16;

const
  // Product ID. Obtain from Digital River Admin Panel
  PROD = 100000001;
  // This key must be same as in App.
  CKey: TKey = ($E5, $8F, $84, $D6, $92, $C9, $A4, $D8, $1A, $FA, $6F, $8D, $AB, $FC, $DF, $B4);

procedure GenerateKey(productId: integer; REG_NAME, EMAIL: string; p2, p3: string);
begin
  var UserKey, CCKey: string;
  var ts1, ts2: TStringList;
  var Work: TCode;
  var OgMakeCodes1 := TOgMakeCodes.Create(nil);
  var dtNow := EncodeDate(2021, 12, 31);
  OgMakeCodes1.SetKey(CKey);
  InitRegCode(CKey, string(REG_NAME), dtNow, Work);
  CCKey := BufferToHex(Work, SizeOf(Work));
  UserKey := 'Username: ' + UTF8Encode(REG_NAME) + #13#10 + 'Key: ' + CCKey;
  ts1 := TStringList.Create;
  try
    ts1.Add(UserKey);
    ts1.SaveToFile(p2);
    ts1.Free;
  except exitcode := ERC_FILE_IO;
  end;
    //
  ts2 := TStringList.Create;
  try
    ts2.Add(CCKey);
    ts2.SaveToFile(p3);
    ts2.Free;
  except exitcode := ERC_FILE_IO;
  end;
  OgMakeCodes1.free;
  exitcode := ERC_SUCCESS;
end;

var
  p1, p2, p3: string;
  ini: TStringList;
  REG_NAME: string;
  EMAIL: string;
  PRODUCT_ID: integer;
begin
  try
    if ParamCount < 3 then begin
      WriteLn('Usage: input.txt output1serial.txt output2user.txt');
      exitcode := ERC_BAD_ARGS;
      exit;
    end;
    //
    if FileExists(p1) then begin
      WriteLn('File input - does not exist: ' + p1);
      exitcode := ERC_BAD_ARGS;
      exit;
    end;
    //
    p1 := ParamStr(1);
    p2 := ParamStr(2);
    p3 := ParamStr(3);
    ini := TStringList.Create;
    ini.Delimiter := '=';
    ini.LoadFromFile(p1);
    REG_NAME := UTF8Decode(ini.Values['REG_NAME']);
    EMAIL := ini.Values['EMAIL'];
    PRODUCT_ID := StrToInt(ini.Values['PRODUCT_ID']);
    if (PRODUCT_ID <> PROD) then begin
      WriteLn('Bad product ID #2: ' + IntToSTr(PRODUCT_ID));
      exitcode := ERC_BAD_INPUT;
      exit;
    end;

    if (Length(REG_NAME) < 1) then begin
      WriteLn('REG_NAME must have at least 1 character');
      exitcode := ERC_BAD_ARGS;
      exit;
    end;
    GenerateKey(PRODUCT_ID, REG_NAME, EMAIL, p2, p3);
  except
    on E: Exception do begin
      WriteLn('Internal error: ' + E.Message, E.StackTrace);
      exitcode := ERC_INTERNAL;
    end;
  end;
end.


