object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Screen Changer'
  ClientHeight = 287
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 247
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    Visible = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 89
    Top = 247
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 1
    Visible = False
    OnClick = Button2Click
  end
  object DesctiptionMemo: TMemo
    Left = 16
    Top = 8
    Width = 313
    Height = 49
    Lines.Strings = (
      #1044#1072#1085#1085#1072#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1072' '#1087#1088#1077#1076#1085#1072#1079#1085#1072#1095#1077#1085#1072' '#1076#1083#1103' '#1089#1083#1091#1095#1072#1077#1074', '#1082#1086#1075#1076#1072' '#1074#1099' '
      #1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1077' '#1085#1077#1089#1082#1086#1083#1100#1082#1086' '#1084#1086#1085#1080#1090#1086#1088#1086#1074', '#1087#1088#1080' '#1101#1090#1086#1084' '#1091' '#1074#1072#1089' '#1085#1077#1090' '
      #1086#1076#1085#1086#1074#1088#1077#1084#1077#1085#1085#1086#1081' '#1074#1080#1076#1080#1084#1086#1089#1090#1080' '#1080#1093' '#1086#1073#1086#1080#1093)
    TabOrder = 2
  end
  object HowToUse: TMemo
    Left = 16
    Top = 63
    Width = 313
    Height = 178
    Lines.Strings = (
      #1055#1088#1080' '#1087#1077#1088#1074#1086#1084' '#1079#1072#1087#1091#1089#1082#1077' '#1074#1099' '#1091#1074#1080#1076#1080#1090#1077' '#1101#1090#1086' '#1086#1082#1085#1086' '#1089' '#1080#1085#1089#1090#1088#1091#1082#1094#1080#1103#1084#1080'.'
      #1055#1088#1080' '#1074#1090#1086#1088#1086#1084' '#1079#1072#1087#1091#1089#1082#1077' '#1080' '#1087#1086#1089#1083#1077#1076#1091#1102#1097#1080#1093' '#1079#1072#1087#1091#1089#1082#1072#1093', '#1076#1072#1085#1085#1086#1077' '
      #1086#1082#1085#1086' '#1085#1077' '#1087#1086#1103#1074#1080#1090#1089#1103'.'
      ''
      #1055#1088#1080' '#1074#1090#1086#1088#1086#1084' '#1079#1072#1087#1091#1089#1082#1077': '#1074#1089#1077' '#1086#1090#1082#1088#1099#1090#1099#1077' '#1086#1082#1085#1072' '#1074#1072#1096#1077#1081' '#1089#1080#1089#1090#1077#1084#1099' '
      #1086#1082#1072#1078#1091#1090#1089#1103' '#1087#1086#1089#1077#1088#1077#1076#1080#1085#1077' '#1101#1082#1088#1072#1085#1086#1074'. '
      #1055#1077#1088#1077#1076#1074#1080#1085#1100#1090#1077' '#1082#1091#1076#1072' '#1085#1091#1078#1085#1086' '#1086#1082#1085#1086', '#1082#1086#1090#1086#1088#1099#1084' '#1074#1072#1084' '#1085#1072#1076#1086' '
      #1074#1086#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100#1089#1103'.'
      ''
      #1044#1072#1083#1100#1096#1077', '#1089#1085#1086#1074#1072' '#1079#1072#1081#1076#1080#1090#1077' '#1074' '#1087#1088#1086#1075#1088#1072#1084#1084#1091'. '#1069#1090#1086' '#1073#1091#1076#1077#1090' '#1090#1088#1077#1090#1080#1081' '
      #1079#1072#1087#1091#1089#1082'.'
      #1055#1088#1080' '#1090#1088#1077#1090#1100#1077#1084' '#1079#1072#1087#1091#1089#1082#1077', '#1074#1089#1077' '#1086#1082#1085#1072', '#1082#1086#1090#1086#1088#1099#1077' '#1074#1099' '#1085#1077' '#1090#1088#1086#1075#1072#1083#1080' '
      #1074#1077#1088#1085#1091#1090#1100#1089#1103' '#1085#1072' '#1089#1074#1086#1080' '#1089#1090#1072#1088#1099#1077' '#1084#1077#1089#1090#1072'.'
      '')
    TabOrder = 3
  end
  object GotItBtn: TButton
    Left = 232
    Top = 247
    Width = 97
    Height = 25
    Caption = #1055#1086#1085#1103#1090#1085#1086'!'
    TabOrder = 4
    OnClick = GotItBtnClick
  end
end
