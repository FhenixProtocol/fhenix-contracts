import { ethers } from 'hardhat';
import { createFheInstance } from './utils';
import { AddTestType,
    ReencryptTestType,
    LteTestType,
    SubTestType,
    MulTestType,
    LtTestType,
    CmuxTestType,
    ReqTestType,
    DivTestType,
    GtTestType,
    GteTestType,
    RemTestType,
    AndTestType,
    OrTestType,
    XorTestType,
    EqTestType,
    NeTestType,
    MinTestType,
    MaxTestType,
    ShlTestType,
    ShrTestType,
    NotTestType,
    AsEboolTestType,
    AsEuint8TestType,
    AsEuint16TestType,
    AsEuint32TestType } from './abis';

import {BaseContract} from "ethers";
import {expect} from "chai";
import {toBe} from "mocha";
const deployContractFromSigner = async (con: any, signer: any, nonce?: number) => {
    return await con.deploy({
        from: signer,
        args: [],
        log: true,
        skipIfAlreadyDeployed: false,
        nonce,
    });
}

const syncNonce = async (con: any, signer: any, stateNonce: number) => {
    console.log(`Syncing nonce to ${stateNonce}`);
    try {
        await deployContractFromSigner(con, signer, stateNonce);
    } catch(e) {
        console.log("Fixed nonce issue");
    }

    return await deployContractFromSigner(con, signer);
}
const deployContract = async (contractName: string) => {
    const [signer] = await ethers.getSigners();
    const con = await ethers.getContractFactory(contractName);
    let deployedContract : BaseContract;
    try {
         deployedContract = await deployContractFromSigner(con, signer);

    } catch (e) {
        if (`${e}`.includes("nonce too")) {
            // find last occurence of ": " in e and get the number that comes after
            const match = `${e}`.match(/state: (\d+)/);
            const stateNonce = match ? parseInt(match[1], 10) : null;
            if (stateNonce === null) {
                throw new Error("Could not find nonce in error");
            }

            deployedContract = await syncNonce(con, signer, stateNonce);
        }
    }

    const contract = deployedContract.connect(signer);
    return contract;
}
const getFheContract = async (contractAddress: string) => {
    const fheContract = await createFheInstance(contractAddress);
    return fheContract;
}
describe('Test Add', () =>  {
    const aOverflow8 = 2 ** 8 - 1;
    const aOverflow16 = 2 ** 16 - 1;
    const aOverflow32 = 2 ** 32 - 1;
    const aUnderflow = 1;

    const bOverflow8 = aOverflow8 - 1;
    const bOverflow16 = aOverflow16 - 1;
    const bOverflow32 = aOverflow32 - 1;
    let contract: AddTestType;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('AddTest') as AddTestType;
        expect(!!contract).to.equal(true);
    });

    const testCases = [
        {
            function: "add(euint8,euint8)",
            cases: [
                {a: 1, b: 2, expectedResult: 3, name: ""},
                {
                    a: aOverflow8,
                    b: bOverflow8,
                    expectedResult: Number(BigInt.asUintN(8, BigInt(aOverflow8 + bOverflow8))),
                    name: " with overflow",
                },
            ],
            resType: 8,
        },
        {
            function: "add(euint16,euint16)",
            cases: [
                {a: 1, b: 2, expectedResult: 3, name: ""},
                {
                    a: aOverflow16,
                    b: bOverflow16,
                    expectedResult: Number(BigInt.asUintN(16, BigInt(aOverflow16 + bOverflow16))),
                    name: " with overflow",
                },
            ],
            resType: 16,
        },
        {
            function: "add(euint32,euint32)",
            cases: [
                {a: 1, b: 2, expectedResult: 3, name: ""},
                {
                    a: aOverflow32,
                    b: bOverflow32,
                    expectedResult: Number(BigInt.asUintN(32, BigInt(aOverflow32 + bOverflow32))),
                    name: " with overflow",
                },
            ],
            resType: 32,
        },
    ];

    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.add(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Reencrypt', () =>  {
    let contract;
    let fheContract;
    let contractAddress;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        const baseContract = await deployContract('ReencryptTest');
        contract = baseContract as ReencryptTestType;
        contractAddress = await baseContract.getAddress();
        fheContract = await getFheContract(contractAddress);

        expect(!!contract).to.equal(true);
        expect(!!fheContract).to.equal(true);

    });

    const testCases = ["reencrypt(euint8)", "reencrypt(euint16)", "reencrypt(euint32)"];

    for (const test of testCases) {
        it(`Test ${test}`, async () => {
            let plaintextInput = Math.floor(Math.random() * 1000) % 256;
            let encryptedOutput = await contract.reencrypt(test, plaintextInput, fheContract.publicKey);
            let decryptedOutput = fheContract.instance.decrypt(contractAddress, encryptedOutput);

            expect(decryptedOutput).to.equal(plaintextInput);
        });
}
});
describe('Test Lte', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('LteTest') as LteTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { a: 1, b: 2, expectedResult: 1, name: " a < b" },
        { a: 2, b: 1, expectedResult: 0, name: " a > b" },
        { a: 3, b: 3, expectedResult: 1, name: " a == b" },
    ];

    const testCases = [
        {
            function: "lte(euint8,euint8)",
            cases,
        },
        {
            function: "lte(euint16,euint16)",
            cases,
        },
        {
            function: "lte(euint32,euint32)",
            cases,
        }
    ];
    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.lte(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Sub', () =>  {
    const aUnderflow = 1;
    const bUnderflow = 4;
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('SubTest') as SubTestType;
        expect(!!contract).to.equal(true);
    });

    const testCases = [
        {
            function: "sub(euint8,euint8)",
            cases: [
                { a: 9, b: 4, expectedResult: 5, name: "" },
                {
                    a: aUnderflow,
                    b: bUnderflow,
                    expectedResult: Number(BigInt.asUintN(8, BigInt(aUnderflow - bUnderflow))),
                    name: " with underflow",
                },
            ],
        },
        {
            function: "sub(euint16,euint16)",
            cases: [
                { a: 9, b: 4, expectedResult: 5, name: "" },
                {
                    a: aUnderflow,
                    b: bUnderflow,
                    expectedResult: Number(BigInt.asUintN(16, BigInt(aUnderflow - bUnderflow))),
                    name: " with underflow",
                },
            ],
        },
        {
            function: "sub(euint32,euint32)",
            cases: [
                { a: 9, b: 4, expectedResult: 5, name: "" },
                {
                    a: aUnderflow,
                    b: bUnderflow,
                    expectedResult: Number(BigInt.asUintN(32, BigInt(aUnderflow - bUnderflow))),
                    name: " with underflow",
                },
            ],
        },
    ];

    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.sub(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Mul', () =>  {
    const overflow8 = 2 ** 8 / 2 + 1;
    const overflow16 = 2 ** 16 / 2 + 1;
    const overflow32 = 2 ** 32 / 2 + 1;
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('MulTest') as MulTestType;
        expect(!!contract).to.equal(true);
    });

    const testCases = [
        {
            function: "mul(euint8,euint8)",
            cases: [
                { a: 2, b: 3, expectedResult: 6, name: "" },
                {
                    a: overflow8,
                    b: 2,
                    expectedResult: Number(BigInt.asUintN(8, BigInt(overflow8 * 2))),
                    name: " as overflow",
                },
            ],
        },
        {
            function: "mul(euint16,euint16)",
            cases: [
                { a: 2, b: 3, expectedResult: 6, name: "" },
                {
                    a: overflow16,
                    b: 2,
                    expectedResult: Number(BigInt.asUintN(16, BigInt(overflow16 * 2))),
                    name: " as overflow",
                },
            ],
        },
        {
            function: "mul(euint32,euint32)",
            cases: [
                { a: 2, b: 3, expectedResult: 6, name: "" },
                {
                    a: overflow32,
                    b: 2,
                    expectedResult: Number(BigInt.asUintN(32, BigInt(overflow32 * 2))),
                    name: " as overflow",
                },
            ],
        },
    ];

    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.mul(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Lt', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('LtTest') as LtTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { a: 1, b: 2, expectedResult: 1, name: " a < b" },
        { a: 2, b: 1, expectedResult: 0, name: " a > b" },
        { a: 3, b: 3, expectedResult: 0, name: " a == b" },
    ];

    const testCases = [
        {
            function: "lt(euint8,euint8)",
            cases,
        },
        {
            function: "lt(euint16,euint16)",
            cases,
        },
        {
            function: "lt(euint32,euint32)",
            cases,
        }
    ];
    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.lt(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Cmux', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('CmuxTest') as CmuxTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { control: true, a: 2, b: 3, expectedResult: 2, name: " true" },
        { control: false, a: 2, b: 3, expectedResult: 3, name: " false" },
    ];

    const testCases = [
        {
            function: "cmux: euint8",
            cases,
        },
        {
            function: "cmux: euint16",
            cases,
        },
        {
            function: "cmux: euint32",
            cases,
        },
        {
            function: "cmux: ebool",
            cases: [
                { control: true, a: 0, b: 1, expectedResult: 0, name: "true" },
                { control: false, a: 0, b: 1, expectedResult: 1, name: "false" },
            ],
        },
    ];

    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.cmux(test.function, testCase.control, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Req', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('ReqTest') as ReqTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { a: 0, shouldCrash: true, name: " with crash" },
        { a: 1, shouldCrash: false, name: " no crash" },
    ];

    const testCases = [
        {
            function: "req(euint8)",
            cases,
        },
        {
            function: "req(euint16)",
            cases,
        },
        {
            function: "req(euint32)",
            cases,
        },
        {
            function: "req(ebool)",
            cases,
        },
    ];

    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                let hadEvaluationFailure = false;
                try {
                    await contract.req(test.function, BigInt(testCase.a));
                } catch (e) {
                    console.log(e);
                    hadEvaluationFailure = `${e}`.includes("execution reverted");
                }
                expect(hadEvaluationFailure).to.equal(testCase.shouldCrash);
            });
        }
    }
});
describe('Test Div', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('DivTest') as DivTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { a: 4, b: 2, expectedResult: 2, name: "" },
        { a: 4, b: 0, expectedResult: 2 ** 256, name: " Div by 0" },
    ];

    const testCases = [
        {
            function: "div(euint8,euint8)",
            cases :[
                { a: 4, b: 2, expectedResult: 2, name: "" },
                { a: 4, b: 3, expectedResult: 1, name: " with reminder" },
                { a: 4, b: 0, expectedResult: 2 ** 8 - 1, name: " div by 0" },
            ],
        },
        {
            function: "div(euint16,euint16)",
            cases :[
                { a: 4, b: 2, expectedResult: 2, name: "" },
                { a: 4, b: 3, expectedResult: 1, name: " with reminder" },
                { a: 4, b: 0, expectedResult: 2 ** 16 - 1, name: " div by 0" },
            ],
        },
        {
            function: "div(euint32,euint32)",
            cases :[
                { a: 4, b: 2, expectedResult: 2, name: "" },
                { a: 4, b: 3, expectedResult: 1, name: " with reminder" },
                { a: 4, b: 0, expectedResult: 2 ** 32 - 1, name: " div by 0" },
            ],
        }
    ];
    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.div(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Gt', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('GtTest') as GtTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { a: 1, b: 2, expectedResult: 0, name: " a < b" },
        { a: 2, b: 1, expectedResult: 1, name: " a > b" },
        { a: 3, b: 3, expectedResult: 0, name: " a == b" },
    ];

    const testCases = [
        {
            function: "gt(euint8,euint8)",
            cases,
        },
        {
            function: "gt(euint16,euint16)",
            cases,
        },
        {
            function: "gt(euint32,euint32)",
            cases,
        }
    ];
    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.gt(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Gte', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('GteTest') as GteTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { a: 1, b: 2, expectedResult: 0, name: " a < b" },
        { a: 2, b: 1, expectedResult: 1, name: " a > b" },
        { a: 3, b: 3, expectedResult: 1, name: " a == b" },
    ];

    const testCases = [
        {
            function: "gte(euint8,euint8)",
            cases,
        },
        {
            function: "gte(euint16,euint16)",
            cases,
        },
        {
            function: "gte(euint32,euint32)",
            cases,
        }
    ];
    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.gte(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Rem', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('RemTest') as RemTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { a: 4, b: 3, expectedResult: 1, name: "" },
        { a: 4, b: 2, expectedResult: 0, name: " no reminder" },
        { a: 4, b: 0, expectedResult: 4, name: " div by 0" },
    ];

    const testCases = [
        {
            function: "rem(euint8,euint8)",
            cases,
        },
        {
            function: "rem(euint16,euint16)",
            cases,
        },
        {
            function: "rem(euint32,euint32)",
            cases,
        },
    ];

    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.rem(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test And', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('AndTest') as AndTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { a: 9, b: 15, expectedResult: 9 & 15, name: "" },
        { a: 7, b: 0, expectedResult: 0, name: " a & 0" },
        { a: 0, b: 5, expectedResult: 0, name: " 0 & b" },
    ];

    const testCases = [
        {
            function: "and(euint8,euint8)",
            cases,
        },
        {
            function: "and(euint16,euint16)",
            cases,
        },
        {
            function: "and(euint32,euint32)",
            cases,
        },
        {
            function: "and(ebool,ebool)",
            cases: [
                { a: 9, b: 15, expectedResult: 1, name: "" },
                { a: 7, b: 0, expectedResult: 0, name: " a & 0" },
                { a: 0, b: 5, expectedResult: 0, name: " 0 & b" },
            ],
        },
    ];

    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.and(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Or', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('OrTest') as OrTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { a: 9, b: 15, expectedResult: 9 | 15, name: "" },
        { a: 7, b: 0, expectedResult: 7, name: " a | 0" },
        { a: 0, b: 5, expectedResult: 5, name: " 0 | b" },
    ];

    const testCases = [
        {
            function: "or(euint8,euint8)",
            cases,
        },
        {
            function: "or(euint16,euint16)",
            cases,
        },
        {
            function: "or(euint32,euint32)",
            cases,
        },
        {
            function: "or(ebool,ebool)",
            cases: [
                { a: 9, b: 15, expectedResult: 1, name: "" },
                { a: 7, b: 0, expectedResult: 1, name: " a | 0" },
                { a: 0, b: 5, expectedResult: 1, name: " 0 | b" },
                { a: 0, b: 0, expectedResult: 0, name: " 0 | 0" },
            ],
        },
    ];

    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.or(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Xor', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('XorTest') as XorTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { a: 0b11110000, b: 0b10100101, expectedResult: 0b11110000 ^ 0b10100101, name: "" },
        { a: 7, b: 0, expectedResult: 7 ^ 0, name: " a ^ 0s" },
        { a: 7, b: 0b1111, expectedResult: 7 ^ 0b1111, name: " a ^ 1s" },
        { a: 0, b: 5, expectedResult: 0 ^ 5, name: " 0s ^ b" },
        { a: 0b1111, b: 5, expectedResult: 0b1111 ^ 5, name: " 1s ^ b" },
    ];

    const testCases = [
        {
            function: "xor(euint8,euint8)",
            cases,
        },
        {
            function: "xor(euint16,euint16)",
            cases,
        },
        {
            function: "xor(euint32,euint32)",
            cases,
        },
        {
            function: "xor(ebool,ebool)",
            cases: [
                { a: 9, b: 15, expectedResult: 0, name: "" },
                { a: 7, b: 0, expectedResult: 1, name: " a ^ 0" },
                { a: 0, b: 5, expectedResult: 1, name: " 0 ^ b" },
                { a: 0, b: 0, expectedResult: 0, name: " 0 ^ 0" },
            ],
        },
    ];

    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.xor(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Eq', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('EqTest') as EqTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { a: 1, b: 2, expectedResult: 0, name: " a < b" },
        { a: 2, b: 1, expectedResult: 0, name: " a > b" },
        { a: 3, b: 3, expectedResult: 1, name: " a == b" },
    ];

    const testCases = [
        {
            function: "eq(euint8,euint8)",
            cases,
        },
        {
            function: "eq(euint16,euint16)",
            cases,
        },
        {
            function: "eq(euint32,euint32)",
            cases,
        },
        {
            function: "eq(ebool,ebool)",
            cases: [
                { a: 1, b: 1, expectedResult: 1, name: " 1 == 1" },
                { a: 0, b: 0, expectedResult: 1, name: " 0 == 0" },
                { a: 0, b: 1, expectedResult: 0, name: " 0 != 1" },
                { a: 1, b: 0, expectedResult: 0, name: " 1 != 0" },
            ],
        },
    ];

    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.eq(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Ne', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('NeTest') as NeTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { a: 1, b: 2, expectedResult: 1, name: " a < b" },
        { a: 2, b: 1, expectedResult: 1, name: " a > b" },
        { a: 3, b: 3, expectedResult: 0, name: " a == b" },
    ];

    const testCases = [
        {
            function: "ne(euint8,euint8)",
            cases,
        },
        {
            function: "ne(euint16,euint16)",
            cases,
        },
        {
            function: "ne(euint32,euint32)",
            cases,
        },
        {
            function: "ne(ebool,ebool)",
            cases: [
                { a: 1, b: 1, expectedResult: 0, name: " 1 == 1" },
                { a: 0, b: 0, expectedResult: 0, name: " 0 == 0" },
                { a: 0, b: 1, expectedResult: 1, name: " 0 != 1" },
                { a: 1, b: 0, expectedResult: 1, name: " 1 != 0" },
            ],
        },
    ];

    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.ne(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Min', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('MinTest') as MinTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { a: 1, b: 2, expectedResult: 1, name: " a < b" },
        { a: 2, b: 1, expectedResult: 1, name: " a > b" },
        { a: 3, b: 3, expectedResult: 3, name: " a == b" },
    ];

    const testCases = [
        {
            function: "min(euint8,euint8)",
            cases,
        },
        {
            function: "min(euint16,euint16)",
            cases,
        },
        {
            function: "min(euint32,euint32)",
            cases,
        },
    ];

    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.min(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Max', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('MaxTest') as MaxTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { a: 1, b: 2, expectedResult: 2, name: " a < b" },
        { a: 2, b: 1, expectedResult: 2, name: " a > b" },
        { a: 3, b: 3, expectedResult: 3, name: " a == b" },
    ];

    const testCases = [
        {
            function: "max(euint8,euint8)",
            cases,
        },
        {
            function: "max(euint16,euint16)",
            cases,
        },
        {
            function: "max(euint32,euint32)",
            cases,
        },
    ];

    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.max(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Shl', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('ShlTest') as ShlTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { a: 0b10101010, b: 1, expectedResult: 0b101010100, name: " <<1" },
        { a: 0b10101010, b: 2, expectedResult: 0b1010101000, name: " <<2" },
        { a: 0b10101010, b: 3, expectedResult: 0b10101010000, name: " <<3" },
        { a: 0b10101010, b: 4, expectedResult: 0b101010100000, name: " <<4" },
        { a: 0b10101010, b: 5, expectedResult: 0b1010101000000, name: " <<5" },
    ];

    const testCases = [
        {
            function: "shl(euint8,euint8)",
            cases : [
                { a: 0b10101010, b: 1, expectedResult: 0b01010100, name: " <<1" },
                { a: 0b10101010, b: 2, expectedResult: 0b10101000, name: " <<2" },
                { a: 0b10101010, b: 3, expectedResult: 0b01010000, name: " <<3" },
                { a: 0b10101010, b: 4, expectedResult: 0b10100000, name: " <<4" },
                { a: 0b10101010, b: 5, expectedResult: 0b01000000, name: " <<5" },
            ],
        },
        {
            function: "shl(euint16,euint16)",
            cases,
        },
        {
            function: "shl(euint32,euint32)",
            cases,
        },
    ];

    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.shl(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Shr', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('ShrTest') as ShrTestType;
        expect(!!contract).to.equal(true);
    });


    const cases = [
        { a: 0b10101010, b: 1, expectedResult: 0b01010101, name: ">>1" },
        { a: 0b10101010, b: 2, expectedResult: 0b00101010, name: ">>2" },
        { a: 0b10101010, b: 3, expectedResult: 0b00010101, name: ">>3" },
        { a: 0b10101010, b: 4, expectedResult: 0b00001010, name: ">>4" },
        { a: 0b10101010, b: 5, expectedResult: 0b00000101, name: ">>5" },
    ];

    const testCases = [
        {
            function: "shr(euint8,euint8)",
            cases,
        },
        {
            function: "shr(euint16,euint16)",
            cases,
        },
        {
            function: "shr(euint32,euint32)",
            cases,
        },
    ];

    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.shr(test.function, BigInt(testCase.a), BigInt(testCase.b));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test Not', () =>  {
    let contract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        contract = await deployContract('NotTest') as NotTestType;
        expect(!!contract).to.equal(true);
    });

    const cases = [
        { a: 9, b: 15, expectedResult: 9 | 15, name: "" },
        { a: 7, b: 0, expectedResult: 7, name: " a | 0" },
        { a: 0, b: 5, expectedResult: 5, name: " 0 | b" },
    ];

    const testCases = [
        {
            function: "not(euint8)",
            cases: [{ value: 0b11110000, expectedResult: 0b00001111, name: "" }],
        },
        {
            function: "not(euint16)",
            cases: [{ value: 0b1111111100000000, expectedResult: 0b0000000011111111, name: "" }],
        },
        {
            function: "not(euint32)",
            cases: [{ value: 0b11111111111111110000000000000000, expectedResult: 0b00000000000000001111111111111111, name: "" }],
        },
        {
            function: "not(ebool)",
            cases: [{ value: 1, expectedResult: 0, name: " !true" }, { value: 0, expectedResult: 1, name: " !false" }],
        },
    ];

    for (const test of testCases) {
        for (const testCase of test.cases) {
            it(`Test ${test.function}${testCase.name}`, async () => {
                const decryptedResult = await contract.not(test.function, BigInt(testCase.value));
                expect(decryptedResult).to.equal(BigInt(testCase.expectedResult));
            });
        }
    }
});
describe('Test AsEbool', () =>  {
    let contract;
    let fheContract;

    const cases = [{input: BigInt(0), output: false}, {input: BigInt(5), output: true}]
    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        const baseContract = await deployContract('AsEboolTest');
        contract = baseContract  as AsEboolTestType;

        const contractAddress = await baseContract.getAddress();
        fheContract = await getFheContract(contractAddress);

        expect(!!contract).to.equal(true);
        expect(!!fheContract).to.equal(true);
    });

    it(`From euint8`, async () => {
        for (const testCase of cases) {
            let decryptedResult = await contract.castFromEuint8ToEbool(testCase.input);
            expect(decryptedResult).to.equal(testCase.output);
        }
    });

    it(`From euint16`, async () => {
        for (const testCase of cases) {
            let decryptedResult = await contract.castFromEuint16ToEbool(testCase.input);
            expect(decryptedResult).to.equal(testCase.output);
        }
    });

    it(`From euint32`, async () => {
        for (const testCase of cases) {
            let decryptedResult = await contract.castFromEuint32ToEbool(testCase.input);
            expect(decryptedResult).to.equal(testCase.output);
        }
    });

    it(`From plaintext`, async () => {
        for (const testCase of cases) {
            let decryptedResult = await contract.castFromPlaintextToEbool(testCase.input);
            expect(decryptedResult).to.equal(testCase.output);
        }
    });

    it(`From pre encrypted`, async () => {
        for (const testCase of cases) {
            // skip for 0 as currently encrypting 0 is not supported
            if (testCase.input === BigInt(0)) {
                continue;
            }

            const encInput = fheContract.instance.encrypt8(Number(testCase.input));
            let decryptedResult = await contract.castFromPreEncryptedToEbool(encInput);
            expect(decryptedResult).to.equal(testCase.output);
        }
    });
});
describe('Test AsEuin8', () =>  {
    let contract;
    let fheContract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        const baseContract = await deployContract('AsEuint8Test');
        contract = baseContract  as AsEuint8TestType;

        const contractAddress = await baseContract.getAddress();
        fheContract = await getFheContract(contractAddress);

        expect(!!contract).to.equal(true);
        expect(!!fheContract).to.equal(true);
    });

    const value = BigInt(1);
    it(`From ebool`, async () => {
        let decryptedResult = await contract.castFromEboolToEuint8(value);
        expect(decryptedResult).to.equal(value);
    });

    it(`From euint16`, async () => {
        let decryptedResult = await contract.castFromEuint16ToEuint8(value);
        expect(decryptedResult).to.equal(value);
    });

    it(`From euint32`, async () => {
        let decryptedResult = await contract.castFromEuint32ToEuint8(value);
        expect(decryptedResult).to.equal(value);
    });

    it(`From plaintext`, async () => {
        let decryptedResult = await contract.castFromPlaintextToEuint8(value);
        expect(decryptedResult).to.equal(value);
    });

    it(`From pre encrypted`, async () => {
        const encInput = fheContract.instance.encrypt8(Number(value));
        let decryptedResult = await contract.castFromPreEncryptedToEuint8(encInput);
        expect(decryptedResult).to.equal(value);
    });
});
describe('Test AsEuin16', () =>  {
    let contract;
    let fheContract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        const baseContract = await deployContract('AsEuint16Test');
        contract = baseContract  as AsEuint16TestType;

        const contractAddress = await baseContract.getAddress();
        fheContract = await getFheContract(contractAddress);

        expect(!!contract).to.equal(true);
        expect(!!fheContract).to.equal(true);
    });

    const value = BigInt(1);
    it(`From ebool`, async () => {
        let decryptedResult = await contract.castFromEboolToEuint16(value);
        expect(decryptedResult).to.equal(value);
    });

    it(`From euint8`, async () => {
        let decryptedResult = await contract.castFromEuint8ToEuint16(value);
        expect(decryptedResult).to.equal(value);
    });

    it(`From euint32`, async () => {
        let decryptedResult = await contract.castFromEuint32ToEuint16(value);
        expect(decryptedResult).to.equal(value);
    });

    it(`From plaintext`, async () => {
        let decryptedResult = await contract.castFromPlaintextToEuint16(value);
        expect(decryptedResult).to.equal(value);
    });

    it(`From pre encrypted`, async () => {
        const encInput = fheContract.instance.encrypt16(Number(value));
        let decryptedResult = await contract.castFromPreEncryptedToEuint16(encInput);
        expect(decryptedResult).to.equal(value);
    });
});
describe('Test AsEuin16', () =>  {
    let contract;
    let fheContract;

    // We don't really need it as test but it is a test since it is async
    it(`Test Contract Deployment`, async () => {
        const baseContract = await deployContract('AsEuint32Test');
        contract = baseContract  as AsEuint32TestType;

        const contractAddress = await baseContract.getAddress();
        fheContract = await getFheContract(contractAddress);

        expect(!!contract).to.equal(true);
        expect(!!fheContract).to.equal(true);
    });

    const value = BigInt(1);
    it(`From ebool`, async () => {
        let decryptedResult = await contract.castFromEboolToEuint32(value);
        expect(decryptedResult).to.equal(value);
    });

    it(`From euint8`, async () => {
        let decryptedResult = await contract.castFromEuint8ToEuint32(value);
        expect(decryptedResult).to.equal(value);
    });

    it(`From euint16`, async () => {
        let decryptedResult = await contract.castFromEuint16ToEuint32(value);
        expect(decryptedResult).to.equal(value);
    });

    it(`From plaintext`, async () => {
        let decryptedResult = await contract.castFromPlaintextToEuint32(value);
        expect(decryptedResult).to.equal(value);
    });

    it(`From pre encrypted`, async () => {
        const encInput = fheContract.instance.encrypt32(Number(value));
        let decryptedResult = await contract.castFromPreEncryptedToEuint32(encInput);
        expect(decryptedResult).to.equal(value);
    });
});

