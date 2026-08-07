/* Manage the Electron Window, Validate Renderer Requests and Route Them to C++ */

import {
	app,
	BrowserWindow,
	ipcMain,
	nativeTheme
} from 'electron';

import path from 'node:path';
import started from 'electron-squirrel-startup';

import type {
	AssemblerRequest,
	AssemblerResult,
	PpuRequest,
	PpuResult,
	TasRequest,
	TasResult
} from './backend-api';

import {
	invokeBackend,
	stopBackend,
	warmBackend
} from './backend';

/* ============================ Squirrel Startup ============================= */

// Exit Immediately When Electron Squirrel Performs Install/Update Events
if (started) {
	app.quit();
}

/* =========================== Request Validation ============================ */

// Confirm a Value Can Be Safely Inspected as a Request Object
function isRecord(
	value: unknown
): value is Record<string, unknown> {
	return typeof value === 'object' && value !== null;
}

// Validate and Build an Assembler Request from Renderer Data
function parseAssemblerRequest(
	value: unknown
): AssemblerRequest {

	if (
		!isRecord(value) ||
		typeof value.source !== 'string' ||
		typeof value.useUndocumented !== 'boolean'
	) {
		throw new TypeError('Invalid assembler request.');
	}

	return {
		source: value.source,
		useUndocumented: value.useUndocumented
	};
}

// Validate and Build a PPU Converter Request from Renderer Data
function parsePpuRequest(
	value: unknown
): PpuRequest {

	if (
		!isRecord(value) ||
		typeof value.address !== 'string' ||
		typeof value.text !== 'string'
	) {
		throw new TypeError('Invalid PPU converter request.');
	}

	return {
		address: value.address,
		text: value.text
	};
}

// Validate and Build a TAS Converter Request from Renderer Data
function parseTasRequest(
	value: unknown
): TasRequest {

	if (
		!isRecord(value) ||
		typeof value.source !== 'string' ||
		(
			value.emulator !== 'fceux-2p' &&
			value.emulator !== 'fceux-1p' &&
			value.emulator !== 'neshawk-2p' &&
			value.emulator !== 'neshawk-1p'
		)
	) {
		throw new TypeError('Invalid TAS converter request.');
	}

	return {
		source: value.source,
		emulator: value.emulator
	};
}

/* ============================= Window Creation ============================= */

// Create the Fixed-Size Main Window and Load the Development or Packaged Renderer
function createWindow(): void {

	// Use the Source Icon during Development and Its Copied Resource after Packaging
	const iconPath = (app.isPackaged)
		? path.join(
			process.resourcesPath,
			'nes-ace.ico'
		)
		: path.join(
			app.getAppPath(),
			'assets',
			'nes-ace.ico'
		);

	const mainWindow = new BrowserWindow({
		width: 880,
		height: 400,
		useContentSize: true,
		resizable: false,
		maximizable: false,
		fullscreenable: false,
		autoHideMenuBar: true,
		show: false,
		backgroundColor: '#1c2127',
		icon: iconPath,

		webPreferences: {
			contextIsolation: true,
			nodeIntegration: false,
			preload: path.join(
				__dirname,
				'preload.js'
			)
		}
	});

	// Keep the Native Window Hidden Until Chromium Has Rendered the Page,
	// Preventing Raw HTML or Partially Applied Styles from Flashing Onscreen
	const startupTimeout = setTimeout(
		() => {

			if (
				!mainWindow.isDestroyed() &&
				!mainWindow.isVisible()
			) {
				console.warn(
					'Renderer startup timed out; showing the window.'
				);

				mainWindow.show();
			}
		},
		5000
	);

	mainWindow.once(
		'show',
		() => {
			clearTimeout(startupTimeout);
		}
	);

	mainWindow.once(
		'closed',
		() => {
			clearTimeout(startupTimeout);
		}
	);

	if (MAIN_WINDOW_VITE_DEV_SERVER_URL) {
		mainWindow.loadURL(
			MAIN_WINDOW_VITE_DEV_SERVER_URL
		);

	} else {

		mainWindow.loadFile(
			path.join(
				__dirname,
				`../renderer/${MAIN_WINDOW_VITE_NAME}/index.html`
			)
		);
	}
}

/* ============================== IPC Handlers =============================== */

// Register Renderer Requests After Electron Has Finished Initializing
app.whenReady().then(() => {

	nativeTheme.themeSource = 'dark';

	// Request a Glossary Entry from the C++ Backend
	ipcMain.handle(
		'nes-ace:glossary',
		(_event, mnemonic: unknown) => {

			if (typeof mnemonic !== 'string') {
				throw new TypeError(
					'Glossary mnemonic must be a string.'
				);
			}

			return invokeBackend<string>(
				'glossary',
				{
					mnemonic
				}
			);
		}
	);

	// Request 6502 Assembly from the C++ Backend
	ipcMain.handle(
		'nes-ace:assemble',
		(_event, value: unknown) => {

			const request = parseAssemblerRequest(value);

			return invokeBackend<AssemblerResult>(
				'assemble',
				request
			);
		}
	);

	// Request PPU Text Conversion from the C++ Backend
	ipcMain.handle(
		'nes-ace:convert-ppu',
		(_event, value: unknown) => {

			const request = parsePpuRequest(value);

			return invokeBackend<PpuResult>(
				'convertPpu',
				request
			);
		}
	);

	// Request Emulator Input Conversion from the C++ Backend
	ipcMain.handle(
		'nes-ace:convert-tas',
		(_event, value: unknown) => {

			const request = parseTasRequest(value);

			return invokeBackend<TasResult>(
				'convertTas',
				request
			);
		}
	);

	// Show the Window Only after the Renderer Has Applied Its Final Layout
	ipcMain.on(
		'nes-ace:renderer-ready',
		event => {

			const mainWindow = BrowserWindow.fromWebContents(event.sender);

			if (
				mainWindow &&
				!mainWindow.isDestroyed() &&
				!mainWindow.isVisible()
			) {
				mainWindow.show();
			}
		}
	);

	// Start the Persistent C++ Backend Before the First Renderer Request so the
	// Initial User Action Does Not Pay the Process Startup Cost
	try {
		warmBackend();

	} catch (error) {
		console.error(
			'Unable to Warm the NES ACE Backend during Startup.',
			error
		);
	}

	createWindow();
});

/* ========================== Application Lifecycle ========================== */

// Stop the Persistent Backend Before Electron Exits
app.on('before-quit', () => {
	stopBackend();
});

// Quit the Application When the Last Window Closes
app.on('window-all-closed', () => {
	app.quit();
});
