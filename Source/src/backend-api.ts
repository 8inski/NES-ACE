/* Define Types Shared Between the Electron Main, Preload and Renderer Processes */

/* ================================ Assembler ================================ */

// Data Sent to the C++ Backend for an Assembly Request
export interface AssemblerRequest {
	source: string;
	useUndocumented: boolean;
}

// Normalized Source Line Returned by the Assembler
export interface AssemblerLine {
	cleanedLine: string;
}

// Error Metadata Returned for an Invalid Source Line
export interface AssemblerError {
	index: number;
	cleanedLine: string;
	error: string;
}

// Segment Metadata Returned by the Assembler
export interface AssemblerSegment {
	index: number;
	length: number;
	origin: number;
	end: number;
}

// Complete Result Returned by an Assembly Request
export interface AssemblerResult {
	cleanedProgram: AssemblerLine[];
	errors: AssemblerError[];
	segments: AssemblerSegment[];
	byteCode: number[];
	inputs: string[];
}

/* ============================== PPU Converter ============================== */

// Data Sent to the C++ Backend for a PPU Conversion Request
export interface PpuRequest {
	address: string;
	text: string;
}

// Error Code Returned for an Invalid PPU Conversion Request
export type PpuErrorCode =
	'invalid-initial' |
	'outside-nametable' |
	'exceeds-buffer' |
	'unknown-ppu-error';

// Complete Result Returned by a Successful PPU Conversion Request
export interface PpuSuccessResult {
	valid: true;
	cleanedPayload: string;
	wrappedPayload: string;
	canWrap: boolean;
	length: number;
	byteCode: number[];
	inputs: string[];
}

// Complete Result Returned by an Invalid PPU Conversion Request
export interface PpuErrorResult {
	valid: false;
	error: PpuErrorCode;
	cleanedPayload: string;
	overflow: number;
}

// Complete Result Returned by Any PPU Conversion Request
export type PpuResult =
	PpuSuccessResult |
	PpuErrorResult;

/* ============================== TAS Converter ============================== */

// Supported Source Emulator and Player Mode Selections
export type TasEmulator =
	'fceux-2p' |
	'fceux-1p' |
	'neshawk-2p' |
	'neshawk-1p';

// Data Sent to the C++ Backend for a TAS Conversion Request
export interface TasRequest {
	source: string;
	emulator: TasEmulator;
}

// Complete Result Returned by a TAS Conversion Request
export interface TasResult {
	inputs: string[];
	convertedInputs: string[];
	lagFrames: number;
}

/* ============================== Renderer API =============================== */

// Functions Exposed by the Preload Script to the Renderer Process
export interface NesAceApi {
	glossary(
		mnemonic: string
	): Promise<string>;

	assemble(
		request: AssemblerRequest
	): Promise<AssemblerResult>;

	convertPpu(
		request: PpuRequest
	): Promise<PpuResult>;

	convertTas(
		request: TasRequest
	): Promise<TasResult>;

	rendererReady(): void;
}
