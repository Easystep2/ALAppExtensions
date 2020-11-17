// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved. 
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
/// <summary> 
/// MSI Plessey barcode font implementation from IDAutomation
/// from: https://www.idautomation.com/barcode-fonts/msi/
/// The MSI Plessey barcode symbology was designed in the 1970s by the Plessey Company in England and has practiced primarily in libraries and retail applications. 
/// The Plessey barcode character set consists of barcode symbols representing the numbers 0-9, the start character, and the stop character. 
/// In the MSI font, the parentheses are used for start and stop characters.
/// </summary>
codeunit 9231 MSI_BarcodeEncoderImpl
{
    Access = Internal;

    /// <summary> 
    /// Encodes the barcode string to print a barcode using the IDautomation barcode font.
    /// From: https://en.wikipedia.org/wiki/MSI_Barcode/
    /// MSI (also known as Modified Plessey) is a barcode symbology developed by the MSI Data Corporation, based on the original Plessey Code symbology. 
    /// It is a continuous symbology that is not self-checking. MSI is used primarily for inventory control, marking storage containers and shelves in warehouse environments.    
    /// </summary>
    /// <param name="TempBarcodeParameters">Parameter of type Record BarcodeParameters temporary.</param>
    /// <param name="EncodedText">Parameter of type Text.</param>
    /// <param name="IsHandled">Parameter of type Boolean.</param>
    procedure FontEncoder(var TempBarcodeParameters: Record BarcodeParameters temporary; var EncodedText: Text; IsHandled: Boolean)
    var
        FontEncoder: DotNet dnFontEncoder;
    begin
        if IsHandled then exit;

        FontEncoder := FontEncoder.FontEncoder();
        EncodedText := FontEncoder.MSI(TempBarcodeParameters."Input String");
    end;

    /// <summary> 
    /// Validates the Input String of the barcode.
    /// From: https://en.wikipedia.org/wiki/Interleaved_2_of_5
    /// Assumes that input is not-null and non-empty
    /// Only 0-9 characters are valid input characters
    /// Using regex from https://www.neodynamic.com/Products/Help/BarcodeWinControl2.5/working_barcode_symbologies.htm
    /// </summary>
    /// <param name="TempBarcodeParameters">Parameter of type Record BarcodeParameters temporary.</param>
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

        // match any string containing non-digit characters
        ValidationResult := RegexPattern.IsMatch(TempBarcodeParameters."Input String", '@"[^\d]"');
    end;

    // Format the Inputstring of the barcode
    procedure Barcode(var TempBarcodeParameters: Record BarcodeParameters temporary; var Base64Data: Text; IsHandled: Boolean)
    begin
        if IsHandled then exit;
    end;
}