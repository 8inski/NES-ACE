/* Expose a Restricted NES ACE API to the Electron Renderer Process */

import {
	contextBridge,
	ipcRenderer
} from 'electron';

import type {
	AssemblerRequest,
	AssemblerResult,
	NesAceApi,
	PpuRequest,
	PpuResult,
	TasRequest,
	TasResult
} from './backend-api';

/* ============================== Renderer API =============================== */

// Forward Approved Renderer Requests to the Electron Main Process
const api: NesAceApi = {

	// Request a Glossary Entry for a 6502 Mnemonic
	glossary(
		mnemonic: string
	): Promise<string> {

		return ipcRenderer.invoke(
			'nes-ace:glossary',
			mnemonic
		);
	},

	// Assemble a 6502 Source Script
	assemble(
		request: AssemblerRequest
	): Promise<AssemblerResult> {

		return ipcRenderer.invoke(
			'nes-ace:assemble',
			request
		);
	},

	// Convert Text into PPU Write Inputs
	convertPpu(
		request: PpuRequest
	): Promise<PpuResult> {

		return ipcRenderer.invoke(
			'nes-ace:convert-ppu',
			request
		);
	},

	// Convert Emulator Inputs into SubNESHawk Inputs
	convertTas(
		request: TasRequest
	): Promise<TasResult> {

		return ipcRenderer.invoke(
			'nes-ace:convert-tas',
			request
		);
	},

	// Notify Electron After the Renderer Has Finished Its Initial Paint
	rendererReady(): void {

		ipcRenderer.send(
			'nes-ace:renderer-ready'
		);
	}
};

/* ============================= Context Bridge ============================== */

// Expose the Restricted API without Providing Direct Electron IPC Access
contextBridge.exposeInMainWorld(
	'nesAce',
	api
);
