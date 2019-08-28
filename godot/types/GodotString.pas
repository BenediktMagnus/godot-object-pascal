unit GodotString;

{$mode objfpc}{$H+}

{$IFDEF FPC}
    {$PACKRECORDS C}
{$ENDIF}

interface

const
    GodotStringSize = SizeOf(Pointer);

type
    PGodotString = ^TGodotString;
    TGodotString = record
        _dont_touch_that: Array[0..GodotStringSize-1] of Byte;
    end;

implementation

end.