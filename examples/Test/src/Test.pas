library Test;

{$mode objfpc}{$H+}

uses
    {$IFDEF UNIX}
        {$IFDEF UseCThreads}
            cthreads,
        {$ENDIF}
    {$ENDIF}
    GDNativeApi,
    GodotObject,
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

function TestReady (GodotObject: PGodotObject; MethodData, UserData: Pointer; ParameterCount: Integer; Parameters: PPGodotVariant): TGodotVariant; cdecl;
begin
    WriteLn('TestReady called.');

    GodotGDNativeCoreApi.GodotVariantNewNil(@Result);
end;

procedure godot_gdnative_init (OptionsPointer: PGodotGDNativeInitOptions); cdecl;
var
    Options: TGodotGDNativeInitOptions;
begin
    WriteLn('gdnative_init called.');

    Options := OptionsPointer^;

    GodotApiExtraction(Options.GodotGDNativeCoreApi);
end;

procedure godot_gdnative_terminate (Options: Pointer); cdecl;
begin
    WriteLn('gdnative_terminate called.');
end;

procedure godot_nativescript_init (GDNativeHandle: Pointer); cdecl;
var
    CreateFunction: TGodotInstanceCreateFunction;
    DestroyFunction: TGodotInstanceDestroyFunction;
    Method: TGodotInstanceMethod;
    Attributes: TGodotMethodAttributes;
    ClassName, BaseClass, FunctionName: PChar;
begin
    WriteLn('Nativescript_init called.');

    CreateFunction := Default(TGodotInstanceCreateFunction);
    CreateFunction.CreateFunction := @TestConstructor;

    DestroyFunction := Default(TGodotInstanceDestroyFunction);
    DestroyFunction.DestroyFunction := @TestDestructor;

    ClassName := 'TestClass';
    BaseClass := 'Node';

    GodotGDNativeExtensionNativescriptApi.GodotNativescriptRegisterClass(GDNativeHandle, ClassName, BaseClass, CreateFunction, DestroyFunction);

    Method := Default(TGodotInstanceMethod);
    Method.Method := @TestReady;

    Attributes.RpcType := GodotMethodRpcModeDisabled;

    FunctionName := '_ready';

    GodotGDNativeExtensionNativescriptApi.GodotNativescriptRegisterMethod(GDNativeHandle, ClassName, FunctionName, Attributes, Method);
end;

function some_test_procedure (Data: Pointer; Parameters: PGodotArray): TGodotVariant; cdecl;
var
    TestInt: TGodotVariant;
begin
    GodotGDNativeCoreApi.GodotVariantNewInt(@TestInt, 42);
    Result := TestInt;
end;

exports
    godot_gdnative_init,
    godot_gdnative_terminate,
    godot_nativescript_init,
    some_test_procedure;

end.