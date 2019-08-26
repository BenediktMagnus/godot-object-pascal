unit GodotNativescript;

{$mode objfpc}{$H+}

interface

uses
    GDNative,
    GodotVariant;

type
    GodotMethodRpcMode = (
        GodotMethodRpcModeDisabled,
	    GodotMethodRpcModeRemote,
	    GodotMethodRpcModeMaster,
	    GodotMethodRpcModePuppet,
	    GodotMethodRpcModeRemotesync,
	    GodotMethodRpcModeMastersync,
	    GodotMethodRpcModePuppetsync
    );

const
	GodotMethodRpcModeSlave = GodotMethodRpcModePuppet;
	GodotMethodRpcModeSync = GodotMethodRpcModeRemotesync;

type
    // Instance functions:
    TCreateFunction = function (InstancePointer: PGodotObject; MethodData: Pointer): Pointer; cdecl; // Returns UserData
    TDestroyFunction = procedure (InstancePointer: PGodotObject; MethodData, UserData: Pointer); cdecl;
    TMethod = function (InstancePointer: PGodotObject; MethodData, UserData: Pointer; ParameterCount: Integer; Parameters: PPGodotVariant): TGodotVariant; cdecl;
    TFreeFunction = procedure (Parameter: Pointer);

type
    TGodotInstanceCreateFunction = record
        CreateFunction: TCreateFunction;
        MethodData: Pointer;
        FreeFunction: TFreeFunction;
    end;
    TGodotInstanceDestroyFunction = record
        DestroyFunction: TDestroyFunction;
        MethodData: Pointer;
        FreeFunction: TFreeFunction;
    end;

type
    TGodotMethodAttributes = record
        RpcType: GodotMethodRpcMode;
    end;
    TGodotInstanceMethod = record
        Method: TMethod;
        MethodData: Pointer;
        FreeFuncton: TFreeFunction;
    end;

procedure godot_nativescript_register_class (GDNativeHandle: Pointer; const ClassName: PChar; const BaseClass: PChar;
                                             CreateFunction: TGodotInstanceCreateFunction;
                                             DestroyFunction: TGodotInstanceDestroyFunction); cdecl; external;
procedure godot_nativescript_register_method (GDNativeHandle: Pointer; const ClassName: PChar; const FunctionName: PChar;
                                              Attributes: TGodotMethodAttributes;
                                              Method: TGodotInstanceMethod); cdecl; external;



implementation

end.