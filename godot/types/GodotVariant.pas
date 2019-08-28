unit GodotVariant;

{$mode objfpc}{$H+}

{$IFDEF FPC}
    {$PACKRECORDS C}
{$ENDIF}

interface

const
    GodotVariantSize = 16 + SizeOf(Pointer);

type
    PPGodotVariant = ^PGodotVariant;
    PGodotVariant = ^TGodotVariant;
    TGodotVariant = record
        _dont_touch_that: Array[0..GodotVariantSize-1] of Byte;
    end;

implementation

end.