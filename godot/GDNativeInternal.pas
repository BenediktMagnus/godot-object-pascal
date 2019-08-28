unit GDNativeInternal;

{$mode objfpc}{$H+}

{$IFDEF FPC}
    {$PACKRECORDS C}
{$ENDIF}

interface

uses
    GodotObject,
    GodotString,
    GDNativeApi;

type
    TReportVersionMismatch = procedure (LibraryPointer: PGodotObject; Reason: PChar; ExpectedVersion, FoundVersion: TGodotGDNativeApiVersion); cdecl;
    TReportLoadingError = procedure (LibraryPointer: PGodotObject; Reason: PChar); cdecl;

type
    PGodotGDNativeInitOptions = ^TGodotGDNativeInitOptions;
    TGodotGDNativeInitOptions = record
        InEditor: Boolean;
        CoreApiHash: Int64;
        EditorApiHash: UInt64;
        NoApiHash: UInt64;
        ReportVersionMismatch: TReportVersionMismatch;
        ReportLoadingError: TReportLoadingError;
        GDNativeLibrary: PGodotObject; // Pointer to the GDNativeLibrary that is being initialised.
        GodotGDNativeCoreApi: PGodotGDNativeCoreApi;
        ActiveLibraryPath: PGodotString;
    end;

implementation

end.