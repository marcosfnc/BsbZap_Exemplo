unit uBsbZap;

interface

uses
  Classes, SysUtils, IdHTTP, IdSSLOpenSSL, IdSSL, ExtCtrls, Graphics, jpeg,
  IdCoderMIME;

type
  TTipoArquivo = (taImagem, taDocumento, taVideo);

  TMensagem = class
  Private
    FNumero: string;
    FTexto: String;
    FArquivoMimetype: String;
    FNumeroContato: string;
    FArquivoBase64: string;
    FNomeContato: string;
    FArquivoNome: string;
    FError: string;
    FBase64QRCode: string;
    FpairingCode: string;
    FArquivotype: string;
    FExtensao: string;
    FBase64Str: string;
    FQtdQrCode: integer;
    procedure SetNumero(const Value: string);
    procedure SetTexto(const Value: String);
    procedure SetArquivoMimetype(const Value: String);
    procedure SetArquivoBase64(const Value: string);
    procedure SetArquivoNome(const Value: string);
    procedure SetNomeContato(const Value: string);
    procedure SetNumeroContato(const Value: string);
    procedure SetError(const Value: string);
    procedure SetBase64QRCode(const Value: string);
    procedure SetpairingCode(const Value: string);
    procedure SetArquivotype(const Value: string);
    procedure SetExtensao(const Value: string);
    procedure SetBase64Str(const Value: string);
    procedure SetQtdQrCode(const Value: integer);

    function DetectFileType(const filePath: string): string;
    function FileToBase64(const FileName: string): string;
    function CleanInvalidBase64Chars(const Base64Str: string): string;
    function TrocaCaracterEspecial(aTexto: string; aCaracteresExtras: array of string): string;
    function GetMimeType(const FileName: string): string;
    function IsNumeric(Value: string): Boolean;

  public
    property Numero: String read FNumero write SetNumero;
    property Texto: String read FTexto write SetTexto;
    property ArquivoMimetype: String read FArquivoMimetype write SetArquivoMimetype;
    property ArquivoBase64: string read FArquivoBase64 write SetArquivoBase64;
    property ArquivoNome: string read FArquivoNome write SetArquivoNome;
    property NumeroContato: string read FNumeroContato write SetNumeroContato;
    property NomeContato: string read FNomeContato write SetNomeContato;
    property Error: string read FError write SetError;
    property pairingCode: string read FpairingCode write SetpairingCode;
    property Base64QRCode: string read FBase64QRCode write SetBase64QRCode;
    property Arquivotype: string read FArquivotype write SetArquivotype;
    property Extensao: string read FExtensao write SetExtensao;
    property Base64Str: string read FBase64Str write SetBase64Str;
    property QtdQrCode: integer read FQtdQrCode write SetQtdQrCode;

    function NumeroEhValido(const Numero: string): Boolean;
    function ObterQrCode(ID, Token, Numero: String): Boolean;
    function StatusConexao(ID, Token: String): string;
    function EnviarMensagem(Numero, Mensagem, ID, Token: string): Integer;
    function EnviarArquivo(Numero, Anexo, ID, Token: string): Integer;
    function EnviarContato(Numero, NomeCont, NumeroContat, ID, Token: string): Integer;
    function ListarGrupos(ID, Token: string): string;

    procedure LoadBase64ToImage(const Base64: string; Image: TImage);
  end;

const
  URLv2                 = 'https://apizap.bsbzap.com';
  URLv3                 = 'https://apizap-v3.bsbzap.com';

  ENDPOINT_MENSSAGEM    = '/message/sendText';
  ENDPOINT_ANEXO        = '/message/sendMedia';
  ENDPOINT_CONTACT      = '/message/sendContact';
  ENDPOINT_QRCOD        = '/instance/connect';
  ENDPOINT_NUMERO_EXIST = '/chat/whatsappNumbers';
  ENDPOINT_PUSHCONTATOS = '/chat/findContacts';
  ENDPOINT_PUSHFOTO     = '/chat/fetchProfilePictureUrl';
  ENDPOINT_LOCALIZACAO  = '/message/sendLocation';
  ENDPOINT_NARRAR_AUDIO = '/message/sendWhatsAppAudio';
  ENDPOINT_LISTAR_GRUPO = '/group/fetchAllGroups';
  ENDPOINT_STATUS       = '/instance/connectionState';

var
  Versao: string;

implementation

uses
  StrUtils, Windows;

{ TMensagem }

function TMensagem.IsNumeric(Value: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 1 to Length(Value) do
    if not (Value[I] in ['0'..'9']) then
    begin
      Result := False;
      Break;
    end;
end;

function TMensagem.CleanInvalidBase64Chars(const Base64Str: string): string;
var
  I: Integer;
  c: Char;
begin
  Result := '';
  for I := 1 to Length(Base64Str) do
  begin
    c := Base64Str[I];
    // Adiciona ao resultado apenas se for um caractere válido em Base64
    if (c in ['A'..'Z', 'a'..'z', '0'..'9', '+', '/', '=']) then
      Result := Result + c;
  end;
end;

function TMensagem.DetectFileType(const filePath: string): string;
var
  fileExt: string;
begin
  fileExt := LowerCase(ExtractFileExt(filePath));

  // Verifica a extensão e associa a um tipo
  if (fileExt = '.pdf') or (fileExt = '.doc') or (fileExt = '.docx') or
     (fileExt = '.txt') or (fileExt = '.xml') or (fileExt = '.xls') or
     (fileExt = '.xlsx') or (fileExt = '.zip') or (fileExt = '.rar') then
    Result := 'document'
  else if (fileExt = '.jpg') or (fileExt = '.jpeg') or (fileExt = '.png') or
          (fileExt = '.gif') or (fileExt = '.bmp') then
    Result := 'image'
  else if (fileExt = '.mp3') or (fileExt = '.wav') or (fileExt = '.ogg') then
    Result := 'audio'
  else if (fileExt = '.mp4') then
    Result := 'video'
  else
    Result := 'document';  // Tipo desconhecido
end;

function TMensagem.EnviarArquivo(Numero, Anexo, ID, Token: string): Integer;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  BaseURL: string;
  JSONStr: string;
  PostDataStream: TStringStream;
begin
  Result := 400;

  Arquivotype := DetectFileType(Anexo);
  Extensao    := LowerCase(Copy(ExtractFileExt(Anexo), 2, MaxInt));
  Base64Str   := FileToBase64(Anexo);
  ArquivoNome := TrocaCaracterEspecial(ExtractFileName(Anexo), []);

  // Remove a extensão do nome do arquivo
  if Pos('.', ArquivoNome) > 0 then
    ArquivoNome := Copy(ArquivoNome, 1, Pos('.', ArquivoNome) - 1);

  BaseURL := URLv2 + ENDPOINT_ANEXO + '/' + ID;

  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
  HTTP.IOHandler := SSL;
  HTTP.Request.ContentType := 'application/json';
  HTTP.Request.CustomHeaders.AddValue('apikey', Token);

  JSONStr := '{"number": "55' + Numero + '", ' +
             '"mediatype": "' + Arquivotype + '", ' +
             '"mimetype": "' + GetMimeType(Anexo) + '", ' +
             '"caption": "Boleto", ' +
             '"media": "' + Base64Str + '", ' +
             '"fileName": "' + ArquivoNome + '.' + Extensao + '", ' +
             '"delay": 100}';

  PostDataStream := TStringStream.Create(JSONStr);

  try
    try
      HTTP.Post(BaseURL, PostDataStream);
      if (HTTP.ResponseCode = 200) or (HTTP.ResponseCode = 201) then
        Result := 201
      else
        Result := HTTP.ResponseCode;
    except
      on E: Exception do
      begin
        if HTTP.ResponseCode > 0 then
          Result := HTTP.ResponseCode
        else
          Result := 500;
        FError := E.Message;
      end;
    end;
  finally
    HTTP.Free;
    SSL.Free;
    PostDataStream.Free;
  end;
end;

function TMensagem.EnviarContato(Numero, NomeCont, NumeroContat, ID, Token: string): Integer;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  BaseURL, sJson: String;
  PostDataStream: TStringStream;
begin
  Result := 400;
  BaseURL := URLv2 + ENDPOINT_CONTACT + '/' + ID;

  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
  HTTP.IOHandler := SSL;
  HTTP.Request.ContentType := 'application/json';
  HTTP.Request.CustomHeaders.AddValue('apikey', Token);

  sJson := '{ "number": "'+ '55' + Numero + '", ' +
           '"contact": [ {' +
           '"fullName": "' + NomeCont + '", ' +
           '"wuid": "55' + NumeroContat + '", ' +
           '"phoneNumber": "+55' + NumeroContat + '" }]}';

  PostDataStream := TStringStream.Create(sJson);

  try
    try
      HTTP.Post(BaseURL, PostDataStream);
      if (HTTP.ResponseCode = 200) or (HTTP.ResponseCode = 201) then
        Result := 201
      else
        Result := HTTP.ResponseCode;
    except
      on E: Exception do
      begin
        if HTTP.ResponseCode > 0 then
          Result := HTTP.ResponseCode
        else
          Result := 500;
        FError := E.Message;
      end;
    end;
  finally
    HTTP.Free;
    SSL.Free;
    PostDataStream.Free;
  end;
end;

function TMensagem.EnviarMensagem(Numero, Mensagem, ID, Token: string): Integer;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  BaseURL: string;
  JSONStr: string;
  PostDataStream: TStringStream;
begin
  Result := 400;
  BaseURL := URLv2 + ENDPOINT_MENSSAGEM + '/' + ID;

  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
  HTTP.IOHandler := SSL;
  HTTP.Request.ContentType := 'application/json';
  HTTP.Request.CustomHeaders.AddValue('apikey', Token);

  if Pos('@', numero) = 0 then
    JSONStr := '{"number": "' + Numero + '", "text": "' + Mensagem + '", "delay": 100}'
  else
    JSONStr := '{"number": "55' + Numero + '", "text": "' + Mensagem + '", "delay": 100}';

  PostDataStream := TStringStream.Create(JSONStr);

  try
    try
      HTTP.Post(BaseURL, PostDataStream);
      if (HTTP.ResponseCode = 200) or (HTTP.ResponseCode = 201) then
        Result := 201
      else
        Result := HTTP.ResponseCode;
    except
      on E: Exception do
      begin
        if HTTP.ResponseCode > 0 then
          Result := HTTP.ResponseCode
        else
          Result := 500;
        FError := E.Message;
      end;
    end;
  finally
    HTTP.Free;
    SSL.Free;
    PostDataStream.Free;
  end;
end;

function TMensagem.FileToBase64(const FileName: string): string;
var
  InputStream: TFileStream;
  Encoder: TIdEncoderMIME;
  Bytes: TStringStream;
begin
  Result := '';
  if not FileExists(FileName) then
    Exit;

  InputStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  Encoder := TIdEncoderMIME.Create(nil);
  Bytes := TStringStream.Create('');
  try
    // No Delphi 7, TIdEncoderMIME.Encode usa TStream
    Bytes.CopyFrom(InputStream, InputStream.Size);
    Bytes.Position := 0;
    Result := Encoder.Encode(Bytes.DataString);
    Result := CleanInvalidBase64Chars(Result);
  finally
    Encoder.Free;
    InputStream.Free;
    Bytes.Free;
  end;
end;

function TMensagem.GetMimeType(const FileName: string): string;
var
  Ext: string;
begin
  Ext := LowerCase(ExtractFileExt(FileName));

  if (Ext = '.html') or (Ext = '.htm') then Result := 'text/html'
  else if (Ext = '.txt') then Result := 'text/plain'
  else if (Ext = '.jpg') or (Ext = '.jpeg') then Result := 'image/jpeg'
  else if (Ext = '.png') then Result := 'image/png'
  else if (Ext = '.gif') then Result := 'image/gif'
  else if (Ext = '.bmp') then Result := 'image/bmp'
  else if (Ext = '.pdf') then Result := 'application/pdf'
  else if (Ext = '.zip') then Result := 'application/zip'
  else if (Ext = '.rar') then Result := 'application/x-rar-compressed'
  else if (Ext = '.doc') then Result := 'application/msword'
  else if (Ext = '.docx') then Result := 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  else if (Ext = '.xls') then Result := 'application/vnd.ms-excel'
  else if (Ext = '.xlsx') then Result := 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  else if (Ext = '.ppt') then Result := 'application/vnd.ms-powerpoint'
  else if (Ext = '.pptx') then Result := 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
  else if (Ext = '.mp3') then Result := 'audio/mpeg'
  else if (Ext = '.ogg') then Result := 'audio/ogg'
  else if (Ext = '.mp4') then Result := 'video/mp4'
  else if (Ext = '.avi') then Result := 'video/x-msvideo'
  else if (Ext = '.mov') then Result := 'video/quicktime'
  else if (Ext = '.json') then Result := 'application/json'
  else Result := 'application/octet-stream';
end;

function TMensagem.ListarGrupos(ID, Token: string): string;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  ResponseStr: string;
begin
  Result := '';
  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

  try
    SSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
    HTTP.IOHandler := SSL;
    HTTP.Request.CustomHeaders.AddValue('apikey', Token);

    try
      ResponseStr := HTTP.Get(URLv2 + '/group/fetchAllGroups/' + ID + '?getParticipants=false');
      Result := ResponseStr;
    except
      on E: Exception do
        FError := 'Erro ao listar grupos: ' + E.Message;
    end;
  finally
    HTTP.Free;
    SSL.Free;
  end;
end;

procedure TMensagem.LoadBase64ToImage(const Base64: string; Image: TImage);
var
  CleanedBase64: string;
  Decoder: TIdDecoderMIME;
  Stream: TMemoryStream;
  JPEGImage: TJPEGImage;
begin
  // Remove o prefixo se existir
  if Pos('data:image', Base64) > 0 then
    CleanedBase64 := Copy(Base64, Pos(',', Base64) + 1, Length(Base64))
  else
    CleanedBase64 := Base64;

  Decoder := TIdDecoderMIME.Create(nil);
  Stream := TMemoryStream.Create;
  JPEGImage := TJPEGImage.Create;

  try
    // No Delphi 7, TIdDecoderMIME.DecodeStream precisa de uma string
    Decoder.DecodeStream(CleanedBase64, Stream);
    Stream.Position := 0;

    // Tenta carregar como JPEG primeiro
    try
      JPEGImage.LoadFromStream(Stream);
      Image.Picture.Assign(JPEGImage);
    except
      // Se falhar como JPEG, tenta como BMP
      try
        Stream.Position := 0;
        Image.Picture.Bitmap.LoadFromStream(Stream);
      except
        Image.Picture.Bitmap.Width := 100;
        Image.Picture.Bitmap.Height := 100;
        Image.Picture.Bitmap.Canvas.TextOut(10, 10, 'Imagem inválida');
      end;
    end;
  finally
    JPEGImage.Free;
    Stream.Free;
    Decoder.Free;
  end;
end;

function TMensagem.NumeroEhValido(const Numero: string): Boolean;
var
  NumeroTemp: string;
  I: Integer;
begin
  // Remove tudo que não é número
  NumeroTemp := '';
  for I := 1 to Length(Numero) do
    if Numero[I] in ['0'..'9'] then
      NumeroTemp := NumeroTemp + Numero[I];

  // Validação básica do número (DDD + número)
  // Brasil: DDD (2 dígitos) + número (8 ou 9 dígitos)
  Result := (Length(NumeroTemp) = 10) or (Length(NumeroTemp) = 11);

  // Verifica se o DDD é válido (11 a 99, exceto alguns)
  if Result and (Length(NumeroTemp) >= 2) then
  begin
    // Extrai DDD
    I := StrToIntDef(Copy(NumeroTemp, 1, 2), 0);
    // DDDs válidos no Brasil (11-99, exceto 20, 23, 25, 26, 29, 30-39, 40, 50, 63, 70, 80, 90)
    Result := (I >= 11) and (I <= 99) and
              not (I in [20, 23, 25, 26, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 50, 63, 70, 80, 90]);
  end;
end;

function TMensagem.ObterQrCode(ID, Token, Numero: String): Boolean;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  ResponseStr, URL: string;
  PairingStart, Base64Start: Integer;
begin
  Result := False;
  Base64QRCode := '';
  pairingCode := '';

  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

  try
    SSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
    HTTP.IOHandler := SSL;
    HTTP.Request.CustomHeaders.AddValue('apikey', Token);

    URL := URLv2 + '/instance/connect/' + ID;
    if Numero <> '' then
      URL := URL + '?number=55' + Numero;

    try
      ResponseStr := HTTP.Get(URL);

      // Parse básico da resposta JSON
      // Procura por "base64" na resposta
      Base64Start := Pos('"base64":"', ResponseStr);
      if Base64Start > 0 then
      begin
        Delete(ResponseStr, 1, Base64Start + 9);
        Base64QRCode := Copy(ResponseStr, 1, Pos('"', ResponseStr) - 1);
      end;

      // Procura por "pairingCode" na resposta
      PairingStart := Pos('"pairingCode":"', ResponseStr);
      if PairingStart > 0 then
      begin
        Delete(ResponseStr, 1, PairingStart + 14);
        pairingCode := Copy(ResponseStr, 1, Pos('"', ResponseStr) - 1);
      end;

      Result := (Base64QRCode <> '');
    except
      on E: Exception do
        Error := 'Não foi possível obter o qr-code da instância! ' + E.Message;
    end;
  finally
    HTTP.Free;
    SSL.Free;
  end;
end;

procedure TMensagem.SetArquivoBase64(const Value: string);
begin
  FArquivoBase64 := Value;
end;

procedure TMensagem.SetArquivoMimetype(const Value: String);
begin
  FArquivoMimetype := Value;
end;

procedure TMensagem.SetArquivoNome(const Value: string);
begin
  FArquivoNome := Value;
end;

procedure TMensagem.SetArquivotype(const Value: string);
begin
  FArquivotype := Value;
end;

procedure TMensagem.SetBase64QRCode(const Value: string);
begin
  FBase64QRCode := Value;
end;

procedure TMensagem.SetBase64Str(const Value: string);
begin
  FBase64Str := Value;
end;

procedure TMensagem.SetError(const Value: string);
begin
  FError := Value;
end;

procedure TMensagem.SetExtensao(const Value: string);
begin
  FExtensao := Value;
end;

procedure TMensagem.SetNomeContato(const Value: string);
begin
  FNomeContato := Value;
end;

procedure TMensagem.SetNumero(const Value: string);
begin
  FNumero := Value;
end;

procedure TMensagem.SetNumeroContato(const Value: string);
begin
  FNumeroContato := Value;
end;

procedure TMensagem.SetpairingCode(const Value: string);
begin
  FpairingCode := Value;
end;

procedure TMensagem.SetQtdQrCode(const Value: integer);
begin
  FQtdQrCode := Value;
end;

procedure TMensagem.SetTexto(const Value: String);
begin
  FTexto := Value;
end;

function TMensagem.StatusConexao(ID, Token: String): string;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  ResponseStr, URL: string;
  StateStart: Integer;
begin
  Result := '';

  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

  try
    SSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
    HTTP.IOHandler := SSL;
    HTTP.Request.CustomHeaders.AddValue('apikey', Token);

    URL := URLv2 + '/instance/connectionState/' + ID;

    try
      ResponseStr := HTTP.Get(URL);

      // Parse básico para obter o estado
      StateStart := Pos('"state":"', ResponseStr);
      if StateStart > 0 then
      begin
        Delete(ResponseStr, 1, StateStart + 8);
        Result := Copy(ResponseStr, 1, Pos('"', ResponseStr) - 1);
      end;
    except
      on E: Exception do
      begin
        if HTTP.ResponseCode = 401 then
          Result := '401' // Não autorizado token inválido
        else if HTTP.ResponseCode = 404 then
          Result := '404' // Instância não cadastrada
        else
          Result := 'Erro: ' + E.Message;
      end;
    end;
  finally
    HTTP.Free;
    SSL.Free;
  end;
end;

function TMensagem.TrocaCaracterEspecial(aTexto: string; aCaracteresExtras: array of string): string;
const
  // Lista de caracteres especiais
  xCarEsp: array[1..38] of String = ('á', 'à', 'ã', 'â', 'ä','Á', 'À', 'Ã', 'Â', 'Ä',
                                     'é', 'è','É', 'È','í', 'ì','Í', 'Ì',
                                     'ó', 'ò', 'ö','õ', 'ô','Ó', 'Ò', 'Ö', 'Õ', 'Ô',
                                     'ú', 'ù', 'ü','Ú','Ù', 'Ü','ç','Ç','ñ','Ñ');
  // Lista de caracteres para troca
  xCarTro: array[1..38] of String = ('a', 'a', 'a', 'a', 'a','A', 'A', 'A', 'A', 'A',
                                     'e', 'e','E', 'E','i', 'i','I', 'I',
                                     'o', 'o', 'o','o', 'o','O', 'O', 'O', 'O', 'O',
                                     'u', 'u', 'u','u','u', 'u','c','C','n', 'N');
var
  xTexto: string;
  i, j: Integer;
begin
  xTexto := aTexto;
  for i := 1 to 38 do
    xTexto := StringReplace(xTexto, xCarEsp[i], xCarTro[i], [rfReplaceAll]);

  for j := 0 to High(aCaracteresExtras) do
    xTexto := StringReplace(xTexto, aCaracteresExtras[j], '', [rfReplaceAll]);

  Result := xTexto;
end;

end.
