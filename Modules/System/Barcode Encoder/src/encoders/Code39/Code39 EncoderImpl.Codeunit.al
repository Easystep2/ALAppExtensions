// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved. 
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
/// <summary> 
/// Code-39 barcode font implementation from IDAutomation
/// from: https://www.idautomation.com/barcode-fonts/code-39/ 
/// An alpha-numeric barcode that encodes uppercase letters, numbers and some symbols; it is also referred to as Barcode/39, the 3 of 9 Code and LOGMARS Code.
/// </summary>
codeunit 9211 Code39_BarcodeEncoderImpl
{
    Access = Internal;

    /// <summary> 
    /// Encodes the barcode string to print a barcode using the IDautomation barcode font.
    /// From: https://en.wikipedia.org/wiki/Code_39/
    /// aka Alpha39, Code 3 of 9, Code 3/9, Type 39, USS Code 39, or USD-3
    /// Replace any spaces with = signs
    /// IDAutomation Uses ! as stop/start symbol
    /// Extended Code 39 barcode fonts barcode fonts are provided to easily encode lower case and special characters in a self checking font environment and begin with IDAutomationSX. 
    /// Extended Code 39 fonts are not compatible with IDAutomation's font encoders, such as the MOD43 function, and the asterisk (*) must be used as the start and stop character. 
    /// For extended characters to scan properly, the scanner must first be enabled to read extended code 39. These fonts are not part of the standard install, and therefore must be manually installed.
    /// </summary>
    /// <param name="TempBarcodeParameters">Parameter of type Record BarcodeParameters temporary which sets the neccessary parameters for the requested barcode.</param>
    /// <param name="EncodedText">Parameter of type Text.</param> 
    /// <param name="IsHandled">Parameter of type Boolean.</param>
    procedure FontEncoder(var TempBarcodeParameters: Record BarcodeParameters temporary; var EncodedText: Text; IsHandled: Boolean)
    var
        FontEncoder: DotNet dnFontEncoder;
        strFormattedData: Text;
    begin
        if IsHandled then exit;


        strFormattedData := TempBarcodeParameters."Input String";

        /// <summary> 
        /// IDAutomation Uses ! as stop/start symbol for Code39 barcode fonts.
        /// Extended Code 39 fonts are not compatible with IDAutomation's font encoders, such as the MOD43 function, and the asterisk (*) must be used as the start and stop character. 
        /// </summary>
        if TempBarcodeParameters."Allow Extended Charset" then begin
            // IDAutomation Uses * as stop/start symbol
            EncodedText := '*' + TempBarcodeParameters."Input String" + '*';
        end
        else begin
            FontEncoder := FontEncoder.FontEncoder();

            If TempBarcodeParameters."Enable Checksum" then
                EncodedText := FontEncoder.Code39Mod43(strFormattedData)
            else
                EncodedText := FontEncoder.Code39(strFormattedData);
        end;
    end;

    /// <summary> 
    /// Validates if the Input String is a valid string to encode the barcode.
    /// From: https://en.wikipedia.org/wiki/Code_39
    /// The Code 39 specification defines 43 characters, consisting of 
    /// uppercase letters(A through Z), numeric digits(0 through 9) 
    /// and a number of special characters(-, ., $, /, +, %, and space).
    /// Using regex from https://www.neodynamic.com/Products/Help/BarcodeWinControl2.5/working_barcode_symbologies.htm
    /// </summary>
    /// <param name="TempBarcodeParameters">Parameter of type Record BarcodeParameters temporary which sets the neccessary parameters for the requested barcode.</param>
    /// <param name="ValidationResult">Parameter of type Boolean.</param>
    /// <param name="IsHandled">Parameter of type Boolean.</param>
    procedure ValidateInputString(var TempBarcodeParameters: Record BarcodeParameters temporary; var ValidationResult: Boolean; IsHandled: Boolean)
    var
        RegexPattern: codeunit Regex;
    begin
        if IsHandled then exit;

        ValidationResult := true;
        // null or empty
        if (TempBarcodeParameters."Input String" = '') then begin
            ValidationResult := false;
            exit;
        end;

        // Verify if input string containings only valid characters
        if TempBarcodeParameters."Allow Extended Charset" then
            ValidationResult := RegexPattern.IsMatch(TempBarcodeParameters."Input String", '^[\000-\177]*$')
        else
            ValidationResult := RegexPattern.IsMatch(TempBarcodeParameters."Input String", '^[0-9A-Z\-.$\/\+%\*\s]*$');
    end;

    // Format the Inputstring of the barcode
    procedure Barcode(var TempBarcodeParameters: Record BarcodeParameters temporary; var Base64Data: Text; IsHandled: Boolean)
    begin
        if IsHandled then exit;
    end;
}