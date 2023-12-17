import { Contract } from 'ethers';
export interface AddTestType extends Contract {
    add: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface ReencryptTestType extends Contract {
    reencrypt: (test: string, a: bigint, pubkey: Uint8Array) => Promise<Uint8Array>;
}
export interface LteTestType extends Contract {
    lte: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface SubTestType extends Contract {
    sub: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface MulTestType extends Contract {
    mul: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface LtTestType extends Contract {
    lt: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface CmuxTestType extends Contract {
    cmux: (test: string,c: boolean, a: bigint, b: bigint) => Promise<bigint>;
}
export interface ReqTestType extends Contract {
    req: (test: string, a: bigint) => Promise<undefined>;
}
export interface DivTestType extends Contract {
    div: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface GtTestType extends Contract {
    gt: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface GteTestType extends Contract {
    gte: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface RemTestType extends Contract {
    rem: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface AndTestType extends Contract {
    and: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface OrTestType extends Contract {
    or: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface XorTestType extends Contract {
    xor: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface EqTestType extends Contract {
    eq: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface NeTestType extends Contract {
    ne: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface MinTestType extends Contract {
    min: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface MaxTestType extends Contract {
    max: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface ShlTestType extends Contract {
    shl: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface ShrTestType extends Contract {
    shr: (test: string, a: bigint, b: bigint) => Promise<bigint>;
}
export interface NotTestType extends Contract {
    not: (test: string, a: bigint) => Promise<bigint>;
}
export interface AsEboolTestType extends Contract {
	castFromEuint8ToEbool: (val: bigint) => Promise<boolean>;
	castFromEuint16ToEbool: (val: bigint) => Promise<boolean>;
	castFromEuint32ToEbool: (val: bigint) => Promise<boolean>;
	castFromPlaintextToEbool: (val: bigint) => Promise<boolean>;
	castFromPreEncryptedToEbool: (val: Uint8Array) => Promise<boolean>;
}
export interface AsEuint8TestType extends Contract {
	castFromEboolToEuint8: (val: bigint) => Promise<bigint>;
	castFromEuint16ToEuint8: (val: bigint) => Promise<bigint>;
	castFromEuint32ToEuint8: (val: bigint) => Promise<bigint>;
	castFromPlaintextToEuint8: (val: bigint) => Promise<bigint>;
	castFromPreEncryptedToEuint8: (val: Uint8Array) => Promise<bigint>;
}
export interface AsEuint16TestType extends Contract {
	castFromEboolToEuint16: (val: bigint) => Promise<bigint>;
	castFromEuint8ToEuint16: (val: bigint) => Promise<bigint>;
	castFromEuint32ToEuint16: (val: bigint) => Promise<bigint>;
	castFromPlaintextToEuint16: (val: bigint) => Promise<bigint>;
	castFromPreEncryptedToEuint16: (val: Uint8Array) => Promise<bigint>;
}
export interface AsEuint32TestType extends Contract {
	castFromEboolToEuint32: (val: bigint) => Promise<bigint>;
	castFromEuint8ToEuint32: (val: bigint) => Promise<bigint>;
	castFromEuint16ToEuint32: (val: bigint) => Promise<bigint>;
	castFromPlaintextToEuint32: (val: bigint) => Promise<bigint>;
	castFromPreEncryptedToEuint32: (val: Uint8Array) => Promise<bigint>;
}


