// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved. 
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
/// <summary> 
/// ITF barcode font implementation from IDAutomation
/// from: https://www.idautomation.com/barcode-fonts/interleaved-2of5/
/// Interleaved 2 of 5 (ITF) is a numeric only barcode used to encode pairs of numbers into a self-checking, high-density barcode format
/// </summary>
codeunit 9227 I2of5_BarcodeEncoderImpl
{
    Access = Internal;

    /// <summary> 
    /// Encodes the barcode string to print a barcode using the IDautomation barcode font.
    /// From: https://en.wikipedia.org/wiki/Interleaved_2_of_5
    /// Interleaved 2 of 5 (ITF) is a continuous two-width barcode symbology encoding digits. 
    /// It is used commercially on 135 film, for ITF-14 barcodes, and on cartons of some products, while the products inside are labeled with UPC or EAN.
    /// ITF encodes pairs of digits; the first digit is encoded in the five bars (or black lines), while the second digit is encoded in the five spaces (or white lines) interleaved with them. 
    /// Two out of every five bars or spaces are wide (hence exactly 2 of 5).
    /// </summary>
    /// <param name="TempBarcodeParameters">Parameter of type Record BarcodeParameters temporary which sets the neccessary parameters for the requested barcode.</param>
    /// <param name="EncodedText">Parameter of type Text.</param>
    /// <param name="IsHandled">Parameter of type Boolean.</param>
    procedure FontEncoder(var TempBarcodeParameters: Record BarcodeParameters temporary; var EncodedText: Text; IsHandled: Boolean)
    var
        FontEncoder: DotNet dnFontEncoder;
        UseMod10: Boolean;
    begin
        if IsHandled then exit;

        FontEncoder := FontEncoder.FontEncoder();
        if UseMod10 then
            EncodedText := FontEncoder.I2of5Mod10(TempBarcodeParameters."Input String")
        else
            EncodedText := FontEncoder.I2of5(TempBarcodeParameters."Input String");
    end;

    /// <summary> 
    /// Validates the Input String of the barcode.
    /// From: https://en.wikipedia.org/wiki/Interleaved_2_of_5
    /// Assumes that input is not-null and non-empty
    /// Only 0-9 characters are valid input characters
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

        // match any string containing non-digit characters
        ValidationResult := RegexPattern.IsMatch(TempBarcodeParameters."Input String", '@"[^\d]"');
    end;

    // Format the Inputstring of the barcode
    procedure Barcode(var TempBarcodeParameters: Record BarcodeParameters temporary; var Base64Data: Text; IsHandled: Boolean)
    begin
        if IsHandled then exit;
    end;
}