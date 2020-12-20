unit YourAppUnit;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.onguard,
  VCL.ogutil;

type
  TForm1 = class(TForm)
    OgRegistrationCode1: TOgRegistrationCode;
    btnReg: TButton;
    StatusLbl: TLabel;
    CodeLbl: TLabel;
    btnRemoveReg: TButton;
    procedure OgRegistrationCode1GetKey(Sender: TObject; var Key: TKey);
    procedure OgRegistrationCode1GetCode(Sender: TObject; var Code: TCode);
    procedure OgRegistrationCode1Checked(Sender: TObject; Status: TCodeStatus);
    procedure btnRegClick(Sender: TObject);
    procedure OgRegistrationCode1GetRegString(Sender: TObject;
      var Value: string);
    procedure btnRemoveRegClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RegStr: string;
  end;

var
  Form1: TForm1;

implementation
uses
  Registry;
{$R *.dfm}

//==============================================================================
// OnGuard
//==============================================================================

procedure TForm1.OgRegistrationCode1GetKey(Sender: TObject; var Key: TKey);
const
  CKey: TKey = ($E5, $8F, $84, $D6, $92, $C9, $A4, $D8, $1A, $FA, $6F, $8D, $AB, $FC, $DF, $B4);
begin
  Key := CKey;
end;

procedure TForm1.OgRegistrationCode1Checked(Sender: TObject;
  Status: TCodeStatus);
var
  S: string;
begin
  case Status of
    ogValidCode: S := 'Valid Registration: ' + RegStr;
    ogInvalidCode: S := 'Invalid release code';
    ogPastEndDate: S := 'Date has expired';
    ogDayCountUsed: S := 'Zero days of use remaining';
    ogRunCountUsed: S := 'Usage count has expired';
    ogNetCountUsed: S := 'Net usage count exceeded';
    ogCodeExpired: S := 'Code has expired';
  else
    S := 'Unknown error';
  end;
  StatusLbl.Caption := S;
end;

procedure TForm1.OgRegistrationCode1GetCode(Sender: TObject; var Code: TCode);
var
  Reg: TRegistry;
  S: string;
begin
  Reg := TRegistry.Create(KEY_READ or KEY_WRITE);
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.OpenKey('Software\YourAppReg', true);
  try
    S := '';
    if Reg.ValueExists('RegistrationCode') then
      S := Reg.ReadString('RegistrationCode');
    {convert to proper form}
    HexToBuffer(S, Code, SizeOf(Code));
    {set code label caption}
    CodeLbl.Caption := S;
  finally
    Reg.Free;
  end;
end;

procedure TForm1.OgRegistrationCode1GetRegString(Sender: TObject;
  var Value: string);
var
  Reg: TRegistry;
  S: string;
begin
  Reg := TRegistry.Create(KEY_READ or KEY_WRITE);
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.OpenKey('Software\YourAppReg', true);
  try
    S := '';
    RegStr := '';
    if Reg.ValueExists('RegistrationStr') then
      RegStr := Reg.ReadString('RegistrationStr');
    Value := RegStr;
  finally
    Reg.Free;
  end;
end;

//==============================================================================
// Remove Registration
//==============================================================================

procedure TForm1.btnRegClick(Sender: TObject);
var
  Reg: TRegistry;
  Work: TCode;
  S: string;
begin
  S := '';
  {ask for string and code}
  if InputQuery('Registration String Entry', 'Enter the registration string', RegStr) then begin
    if InputQuery('Registration Code Entry', 'Enter the code', S) then begin
      Reg := TRegistry.Create(KEY_READ or KEY_WRITE);
      Reg.RootKey := HKEY_CURRENT_USER;
      Reg.OpenKey('Software\YourAppReg', true);
      try
        {store the code in the Reg file if it looks OK}
        if HexToBuffer(S, Work, SizeOf(Work)) then begin
          {save the value}
          Reg.WriteString('RegistrationCode', S);
          Reg.WriteString('RegistrationStr', RegStr);
          CodeLbl.Caption := S;

          {tell the code component to test the new code, reporting the results}
          OgRegistrationCode1.CheckCode(True);
        end;
      finally
        Reg.Free;
      end;
    end;
  end;
end;

//==============================================================================
// Remove Registration
//==============================================================================

procedure TForm1.btnRemoveRegClick(Sender: TObject);
begin
  var Reg := TRegistry.Create(KEY_READ or KEY_WRITE);
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.OpenKey('Software\YourAppReg', true);
  try
    Reg.WriteString('RegistrationCode', '');
    Reg.WriteString('RegistrationStr', '');
  finally
    Reg.Free;
  end;
end;

end.

