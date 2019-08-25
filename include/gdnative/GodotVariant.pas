unit GodotVariant;

interface

const
    GodotVariantSize = 16 + SizeOf(Pointer);

type
    PPGodotVariant = ^PGodotVariant;
    PGodotVariant = ^TGodotVariant;
    TGodotVariant = record
        _dont_touch_that: Array[0..GodotVariantSize-1] of Byte;
    end;

procedure godot_variant_new_int (GodotVariant: PGodotVariant; const Value: Int64); cdecl; external;
procedure godot_variant_new_nil (GodotVariant: PGodotVariant); cdecl; external;

implementation

end.