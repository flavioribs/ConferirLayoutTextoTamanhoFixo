unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans,
  dxSkinHighContrast, dxSkiniMaginary, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinPumpkin,
  dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, cxTextEdit,
  cxGroupBox, Vcl.Buttons, Vcl.ExtCtrls, Data.DB, Datasnap.DBClient,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxNavigator, cxDBData, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridLevel, cxClasses,
  cxGridCustomView, cxGrid, Vcl.Menus, shellapi, inifiles;

type
  TfrmMain = class(TForm)
    pnlBotoes: TPanel;
    btnGravar: TSpeedButton;
    btnCancelar: TSpeedButton;
    btnAjuda: TSpeedButton;
    btnImprimir: TSpeedButton;
    btnDica: TSpeedButton;
    cxGroupBox1: TcxGroupBox;
    edtTextoParaValidar: TcxTextEdit;
    cxGroupBox2: TcxGroupBox;
    cdsLayout: TClientDataSet;
    cdsLayoutid: TIntegerField;
    cdsLayoutDescricao: TStringField;
    cdsLayoutPosicaoInicial: TIntegerField;
    cdsLayoutTamanho: TIntegerField;
    dsLayout: TDataSource;
    grdLayout: TcxGridDBTableView;
    grdLayoutArquivoLevel1: TcxGridLevel;
    grdLayoutArquivo: TcxGrid;
    grdLayoutid: TcxGridDBColumn;
    grdLayoutDescricao: TcxGridDBColumn;
    grdLayoutPosicaoInicial: TcxGridDBColumn;
    grdLayoutTamanho: TcxGridDBColumn;
    cdsLayoutValoresValidos: TStringField;
    grdLayoutValoresValidos: TcxGridDBColumn;
    btnExtras: TSpeedButton;
    ppmExtras: TPopupMenu;
    SalvarLayout1: TMenuItem;
    CarregarLayout1: TMenuItem;
    OpenDlg: TOpenDialog;
    SaveDlg: TSaveDialog;
    SaveDlgResultado: TSaveDialog;
    procedure CarregarLayout1Click(Sender: TObject);
    procedure SalvarLayout1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnExtrasClick(Sender: TObject);
    procedure btnAjudaClick(Sender: TObject);
  private
    procedure ValidarLayout;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnAjudaClick(Sender: TObject);
begin
  ShellExecute(handle,'open',PChar('http://flavioribs.info'), '','',SW_SHOWNORMAL);
end;

procedure TfrmMain.btnExtrasClick(Sender: TObject);
begin
  if btnExtras.PopupMenu <> nil then
   btnExtras.PopupMenu.Popup(btnExtras.ClientOrigin.X, btnExtras.ClientOrigin.Y - btnExtras.Height);
end;

procedure TfrmMain.btnGravarClick(Sender: TObject);
begin
  ValidarLayout;
end;

procedure TfrmMain.ValidarLayout;
var
  stl: TStringList;
  sText, sValidacao: String;
  iTamanhoEncontrado: Integer;
begin
  if SaveDlgResultado.Execute then
   begin
    stl := TStringList.Create;

    stl.add('<!doctype html>');
    stl.add('<html lang="en">');
    stl.add('  <head>');
    stl.add('    <!-- Required meta tags -->');
    stl.add('    <meta charset="ISO-8859-1">');
    stl.add('    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">');
    stl.add(' ');
    stl.add('    <!-- Bootstrap CSS -->');
    stl.add('    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">');
    stl.add(' ');
    stl.add('    <title>Resultado da Validação do Registro</title>');
    stl.add('  </head>');
    stl.add('  <body>');
    stl.add('    <h1>Resultado da Validação do Registro</h1>');
    stl.add(' ');
    stl.add(Format('	<div><b>Linha a Ser Validada: %s</b></div>', [QuotedStr(edtTextoParaValidar.Text)]));
    stl.add(' ');
    stl.add('	<table border="1" border-style="single"><tr><td>Identificacao</td><td>Descrição</td><td>Posição Inicial</td><td>Tamanho</td><td>Tamanho Encontrado</td><td>Validação</td><td>Texto</td></tr>');

    try
     if (cdsLayout.RecordCount > 0) and (edtTextoParaValidar.Text <> '') then
      begin
       cdsLayout.First;
       while not cdsLayout.Eof do
        begin
         sValidacao := '';
         sText := Copy(edtTextoParaValidar.Text, cdsLayoutPosicaoInicial.AsInteger, cdsLayoutTamanho.AsInteger);
         iTamanhoEncontrado := Length(sText);

         if (cdsLayoutTamanho.AsInteger <> iTamanhoEncontrado) then
          sValidacao := 'Tamanho do campo incorreto. ';

         if (cdsLayoutValoresValidos.AsString <> '') then
          begin
           if (cdsLayoutValoresValidos.AsString <> sText) then
            sValidacao := sValidacao + 'Valor incorreto para o campo. ';
          end;

         stl.add(Format('		<tr><td>%d</td><td>%s</td><td>%d</td><td>%d</td><td>%d</td><td>%s</td><td>%s</td></tr>',
                 [cdsLayoutid.AsInteger, cdsLayoutDescricao.AsString, cdsLayoutPosicaoInicial.AsInteger, cdsLayoutTamanho.AsInteger, iTamanhoEncontrado, sValidacao, QuotedStr(sText)]));

         cdsLayout.Next;
        end;

       stl.add('	</table>');
       stl.add(' ');
       stl.add('    <!-- Optional JavaScript -->');
       stl.add('    <!-- jQuery first, then Popper.js, then Bootstrap JS -->');
       stl.add('    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>');
       stl.add('    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>');
       stl.add('    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>');
       stl.add('  </body>');
       stl.add('</html>');

       stl.SaveToFile(SaveDlgResultado.FileName);
       ShellExecute(handle,'open',PChar(SaveDlgResultado.FileName), '','',SW_SHOWNORMAL);

       ShowMessage('Validação concluída!');
      end
     else ShowMessage('Não há layout para realizar a validação.');
    finally
     stl.Free;
    end;
   end;
end;

procedure TfrmMain.CarregarLayout1Click(Sender: TObject);
var
  Ini: TIniFile;
begin
  if OpenDlg.Execute then
   begin
    try
     Ini := TIniFile.Create(ChangeFileExt(OpenDlg.FileName, '.INI'));
     edtTextoParaValidar.Text := Ini.ReadString('Config', 'TextoValidacao', '');
     cdsLayout.LoadFromFile(OpenDlg.FileName);
    finally
     Ini.Free;
    end;
   end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  cdsLayout.CreateDataSet;
end;

procedure TfrmMain.SalvarLayout1Click(Sender: TObject);
var
  Ini: TIniFile;
begin
  if SaveDlg.Execute then
   begin
    try
     Ini := TIniFile.Create(ChangeFileExt(SaveDlg.FileName, '.INI'));
     Ini.WriteString('Config', 'TextoValidacao', edtTextoParaValidar.Text);
     cdsLayout.SaveToFile(SaveDlg.FileName, dfxml);
    finally
     Ini.Free;
    end;
   end;
end;

end.
