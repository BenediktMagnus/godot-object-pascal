library Test;

{$mode objfpc}{$H+}

uses
    {$IFDEF UNIX}
        {$IFDEF UseCThreads}
            cthreads,
        {$ENDIF}
    {$ENDIF}
    GDNative,
    GodotNativescript,
    GodotVariant,
    GodotArray;

function TestConstructor (GodotObject: PGodotObject; MethodData: Pointer): Pointer; cdecl;
begin
    WriteLn('TestConstructor called.');

    Result := nil;
end;

procedure TestDestructor (GodotObject: PGodotObject; MethodData, UserData: Pointer); cdecl;
begin
    WriteLn('TestDestructor called.');
end;

function TestReady(GodotObject: PGodotObject; MethodData, UserData: Pointer; ParameterCount: Integer; Parameters: PPGodotVariant): TGodotVariant; cdecl;
begin
    godot_variant_new_nil(@Result);
    WriteLn('TestReady called.');
end;

procedure godot_gdnative_init (Options: Pointer); cdecl;
begin
end;

procedure godot_gdnative_terminate (Options: Pointer); cdecl;
begin
end;

procedure godot_nativescript_init (GDNativeHandle: Pointer); cdecl;
var
    CreateFunction: TGodotInstanceCreateFunction;
    DestroyFunction: TGodotInstanceDestroyFunction;
    Method: TGodotInstanceMethod;
    Attributes: TGodotMethodAttributes;
begin
    WriteLn('Nativescript Init');

    CreateFunction.CreateFunction := @TestConstructor;
    DestroyFunction.DestroyFunction := @TestDestructor;

    godot_nativescript_register_class(GDNativeHandle, 'TestClass', 'Node', CreateFunction, DestroyFunction);

    Method.Method := @TestReady;
    Attributes.RpcType := GodotMethodRpcModeDisabled;

    godot_nativescript_register_method(GDNativeHandle, 'TestClass', '_ready', Attributes, Method);
end;

function some_test_procedure (Data: Pointer; Parameters: PGodotArray): TGodotVariant; cdecl;
var
    TestInt: TGodotVariant;
begin
    godot_variant_new_int(@TestInt, 42);

    Result := TestInt;
end;

exports
    godot_gdnative_init,
    godot_gdnative_terminate,
    godot_nativescript_init,
    some_test_procedure;

end.