unit GodotArray;

interface

const
    GodotArraySize = SizeOf(Pointer);

type
    PGodotArray = ^TGodotArray;
    TGodotArray = record
        _dont_touch_that: Array[0..GodotArraySize-1] of Byte;
    end;

implementation

end.