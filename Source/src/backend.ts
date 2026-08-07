/* Manage Communication Between Electron and the Persistent C++ Backend Process */

import { spawn } from 'node:child_process';
import type { ChildProcessWithoutNullStreams } from 'node:child_process';
import { existsSync } from 'node:fs';
import path from 'node:path';

import { app } from 'electron';

/* ====================== Backend Response Types/State ======================= */

// JSON Response Shape Returned by the C++ Backend
interface BackendResponse {
	id: number;
	ok: boolean;
	result: unknown;
	error: string;
}

// Promise Handlers Waiting for a Matching Backend Response
interface PendingRequest {
	resolve: (value: unknown) => void;
	reject: (error: Error) => void;
}

let backend: ChildProcessWithoutNullStreams | null = null;
let stdoutBuffer = '';
let nextRequestId = 1;

const pendingRequests = new Map<number, PendingRequest>();

/* ========================= Backend Path Resolution ========================= */

// Resolve the Backend Executable for Development and Packaged Builds
function getBackendPath(): string {

	const basePath = (app.isPackaged)
		? process.resourcesPath
		: app.getAppPath();

	return path.join(
		basePath,
		'backend',
		'backend.exe'
	);
}

/* =========================== Response Validation =========================== */

// Confirm Parsed JSON Matches the Expected Backend Response Shape
function isBackendResponse(
	value: unknown
): value is BackendResponse {

	if (
		typeof value !== 'object' ||
		value === null
	) {
		return false;
	}

	const response = value as Partial<BackendResponse>;

	return (
		typeof response.id === 'number' &&
		typeof response.ok === 'boolean' &&
		typeof response.error === 'string' &&
		'result' in response
	);
}

/* ======================= Pending Request Management ======================== */

// Reject Every Request Waiting on a Backend That Can No Longer Respond
function rejectPendingRequests(
	message: string
): void {

	for (const request of pendingRequests.values()) {
		request.reject(new Error(message));
	}

	pendingRequests.clear();
}

/* =========================== Response Processing =========================== */

// Parse One Complete JSON Response and Resolve Its Matching Request
function handleResponseLine(
	line: string
): void {

	if (line.length === 0) {
		return;
	}

	let parsed: unknown;

	try {
		parsed = JSON.parse(line);

	} catch {

		const message = `Backend returned invalid JSON: ${line}`;

		console.error(message);
		rejectPendingRequests(message);

		return;
	}

	if (!isBackendResponse(parsed)) {

		const message = 'Backend returned a response with an invalid shape.';

		console.error(message, parsed);
		rejectPendingRequests(message);

		return;
	}

	const request = pendingRequests.get(parsed.id);

	if (!request) {

		if (parsed.id === 0) {
			rejectPendingRequests(
				parsed.error ||
				'Backend rejected a malformed request.'
			);

			return;
		}

		console.error(`No pending backend request with ID ${parsed.id}.`);

		return;
	}

	pendingRequests.delete(parsed.id);

	if (parsed.ok) {
		request.resolve(parsed.result);
		return;
	}

	request.reject(
		new Error(
			parsed.error ||
			'Backend operation failed.'
		)
	);
}

// Buffer Backend Output Until One or More Complete JSON Lines Are Available
function handleStdout(
	chunk: string
): void {

	stdoutBuffer += chunk;

	let newlineIndex = stdoutBuffer.indexOf('\n');

	while (newlineIndex !== -1) {

		const line = stdoutBuffer
			.slice(0, newlineIndex)
			.replace(/\r$/, '');

		stdoutBuffer = stdoutBuffer.slice(newlineIndex + 1);

		handleResponseLine(line);

		newlineIndex = stdoutBuffer.indexOf('\n');
	}
}

/* ======================== Backend Process Lifecycle ======================== */

// Start the C++ Backend Once and Reuse It for Every Request
function startBackend(): ChildProcessWithoutNullStreams {

	if (backend) {
		return backend;
	}

	const executablePath = getBackendPath();

	if (!existsSync(executablePath)) {
		throw new Error(
			`Backend executable not found:\n${executablePath}`
		);
	}

	console.log(`Starting NES ACE backend: ${executablePath}`);

	const child = spawn(
		executablePath,
		[],
		{
			cwd: path.dirname(executablePath),
			stdio: [
				'pipe',
				'pipe',
				'pipe'
			],
			windowsHide: true
		}
	);

	backend = child;
	stdoutBuffer = '';

	child.stdout.setEncoding('utf8');
	child.stderr.setEncoding('utf8');

	child.stdout.on(
		'data',
		handleStdout
	);

	child.stderr.on(
		'data',
		(message: string) => {
			console.error(`Backend stderr: ${message.trimEnd()}`);
		}
	);

	child.once(
		'error',
		error => {

			if (backend === child) {
				backend = null;
			}

			rejectPendingRequests(
				`Backend process error: ${error.message}`
			);
		}
	);

	child.once(
		'exit',
		(code, signal) => {

			if (backend === child) {
				backend = null;
			}

			const reason = (signal)
				? `signal ${signal}`
				: `exit code ${code ?? 'unknown'}`;

			rejectPendingRequests(
				`Backend process exited with ${reason}.`
			);
		}
	);

	return child;
}

/* =========================== Public Backend API ============================ */

// Start the Persistent Backend Before the First User Request
export function warmBackend(): void {
	startBackend();
}

// Send One JSON Request and Resolve When the Matching Response Arrives
export function invokeBackend<T>(
	action: string,
	payload: unknown
): Promise<T> {

	const child = startBackend();
	const id = nextRequestId++;

	const message = JSON.stringify({
		id,
		action,
		payload
	});

	return new Promise<T>((resolve, reject) => {

		pendingRequests.set(id, {
			resolve: value => {
				resolve(value as T);
			},
			reject
		});

		child.stdin.write(`${message}\n`, error => {

			if (!error) {
				return;
			}

			pendingRequests.delete(id);
			reject(error);
		});
	});
}

// Stop the Backend and Reject Any Requests Still Waiting for a Response
export function stopBackend(): void {

	const child = backend;

	backend = null;

	if (
		child &&
		!child.killed
	) {
		child.kill();
	}

	rejectPendingRequests('Backend process stopped.');
}
