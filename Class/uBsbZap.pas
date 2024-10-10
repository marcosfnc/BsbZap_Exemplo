unit uBsbZap;

interface

  uses
    System.Classes, System.JSON, System.RegularExpressions, IdHTTP, IdSSL, IdSSLOpenSSL,
    system.SysUtils, vcl.ExtCtrls, Vcl.Imaging.pngimage, Soap.EncdDecd, System.NetEncoding;

type TTipoArquivo = (taImagem, taDocumento, taVideo);

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

    function DetectFileType(const filePath: string): string;
    function FileToBase64(const FileName: string): string;
    function CleanInvalidBase64Chars(const Base64Str: string): string;
    function TrocaCaracterEspecial(aTexto: string; aCaracteresExtras: array of string): string;


    procedure SetExtensao(const Value: string);
    procedure SetBase64Str(const Value: string);
    procedure SetQtdQrCode(const Value: integer);

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
    function ObterQrCode(ID, Token, Numero : String): Boolean;
    function StatusConexao(ID, Token: String): string;
    function EnviarMensagem(Numero, Mensagem, ID, Token: string): Integer;
    function EnviarArquivo(Numero, Anexo, ID, Token: string): Integer;
    function EnviarContato(Numero, NomeCont, NumeroContat, ID, Token: string): Integer;

    procedure LoadBase64ToImage(const Base64: string; Image: TImage);
end;

const
  URLv2                 = 'https://apibsbzap.bsbsoftware.com.br';

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


implementation

{ TMensagem }

function TMensagem.CleanInvalidBase64Chars(const Base64Str: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Base64Str) do
  begin
    // Adiciona ao resultado apenas se for um caractere válido em Base64
    if Base64Str[I] in ['A'..'Z', 'a'..'z', '0'..'9', '+', '/', '='] then
      Result := Result + Base64Str[I];
  end;
end;

function TMensagem.DetectFileType(const filePath: string): string;
var
  fileExt: string;
begin
  fileExt := LowerCase(ExtractFileExt(filePath));

  // Verifica a extensão e associa a um tipo
  if (fileExt = '.pdf') or (fileExt = '.doc') or (fileExt = '.docx') or (fileExt = '.txt') or (fileExt = '.xml') or (fileExt = '.xls') then
    Result := 'document'
  else
  if (fileExt = '.jpg') or (fileExt = '.jpeg') or (fileExt = '.png') or (fileExt = '.gif') or (fileExt = '.bpm') then
    Result := 'image'
  else
  if (fileExt = '.mp3') or (fileExt = '.wav') or (fileExt = '.ogg') then
    Result := 'audio'
  else
  if (fileExt = '.mp4') then
    Result := 'video'
  else
  if (fileExt = '.zip') or (fileExt = '.rar') or (fileExt = '.xlsx') then
    Result := 'document'
  else
    Result := 'document';  // Tipo desconhecido

end;

function TMensagem.EnviarArquivo(Numero, Anexo, ID, Token: string): Integer;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  BaseURL, sMenssagem: string;
  JSONToSend, MediaMessageJSON: TJSONObject;
  PostDataStream: TStringStream;
begin
  Result := 400;

  Arquivotype := DetectFileType(Anexo);
  Extensao    := ExtractFileExt(Anexo).ToLower.Replace('.', '');
  Base64Str   := FileToBase64(Anexo);
  ArquivoNome := TrocaCaracterEspecial(ExtractFileName(Anexo).Replace(ExtractFileExt(Anexo), ''), []);

  BaseURL := URLv2 + ENDPOINT_ANEXO + '/' + ID;

  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
  HTTP.IOHandler := SSL;
  HTTP.Request.ContentType := 'application/json';
  HTTP.Request.CustomHeaders.AddValue('apikey', Token);

   JSONToSend       := TJSONObject.Create;

  try
    JSONToSend.AddPair('number', '55' + Numero);

    JSONToSend.AddPair('mediatype', Arquivotype);
    JSONToSend.AddPair('mimetype', Arquivotype + '/' + Extensao);
    JSONToSend.AddPair('caption', 'Teste caption');  // pode passar um titulo para o nexo
    JSONToSend.AddPair('media', Base64Str);
    JSONToSend.AddPair('fileName', ArquivoNome + '.' + Extensao);
    JSONToSend.AddPair('delay', TJSONNumber.Create(100));

    PostDataStream := TStringStream.Create(JSONToSend.ToString, TEncoding.UTF8);

    try
      HTTP.Post(BaseURL, PostDataStream);
      case HTTP.ResponseCode of
        200, 201: Result := 201;
        else
          raise Exception.Create(HTTP.ResponseText);
      end;
    except
      Result := HTTP.ResponseCode;
    end;

  finally
    FreeAndNil(HTTP);
    FreeAndNil(SSL);
    FreeAndNil(JSONToSend);
    FreeAndNil(PostDataStream);
  end;
end;

function TMensagem.EnviarContato(Numero, NomeCont, NumeroContat, ID, Token: string): Integer;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  BaseURL, sJson: String;
  JSONToSend: TJSONObject;
  PostDataStream: TStringStream;
begin
  Result := 400;
  BaseURL := URLv2 + ENDPOINT_CONTACT + '/' + ID;

  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
  HTTP.IOHandler := SSL;
  HTTP.Request.ContentType := 'application/json';
  HTTP.Request.CustomHeaders.AddValue('apikey', Token);

  try
    sJson := '{ "number": "'+ '55' +Numero+'", '+
             '"contact": [ {'+
             '"fullName": "'+NomeCont+'", '+
             '"wuid": "' + '55' + NumeroContat + '", '+
             '"phoneNumber": "+55'+NumeroContat+'" }]}';

    PostDataStream := TStringStream.Create(sJson, TEncoding.UTF8);

    try
      HTTP.Post(BaseURL, PostDataStream);
      case HTTP.ResponseCode of
        200, 201: Result := 201;
      else
        raise Exception.Create(HTTP.ResponseText);
      end;
    except
      Result := HTTP.ResponseCode;
    end;

  finally
    FreeAndNil(HTTP);
    FreeAndNil(SSL);
    FreeAndNil(PostDataStream);
  end;
end;

function TMensagem.EnviarMensagem(Numero, Mensagem, ID, Token: string): Integer;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  BaseURL: string;
  JSONToSend: TJSONObject;
  PostDataStream: TStringStream;
begin
  Result := 400;
  BaseURL := URLv2 + ENDPOINT_MENSSAGEM + '/' + ID;

  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  JSONToSend := TJSONObject.Create;

  SSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
  HTTP.IOHandler := SSL;
  HTTP.Request.ContentType := 'application/json';
  HTTP.Request.CustomHeaders.AddValue('apikey', Token);

  try
    JSONToSend.AddPair('number', '55' + Numero);

    JSONToSend.AddPair('text', Mensagem);
    JSONToSend.AddPair('delay', TJSONNumber.Create(100));

    PostDataStream := TStringStream.Create(JSONToSend.ToString, TEncoding.UTF8);
    try
      HTTP.Post(BaseURL, PostDataStream);
      case HTTP.ResponseCode of
        200, 201: Result := 201; // mensagem enviada
      else
        raise Exception.Create(HTTP.ResponseText);
      end;
    except
      Result := HTTP.ResponseCode;
    end;

  finally
    FreeAndNil(HTTP);
    FreeAndNil(SSL);
    FreeAndNil(JSONToSend);
    FreeAndNil(PostDataStream);
  end;

end;

function TMensagem.FileToBase64(const FileName: string): string;
var
  InputStream: TFileStream;
  Bytes: TBytes;
  base64:String;
begin
  Result := '';
  if not FileExists(FileName) then
    Exit;

  InputStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    SetLength(Bytes, InputStream.Size);
    InputStream.Read(Bytes[0], InputStream.Size);
    base64 := TNetEncoding.Base64.EncodeBytesToString(Bytes);
    base64 := CleanInvalidBase64Chars(base64);
    Result := base64;
  finally
    InputStream.Free;
  end;
end;

procedure TMensagem.LoadBase64ToImage(const Base64: string; Image: TImage);
var
  CleanedBase64: string;
  Input: TStringStream;
  Output: TMemoryStream;
  Img: TPNGImage;  // Para PNG
begin
  // Remover o prefixo da string Base64
  CleanedBase64 := Base64.Replace('data:image/png;base64,', '', [rfIgnoreCase]);

  Input := TStringStream.Create(CleanedBase64, TEncoding.ASCII);
  try
    Output := TMemoryStream.Create;
    try
      DecodeStream(Input, Output);
      Output.Position := 0;

      Img := TPNGImage.Create;  // Para PNG
      try
        Img.LoadFromStream(Output);
        Image.Picture.Assign(Img);
      finally
        Img.Free;
      end;

    finally
      Output.Free;
    end;
  finally
    Input.Free;
  end;
end;

function TMensagem.NumeroEhValido(const Numero: string): Boolean;
var
  NumeroTemp: string;
begin
  NumeroTemp := TRegex.Replace(Numero, '\D', '');
  Result     := TRegex.IsMatch(NumeroTemp, '^[1-9]{2}9?[1-9][0-9]{7}$');
end;

function TMensagem.ObterQrCode(ID, Token, Numero: String): Boolean;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  params: TStringList;
  Parametros, ResponseStr: string;
  ResponseJSON: TJSONObject;
begin
  Result := False;

  HTTP   := TIdHTTP.Create(nil);
  SSL    := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  params := TStringList.Create;

  try
    SSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
    HTTP.IOHandler := SSL;
    HTTP.Request.CustomHeaders.AddValue('apikey', Token);
    try
      params.Add(ID);

      if Numero <> '' then
        params.Add('?number' + '55' + Numero);

      Parametros := StringReplace(params.Text, #13#10, '', [rfReplaceAll]);

      ResponseStr := HTTP.Get(Urlv2 + '/instance/connect/' + Parametros);

      ResponseJSON := TJSONObject.ParseJSONValue(ResponseStr) as TJSONObject;
      Base64QRCode := ResponseJSON.GetValue<string>('base64');
      pairingCode  := ResponseJSON.GetValue<string>('pairingCode');
      QtdQrCode    := ResponseJSON.GetValue<integer>('count');
      Result := True;
    except
      on E: Exception do
        Error := 'Não foi possível obter o qr-code da instância!' + E.Message;
    end;

  finally
    FreeAndNil(HTTP);
    FreeAndNil(SSL);
    FreeAndNil(params);
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
  ResponseStr: string;
  ResponseJSON, InstanceJSON: TJSONObject;
begin
  Result := '';

  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

  try
    SSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
    HTTP.IOHandler := SSL;

    HTTP.Request.CustomHeaders.AddValue('apikey', Token);

    try
      ResponseStr := HTTP.Get(Urlv2 + '/instance/connectionState/' + ID);
      ResponseJSON := TJSONObject.ParseJSONValue(ResponseStr) as TJSONObject;

      InstanceJSON := ResponseJSON.GetValue<TJSONObject>('instance');
      Result := InstanceJSON.GetValue<string>('state');
    except
      on E: Exception do
      begin
        case HTTP.ResponseCode of
          401: Result := '401'; //Não autorizado token invalido
          404: Result := '404'; //instancia nao cadastrada
        else
          Result := 'Erro: ' + E.Message;
        end;
      end;
    end;
  finally
    FreeAndNil(HTTP);
    FreeAndNil(SSL);
  end;
end;

function TMensagem.TrocaCaracterEspecial(aTexto: string; aCaracteresExtras: array of string): string;
  const
    //Lista de caracteres especiais
    xCarEsp: array[1..38] of String = ('á', 'à', 'ã', 'â', 'ä','Á', 'À', 'Ã', 'Â', 'Ä',
                                       'é', 'è','É', 'È','í', 'ì','Í', 'Ì',
                                       'ó', 'ò', 'ö','õ', 'ô','Ó', 'Ò', 'Ö', 'Õ', 'Ô',
                                       'ú', 'ù', 'ü','Ú','Ù', 'Ü','ç','Ç','ñ','Ñ');
    //Lista de caracteres para troca
    xCarTro: array[1..38] of String = ('a', 'a', 'a', 'a', 'a','A', 'A', 'A', 'A', 'A',
                                       'e', 'e','E', 'E','i', 'i','I', 'I',
                                       'o', 'o', 'o','o', 'o','O', 'O', 'O', 'O', 'O',
                                       'u', 'u', 'u','u','u', 'u','c','C','n', 'N');
  var
    xTexto : string;
    i : Integer;
  begin
    xTexto := aTexto;
    for i:=1 to 38 do
      xTexto := StringReplace(xTexto, xCarEsp[i], xCarTro[i], [rfreplaceall]);
    for i:=0 to High(aCaracteresExtras) do
      xTexto := StringReplace(xTexto, aCaracteresExtras[i], '', [rfreplaceall]);
    Result := xTexto;
  end;
end.
