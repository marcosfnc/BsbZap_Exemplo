program BsbZap;

uses
  Vcl.Forms,
  uPrincipal in 'Form\uPrincipal.pas' {Form1},
  uBsbZap in 'Class\uBsbZap.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
