// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved. 
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
/// <summary> 
/// UPC-A barcode font implementation from IDAutomation
/// from: https://www.barcodefaq.com/barcode-properties/symbologies/upc-a/
/// Is most commonly used to encode 12 digits of the GTIN.
/// </summary>
codeunit 9223 UPCA_BarcodeEncoderImpl
{
    Access = Internal;

    /// <summary> 
    /// Encodes the barcode string to print a barcode using the IDautomation barcode font.
    /// From: https://en.wikipedia.org/wiki/Universal_Product_Code
    /// The Universal Product Code (UPC; redundantly: UPC code) is a barcode symbology that is widely used in the United States, Canada, Europe, Australia, New Zealand, and other countries for tracking trade items in stores.
    /// UPC (technically refers to UPC-A) consists of 12 numeric digits that are uniquely assigned to each trade item. Along with the related EAN barcode, the UPC is the barcode mainly used for scanning of trade items at the point of sale, per GS1 specifications. 
    /// UPC data structures are a component of GTINs and follow the global GS1 specification, which is based on international standards. But some retailers (clothing, furniture) do not use the GS1 system (rather other barcode symbologies or article number systems). 
    /// On the other hand, some retailers use the EAN/UPC barcode symbology, but without using a GTIN (for products sold in their own stores only).    
    /// </summary>
    /// <param name="TempBarcodeParameters">Parameter of type Record BarcodeParameters temporary which sets the neccessary parameters for the requested barcode.</param>
    /// <param name="EncodedText">Parameter of type Text.</param>
    /// <param name="IsHandled">Parameter of type Boolean.</param>
    procedure FontEncoder(var TempBarcodeParameters: Record BarcodeParameters temporary; var EncodedText: Text; IsHandled: Boolean)
    var
        FontEncoder: DotNet dnFontEncoder;
    begin
        if IsHandled then exit;

        FontEncoder := FontEncoder.FontEncoder();
        EncodedText := FontEncoder.UPCA(TempBarcodeParameters."Input String");
    end;

    /// <summary> 
    /// Encodes the barcode string to generate a barcode image in Base64 format
    /// From: https://en.wikipedia.org/wiki/Universal_Product_Code
    /// The Universal Product Code (UPC; redundantly: UPC code) is a barcode symbology that is widely used in the United States, Canada, Europe, Australia, New Zealand, and other countries for tracking trade items in stores.
    /// UPC (technically refers to UPC-A) consists of 12 numeric digits that are uniquely assigned to each trade item. Along with the related EAN barcode, the UPC is the barcode mainly used for scanning of trade items at the point of sale, per GS1 specifications. 
    /// UPC data structures are a component of GTINs and follow the global GS1 specification, which is based on international standards. But some retailers (clothing, furniture) do not use the GS1 system (rather other barcode symbologies or article number systems). 
    /// On the other hand, some retailers use the EAN/UPC barcode symbology, but without using a GTIN (for products sold in their own stores only).    
    /// 
    /// This Function is currently throwing an error when the paramater "IsHandled" = false, and is reserved for future use when Base64ImageEncoding will be supported.
    /// </summary>
    /// <param name="TempBarcodeParameters">Parameter of type Record BarcodeParameters temporary.</param>
    /// <param name="Base64Image">Parameter of type Text.</param>
    /// <param name="IsHandled">Parameter of type Boolean.</param>
    procedure Base64ImageEncoder(var TempBarcodeParameters: Record BarcodeParameters temporary; var Base64Image: Text; IsHandled: Boolean);
    var
        NotImplementedErr: Label 'Base64 Image Encoding is currently not implemented for Provider%1 and Symbology %2', comment = '%1 =  Provider Caption, %2 = Symbology Caption';
    begin
        if IsHandled then exit;

        Error(NotImplementedErr, TempBarcodeParameters.Provider, TempBarcodeParameters.Symbology);
    end;

    /// <summary> 
    /// Validates the Input String of the barcode.
    /// From: https://en.wikipedia.org/wiki/Universal_Product_Code
    /// Assumes that input is not-null and non-empty
    /// Only 0-9 characters are valid input characters
    /// Using regex from https://www.neodynamic.com/Products/Help/BarcodeWinControl2.5/working_barcode_symbologies.htm
    /// </summary>
    /// <param name="TempBarcodeParameters">Parameter of type Record BarcodeParameters temporary which sets the neccessary parameters for the requested barcode.</param>
    /// <param name="InputStringOK">Parameter of type Boolean.</param>
    /// <param name="IsHandled">Parameter of type Boolean.</param>
    procedure ValidateInputString(var TempBarcodeParameters: Record BarcodeParameters temporary; var InputStringOK: Boolean; IsHandled: Boolean)
    var
        RegexPattern: codeunit Regex;
    begin
        if IsHandled then exit;

        InputStringOK := true;
        // null or empty
        if (TempBarcodeParameters."Input String" = '') then begin
            InputStringOK := false;
            exit;
        end;

        // exit early if input string is not 11, 12, 14, or 17 characters long
        case strlen(TempBarcodeParameters."Input String") of
            11:
                exit;
            12:
                exit;
            14:
                exit;
            17:
                exit;
            else
                InputStringOK := false;
        end;
        // match any string containing non-digit characters
        InputStringOK := RegexPattern.IsMatch(TempBarcodeParameters."Input String", '@"[^\d]"');
    end;
}