/* Add the NES ACE Preload API to the Browser Window Type */
/// <reference types="vite/client" />

import type { NesAceApi } from './backend-api';

declare global {

	interface Window {
		nesAce: NesAceApi;
	}
}

export {};
