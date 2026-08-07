/* Configure and Manage the Assembler CodeJar Editor */

import { CodeJar } from 'codejar';

/* ================================ Elements ================================= */

// Retrieve the Required CodeJar Host or Fail Immediately
function requireAssemblerHost(): HTMLElement {

	const host = document.getElementById('assembler-input');

	if (!host) {
		throw new Error('Missing required element #assembler-input.');
	}

	return host;
}

const assemblerHost = requireAssemblerHost();

/* ============================== Highlighting =============================== */

const assemblerErrorHighlightName = 'assembler-error';

interface CustomHighlightRegistry {
	set(
		name: string,
		highlight: unknown
	): void;

	delete(
		name: string
	): boolean;
}

interface CustomHighlightWindow extends Window {
	Highlight?: new (...ranges: Range[]) => unknown;
}

let assemblerErrorLines = new Set<number>();
let legacyErrorMarkup = false;

// Retrieve Chromium's DOM-Free Text Highlighting API When Available
function getCustomHighlightApi(): {
	registry: CustomHighlightRegistry;
	Highlight: new (...ranges: Range[]) => unknown;
} | null {

	const registry = (
		CSS as typeof CSS & {
			highlights?: CustomHighlightRegistry;
		}
	).highlights;

	const Highlight = (
		window as CustomHighlightWindow
	).Highlight;

	if (
		!registry ||
		!Highlight
	) {
		return null;
	}

	return {
		registry,
		Highlight
	};
}

// Escape Source Text for the Legacy Highlighting Fallback
function escapeHtml(
	value: string
): string {

	return value
		.replace(/&/g, '&amp;')
		.replace(/</g, '&lt;')
		.replace(/>/g, '&gt;');
}

// Find a Text Node and Local Offset for One Source Character Position
function findTextBoundary(
	position: number
): {
	node: Text;
	offset: number;
} | null {

	const walker = document.createTreeWalker(
		assemblerHost,
		NodeFilter.SHOW_TEXT
	);

	let consumed = 0;
	let current = walker.nextNode();

	while (current) {

		const node = current as Text;
		const next = consumed + node.data.length;

		if (position <= next) {
			return {
				node,
				offset: position - consumed
			};
		}

		consumed = next;
		current = walker.nextNode();
	}

	if (
		position === 0 &&
		assemblerHost.textContent === ''
	) {

		const node = document.createTextNode('');

		assemblerHost.append(node);

		return {
			node,
			offset: 0
		};
	}

	return null;
}

// Build DOM Ranges for the Current Zero-Based C++ Error Line Indices
function buildAssemblerErrorRanges(): Range[] {

	const source = assemblerEditor.toString();
	const lineStarts = [0];

	for (
		let index = 0;
		index < source.length;
		index++
	) {

		if (source[index] === '\n') {
			lineStarts.push(index + 1);
		}
	}

	const ranges: Range[] = [];

	for (const line of assemblerErrorLines) {

		const start = lineStarts[line];

		if (start === undefined) {
			continue;
		}

		const end = (line + 1 < lineStarts.length)
			? lineStarts[line + 1] - 1
			: source.length;

		const startBoundary = findTextBoundary(start);
		const endBoundary = findTextBoundary(end);

		if (
			!startBoundary ||
			!endBoundary
		) {
			continue;
		}

		const range = document.createRange();

		range.setStart(
			startBoundary.node,
			startBoundary.offset
		);

		range.setEnd(
			endBoundary.node,
			endBoundary.offset
		);

		ranges.push(range);
	}

	return ranges;
}

// Remove Either Custom or Legacy Error Styling without Changing Source Text
function clearAssemblerErrorRendering(): void {

	const api = getCustomHighlightApi();

	if (api) {
		api.registry.delete(
			assemblerErrorHighlightName
		);
	}

	if (legacyErrorMarkup) {

		for (
			const line of Array.from(
				assemblerHost.querySelectorAll('.assembler-error-line')
			)
		) {
			line.classList.remove('assembler-error-line');
		}
	}

	legacyErrorMarkup = false;
}

// Apply Legacy Span Markup Only When Custom Highlights Are Unavailable
function applyLegacyAssemblerErrors(): void {

	const source = assemblerEditor.toString();
	const restoreCursor = document.activeElement === assemblerHost;
	const cursor = (restoreCursor)
		? assemblerEditor.save()
		: undefined;
	const scrollTop = assemblerHost.scrollTop;
	const scrollLeft = assemblerHost.scrollLeft;

	assemblerHost.innerHTML = source
		.split('\n')
		.map((line, index) => {

			const errorClass = (assemblerErrorLines.has(index))
				? ' assembler-error-line'
				: '';

			return (
				`<span class="assembler-code-line${errorClass}">` +
				escapeHtml(line) +
				'</span>'
			);
		})
		.join('\n');

	legacyErrorMarkup = true;
	assemblerHost.scrollTop = scrollTop;
	assemblerHost.scrollLeft = scrollLeft;

	if (cursor) {
		assemblerEditor.restore(cursor);
	}
}

// Render Error Colors without Rebuilding CodeJar's DOM on Every Keystroke
function renderAssemblerErrors(): void {

	clearAssemblerErrorRendering();

	if (assemblerErrorLines.size === 0) {
		return;
	}

	const api = getCustomHighlightApi();

	if (!api) {
		applyLegacyAssemblerErrors();
		return;
	}

	const ranges = buildAssemblerErrorRanges();

	if (ranges.length === 0) {
		return;
	}

	api.registry.set(
		assemblerErrorHighlightName,
		new api.Highlight(...ranges)
	);
}

// CodeJar Still Calls Its Highlighter, but Plain Editing Requires No DOM Work
function highlightAssembler(
	_editor: HTMLElement
): void {
	// Error Colors Are Applied Separately Through the Custom Highlight API
}

/* ================================= Editor ================================== */

// Keep CodeJar Focused on Plain Text Editing Rather Than Auto Formatting
const assemblerEditor = CodeJar(
	assemblerHost,
	highlightAssembler,
	{
		tab: '\t',
		spellcheck: false,
		catchTab: true,
		preserveIdent: false,
		addClosing: false,
		history: true
	}
);

// CodeJar Applies Soft-Wrapping as Inline Styles During Initialization, Override
// Them Here so Long Assembly Lines Scroll Horizontally
assemblerHost.style.overflowX = 'auto';
assemblerHost.style.overflowWrap = 'normal';
assemblerHost.style.whiteSpace = 'pre';

let previousSource = assemblerEditor.toString();

// Clear All Stale Error Colors as Soon as the User Changes the Source
assemblerEditor.onUpdate(source => {

	if (source === previousSource) {
		return;
	}

	previousSource = source;

	if (
		assemblerErrorLines.size === 0 &&
		!legacyErrorMarkup
	) {
		return;
	}

	const cursor = (legacyErrorMarkup)
		? assemblerEditor.save()
		: undefined;
	const scrollTop = assemblerHost.scrollTop;
	const scrollLeft = assemblerHost.scrollLeft;

	assemblerErrorLines.clear();
	clearAssemblerErrorRendering();

	// Custom Highlights Do Not Alter the DOM the Legacy Fallback Does, so
	// Normalize It Back to Plain Text After the First User Edit
	if (cursor) {
		assemblerEditor.updateCode(
			source,
			false
		);

		assemblerHost.scrollTop = scrollTop;
		assemblerHost.scrollLeft = scrollLeft;
		assemblerEditor.restore(cursor);
	}
});

/* =============================== Public API ================================ */

// Retrieve the Current Assembler Source
export function getAssemblerSource(): string {
	return assemblerEditor.toString();
}

// Replace the Current Set of Zero-Based C++ Error Line Indices
export function setAssemblerErrorLines(
	lines: readonly number[]
): void {

	assemblerErrorLines = new Set(
		lines.filter(line => Number.isInteger(line) && line >= 0)
	);

	renderAssemblerErrors();
}

// Replace the Displayed Source and Error Lines from One Assembly Result
export function setAssemblerResult(
	source: string,
	lines: readonly number[]
): void {

	clearAssemblerErrorRendering();

	assemblerErrorLines = new Set(
		lines.filter(line => Number.isInteger(line) && line >= 0)
	);

	// Treat the Cleaned Source as the New Baseline Because It Is Now the
	// Authoritative Text Displayed in the Editor After Assembly
	previousSource = source;

	// Suppress onUpdate Because This Replacement Came from the C++ Result
	// Rather Than a User Edit Inside the CodeJar Editor
	assemblerEditor.updateCode(
		source,
		false
	);

	renderAssemblerErrors();
}

// Clear the Current Assembler Source and Its Error Colors
export function clearAssemblerSource(): void {

	assemblerErrorLines.clear();
	clearAssemblerErrorRendering();

	previousSource = '';

	assemblerEditor.updateCode(
		'',
		false
	);
}

// Return Keyboard Focus to the Assembler Editor
export function focusAssemblerEditor(): void {
	assemblerHost.focus();
}
