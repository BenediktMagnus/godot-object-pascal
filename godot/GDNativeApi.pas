unit GDNativeApi;

{$mode objfpc}{$H+}

{$IFDEF FPC}
    {$PACKRECORDS C}
{$ENDIF}

interface

uses
    GodotObject,
    GodotVariant;

const
    GodoApiVersion = 1;

// API core and extension types:
const
    // The core API type:
    GDNativeCore = 0;
    // The extension API types:
    GDNativeExtensionNativescript = 1;
	GDNativeExtensionPluginscript = 2;
	GDNativeExtensionAndroid = 3;
	GDNativeExtensionARVR = 4;
	GDNativeExtensionVideorecord = 5;
	GDNativeExtensionNet = 6;
    // The number of extensions:
    GDNativeExtensionCount = 6;

// Method RPC modes:
// Attention: Muste be an enum because Godot does not use cardinals for this type!
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

// Method instance functions:
type
    TCreateFunction = function (InstancePointer: PGodotObject; MethodData: Pointer): Pointer; cdecl; // Returns UserData
    TDestroyFunction = procedure (InstancePointer: PGodotObject; MethodData, UserData: Pointer); cdecl;
    TMethod = function (InstancePointer: PGodotObject; MethodData, UserData: Pointer; ParameterCount: Integer; Parameters: PPGodotVariant): TGodotVariant; cdecl;
    TFreeFunction = procedure (Parameter: Pointer);

// Method related records:
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
    TGodotMethodAttributes = record
        RpcType: GodotMethodRpcMode;
    end;
    TGodotInstanceMethod = record
        Method: TMethod;
        MethodData: Pointer;
        FreeFuncton: TFreeFunction;
    end;

// API related records:
type
    TGodotGDNativeApiVersion = record
        Major: Cardinal;
        Minor: Cardinal;
    end;

// API header:
type
    PGodotGDNativeApiHeader = ^TGodotGDNativeApiHeader;
    TGodotGDNativeApiHeader = record
        ApiType: Cardinal;
        ApiVersion: TGodotGDNativeApiVersion;
        Next: PGodotGDNativeApiHeader;
    end;

// API helper types:
type
    PGDNativeApiExtensionArray = ^TGDNativeApiExtensionArray;
    TGDNativeApiExtensionArray = Array[0..GDNativeExtensionCount-1] of PGodotGDNativeApiHeader;

// API functions:
type
    TGodotNativescriptRegisterClass = procedure (GDNativeHandle: Pointer; ClassName: PChar; BaseClass: PChar;
                                                 CreateFunction: TGodotInstanceCreateFunction;
                                                 DestroyFunction: TGodotInstanceDestroyFunction); cdecl;
    TGodotNativescriptRegisterMethod = procedure  (GDNativeHandle: Pointer; ClassName: PChar; FunctionName: PChar;
                                                   Attributes: TGodotMethodAttributes;
                                                   Method: TGodotInstanceMethod); cdecl;
    TGodotVariantNewNil = procedure (GodotVariant: PGodotVariant); cdecl;
    TGodotVariantNewInt = procedure (GodotVariant: PGodotVariant; Value: Int64); cdecl;

// APIs:
type
    PGodotGDNativeCoreApi = ^TGodotGDNativeCoreApi;
    TGodotGDNativeCoreApi = record
        ApiType: Cardinal;
        ApiVersion: TGodotGDNativeApiVersion;
        Next: PGodotGDNativeApiHeader;
        ExtensionCount: Cardinal;
        Extensions: PGDNativeApiExtensionArray;
        Functions1: Array[0..508] of Pointer;
        GodotVariantNewNil: TGodotVariantNewNil;
        GodotVariantNewBool: Pointer;
        GodotVariantNewUInt: Pointer;
        GodotVariantNewInt: TGodotVariantNewInt;
        Functions2: Array[0..230] of Pointer;
    end;
    PGodotGDNativeExtensionNativescriptApi = ^TGodotGDNativeExtensionNativescriptApi;
    TGodotGDNativeExtensionNativescriptApi = record
        ApiType: Cardinal;
        ApiVersion: TGodotGDNativeApiVersion;
        Next: PGodotGDNativeApiHeader;
        GodotNativescriptRegisterClass: TGodotNativescriptRegisterClass;
        FunctionToolClass: Pointer;
        GodotNativescriptRegisterMethod: TGodotNativescriptRegisterMethod;
        Functions: Array[0..2] of Pointer;
    end;

procedure GodotApiExtraction (GodotGDNativeApiPointer: PGodotGDNativeCoreApi);

var
    GodotGDNativeCoreApi: TGodotGDNativeCoreApi;
    GodotGDNativeExtensionNativescriptApi: TGodotGDNativeExtensionNativescriptApi;

implementation

procedure GodotApiExtraction (GodotGDNativeApiPointer: PGodotGDNativeCoreApi);
var
    i: Integer;
    ExtensionArrayPointer: PGDNativeApiExtensionArray;
    ExtensionArray: TGDNativeApiExtensionArray;
    ExtensionPointer: PGodotGDNativeApiHeader;
    Extension: TGodotGDNativeApiHeader;
begin
    GodotGDNativeCoreApi := GodotGDNativeApiPointer^;

    for i := 0 to GodotGDNativeCoreApi.ExtensionCount - 1 do
    begin
        ExtensionArrayPointer := GodotGDNativeCoreApi.Extensions;
        ExtensionArray := ExtensionArrayPointer^;

        ExtensionPointer := ExtensionArray[i];
        Extension := ExtensionPointer^;

        if Extension.ApiType = GDNativeExtensionNativescript then
        begin
            GodotGDNativeExtensionNativescriptApi := PGodotGDNativeExtensionNativescriptApi(ExtensionPointer)^;
        end;
    end;
end;

end.