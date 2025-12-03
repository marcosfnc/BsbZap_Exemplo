unit uPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls, StdCtrls, Buttons, StrUtils;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    GbInstancia: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtID: TEdit;
    edtSenha: TEdit;
    Button2: TButton;
    PnlEnvios: TPanel;
    GbFoto: TGroupBox;
    ImgQrCode: TImage;
    BtnCarregaFoto: TButton;
    GbDadosEnvio: TGroupBox;
    Label4: TLabel;
    Label3: TLabel;
    MemoMensagem: TMemo;
    EdtPara: TEdit;
    LbAnexos: TLabel;
    ListBoxAnexos: TListBox;
    ButAnexar: TSpeedButton;
    GbContato: TGroupBox;
    EdtNomeContato: TEdit;
    EdtNumeroContato: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ChkContato: TCheckBox;
    ButEnviar: TBitBtn;
    EdtNumeroFoto: TEdit;
    Label8: TLabel;
    TimerQrCode: TTimer;
    ODAnexos: TOpenDialog;
    GroupBox1: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    GbGrupos: TGroupBox;
    BitBtn3: TBitBtn;
    MmGrupos: TMemo;
    ComboBox1: TComboBox;
    Label9: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure ChkContatoClick(Sender: TObject);
    procedure ButEnviarClick(Sender: TObject);
    procedure BtnCarregaFotoClick(Sender: TObject);
    procedure ButAnexarClick(Sender: TObject);
    procedure TimerQrCodeTimer(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    QtdInicialQrCode: Integer;
    QrCodeBase64: string;
    procedure CarregarQRCode;
    procedure ConectarInstancia;
    procedure MostrarErro;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses uBsbZap;

procedure TForm1.BitBtn3Click(Sender: TObject);
var
  BsbZap: TMensagem;
begin
  BsbZap := TMensagem.Create;
  try
    MmGrupos.Lines.Add(BsbZap.ListarGrupos(edtID.Text, edtSenha.Text));
  finally
    BsbZap.Free;
  end;
end;

procedure TForm1.BtnCarregaFotoClick(Sender: TObject);
var
  BsbZap: TMensagem;
begin
  if Trim(EdtNumeroFoto.Text) = '' then
  begin
    ShowMessage('Favor Digitar o numero do contato para obter a foto!');
    EdtNumeroFoto.SetFocus;
    Exit;
  end;

  BsbZap := TMensagem.Create;
  try
    // Aqui você pode adicionar a lógica para obter a foto do contato
    // Exemplo: BsbZap.ObterFotoContato(...)
    ShowMessage('Funcionalidade de obter foto ainda não implementada');
  finally
    BsbZap.Free;
  end;
end;

procedure TForm1.ButAnexarClick(Sender: TObject);
begin
  if odAnexos.Execute then
    ListBoxAnexos.Items.Add(odAnexos.FileName);
end;

procedure TForm1.ButEnviarClick(Sender: TObject);
var
  BsbZap: TMensagem;
  Mensagem, numero,
  ID, Token: String;
  x: integer;
begin
  if Trim(EdtPara.Text) = '' then
  begin
    MessageDlg('Informe o número para envio!', mtWarning, [mbOK], 0);
    EdtPara.SetFocus;
    Exit;
  end;

  if ChkContato.Checked then
  begin
    if EdtNomeContato.Text = '' then
    begin
      MessageDlg('Favor digitar o nome do contato.', mtWarning, [mbOK], 0);
      EdtNomeContato.SetFocus;
      Exit;
    end;

    if EdtNumeroContato.Text = '' then
    begin
      MessageDlg('Favor digitar o numero do contato.', mtWarning, [mbOK], 0);
      EdtNumeroContato.SetFocus;
      Exit;
    end;
  end;

  BsbZap := TMensagem.Create;

  try
    ID       := Trim(edtID.Text);
    Token    := Trim(edtSenha.Text);
    Mensagem := Trim(MemoMensagem.Text);
    numero   := Trim(EdtPara.Text);

    // No Delphi 7 não temos .Contains, usamos Pos
    if Pos('@', numero) = 0 then
    begin
      if not BsbZap.NumeroEhValido(numero) then
      begin
        MessageDlg('Número inválido.', mtWarning, [mbOK], 0);
        EdtPara.SetFocus;
        Exit;
      end;
    end;

    if Mensagem <> '' then
    begin
      if BsbZap.EnviarMensagem(Numero, Mensagem, ID, Token) = 201 then
        ShowMessage('Mensagem Enviada!')
      else
        ShowMessage('Falha no envio da mensagem!');
    end;

    for X := 0 to ListBoxAnexos.Items.Count - 1 do
    begin
      if BsbZap.EnviarArquivo(Numero, ListBoxAnexos.Items[X], ID, Token) = 201 then
        ShowMessage('Anexo ' + ListBoxAnexos.Items[X] + ' Enviado!')
      else
        ShowMessage('Falha no envio do anexo ' + ListBoxAnexos.Items[X])
    end;

    if ChkContato.Checked then
    begin
      if BsbZap.EnviarContato(Numero, Trim(EdtNomeContato.Text),
                              Trim(EdtNumeroContato.Text), ID, Token) = 201 then
        ShowMessage('Contato Enviado!')
      else
        ShowMessage('Falha no envio do contato!');
    end;

  finally
    BsbZap.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  BsbZap: TMensagem;
  Status: string;
  StatusIndex: Integer;
begin
  if edtID.Text = '' then
  begin
    ShowMessage('Favor Digitar o ID de uma instância existente!');
    Exit;
  end;

  if edtSenha.Text = '' then
  begin
    ShowMessage('Favor Digitar a Api-key da instância!');
    Exit;
  end;

  BsbZap := TMensagem.Create;
  try
    Status := BsbZap.StatusConexao(Trim(edtID.Text), Trim(edtSenha.Text));

    // Determina qual caso baseado no status
    if Status = '404' then
      StatusIndex := 0
    else if Status = '401' then
      StatusIndex := 1
    else if Status = 'open' then
      StatusIndex := 2
    else
      StatusIndex := -1;

    case StatusIndex of
      0:
        begin
          ShowMessage('Instância nao cadastrada na API!');
          edtID.SetFocus;
          Exit;
        end;
      1:
        begin
          ShowMessage('Api-Key invalida!');
          edtSenha.SetFocus;
          Exit;
        end;
      2:
        begin
          GbFoto.Enabled       := True;
          GbDadosEnvio.Enabled := True;
          GbInstancia.Enabled  := False;
          GbGrupos.Enabled     := True;
          ShowMessage('Instância conectada com sucesso!');
        end;
      else
      begin
        if BsbZap.ObterQrCode(Trim(edtID.Text), Trim(edtSenha.Text), '') then
        begin
          QrCodeBase64 := BsbZap.Base64QRCode;
          CarregarQRCode;
          TimerQrCode.Enabled := True;
        end
        else
        begin
          ShowMessage('Não foi possivel conectar na instância!');
        end;
      end;
    end;

  finally
    BsbZap.Free;
  end;
end;

procedure TForm1.ChkContatoClick(Sender: TObject);
begin
  GbContato.Enabled := ChkContato.Checked;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  QtdInicialQrCode := 0;
  QrCodeBase64 := '';
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // Limpeza se necessário
end;

procedure TForm1.CarregarQRCode;
var
  BsbZap: TMensagem;
begin
  BsbZap := TMensagem.Create;
  try
    BsbZap.LoadBase64ToImage(QrCodeBase64, ImgQrCode);
  finally
    BsbZap.Free;
  end;
end;

procedure TForm1.ConectarInstancia;
begin
  GbFoto.Enabled       := True;
  GbDadosEnvio.Enabled := True;
  GbInstancia.Enabled  := False;
  GbGrupos.Enabled     := True;
  ImgQrCode.Picture    := nil;
  ShowMessage('Instância conectada com sucesso!');
end;

procedure TForm1.MostrarErro;
begin
  ShowMessage('Não foi possivel conectar na instância!');
end;

// Implementação simples sem threads (mais compatível com Delphi 7)
procedure TForm1.TimerQrCodeTimer(Sender: TObject);
var
  Status: string;
  BsbZap: TMensagem;
begin
  TimerQrCode.Enabled := False;

  BsbZap := TMensagem.Create;
  try
    Status := BsbZap.StatusConexao(Trim(edtID.Text), Trim(edtSenha.Text));

    if Status = 'open' then
    begin
      ConectarInstancia;
      Exit;
    end;

    if Pos('Erro', Status) = 0 then // Se não contém "Erro"
    begin
      if BsbZap.ObterQrCode(Trim(edtID.Text), Trim(edtSenha.Text), '') then
      begin
        QrCodeBase64 := BsbZap.Base64QRCode;
        CarregarQRCode;
        TimerQrCode.Enabled := True;
      end
      else
      begin
        MostrarErro;
      end;
    end;

  finally
    BsbZap.Free;
  end;

  // Processar mensagens da fila para atualizar a interface
  Application.ProcessMessages;
end;

end.
