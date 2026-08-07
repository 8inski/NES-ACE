/* Manage NES ACE GUI Controls, Tab Navigation and Backend Requests */

import './index.css';

import searchSvg from './assets/svg/search.svg?raw';
import trashSvg from './assets/svg/trash-can.svg?raw';
import convertSvg from './assets/svg/circular-arrows.svg?raw';

import {
	clearAssemblerSource,
	focusAssemblerEditor,
	getAssemblerSource,
	setAssemblerErrorLines,
	setAssemblerResult
} from './assembler-editor';

import type {
	AssemblerResult,
	PpuErrorCode,
	PpuErrorResult,
	PpuSuccessResult,
	TasEmulator
} from './backend-api';

/* ================================ SVG Icons ================================ */

// Associate HTML data-icon Values with Their Raw SVG Assets
const icons: Record<string, string> = {
	search: searchSvg,
	trash: trashSvg,
	convert: convertSvg
};

// Insert Each Registered SVG into Its Matching Icon Container
for (
	const element of document.querySelectorAll<HTMLElement>('[data-icon]')
) {

	const iconName = element.dataset.icon;

	if (!iconName) {
		continue;
	}

	const svg = icons[iconName];

	if (!svg) {
		console.warn(`No SVG registered for icon "${iconName}".`);
		continue;
	}

	element.innerHTML = svg;
}

/* ============================= Tab Navigation ============================== */

// Collect the Tab Buttons and Their Associated Content Panels
const tabs = Array.from(
	document.querySelectorAll<HTMLButtonElement>('[role="tab"]')
);

const panels = Array.from(
	document.querySelectorAll<HTMLElement>('[role="tabpanel"]')
);

// Activate One Tab and Display Only Its Associated Panel
function activateTab(
	selectedTab: HTMLButtonElement
): void {

	const selectedPanelId = selectedTab.getAttribute('aria-controls');

	if (!selectedPanelId) {
		return;
	}

	for (const tab of tabs) {

		const isSelected = tab === selectedTab;

		tab.setAttribute('aria-selected', String(isSelected));
	}

	for (const panel of panels) {
		panel.hidden = panel.id !== selectedPanelId;
	}
}

// Register Mouse Navigation for Every Tab
for (const tab of tabs) {

	tab.addEventListener('click', () => {
		activateTab(tab);
	});
}

/* ============================= Common Helpers ============================== */

// Retrieve a Required HTML Element or Fail Immediately with Its Missing ID
function requireElement<T extends HTMLElement>(
	id: string
): T {

	const element = document.getElementById(id);

	if (!element) {
		throw new Error(`Missing required element #${id}.`);
	}

	return element as T;
}

// Convert an Unknown Thrown Value into a Displayable Error Message
function getErrorMessage(
	error: unknown
): string {

	if (error instanceof Error) {
		return error.message;
	}

	return String(error);
}

// Display a Backend or Renderer Error in an Output Textarea
function showError(
	output: HTMLTextAreaElement,
	error: unknown
): void {
	output.value = `ERROR:\n${getErrorMessage(error)}`;
}

// Disable a Convert/Search Button While Its Asynchronous Action Is Running
async function runWithButton(
	button: HTMLButtonElement,
	action: () => Promise<void>
): Promise<void> {

	button.disabled = true;

	try {
		await action();

	} finally {
		button.disabled = false;
	}
}

// Check for the Shared Ctrl + Enter Conversion Shortcut
function isConvertShortcut(
	event: KeyboardEvent
): boolean {
	return event.key === 'Enter' && event.ctrlKey;
}

// Format a Number as Uppercase Hexadecimal with a Fixed Width
function formatHex(
	value: number,
	width: number
): string {

	return value
		.toString(16)
		.toUpperCase()
		.padStart(width, '0');
}

// Format Byte Code as Space-Separated Two-Digit Hexadecimal Values
function formatByteCode(
	byteCode: number[]
): string {

	return byteCode
		.map(byte => formatHex(byte, 2))
		.join(' ');
}

const assemblerErrorMessages: Record<string, string> = {
	none: 'None',
	syntax: 'Syntax Error',
	'invalid-label': 'Invalid Label',
	'invalid-instruction': 'Invalid Instruction',
	'undocumented-instruction': 'Undocumented Instruction',
	'invalid-operand': 'Invalid Operand',
	'invalid-mode': 'Invalid Addressing Mode',
	'invalid-origin': 'Invalid Origin Directive',
	'invalid-constant': 'Invalid Constant Directive',
	'invalid-data': 'Invalid Data Directive',
	'duplicate-symbol': 'Duplicate Symbol',
	'undefined-symbol': 'Undefined Symbol',
	'branch-out-of-range': 'Branch Out of Range',
	'missing-origin': 'Missing Origin Directive',
	'unknown-assembler-error': 'Unknown Assembler Error'
};

// Format Structured Assembler Errors for the Temporary Textarea Output
function formatAssemblerErrors(
	result: AssemblerResult
): string {

	const errorCount = result.errors.length;
	const errorLabel = (errorCount === 1)
		? 'Error'
		: 'Errors';

	const errors = result.errors
		.map(error => {

			const displayMessage = assemblerErrorMessages[error.error]
				?? error.error;

			return [
				`Line ${error.index + 1}: ${displayMessage}`,
				error.cleanedLine
			].join('\n');
		})
		.join('\n\n');

	return [
		`${errorCount} ${errorLabel} Found:`,
		errors
	].join('\n\n');
}

// Format a Successful Assembler Result for the Output Textarea
function formatAssemblerResult(
	result: AssemblerResult
): string {

	const segmentCount = result.segments.length;
	const segmentLabel = (segmentCount === 1)
		? 'Segment'
		: 'Segments';

	const largestSegmentNumber = Math.max(
		1,
		...result.segments.map(segment => segment.index + 1)
	);

	const largestSegmentLength = Math.max(
		0,
		...result.segments.map(segment => segment.length)
	);

	const segmentNumberWidth = String(largestSegmentNumber).length;
	const segmentLengthWidth = String(largestSegmentLength).length;

	const segments = result.segments
		.map(segment => {

			const segmentNumber = String(segment.index + 1)
				.padStart(segmentNumberWidth, '0');

			const segmentLength = String(segment.length)
				.padStart(segmentLengthWidth, ' ');

			const byteLabel = (segment.length === 1)
				? 'Byte '
				: 'Bytes';

			return (
				`Segment ${segmentNumber}: ${segmentLength} ${byteLabel} ` +
				`($${formatHex(segment.origin, 4)} - $${formatHex(segment.end, 4)})`
			);
		})
		.join('\n');

	return [
		`${segmentCount} ${segmentLabel} Generated:`,
		segments,
		formatByteCode(result.byteCode),
		result.inputs.join('\n')
	].join('\n\n');
}

// Format a Successful PPU Conversion Result for the Output Textarea
function formatPpuResult(
	result: PpuSuccessResult
): string {

	const sections = [
		`Payload Length: ${result.length}`
	];

	if (!result.canWrap) {
		sections.push(
			'**WARNING**\nUnable to Provide Correctly Wrapped Payload'
		);

	} else if (result.cleanedPayload !== result.wrappedPayload) {

		sections.push(
			[
				'**WARNING**',
				'Payload Will Wrap Incorrectly',
				'',
				'Recommended Payload:',
				result.wrappedPayload
			].join('\n')
		);
	}

	sections.push(
		formatByteCode(result.byteCode),
		result.inputs.join('\n')
	);

	return sections.join('\n\n');
}

const ppuErrorMessages: Record<PpuErrorCode, string> = {
	'invalid-initial': 'Invalid PPU Address',
	'outside-nametable': 'Payload Extends Outside PPU Nametable Range ($2000 - $23BF)',
	'exceeds-buffer': 'Payload Length Exceeds RAM Buffer Size',
	'unknown-ppu-error': 'Unknown PPU Conversion Error'
};

// Format an Invalid PPU Conversion Result for the Output Textarea
function formatPpuError(
	result: PpuErrorResult
): string {

	if (result.error === 'exceeds-buffer') {

		const overflowLabel = (result.overflow === 1)
			? 'Character'
			: 'Characters';

		return (
			`Payload Length Exceeds RAM Buffer Size by ` +
			`${result.overflow} ${overflowLabel}`
		);
	}

	return ppuErrorMessages[result.error];
}

/* ================================ Glossary ================================= */

// Collect Glossary Tab Controls
const glossaryInput = requireElement<HTMLInputElement>('index-entry');
const glossarySearch = requireElement<HTMLButtonElement>('glossary-search');
const glossaryClear = requireElement<HTMLButtonElement>('glossary-clear');
const glossaryOutput = requireElement<HTMLTextAreaElement>('glossary-output');

// Request and Display a Glossary Entry for the Current Mnemonic
async function searchGlossary(): Promise<void> {

	const mnemonic = glossaryInput.value.trim();

	if (mnemonic.length === 0) {
		glossaryOutput.value = '';
		return;
	}

	await runWithButton(
		glossarySearch,
		async () => {

			try {
				glossaryOutput.value = await window.nesAce.glossary(mnemonic);

			} catch (error) {
				showError(glossaryOutput, error);
			}
		}
	);
}

// Reset the Glossary Tab and Return Focus to Its Input
function clearGlossary(): void {

	glossaryInput.value = '';
	glossaryOutput.value = '';

	glossaryInput.focus();
}

// Register Glossary Tab Controls
glossarySearch.addEventListener('click', () => {
	void searchGlossary();
});

glossaryClear.addEventListener(
	'click',
	clearGlossary
);

/* ================================ Assembler ================================ */

// Collect Assembler Tab Controls
const assemblerOutput = requireElement<HTMLTextAreaElement>('assembler-output');
const assemblerConvert = requireElement<HTMLButtonElement>('assembler-convert');
const assemblerClear = requireElement<HTMLButtonElement>('assembler-clear');
const undocumentedCheck = requireElement<HTMLInputElement>('undoc-check');

// Assemble the Current Source and Display Inputs or Formatted Errors
async function assembleSource(): Promise<void> {

	const source = getAssemblerSource();

	if (source.trim().length === 0) {
		setAssemblerErrorLines([]);
		assemblerOutput.value = '';
		return;
	}

	await runWithButton(
		assemblerConvert,
		async () => {

			try {

				const result = await window.nesAce.assemble({
					source,
					useUndocumented: undocumentedCheck.checked
				});

				setAssemblerResult(
					result.cleanedProgram
						.map(line => line.cleanedLine)
						.join('\n'),
					result.errors.map(error => error.index)
				);

				assemblerOutput.value = (result.errors.length === 0)
					? formatAssemblerResult(result)
					: formatAssemblerErrors(result);

			} catch (error) {
				setAssemblerErrorLines([]);
				showError(assemblerOutput, error);
			}
		}
	);
}

// Reset the Assembler Tab and Return Focus to Its Source Input
function clearAssembler(): void {

	clearAssemblerSource();
	assemblerOutput.value = '';
	undocumentedCheck.checked = false;

	focusAssemblerEditor();
}

// Register Assembler Tab Controls
assemblerConvert.addEventListener('click', () => {
	void assembleSource();
});

assemblerClear.addEventListener(
	'click',
	clearAssembler
);

/* ============================== PPU Converter ============================== */

// Collect PPU Converter Tab Controls
const ppuAddress = requireElement<HTMLInputElement>('ppu-entry');
const ppuInput = requireElement<HTMLTextAreaElement>('ppu-input');
const ppuOutput = requireElement<HTMLTextAreaElement>('ppu-output');
const ppuConvert = requireElement<HTMLButtonElement>('ppu-convert');
const ppuClear = requireElement<HTMLButtonElement>('ppu-clear');

// Convert the Current PPU Address and Text into SubNESHawk Inputs
async function convertPpu(): Promise<void> {

	if (
		ppuAddress.value.trim().length === 0 ||
		ppuInput.value.length === 0
	) {
		ppuOutput.value = '';
		return;
	}

	await runWithButton(
		ppuConvert,
		async () => {

			try {

				const result = await window.nesAce.convertPpu({
					address: ppuAddress.value.trim(),
					text: ppuInput.value
				});

				ppuInput.value = result.cleanedPayload;
				ppuOutput.value = (result.valid === true)
					? formatPpuResult(result)
					: formatPpuError(result);

			} catch (error) {
				showError(ppuOutput, error);
			}
		}
	);
}

// Reset the PPU Converter Tab and Return Focus to Its Address Input
function clearPpu(): void {

	ppuAddress.value = '';
	ppuInput.value = '';
	ppuOutput.value = '';

	ppuAddress.focus();
}

// Register PPU Converter Tab Controls
ppuConvert.addEventListener('click', () => {
	void convertPpu();
});

ppuClear.addEventListener(
	'click',
	clearPpu
);

/* ============================== TAS Converter ============================== */

// Collect TAS Converter Tab Controls
const tasEmulator = requireElement<HTMLSelectElement>('emu-select');
const tasMode = requireElement<HTMLSelectElement>('mode-select');
const tasInput = requireElement<HTMLTextAreaElement>('tas-input');
const tasOutput = requireElement<HTMLTextAreaElement>('tas-output');
const tasConvert = requireElement<HTMLButtonElement>('tas-convert');
const tasClear = requireElement<HTMLButtonElement>('tas-clear');

// Convert Current FCEUX/NESHawk Inputs into SubNESHawk Inputs
async function convertTas(): Promise<void> {

	if (tasInput.value.length === 0) {
		tasOutput.value = '';
		return;
	}

	await runWithButton(
		tasConvert,
		async () => {

			try {

				const emulator = (
					`${tasEmulator.value}-${tasMode.value}`
				) as TasEmulator;

				const result = await window.nesAce.convertTas({
					source: tasInput.value,
					emulator
				});

				tasInput.value = result.inputs.join('\n');
				tasOutput.value = [
					`Lag Frames: ${result.lagFrames}`,
					result.convertedInputs.join('\n')
				].join('\n\n');

			} catch (error) {
				showError(tasOutput, error);
			}
		}
	);
}

// Reset the TAS Converter Tab and Restore the Default Emulator
function clearTas(): void {

	tasInput.value = '';
	tasOutput.value = '';
	tasEmulator.value = 'fceux';
	tasMode.value = '2p';

	tasInput.focus();
}

// Register TAS Converter Tab Controls
tasConvert.addEventListener('click', () => {
	void convertTas();
});

tasClear.addEventListener(
	'click',
	clearTas
);

/* ======================== Global Keyboard Shortcuts ======================== */

// Run the Active Tab's Primary Action from Anywhere in the Interface
document.addEventListener(
	'keydown',
	event => {

		if (event.repeat || event.isComposing) {
			return;
		}

		const selectedTab = tabs.find(
			tab => tab.getAttribute('aria-selected') === 'true'
		);
		const selectedPanelId = selectedTab?.getAttribute('aria-controls');

		if (!selectedPanelId) {
			return;
		}

		if (selectedPanelId === 'panel-glossary') {

			if (
				event.key !== 'Enter' ||
				event.ctrlKey ||
				event.metaKey ||
				event.altKey ||
				event.shiftKey
			) {
				return;
			}

			event.preventDefault();
			event.stopPropagation();

			if (!glossarySearch.disabled) {
				void searchGlossary();
			}

			return;
		}

		if (!isConvertShortcut(event)) {
			return;
		}

		event.preventDefault();
		event.stopPropagation();

		switch (selectedPanelId) {

			case 'panel-assembler':

				if (!assemblerConvert.disabled) {
					void assembleSource();
				}

				break;

			case 'panel-ppu-converter':

				if (!ppuConvert.disabled) {
					void convertPpu();
				}

				break;

			case 'panel-tas-converter':

				if (!tasConvert.disabled) {
					void convertTas();
				}

				break;
		}
	},
	{
		capture: true
	}
);

/* ============================ Renderer Startup ============================= */

// Wait for Custom Fonts and Stable Layout Before Revealing the Window
async function finishRendererStartup(): Promise<void> {

	await document.fonts.ready;

	// Give Chromium Two Frames to Apply Imported CSS, Inserted SVGs and CodeJar
	// Layout Before Making the Document Visible
	await new Promise<void>(resolve => {

		requestAnimationFrame(() => {

			requestAnimationFrame(() => {
				resolve();
			});
		});
	});

	document.documentElement.classList.add(
		'renderer-ready'
	);

	// Paint the Newly Visible Document into the Still-Hidden BrowserWindow
	// Before Asking Electron to Show It
	await new Promise<void>(resolve => {

		requestAnimationFrame(() => {
			resolve();
		});
	});

	window.nesAce.rendererReady();
}

void finishRendererStartup();
