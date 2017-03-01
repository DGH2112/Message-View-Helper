(**

  This module contains a form for hosting the options frame for older IDEs.

  @Author  David Hoyle
  @Version 1.0
  @Date    01 Mar 2017

**)
Unit MsgViewHelper.OptionsForm;

Interface

{$INCLUDE CompilerDefinitions.inc}

Uses
  {$IFDEF DXE20}System.Classes{$ELSE}Classes{$ENDIF},
  {$IFDEF DXE20}Vcl.Controls{$ELSE}Controls{$ENDIF},
  {$IFDEF DXE20}Vcl.Forms{$ELSE}Forms{$ENDIF},
  {$IFDEF DXE20}Vcl.ExtCtrls{$ELSE}ExtCtrls{$ENDIF},
  {$IFDEF DXE20}Vcl.StdCtrls{$ELSE}StdCtrls{$ENDIF},
  {$IFDEF DXE20}Vcl.Buttons{$ELSE}Buttons{$ENDIF},
  MsgViewHelper.OptionsFrame;

Type
  (** A form for histing the options frame in older IDEs. **)
  TfrmMVHOptions = Class(TForm)
    pnlOptionsFrame: TPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure FormCreate(Sender: TObject);
  Private
    { Private declarations }
    FOptionsFrame : TframeMVHOptions;
  Public
    { Public declarations }
    Class Function Execute : Boolean;
  End;

Implementation

{$R *.dfm}

(**

  This method invokes the options form dialogue to configuring the applications options.

  @precon  None.
  @postcon Displays the dialogue for the user to configure the options. The options are only updated
           if the dialogue is confirmed.

  @return  a Boolean

**)
Class Function TfrmMVHOptions.Execute: Boolean;

Var
  F : TfrmMVHOptions;

Begin
  Result := False;
  F := TfrmMVHOptions.Create(Nil);
  Try
    F.FOptionsFrame.InitialiseFrame;
    If F.ShowModal = mrOk Then
      Begin
        F.FOptionsFrame.FinaliseFrame;
        Result := True;
      End;
  Finally
    F.Free;
  End;
End;

(**

  This is an OnFormCreate Event Handler for the TfrmMVHOptions class.

  @precon  None.
  @postcon Creates and installs the options frame in the dialogue panel.

  @param   Sender as a TObject

**)
Procedure TfrmMVHOptions.FormCreate(Sender: TObject);

Begin
  FOptionsFrame := TframeMVHOptions.Create(Self);
  FOptionsFrame.Parent := pnlOptionsFrame;
  FOptionsFrame.Align := alClient;
End;

End.
