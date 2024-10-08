unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, system.StrUtils;

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
    procedure Button2Click(Sender: TObject);
    procedure ChkContatoClick(Sender: TObject);
    procedure ButEnviarClick(Sender: TObject);
    procedure BtnCarregaFotoClick(Sender: TObject);
    procedure ButAnexarClick(Sender: TObject);
    procedure TimerQrCodeTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses uBsbZap;

procedure TForm1.BtnCarregaFotoClick(Sender: TObject);
var
  BsbZap: TMensagem;
begin
  if EdtNumeroFoto.Text = '' then
  begin
    ShowMessage('Favor Digitar o numero do contato para obter a foto!');
    EdtNumeroFoto.SetFocus;
    Exit;
  end;

  BsbZap := TMensagem.Create;


  try


  finally
    FreeAndNil(BsbZap);
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
  if Trim(EdtPara.Text).IsEmpty then
  begin
    MessageDlg('Informe o número para envio!',  mtWarning, [mbOK], 0);
    EdtPara.SetFocus;
    Abort;
  end;

  if ChkContato.Checked then
  begin
    if EdtNomeContato.Text = '' then
    begin
      MessageDlg('Favor digitar o nome do contato.', mtWarning, [mbOK], 0);
      EdtNomeContato.SetFocus;
      exit;
    end;

    if EdtNumeroContato.Text = '' then
    begin
      MessageDlg('Favor digitar o numero do contato.', mtWarning, [mbOK], 0);
      EdtNumeroContato.SetFocus;
      exit;
    end;
  end;

  BsbZap := TMensagem.Create;

  try
    if not BsbZap.NumeroEhValido(Trim(EdtPara.Text)) then
    begin
      MessageDlg('Número inválido.', mtWarning, [mbOK], 0);
      EdtPara.SetFocus;
      Abort;
    end;

    ID       := trim(edtID.Text);
    Token    := trim(edtSenha.Text);
    Mensagem := Trim(MemoMensagem.Text);
    numero   := Trim(EdtPara.Text);

    if Mensagem <> '' then
    begin
      if BsbZap.EnviarMensagem(Numero, Mensagem, ID, Token) = 201 then
        ShowMessage('Mensagem Enviada!')
      else
        ShowMessage('Falha no envio da mensagem!');
    end;

    for X := 0 to ListBoxAnexos.Items.Count-1 do
    begin
      if BsbZap.EnviarArquivo(Numero, ListBoxAnexos.Items[X],ID, Token) = 201 then
        ShowMessage('Anexo ' + ListBoxAnexos.Items[X] + ' Enviado!')
      else
        ShowMessage('Falha no envio do anexo ' + ListBoxAnexos.Items[X])
    end;

    if ChkContato.Checked then
    begin
      if BsbZap.EnviarContato(Numero, Trim(EdtNomeContato.Text),trim(EdtNumeroContato.Text), ID, Token) = 201 then
        ShowMessage('Contato Enviado!')
      else
        ShowMessage('Falha no envio do contato!');
    end;

  finally
    FreeAndNil(BsbZap);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  BsbZap: TMensagem;
  Status: string;
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

    case AnsiIndexText(Status, ['404', '401', 'open'])  of
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
          GbFoto.Enabled       := true;
          GbDadosEnvio.Enabled := true;
          GbInstancia.Enabled  := False;
          ShowMessage('Instância conectada com sucesso!');
        end;
      else
      begin
        if BsbZap.ObterQrCode(Trim(edtID.Text), Trim(edtSenha.Text),'') then
        begin
          BsbZap.LoadBase64ToImage(BsbZap.Base64QRCode,ImgQrCode);
          TimerQrCode.Enabled := True;
        end
        else
        begin
          ShowMessage('Não foi possivel conectar na instância!');
        end;
      end;
    end;

  finally
    FreeAndNil(BsbZap);
  end;
end;

procedure TForm1.ChkContatoClick(Sender: TObject);
begin
  GbContato.Enabled := ChkContato.Checked;
end;

procedure TForm1.TimerQrCodeTimer(Sender: TObject);
var
  MyThread: TThread;
begin
  MyThread := TThread.CreateAnonymousThread(
    procedure
    var
      Status: string;
      BsbZap: TMensagem;
    begin
      TimerQrCode.Enabled  := false;

      BsbZap := TMensagem.Create;
      try
        Status := BsbZap.StatusConexao(Trim(edtID.Text), Trim(edtSenha.Text));

        if Status = 'open' then
        begin
          GbFoto.Enabled       := true;
          GbDadosEnvio.Enabled := true;
          GbInstancia.Enabled  := False;
          ImgQrCode.Picture    := nil;
          ShowMessage('Instância conectada com sucesso!');
          exit;
        end;

        if Status <> 'Erro' then
          TimerQrCode.Enabled := True;

      finally
        FreeAndNil(BsbZap);
      end;
    end);
    MyThread.Start;
end;

end.
