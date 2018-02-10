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
  cxGridCustomView, cxGrid, Vcl.Menus, shellapi;

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
  sText: String;
  iTamanhoEncontrado: Integer;
begin
  if SaveDlgResultado.Execute then
   begin
    stl := TStringList.Create;
    stl.add('<html><head><title>Resultado da Validação do Registro</title></head><body>');

    try
     if (cdsLayout.RecordCount > 0) and (edtTextoParaValidar.Text <> '') then
      begin
       stl.add(Format('<div><b>Linha a Ser Validada: %s</b></div>', [edtTextoParaValidar.Text]));
       stl.add('<table><tr><td>Identificacao</td><td>Descrição</td><td>Posição Inicial</td><td>Tamanho</td><td>Tamanho Encontrado</td><td>Texto</td></tr>');
       cdsLayout.First;
       while not cdsLayout.Eof do
        begin
         sText := Copy(edtTextoParaValidar.Text, cdsLayoutPosicaoInicial.AsInteger, cdsLayoutTamanho.AsInteger);
         iTamanhoEncontrado := Length(sText);

         stl.add(Format('<tr><td>%d</td><td>%s</td><td>%d</td><td>%d</td><td>%d</td><td>%s</td></tr>',
                 [cdsLayoutid.AsInteger, cdsLayoutDescricao.AsString, cdsLayoutPosicaoInicial.AsInteger, cdsLayoutTamanho.AsInteger, iTamanhoEncontrado, QuotedStr(sText)]));

         cdsLayout.Next;
        end;

       stl.add('</table></body></html>');

       stl.SaveToFile(SaveDlgResultado.FileName);
       ShellExecute(handle,'open',PChar(edtTextoParaValidar.Text), '','',SW_SHOWNORMAL);

       ShowMessage('Validação concluída!');
      end
     else ShowMessage('Não há layout para realizar a validação.');
    finally
     stl.Free;
    end;
   end;
end;

procedure TfrmMain.CarregarLayout1Click(Sender: TObject);
begin
  if OpenDlg.Execute then
   begin
    cdsLayout.LoadFromFile(OpenDlg.FileName);
   end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  cdsLayout.CreateDataSet;
end;

procedure TfrmMain.SalvarLayout1Click(Sender: TObject);
begin
  if SaveDlg.Execute then
   begin
    cdsLayout.SaveToFile(SaveDlg.FileName, dfxml);
   end;
end;

end.
