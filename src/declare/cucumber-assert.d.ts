declare namespace CucumberAssert {
    export let equal: (actual: any, expected: any, callback: () => any, message?: string) => void;
    export let notEqual: (actual: any, expected: any, callback: () => any, message?: string) => void;
    export let deepEqual: (actual: any, expected: any, callback: () => any, message?: string) => void;
    export let notDeepEqual: (actual: any, expected: any, callback: () => any, message?: string) => void;
    export let strictEqual: (actual: any, expected: any, callback: () => any, message?: string) => void;
    export let notStrictEqual: (actual: any, expected: any, callback: () => any, message?: string) => void;
    export let throws: (block: any, callback: () => any, error?: any, message?: string) => void;
    export let doesNotThrow: (block: any, callback: () => any, message?: string) => void;
    export let ifError: (value: any, callback: () => any, message?: string) => void;
}

declare module "cucumber-assert" {
    export = CucumberAssert;
}